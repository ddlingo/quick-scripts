Here’s a **short, practical tutorial** on how to use and manage your Terraform files for an OpenStack (or similar) automation project:

---

## 1. Key Files

- **main.tf**  
  Core logic and resources.  
  **You rarely edit this** unless you want to change how resources are created.

- **variables-naming.tf**  
  Defines all the configurable variables.  
  **You only edit this if you want to add/remove/change variable definitions or defaults.**

- **terraform.tfvars**  
  Where you provide actual values for the variables (org, env, project, etc).  
  **You edit this for each deployment/environment.**

- **outputs.tf** (optional)  
  Shows useful outputs after running Terraform.  
  **Edit if you want to display different results.**

---

## 2. Quick Start Steps

1. **Copy/clone the repo** to your machine.
2. **Edit `terraform.tfvars`** to set your organization, environment, app, project ID, and group-to-role mappings.
3. (Optional) **Edit `variables-naming.tf`** if you want to add/remove/change variables or set different defaults.
4. (Usually not needed) **Edit `main.tf`** if you want to change core logic or resource creation.
5. (Optional) **Edit `outputs.tf`** if you want to customize what info is shown after `terraform apply`.

---

## 3. Running Terraform

```sh
terraform init
terraform plan
terraform apply
```
- `terraform init`: Sets up the working directory.
- `terraform plan`: Shows what will be created/changed.
- `terraform apply`: Provisions resources with your settings.

---

## **Summary Table**

| File                | You Edit?         | Purpose                                             |
|---------------------|-------------------|-----------------------------------------------------|
| main.tf             | Rarely            | Resource logic                                      |
| variables-naming.tf | Sometimes         | Variable definitions & defaults                     |
| terraform.tfvars    | Yes, always       | Your variable values for each deployment            |
| outputs.tf          | Sometimes/optional| Output useful info after apply                      |

---

**Tip:**  
Just edit `terraform.tfvars` for most use cases!  
Edit other files only if you want to customize logic, variables, or outputs.
