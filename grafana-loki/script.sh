#!/bin/bash

set -Eeuo pipefail

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
trap 'echo "User-data failed at line ${LINENO}: ${BASH_COMMAND}"' ERR

echo "======================================================"
echo "Starting EC2 bootstrap"
echo "Date: $(date)"
echo "======================================================"

AWS_REGION="ap-south-1"
LOKI_S3_BUCKET="grafana-loki-s3bucket-loki-ap-south-1 "
LOKI_VERSION="3.5.5"
GRAFANA_ADMIN_USER="admin"
GRAFANA_ADMIN_PASSWORD=""

echo "[1/10] Updating system packages..."
dnf update -y
# Amazon Linux 2023 includes curl-minimal, which already provides the curl
# command. Do not install the conflicting full curl package.
dnf install -y wget unzip tar gzip jq openssl ca-certificates shadow-utils policycoreutils awscli

# Generate the password only after OpenSSL has been installed.
GRAFANA_ADMIN_PASSWORD="$(openssl rand -base64 48 | tr -dc 'A-Za-z0-9' | head -c 32)"

echo "[2/10] Verifying AWS IAM role..."
AWS_IDENTITY="$(aws sts get-caller-identity --region "${AWS_REGION}" --output json)"
echo "${AWS_IDENTITY}"

echo "[3/10] Creating service users..."
id loki >/dev/null 2>&1 || useradd --system --home-dir /var/lib/loki --shell /sbin/nologin loki

echo "[4/10] Configuring Grafana repository..."
cat > /etc/yum.repos.d/grafana.repo <<'EOF'
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

rpm --import https://rpm.grafana.com/gpg.key
dnf clean all
dnf makecache

echo "[5/10] Installing Grafana and Alloy..."
dnf install -y grafana alloy nginx

usermod -aG systemd-journal alloy || true

echo "Configuring Nginx static host..."
mkdir -p /usr/share/nginx/html
echo "hello world" > /usr/share/nginx/html/index.html
nginx -v 2>&1 | sed 's/^nginx version: //' > /usr/share/nginx/html/build_info

cat > /etc/nginx/conf.d/hello.conf <<'EOF'
server {
  listen 80 default_server;
  server_name _;
  root /usr/share/nginx/html;
  index index.html;

  location / {
    try_files $uri $uri/ =404;
  }

  location = /build_info {
    default_type text/plain;
    try_files /build_info =404;
  }
}
EOF

nginx -t
systemctl enable --now nginx

echo "[6/10] Installing Loki ${LOKI_VERSION}..."
curl -fL --retry 5 --retry-delay 3 -o /tmp/loki.zip "https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip"
unzip -o /tmp/loki.zip -d /tmp/loki
install -m 0755 /tmp/loki/loki-linux-amd64 /usr/local/bin/loki
rm -rf /tmp/loki /tmp/loki.zip

mkdir -p /etc/loki /var/lib/loki/chunks /var/lib/loki/rules /var/lib/loki/compactor /var/lib/loki/tsdb-index /var/lib/loki/tsdb-cache
chown -R loki:loki /etc/loki /var/lib/loki
chmod 750 /etc/loki /var/lib/loki

cat > /etc/systemd/system/loki.service <<'EOF'
[Unit]
Description=Grafana Loki
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=loki
Group=loki
ExecStart=/usr/local/bin/loki -config.file=/etc/loki/loki.yaml
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

echo "[7/10] Configuring Loki..."
cat > /etc/loki/loki.yaml <<EOF
auth_enabled: false

server:
  http_listen_address: 127.0.0.1
  http_listen_port: 3100
  grpc_listen_address: 127.0.0.1
  grpc_listen_port: 9096

common:
  instance_addr: 127.0.0.1
  path_prefix: /var/lib/loki
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory
  storage:
    s3:
      endpoint: s3.${AWS_REGION}.amazonaws.com
      region: ${AWS_REGION}
      bucketnames: ${LOKI_S3_BUCKET}
      s3forcepathstyle: false

schema_config:
  configs:
    - from: 2024-04-01
      store: tsdb
      object_store: s3
      schema: v13
      index:
        prefix: loki_index_
        period: 24h

storage_config:
  aws:
    region: ${AWS_REGION}
    bucketnames: ${LOKI_S3_BUCKET}
  tsdb_shipper:
    active_index_directory: /var/lib/loki/tsdb-index
    cache_location: /var/lib/loki/tsdb-cache
    cache_ttl: 24h

compactor:
  working_directory: /var/lib/loki/compactor
  retention_enabled: true
  delete_request_store: s3

limits_config:
  retention_period: 30d
  ingestion_rate_mb: 8
  ingestion_burst_size_mb: 16
  max_cache_freshness_per_query: 10m
  reject_old_samples: true
  reject_old_samples_max_age: 168h

query_range:
  results_cache:
    cache:
      embedded_cache:
        enabled: true
        max_size_mb: 100

analytics:
  reporting_enabled: false
EOF

chown loki:loki /etc/loki/loki.yaml
chmod 640 /etc/loki/loki.yaml

echo "[8/10] Configuring Grafana Alloy..."
mkdir -p /var/lib/alloy /etc/alloy
chown -R alloy:alloy /var/lib/alloy /etc/alloy

