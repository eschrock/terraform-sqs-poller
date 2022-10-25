variable "prefix" {
  description = "prefix used for all resource names"
  type        = string
}

variable "schedule_lambda_arn" {
  description = "schedule handler lambda"
  type        = string
}

variable "monitor_lambda_arn" {
  description = "monitor handler lambda"
  type        = string
}

variable "complete_lambda_arn" {
  description = "monitor handler lambda"
  type        = string
}

variable "monitor_delay" {
  description = "monitor delay, in seconds"
  type        = number
  default     = 1
}