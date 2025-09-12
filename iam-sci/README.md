# OpenStack SCI Terraform Deployment

This repository contains modular Terraform code to bootstrap, network, and orchestrate an OpenStack project for SCI/Keycloak federated IAM, with tagging, security, and compute best practices.

---

## 🗂️ File Structure

```
provider.tf              # OpenStack provider (clouds.yaml-based)
variables.tf             # All configurable variables
network.tf               # Networks, subnets, routers, and ports
security_groups.tf       # Security groups and rules
compute.tf               # Compute instances and floating IPs
keystone.tf              # IAM/federation/project/role assignments
outputs.tf               # Important resource outputs
workspace-tfvars/
  dev-sms-L-sci.tfvars   # Example tfvars for a "dev-sms" project
```

---

## 🚀 Quick Start

1. **Configure clouds.yaml**

   Ensure your OpenStack clouds.yaml is present (default: `~/.config/openstack/clouds.yaml`) and contains a section matching your `os_cloud_name` (e.g., `sci-dev`).

2. **Clone the repo and initialize**

   ```sh
   git clone <your-repo-url>
   cd <your-repo>
   terraform init
   ```

3. **Adjust your variables**

   Update `workspace-tfvars/dev-sms-L-sci.tfvars` for your environment/project.

4. **Plan and apply**

   ```sh
   terraform plan -var-file=workspace-tfvars/dev-sms-L-sci.tfvars
   terraform apply -var-file=workspace-tfvars/dev-sms-L-sci.tfvars
   ```

---

## 🔑 Federation, IAM, and Bootstrapping

- **Federated group assignments:**  
  The `keystone.tf` file assigns a federated group (populated from Keycloak/SCI) a custom role in the new project.

- **Local admin (optional):**  
  Set `bootstrap_admin_name` and `bootstrap_admin_password` for a "break-glass" admin user, or leave blank to disable.

---

## 🏗️ Networking and Security

- **Two networks** (sms and bind), each with their own subnet
- **Router** connecting both to external network
- **Security group** for intra-project communication (ICMP, SSH, DNS)
- **Ports** with fixed IPs, attached to compute instances

---

## 🖥️ Compute

- Two example servers, each on a different network/port
- `server1` receives a floating IP for external access

---

## 🏷️ Tagging/Metadata

- All resources are tagged/contextualized with environment, owner, and business metadata, suitable for automation or reporting.

---

## 📦 Outputs

After `apply`, Terraform will output:
- Project and network IDs
- Compute instance IDs
- Assigned floating IPs
- Federated group IDs

---

## 📝 Customization

- Duplicate the example `.tfvars` file for new projects or environments.
- Add modules or split files further as your environment grows.
- For production, lock down security group rules (e.g., SSH only from a VPN).

---

## 🛠️ Troubleshooting

- **clouds.yaml not found?**  
  Ensure it exists at `~/.config/openstack/clouds.yaml` or set `OS_CLIENT_CONFIG_FILE`.

- **Federated group not found?**  
  Confirm the group exists in Keystone, synced from Keycloak/SCI.

- **State file location:**  
  By default, local. For production, configure a remote backend (S3, Swift, etc.).

---

## 📄 License

MIT

---

## ✉️ Questions?

Open an issue or contact the project maintainer.
