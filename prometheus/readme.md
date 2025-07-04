```bash

📁 Folder Structure
.
├── alertmanager
│   ├── am-install.yaml
│   └── readme.md
├── blackbox_exporter
│   └── blackbox_exporter_install.sh
├── cloudwatch_exporter_rds
│   ├── cloudwatch-exporter.service
│   └── cloudwatch_exporter.yaml
├── cwatch-exporter
│   ├── README.md
│   ├── defaults
│   │   └── main.yml
│   ├── files
│   │   ├── cloudwatch_exporter-0.16.0-jar-with-dependencies.jar
│   │   └── cloudwatch_exporter.yml
│   ├── handlers
│   │   └── main.yml
│   ├── meta
│   │   └── main.yml
│   ├── tasks
│   │   └── main.yml
│   ├── templates
│   │   └── cloudwatch-exporter.service.j2
│   ├── tests
│   │   ├── inventory
│   │   └── test.yml
│   └── vars
│       └── main.yml
├── grafana_dash
│   ├── grafana_download_install.yaml
│   └── grafana_install.sh
├── node_exporter
│   └── node-exporter-install.sh
├── prometheus_ansible_script
│   ├── install_config_prometheus.yaml
│   ├── invoke_prometheus_config_role.yaml
│   ├── prometheus-config
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   └── prometheus.service.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── prometheus-install.sh
│   ├── prometheus.service
│   └── readme.md
├── rds-cwatch.yaml
└── readme.md

24 directories, 34 files

Here are the default ports for each services like AlertManager, Blackbox Exporter,CloudWatch-exporter, Grafana, Prometheus, Node Exporter,

AlertManager: 9093 & 9094 (Web UI & Cluster Communication)

CloudWatch exporter: 9106

Grafana: 3000 (default HTTP port for the Grafana web UI)

Prometheus: 9090 (default port for Prometheus server HTTP)

Node Exporter: 9100 (default port for node_exporter metrics endpoint)

Blackbox Exporter: 9115 (default port for blackbox_exporter metrics endpoint)

