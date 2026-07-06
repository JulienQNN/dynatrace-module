# ── IAM ────────────────────────────────────────
# Creates:
#   1. dynatrace_iam_policy_boundary    (data scope / cost boundary)
#   2. dynatrace_iam_policy_bindings_v2 (binds existing policy + boundary to a group)
#
# The IAM policy itself is shared/global and NOT managed here.

data "dynatrace_iam_group" "this" {
  for_each = var.iam_group_access

  name = each.value.group_name
}

data "dynatrace_iam_policy" "this" {
  for_each = var.iam_group_access

  name = each.value.policy_name
}

resource "dynatrace_iam_policy_boundary" "this" {
  for_each = var.iam_group_access

  name  = each.value.boundary_name
  query = each.value.boundary_query
}

resource "dynatrace_iam_policy_bindings_v2" "this" {
  for_each = var.iam_group_access

  environment = var.dynatrace_environment
  group       = data.dynatrace_iam_group.this[each.key].id

  policy {
    id         = data.dynatrace_iam_policy.this[each.key].id
    boundaries = [dynatrace_iam_policy_boundary.this[each.key].name]
  }
}
