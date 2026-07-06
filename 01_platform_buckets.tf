# ── Platform Buckets ──────────────────────────
# Each bucket creates:
#   1. dynatrace_platform_bucket
#   2. dynatrace_openpipeline_v2_logs_pipelines  (pipeline targeting the bucket)
#   3. dynatrace_openpipeline_v2_logs_routing     (routing entry sending logs to the pipeline)

resource "dynatrace_platform_bucket" "this" {
  for_each = var.platform_buckets

  name      = each.key
  table     = each.value.table
  retention = each.value.retention
}

resource "dynatrace_openpipeline_v2_logs_pipelines" "this" {
  for_each = var.platform_buckets
  custom_id = each.key
  display_name = try(each.value.pipeline_display_name, "${each.key}-pipeline")

  storage {
    processors {
      processor {
        type        = "bucketAssignment"
        id          = "processor_bucket_assignment_${each.key}"
        description = "Assign logs to ${each.key} bucket"
        matcher     = "true"
        bucket_assignment {
          bucket_name = dynatrace_platform_bucket.this[each.key].name
        }
        enabled = true
      }
    }
  }
}

resource "dynatrace_openpipeline_v2_logs_routing" "this" {
  for_each = var.platform_buckets

  routing_entries {
    routing_entry {
      enabled     = try(each.value.routing_enabled, true)
      description = try(each.value.routing_description, "Route logs to ${each.key}")
      matcher     = each.value.routing_matcher

      pipeline_type       = "custom"
      builtin_pipeline_id = dynatrace_openpipeline_v2_logs_pipelines.this[each.key].custom_id
    }
  }
}
