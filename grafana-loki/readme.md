# Standalone EC2 Grafana, Loki and Nginx

This Terraform project creates a standalone Amazon Linux 2023 EC2 server with:
```
Grafana dashboard
Grafana Loki log storage
Grafana Alloy log collector
Loki logs stored in Amazon S3
Nginx static website
Systemd services for automatic startup
```

| File | Purpose |
|---|---|
| `ec2.tf` | Creates the EC2 instance |
| `iamrole.tf` | Creates the IAM role, policy and instance profile |
| `s3_bucket.tf` | Creates the S3 bucket for Loki |
| `providers.tf` | Configures the AWS provider |
| `variables.tf` | Defines input variables |
| `terraform.tfvars` | Contains environment-specific values |
| `outputs.tf` | Displays EC2 IP addresses and website URLs |
| `script.sh` | EC2 user-data installation script |

# Prerequisites:
## Prerequisites

| Requirement | Description |
|---|---|
| Terraform | Installed |
| AWS CLI | Configured |
| AWS account | Permission to create EC2, IAM, S3, and security groups |
| EC2 key pair | Required for SSH access |
| VPC and subnet | Must have internet access |
| AMI | Amazon Linux 2023 x86_64 |

## EC2 Security Group

| Port | Purpose |
|---:|---|
| 22 | SSH |
| 80 | Nginx website |
| 3000 | Grafana |

Loki port `3100` and gRPC port `9096` should remain closed to the internet.

## Deploy
```
From the Terraform project directory:
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply

Confirm the deployment when Terraform asks.

# View outputs:
terraform output
Expected outputs include:
instance_public_ip
instance_private_ip
Static_Web
StaticWeb_buildinfo
Access the services
Replace <EC2_PUBLIC_IP> with the IP shown by Terraform.

# Nginx website:
http://<EC2_PUBLIC_IP>/

# Build information:
http://<EC2_PUBLIC_IP>/build_info

# Grafana:
http://<EC2_PUBLIC_IP>:3000

The Grafana username and generated password are saved on the EC2 instance:

sudo cat /root/grafana-credentials.txt

Grafana and Loki
The Loki datasource is provisioned automatically with this URL:

http://127.0.0.1:3100
Grafana and Loki run on the same EC2 instance, so Grafana connects to Loki through localhost.

Logs collected by Alloy

# Alloy sends these logs to Loki:
Nginx access log
Nginx error log
/var/log/*.log
/var/log/user-data.log
systemd journal

In Grafana, open Explore, select the Loki datasource, and use:
{job="nginx"}
{job="nginx", log_type="access"}
{job="nginx", log_type="error"}
{job="system"}
{job="systemd-journal"}
{job="user-data"}
```
# Check services on EC2
```
sudo systemctl status nginx --no-pager
sudo systemctl status loki --no-pager
sudo systemctl status alloy --no-pager
sudo systemctl status grafana-server --no-pager
```

# Check logs:
```
sudo journalctl -u loki -n 50 --no-pager
sudo journalctl -u alloy -n 50 --no-pager
sudo journalctl -u grafana-server -n 50 --no-pager
sudo tail -n 50 /var/log/user-data.log
```

# Test Loki:
```
curl http://127.0.0.1:3100/ready
```
# Expected result:
ready

# Test Nginx:
```
curl http://127.0.0.1/
curl http://127.0.0.1/build_info
``
# Re-run user data:
```
User data normally runs only during the first EC2 boot. To recreate the instance with the latest script.sh:
terraform apply -replace='aws_instance.loki-vm'
```

# Important security notes:
```
Do not expose Loki ports 3100 or 9096 publicly.
Restrict SSH port 22 to your own IP address.
Restrict Grafana port 3000 to trusted users or use a reverse proxy.
Use HTTPS and a domain name for production Grafana access.
Protect /root/grafana-credentials.txt.
Do not print passwords into /var/log/user-data.log.
Use an Elastic IP if the public IP must remain stable.

# Destroy the infrastructure:
This removes the Terraform-managed resources:
terraform destroy
Review the plan carefully before confirming.
```
