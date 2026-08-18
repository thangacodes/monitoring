EC2 CloudWatch Dashboard with Terraform:
This Terraform project creates an Amazon CloudWatch dashboard for EC2 instances.

The dashboard displays:

EC2 CPU utilization

Memory utilization from the CloudWatch Agent

Filesystem utilization from the CloudWatch Agent

The dashboard uses CloudWatch search expressions, so any EC2 instance publishing the matching metrics can appear automatically.

Files:

.
├── dashboard_creation.tf          # CloudWatch dashboard definition
├── variables.tf                   # Input variables
├── providers.tf                   # AWS provider configuration
├── tfversions.tf                  # Terraform and provider requirements
└── outputs.tf                     # Dashboard outputs

Prerequisites:

Terraform installed.

AWS CLI configured.

An AWS profile with CloudWatch dashboard permissions.

CloudWatch Agent installed and running on the EC2 instances.

EC2 instances publishing metrics to the CWAgent namespace.

The AWS profile must be available locally:

aws sts get-caller-identity --profile captain

Configuration:

The default variables are:

aws_region  = "ap-south-1"
aws_profile = "captain"
environment = "sandbox"

You can override them with a terraform.tfvars file:

aws_region  = "ap-south-1"
aws_profile = "captain"
environment = "production"

The dashboard will be named:

ec2-production-metrics

Deploy the dashboard

Initialize Terraform:

terraform init

Format the files:

terraform fmt

Validate the configuration:

terraform validate

Review the changes:

terraform plan

Create or update the dashboard:

terraform apply

View the outputs

terraform output

The outputs include the dashboard name and ARN.

Existing dashboard

If you want Terraform to manage an existing dashboard named AppServerMetrics, set this value in main.tf:

dashboard_name = "AppServerMetrics"

Then import the dashboard into Terraform state:

terraform import aws_cloudwatch_dashboard.ec2 AppServerMetrics

Review the result with:

terraform plan

Troubleshooting

Check whether the CloudWatch Agent is running on an EC2 instance:

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status

List CloudWatch Agent metrics for an instance:

aws cloudwatch list-metrics \
  --namespace CWAgent \
  --dimensions Name=InstanceId,Value=<instance-id> \
  --region ap-south-1 \
  --profile captain

If no metrics are returned, verify the CloudWatch Agent configuration, IAM role, AWS Region, and agent logs.

Cleanup

To remove the Terraform-managed dashboard:

terraform destroy --auto-approve

This removes the CloudWatch dashboard but does not terminate EC2 instances.