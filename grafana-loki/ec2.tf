resource "aws_instance" "loki-vm" {
  ami                    = var.ami_id
  instance_type          = var.instance_spec
  key_name               = var.sshkey
  vpc_security_group_ids = var.virtualfirewall
  user_data              = file("${path.module}/script.sh")
  iam_instance_profile   = aws_iam_instance_profile.loki_s3_bucket.name

  depends_on = [
    aws_s3_bucket.loki,
    aws_iam_role_policy_attachment.loki_s3_bucket,
    aws_iam_instance_profile.loki_s3_bucket
  ]

  tags = {
    Name          = "Grafana-Loki-Server"
    Creation_Date = "14-09-2026"
    Environment   = var.environment
    Owner         = var.owner
  }
}
