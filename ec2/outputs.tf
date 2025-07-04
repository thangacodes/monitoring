output "app_server_1_info" {
  value = {
    id         = aws_instance.app[0].id
    public_ip  = aws_instance.app[0].public_ip
    private_ip = aws_instance.app[0].private_ip
  }
}
output "app_server_2_info" {
  value = {
    id         = aws_instance.app[1].id
    public_ip  = aws_instance.app[1].public_ip
    private_ip = aws_instance.app[1].private_ip
  }
}