terraform {
  required_version = ">= 1.10.0"
  required_providers {
    dynatrace = {
      source  = "dynatrace-oss/dynatrace"
      version = "~> 2.1.0"
    }
  }
}
