output "alert_id" {
  value = datadog_monitor.ec2_cpu_high.id
}

output "alert_message" {
  value = datadog_monitor.ec2_cpu_high.message
}

output "alert_name" {
  value = datadog_monitor.ec2_cpu_high.name
}