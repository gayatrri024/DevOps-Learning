 variable "aws_region" {
  description = "AWS region used for learning"
  type        = string
  default     = "us-east-1"
}

variable "monthly_budget" {
  description = "Monthly AWS learning budget in USD"
  type        = string
  default     = "5"
}

variable "alert_email" {
  description = "Email address for AWS budget alerts"
  type        = string
}