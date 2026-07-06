# dso-arsenal-dynatrace-module

Terraform module for Dynatrace configuration. Manages platform buckets, OpenPipeline routing, and IAM group access.

## Usage

```hcl
module "dynatrace" {
  source = "git::https://github.com/JulienQNN/dynatrace-module.git"

  platform_buckets      = local.platform_buckets
  iam_group_access      = local.iam_group_access
  dynatrace_environment = var.dynatrace_environment
}
```

## Variables

| Variable | Type | Required | Description |
|---|---|---|---|
| `platform_buckets` | `any` | no | Platform buckets definitions (map keyed by bucket name) |
| `iam_group_access` | `any` | no | IAM group access definitions (map keyed by access name) |
| `dynatrace_environment` | `string` | yes | Dynatrace environment UUID |

## Resources created

### Per `platform_buckets` entry

| Resource | Description |
|---|---|
| `dynatrace_platform_bucket` | Grail log bucket |
| `dynatrace_openpipeline_v2_logs_pipelines` | Pipeline with bucket assignment processor |
| `dynatrace_openpipeline_v2_logs_routing` | Routing entry directing logs to the pipeline |

#### Attributes

| Field | Required | Default |
|---|---|---|
| `routing_matcher` | yes | `matchesPhrase(dt.system.bucket, "<key>")` |
| `table` | no | `logs` |
| `retention` | no | `90` |
| `description` | no | — |
| `pipeline_display_name` | no | `<key>-pipeline` |
| `routing_enabled` | no | `true` |
| `routing_description` | no | `Route logs to <key>` |

### Per `iam_group_access` entry

| Resource | Description |
|---|---|
| `data.dynatrace_iam_group` | Looks up existing IAM group |
| `data.dynatrace_iam_policy` | Looks up existing IAM policy |
| `dynatrace_iam_policy_boundary` | Creates a policy boundary (data scope) |
| `dynatrace_iam_policy_bindings_v2` | Binds policy + boundary to the group |

#### Attributes

| Field | Required | Default |
|---|---|---|
| `group_name` | yes | — |
| `boundary_query` | yes | — |
| `policy_name` | no | `ReadOnly` |
| `boundary_name` | no | `Boundary_<key>` |

## Provider requirements

| Provider | Version |
|---|---|
| `dynatrace-oss/dynatrace` | `~> 1.100.0` |

## Environment variables

| Variable | Required for |
|---|---|
| `DYNATRACE_ENV_URL` | All resources |
| `DYNATRACE_API_TOKEN` | All resources |
| `DT_ACCOUNT_ID` | IAM resources only |
