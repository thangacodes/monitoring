resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  count                  = var.ins_count
  vpc_security_group_ids = var.sgp
  tags = {
    Name        = "App-server-${count.index + 1}"
    Environment = "dev"
    Owner       = "admin@try-devops.xyz"
    Tfversion   = "v1.12.1"
  }
}