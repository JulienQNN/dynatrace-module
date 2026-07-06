variable "platform_buckets" {
  description = "Platform buckets definitions (decoded from YAML)"
  type        = any
  default     = {}
}

variable "iam_bindings" {
  description = "IAM policy + boundary + binding definitions (decoded from YAML)"
  type        = any
  default     = {}
}

variable "dynatrace_environment" {
  description = "Dynatrace environment UUID (shared across all bindings)"
  type        = string
}
