output "instance_name" {
  description = "EC2 instance name"
  value       = aws_instance.loki-vm.key_name
}
output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.loki-vm.id
}
output "instance_public_ip" {
  description = "EC2 instance Public IP"
  value       = aws_instance.loki-vm.public_ip
}
output "instance_private_ip" {
  description = "EC2 instance Private IP"
  value       = aws_instance.loki-vm.private_ip
}

output "loki_s3_bucket_name" {
  description = "S3 bucket used for Loki storage"
  value       = aws_s3_bucket.loki.bucket
}

output "loki_s3_bucket_arn" {
  description = "ARN of the Loki S3 bucket"
  value       = aws_s3_bucket.loki.arn
}

output "loki_iam_role_name" {
  description = "IAM role attached to the Loki EC2 instance"
  value       = aws_iam_role.loki_s3_bucket.name
}

output "loki_iam_role_arn" {
  description = "ARN of the IAM role attached to the Loki EC2 instance"
  value       = aws_iam_role.loki_s3_bucket.arn
}

output "loki_instance_profile_name" {
  description = "IAM instance profile attached to the EC2 instance"
  value       = aws_iam_instance_profile.loki_s3_bucket.name
}
output "grafana_url" {
  description = "Grafana URL"
  value       = "http://${aws_instance.loki-vm.public_ip}:3000"
}

output "loki_url" {
  description = "Loki URL"
  value       = "http://${aws_instance.loki-vm.public_ip}:3100"
}

output "Static_Web" {
  description = "Nginx website"
  value       = "http://${aws_instance.loki-vm.public_ip}"
}

output "StaticWeb_buildinfo" {
  description = "Nginx build information"
  value       = "http://${aws_instance.loki-vm.public_ip}/build_info"
}
