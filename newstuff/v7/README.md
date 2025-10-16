# Terraform Usage Guide — Layer 00 (Role & Workspace Management)

This layer manages **Keystone roles**, **project permissions**, and **Keycloak mappings** using a **shared remote backend** and **Terraform workspaces**.  
Each workspace (e.g., `dev-btp`, `prod-btp`) corresponds to an environment and maintains its own isolated remote state and role assignments.

---

## ⚙️ Backend Overview

- **Backend type:** S3-compatible (Ceph / SAP ObjectStore)
- **Configuration file:** `backend.hcl`
- **Workspace mode:** Shared remote workspaces (`dev-btp`, `prod-btp`, etc.)
- **State file path format:**  


Each workspace has its own remote state and roles.  
Terraform automatically creates the correct path structure in the ObjectStore bucket.

---

## 🚀 First-Time Setup (Initial User Only)

The first user initializes the backend connection and creates the initial environment workspace.

```bash
# Navigate to the Terraform directory
cd path/to/terraform/layer-00/

# Initialize Terraform using the shared backend config
terraform init -reconfigure -backend-config=backend.hcl

# Create the workspace for this environment (done once)
terraform workspace new dev-btp

# Confirm workspace
terraform workspace show

# Run plan/apply normally
terraform plan
terraform apply


What This Does

Connects to the shared backend (defined in backend.hcl).

Creates a new remote workspace (dev-btp) under management/layer-00/.

Generates and uploads the remote state file for all role resources.

Once complete, the workspace and remote state are available to all team members.
-----------------------------

***Setup for All Other Team Members
cd path/to/terraform/layer-00/

terraform init -reconfigure -backend-config=backend.hcl
terraform workspace select dev-btp || terraform workspace new dev-btp

terraform workspace show
terraform plan
terraform apply



What Is Happening?

init ensures the backend configuration matches the shared ObjectStore setup.

workspace select links local Terraform to the shared remote workspace and state.

Terraform automatically uses the same role mappings, credentials, and state across users



Role and Workspace Mapping

Each workspace = one OpenStack / SCI project environment.

Roles and groups created in Terraform are tied to that workspace’s state.

Example:

dev-btp workspace manages roles/groups for DEV environment.

prod-btp workspace manages roles/groups for PROD.

When Keycloak and Keystone are integrated:

Keycloak group membership (via LDAP/AD) maps to Keystone roles defined by Terraform.

Each workspace ensures that role assignments stay isolated between projects/environments.

Terraform enforces consistency between Keystone projects, Keycloak roles, and AD groups for the same environment.



Needed Commands
Command	Description
terraform workspace list	List all available workspaces
terraform workspace show	Display the current workspace
terraform workspace select <name>	Switch to another environment
terraform init -migrate-state -reconfigure	Reconnects or migrates state after backend updates
terraform fmt	Format Terraform code
terraform validate	Validate Terraform syntax
terraform state list	List managed resources for current workspace
terraform output	View output variables (e.g., role IDs, group mappings)

Consistency and Safety
Mechanism	Purpose
Shared remote backend	Ensures everyone shares the same central state location
Workspaces	Provide isolated environments (dev, prod, etc.)
State locking	Prevents simultaneous updates to the same state file
Role scoping	Keeps Keystone/Keycloak roles tied to the correct project workspace
backend.hcl	Standardizes backend connection for all users



Troubleshooting
Issue	Resolution
Prompt for bucket/path	Use terraform init -reconfigure -backend-config=backend.hcl
Access denied / timeout	Verify access to ObjectStore endpoint and credentials
Workspace mismatch	Run terraform workspace show to confirm and switch as needed
Backend configuration changed	Run terraform init -reconfigure -backend-config=backend.hcl
Duplicate role creation	Someone applied in default workspace — always confirm workspace before apply
403/Access errors on role assignment	Verify that AD/Keycloak group trust is synced and mapped to correct project workspace


Quick Summary
Role	Commands
Initial setup (first user)	terraform init -reconfigure -backend-config=backend.hcl
terraform workspace new dev-btp
terraform plan && terraform apply
All other users	terraform init -reconfigure -backend-config=backend.hcl
`terraform workspace select dev-btp
Notes

Never commit .terraform/ or any .tfstate files to Git.

Never manually edit or rename state files.

Always verify your active workspace (terraform workspace show) before running apply.

State locking and remote state ensure that role and project assignments remain consistent across all users and environments.
