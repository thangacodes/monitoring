locals {
  dashboard_name = "ec2-${var.environment}-metrics"
}

resource "aws_cloudwatch_dashboard" "ec2" {
  dashboard_name = local.dashboard_name

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "EC2 CPU Utilization"
          region = var.aws_region
          view   = "timeSeries"
          period = var.metric_period
          stat   = var.metric_stat

          metrics = [
            [
              "expression",
              "SEARCH('{AWS/EC2,InstanceId} MetricName=\"CPUUtilization\"', '${var.metric_stat}', ${var.metric_period})",
              {
                id    = "cpu"
                label = "CPU Utilization"
              }
            ]
          ]
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "Memory Utilization"
          region = var.aws_region
          view   = "timeSeries"
          period = var.metric_period
          stat   = var.metric_stat

          metrics = [
            [
              "expression",
              "SEARCH('{CWAgent,InstanceId} MetricName=\"mem_used_percent\"', '${var.metric_stat}', ${var.metric_period})",
              {
                id    = "memory"
                label = "Memory Used %"
              }
            ]
          ]
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6

        properties = {
          title  = "Filesystem Utilization"
          region = var.aws_region
          view   = "timeSeries"
          period = var.metric_period
          stat   = var.metric_stat

          metrics = [
            [
              "expression",
              "SEARCH('{CWAgent,InstanceId} MetricName=\"disk_used_percent\"', '${var.metric_stat}', ${var.metric_period})",
              {
                id    = "disk"
                label = "Disk Used %"
              }
            ]
          ]
        }
      }
    ]
  })
}