cat > /etc/alloy/config.alloy <<'EOF'
loki.write "local" {
  endpoint {
    url = "http://127.0.0.1:3100/loki/api/v1/push"
  }
}

loki.source.journal "system" {
  forward_to = [loki.write.local.receiver]
  labels = {
    job = "systemd-journal",
  }
}

local.file_match "system_logs" {
  path_targets = [
    {
      __path__ = "/var/log/*.log",
      job      = "system",
    },
  ]
}

loki.source.file "system_logs" {
  targets    = local.file_match.system_logs.targets
  forward_to = [loki.write.local.receiver]
}

local.file_match "nginx" {
  path_targets = [
    {
      __path__ = "/var/log/nginx/access.log",
      job      = "nginx",
      log_type = "access",
    },
    {
      __path__ = "/var/log/nginx/error.log",
      job      = "nginx",
      log_type = "error",
    },
  ]
}

loki.source.file "nginx" {
  targets    = local.file_match.nginx.targets
  forward_to = [loki.write.local.receiver]
}

local.file_match "user_data" {
  path_targets = [
    {
      __path__ = "/var/log/user-data.log",
      job      = "user-data",
    },
  ]
}

loki.source.file "user_data" {
  targets    = local.file_match.user_data.targets
  forward_to = [loki.write.local.receiver]
}
EOF

chown alloy:alloy /etc/alloy/config.alloy
chmod 640 /etc/alloy/config.alloy

echo "[9/10] Configuring Grafana..."
mkdir -p /etc/grafana/provisioning/datasources

cat > /etc/grafana/provisioning/datasources/loki.yaml <<'EOF'
apiVersion: 1

datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://127.0.0.1:3100
    isDefault: true
    editable: false
    jsonData:
      timeout: 60
      maxLines: 5000
EOF

cat > /etc/grafana/grafana.ini <<EOF
[server]
protocol = http
http_addr = 0.0.0.0
http_port = 3000
domain = localhost
root_url = %(protocol)s://%(domain)s/

[security]
admin_user = ${GRAFANA_ADMIN_USER}
admin_password = ${GRAFANA_ADMIN_PASSWORD}

[users]
allow_sign_up = false

[analytics]
reporting_enabled = false
check_for_updates = false

[log]
mode = console
level = info

[feature_toggles]
enable = logsExploreTableVisual
EOF

echo "[10/10] Starting services..."
chmod 644 /var/log/user-data.log
chown -R grafana:grafana /etc/grafana
systemctl daemon-reload
systemctl enable loki alloy grafana-server
systemctl restart loki
systemctl restart alloy
systemctl restart grafana-server

echo "Waiting for Loki..."
LOKI_READY=false
for i in {1..30}; do
  if curl -fsS http://127.0.0.1:3100/ready >/dev/null 2>&1; then
    LOKI_READY=true
    echo "Loki is ready."
    break
  fi
  sleep 2
done

if [ "${LOKI_READY}" != "true" ]; then
  echo "Loki failed to become ready."
  journalctl -u loki --no-pager -n 100
  exit 1
fi

echo "Waiting for Grafana..."
GRAFANA_READY=false
for i in {1..30}; do
  if curl -fsS http://127.0.0.1:3000/api/health >/dev/null 2>&1; then
    GRAFANA_READY=true
    echo "Grafana is ready."
    break
  fi
  sleep 2
done

if [ "${GRAFANA_READY}" != "true" ]; then
  echo "Grafana failed to become ready."
  journalctl -u grafana-server --no-pager -n 100
  exit 1
fi

IMDS_TOKEN="$(curl -fsS -X PUT \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
  http://169.254.169.254/latest/api/token)"

EC2_PUBLIC_IP="$(curl -fsS \
  -H "X-aws-ec2-metadata-token: ${IMDS_TOKEN}" \
  http://169.254.169.254/latest/meta-data/public-ipv4)"

echo "Instance Public IP Address: ${EC2_PUBLIC_IP}"

cat > /root/grafana-credentials.txt <<EOF
Grafana URL:
http://${EC2_PUBLIC_IP}:3000

Username:
${GRAFANA_ADMIN_USER}

Password:
${GRAFANA_ADMIN_PASSWORD}
EOF

chmod 600 /root/grafana-credentials.txt

echo "======================================================"
echo "Installation completed"
echo "======================================================"
systemctl --quiet is-active loki && echo "Loki: active" || true
systemctl --quiet is-active alloy && echo "Alloy: active" || true
systemctl --quiet is-active grafana-server && echo "Grafana: active" || true
echo "Credentials saved to /root/grafana-credentials.txt"
echo "Grafana URL: http://${EC2_PUBLIC_IP}:3000"
echo "Loki readiness: $(curl -fsS http://127.0.0.1:3100/ready)"
echo "Grafana health: $(curl -fsS http://127.0.0.1:3000/api/health)"
echo "NGINX Information:"
echo "NGINX Static Website: $(curl -fsS http://127.0.0.1/)"
echo "NGINX build_info: $(curl -fsS http://127.0.0.1/build_info)"
echo "Bootstrap finished: $(date)"
