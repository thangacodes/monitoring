variable "aws_region" {
  description = "AWS Region where the dashboard is created"
  type        = string
  default     = "ap-south-1"
}

variable "aws_profile" {
  description = "AWS CLI profile used by Terraform"
  type        = string
  default     = "captain"
}

variable "environment" {
  description = "Environment name used in the dashboard name"
  type        = string
  default     = "sandbox"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.environment))
    error_message = "Environment must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "metric_period" {
  description = "Metric period in seconds"
  type        = number
  default     = 300
}

variable "metric_stat" {
  description = "CloudWatch statistic"
  type        = string
  default     = "Average"

  validation {
    condition     = contains(["Average", "Minimum", "Maximum", "Sum"], var.metric_stat)
    error_message = "metric_stat must be Average, Minimum, Maximum, or Sum."
  }
}