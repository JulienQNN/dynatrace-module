variable "platform_buckets" {
  description = "Platform buckets definitions (decoded from YAML)"
  type        = any
  default     = {}
}

variable "iam_group_access" {
  description = "IAM group access definitions (decoded from YAML)"
  type        = any
  default     = {}
}

variable "dynatrace_environment" {
  description = "Dynatrace environment UUID (shared across all bindings)"
  type        = string
}
