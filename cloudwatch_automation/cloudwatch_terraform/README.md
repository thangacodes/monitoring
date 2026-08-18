# EC2 CloudWatch Dashboard with Terraform
```bash

Terraform configuration for creating an Amazon CloudWatch dashboard that monitors EC2 instances and CloudWatch Agent metrics.

Dashboard metrics

CPU utilization from the AWS/EC2 namespace

Memory utilization from the CWAgent namespace

Filesystem utilization from the CWAgent namespace

The dashboard uses CloudWatch search expressions, so new instances that publish the matching metrics can appear automatically.

Project structure:

.
├── dashboard_creation.tf          # CloudWatch dashboard and widgets
├── variables.tf                   # Input variables
├── providers.tf                   # AWS provider configuration
├── tfversions.tf                  # Terraform and provider requirements
└── outputs.tf                     # Dashboard name and ARN

Requirements:

Terraform 1.6 or later

AWS CLI configured with a valid profile

AWS permissions to create and manage CloudWatch dashboards

CloudWatch Agent installed and running on the target EC2 instances

EC2 instances publishing metrics to the CWAgent namespace

Verify the AWS profile before deploying:

aws sts get-caller-identity --profile captain

Configuration

The default variables are:

aws_region  = "ap-south-1"
aws_profile = "captain"
environment = "sandbox"

Create a terraform.tfvars file to override the defaults:

aws_region  = "ap-south-1"
aws_profile = "captain"
environment = "production"

The resulting dashboard name will be:

ec2-production-metrics

Do not commit AWS access keys, private keys, or other secrets to the repository.

Deploy

Run the following commands from the Terraform project directory:

terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply

Review the plan carefully before approving terraform apply.

View outputs

terraform output

The outputs include the CloudWatch dashboard name and ARN.

Manage an existing dashboard

To manage an existing dashboard named AppServerMetrics, update the dashboard name in main.tf:

locals {
  dashboard_name = "AppServerMetrics"
}

Import the existing dashboard into Terraform state:

terraform import aws_cloudwatch_dashboard.ec2 AppServerMetrics

Always review the result after importing:

terraform plan

Terraform will manage the dashboard configuration after it has been imported. Manual changes made in the AWS Console may be overwritten by the next Terraform apply.

Verify CloudWatch Agent metrics

Check the agent status on an EC2 instance:

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status

Note:
-m means mode.
ec2 means the agent is running on an Amazon EC2 instance.
-a means action.
status asks the agent to display its current status.

List metrics for a specific instance:

aws cloudwatch list-metrics \
  --namespace CWAgent \
  --dimensions Name=InstanceId,Value=<instance-id> \
  --region ap-south-1 \
  --profile captain

Memory and disk metrics should be visible under:

CloudWatch → Metrics → All metrics → CWAgent

If no metrics are returned, verify the CloudWatch Agent configuration, IAM role, AWS Region, network access, and agent logs.

Destroy

To remove the Terraform-managed dashboard:

terraform destroy

This removes the CloudWatch dashboard only. It does not terminate EC2 instances.

```
