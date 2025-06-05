resource "datadog_monitor" "ec2_cpu_high" {
  name               = "[Alert]- High CPU Usage for EC2"
  type               = "metric alert"
  message            = <<-EOT
    High CPU usage detected on EC2 instance!
    - Host: {{host.name}}
    - Instance ID: {{aws.ec2.instance_id}}
    - Region: {{region}}
    Notify: @td@gmail.com
  EOT
  escalation_message = "Please check EC2 load ASAP!"

  query = <<-EOT
    avg(last_5m):avg:aws.ec2.cpuutilization{environment:dev,region:ap-south-1} > 70
  EOT

  monitor_thresholds {
    warning  = 60
    critical = 70
  }
  priority     = 2
  include_tags = true
  tags         = ["env:dev", "team:devops"]
}
