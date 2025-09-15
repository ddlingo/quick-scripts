# OpenStack Federation Automation with Terraform

## Overview

This project automates the process of mapping federated groups (e.g., from Keycloak or another IdP) to OpenStack roles in a target project using Terraform. It is cloud-agnostic (no AWS dependencies) and supports remote state storage in AWS S3.

---

## Features

- **Federation Mapping:** Assigns existing OpenStack groups to existing roles in a specified project.
- **Flexible Group-to-Role Mapping:** Define any number of group-to-role assignments via variables.
- **Naming, Tagging, and Metadata:** Supports detailed tagging for traceability and compliance.
- **Remote State:** Stores Terraform state in AWS S3 (with optional DynamoDB locking).
- **Output:** Returns assignment details after apply.

---

## Files

- `main.tf` — Project context, locals, and tagging
- `openstack-federation.tf` — Core group-to-role assignment logic
- `variables-root.tf` — Context and backend variables
- `variables-naming.tf` — Naming, toggles, group/role mapping, project id
- `providers.tf` — OpenStack provider configuration and credentials
- `remote-backend.tf` — S3 remote state backend configuration
- `terraform.tfvars` — Example variable values
- `outputs.tf` — Useful outputs of assignments

---

## Prerequisites

- Terraform >= 1.0
- Access to your OpenStack environment (API credentials)
- OpenStack groups and roles created in advance
- Access to an S3 bucket for remote state
- (Recommended) DynamoDB table for state locking

---

## Usage

### 1. **Clone the Repository**

```sh
git clone <this-repository-url>
cd <repo-directory>
```

### 2. **Configure Variables**

Edit `terraform.tfvars` (or use environment variables/CLI flags) to provide:

- **OpenStack project and mapping:**
  - `project_id`: the OpenStack project ID where assignments will be made
  - `federated_group_to_role`: mapping of group names (as in Keystone) to role names (as in Keystone)
- **Remote state backend:**
  - `s3_bucket_name`, `s3_state_key`, `s3_region`, etc.
- **OpenStack credentials:** (in environment variables, or supply directly via `terraform.tfvars` or a `.auto.tfvars` file)
  - `os_auth_url`, `os_user_name`, `os_password`, `os_tenant_name`, `os_region`

Example (`terraform.tfvars`):
```hcl
org_slug       = "sci"
env_slug       = "dev"
app_slug       = "iam-orchestration"
owner          = "platform-team"
cost_center    = "CC12345"
tag_stack      = "platform"
tag_purpose    = "iam-management"
tag_compliance = "none"
extra_tags = {
  Department   = "Cloud"
  Automation   = "Terraform"
  Confidential = "false"
}
federated_group_to_role = {
  "keycloak-group1" = "member"
  "keycloak-admins" = "admin"
}
project_id = "your-openstack-project-id"
s3_bucket_name    = "your-terraform-state-bucket"
s3_state_key      = "openstack-federation/terraform.tfstate"
s3_region         = "us-east-1"
s3_dynamodb_table = "your-terraform-lock-table"
s3_profile        = "default"
os_auth_url       = "https://openstack.example.com:5000/v3/"
os_user_name      = "your-username"
os_password       = "your-password"
os_tenant_name    = "your-tenant"
os_region         = "RegionOne"
```

### 3. **Initialize Terraform**

```sh
terraform init
```

### 4. **Preview the Plan**

```sh
terraform plan
```

### 5. **Apply the Automation**

```sh
terraform apply
```

---

## Outputs

After apply, Terraform will output:

- `group_role_assignment_ids`: List of all assignment resource IDs.
- `group_to_role_assignment_map`: Map of group name to role, group_id, and assignment_id.

---

## Notes

- **No AWS IAM is used:** All logic is for OpenStack.
- **Groups and roles must pre-exist** in Keystone; this module does not create them.
- **Remote state:** Make sure your AWS credentials or profile has access to the S3 bucket and DynamoDB table.
- **OpenStack credentials** can be provided via variables, environment, or OpenStack clouds.yaml (if your provider config supports it).

---

## Troubleshooting

- **Provider authentication errors:** Check your OpenStack credentials and endpoint.
- **S3 backend errors:** Ensure AWS credentials/profile and bucket exist, and DynamoDB table exists if used.
- **Resource not found:** Confirm all group and role names exist in Keystone.

---

## Customization

- Add more tags, variables, or outputs as needed.
- Use as a module in a larger Terraform root if desired.

---

## License

MIT or Apache-2.0 (specify as appropriate).
