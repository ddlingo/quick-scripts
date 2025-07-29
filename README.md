# quick-scripts
#  Section 1: PostgreSQL Operator Comparison for Keycloak

Selecting the right PostgreSQL operator is crucial when deploying Keycloak in Kubernetes with high availability, observability, and maintainability. Below is a comparison of the top Kubernetes-native PostgreSQL operators.

---

## Recommended: CloudNativePG (by EDB)

- **Project Type**: Kubernetes-native operator
- **CNCF Status**: Incubating
- **License**: Apache 2.0
- **Designed For**: Cloud-native HA PostgreSQL
- **HA Method**: Streaming replication + automatic failover
- **Backup Support**:  `pgBackRest`
- **TLS, RBAC, Secrets**:  Fully supported
- **Disaster Recovery (DR)**:  Yes
- **GitOps Compatible**:  ArgoCD, Kustomize, Helm
- **Support**: Maintained by EDB, strong community

**Why It's Recommended for Keycloak**:
- Native failover, PVC handling, and Service selectors
- Readiness/liveness probes supported
- Lightweight, fast startup, declarative YAML config
- Seamless integration with Kubernetes RBAC and Secrets
- Fully GitOps-compatible

**Pros**:
- Lightweight and secure
- Kubernetes-native failover logic
- Easy backup and PITR
- Production-proven

**Cons**:
- CLI/YAML only (no GUI)
- Doesn't include built-in read scaling logic

---

##  Zalando Postgres Operator

- **HA Method**: Patroni + Spilo container
- **Backups**: WAL-G
- **Failover**: Patroni-controlled
- **Production Ready**:

**Pros**:
- Stable, widely used
- Advanced configurability
- Supports read replicas

**Cons**:
- Requires external components (Patroni, Spilo)
- Not Kubernetes-native
- Higher learning curve

---

##  CrunchyData PGO (PostgreSQL Operator)

- **HA Method**: Custom failover controller
- **Backups**: Integrated `pgBackRest`
- **Security**: TLS, LDAP, RBAC
- **UI**: Available (via CrunchyBridge)
- **Compliance**: Strong enterprise features

**Pros**:
- Feature-rich
- Excellent observability and backup management
- Enterprise support

**Cons**:
- Heavyweight
- Learning curve
- Some features require a paid tier

---

##  Honorable Mention: StackGres

- **Focus**: Full-stack Postgres platform (TLS, backups, UI, monitoring)
- **UI**:  GUI for cluster creation and metrics
- **Use Case**: Small/medium setups or proof of concept

**Pros**:
- Nice visual interface
- Good for new users

**Cons**:
- Smaller community
- Opinionated architecture

This deployment uses **CloudNativePG** to run a highly available PostgreSQL cluster with **streaming replication**, powering a production-grade **Keycloak** installation on Kubernetes.

## 🧩 Architecture Overview

- **PostgreSQL (CloudNativePG):**
  - 1 primary + 2 standby nodes
  - Streaming replication via WAL (Write-Ahead Logging)
  - Automatic failover to a standby if the primary fails

- **Keycloak:**
  - Configured to connect to the HA Postgres cluster
  - Uses JDBC connection to the primary endpoint
  - HA ready with multiple replicas (optional)

- **Optional Enhancements:**
  - TLS for DB traffic (disabled by default)
  - pgbouncer for connection pooling


What Is Streaming Replication?
Streaming replication is a built-in feature of PostgreSQL that:

Continuously ships Write-Ahead Logs (WAL) from the primary to one or more standby nodes.

Standby nodes replay those WAL logs to stay in sync with the primary.

Data changes are almost immediately replicated—hence “streaming.”




##  How Streaming Replication Works

1. The **primary node** handles all read/write operations.
2. **Standby nodes** continuously receive WAL logs from the primary.
3. If the primary crashes:
   - CloudNativePG automatically promotes a standby to be the new primary.
   - The cluster `Service` re-points to the new primary.
   - Keycloak reconnects transparently.

### Diagram:

```
                [Keycloak Pods]
                     |
          +-----------------------+
          |  Cluster DB Service   |
          +-----------------------+
                     |
                [Primary Pod]
                     |
        WAL Logs     ↓      WAL Logs
               [Standby A]   [Standby B]
                    ↘         ↙
               Automatic Failover


Why It's Important for Keycloak:
Keycloak must connect to a reliable PostgreSQL cluster. If the DB dies and doesn't fail over, Keycloak will be unavailable.

CloudNativePG makes streaming replication HA native to Kubernetes by:

Auto-configuring WAL streaming

Managing PVCs for each instance

Detecting failures and promoting standbys

Exposing a single endpoint that always points to the active primary


PostgreSQL Requirements for Keycloak
1. Version Compatibility
Supported PostgreSQL versions (as of Keycloak 24+):

PostgreSQL 12, 13, 14, 15, 16

Prefer the latest minor release for security and performance.

Must support standard UTF-8 encoding and SQL:2011 features.

2. Database Schema Initialization
Keycloak automatically creates the schema if it has proper privileges.

You can pre-create the schema if desired.

The database must be empty if you allow Keycloak to initialize it.

3. Connection Requirements
Keycloak uses JDBC (via quarkus.datasource.* or KC_DB_* env vars)

Example JDBC URL:

bash
Copy
Edit
KC_DB=postgres
KC_DB_URL=jdbc:postgresql://<host>:5432/keycloak
KC_DB_USERNAME=keycloak
KC_DB_PASSWORD=changeme
TLS is recommended for security (ssl=true or sslmode=require)

4. High Availability
Keycloak supports horizontal scaling — all nodes must access the same Postgres backend.

Thus, the DB must be:

Highly available (e.g., streaming replication, Patroni, or CloudNativePG HA)

Consistent (no eventual-consistency or async replication)

Backed by automatic failover if using in production

5. Connection Pooling
Production-grade deployments should use pgbouncer or a K8s-sidecar like Pgpool-II

This prevents connection saturation from multiple Keycloak pods

6. Resource Sizing Recommendations
Resource	Recommendation
DB Storage	SSD-backed, with WAL archive
CPU	2+ cores recommended
RAM	4–8 GB depending on load
Connections	50–100 min (use pooling)
WAL Archiving	Needed for PITR
Backups	Automated + daily minimum

7. Security Best Practices
Use non-root DB user with permissions only on the keycloak database

Restrict network access using K8s NetworkPolicies or VPC rules

Enable TLS at rest and in transit
------------------------------------------------
```yaml name=keycloak-postgres-ha.yaml
# CloudNativePG Cluster for HA PostgreSQL on OpenStack Cinder CSI (for Keycloak)
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: keycloak-db
  namespace: keycloak
spec:
  # High-availability: 3 instances, each with its own PV
  instances: 3
  # Use the latest CloudNativePG PostgreSQL image compatible with Keycloak (Postgres 15+ is safe for recent Keycloak)
  imageName: ghcr.io/cloudnative-pg/postgresql:15.7
  primaryUpdateStrategy: unsupervised
  storage:
    # Must match your OpenStack Cinder CSI StorageClass; confirm it's RWX if you need multi-node mount (rare for PG)
    storageClass: cinder-csi
    size: 10Gi
  # Credentials for superuser (admin)
  superuserSecret:
    name: keycloak-db-superuser
  enableSuperuserAccess: true
  # Keycloak-specific database and user
  bootstrap:
    initdb:
      database: keycloak
      owner: keycloak
      secret:
        name: keycloak-db-app
  # Expose via ClusterIP Service (default), or configure for LoadBalancer/Ingress as needed
  # Uncomment and customize if you want a load-balanced read endpoint:
  # externalClusters:
  #   - name: keycloak-db-reader
  #     host: keycloak-db-rw.keycloak.svc
  #     port: 5432
  #     user: keycloak
  #     password:
  #       name: keycloak-db-app
  #       key: password
  # Optional: Configure monitoring, backups, etc., as needed

---
# Superuser credentials secret (never store real passwords in Git)
apiVersion: v1
kind: Secret
metadata:
  name: keycloak-db-superuser
  namespace: keycloak
type: Opaque
stringData:
  username: postgres
  password: supersecurepassword

---
# App user credentials secret (used by Keycloak)
apiVersion: v1
kind: Secret
metadata:
  name: keycloak-db-app
  namespace: keycloak
type: Opaque
stringData:
  username: keycloak
  password: keycloakpassword

---
# Example: Service for Keycloak to connect to the DB cluster's RW endpoint
apiVersion: v1
kind: Service
metadata:
  name: keycloak-db-rw
  namespace: keycloak
spec:
  ports:
    - port: 5432
      targetPort: 5432
      name: postgres
  selector:
    cnpg.io/cluster: keycloak-db
  type: ClusterIP
```

**Key design notes:**
- **StatefulSet**: The CloudNativePG operator uses its own CRDs (not a vanilla StatefulSet), but it still ensures each instance has its own PVC with strict identity. This is the recommended pattern for PostgreSQL HA on Kubernetes.
- **StorageClass**: Ensure `cinder-csi` is configured for dynamic provisioning and supports `ReadWriteOnce` (this is the default for PostgreSQL; `RWX` is not typically needed unless you have special failover demands).
- **Secrets**: Credentials are stored in Kubernetes secrets. Rotate them securely for production.
- **Operator installed**: Assumes CloudNativePG operator is deployed and CRDs are available.
- **Upgrades**: Use a strict version match for your Keycloak version’s Postgres compatibility. Adjust the `imageName` if you need a different minor version (e.g., `15.x`).
- **PVCs**: Never delete PVCs unless you are doing a full rebuild of the cluster.
- **Service**: The `keycloak-db-rw` service gives Keycloak a stable endpoint for writes.

**Before deploying:**
- Make sure the namespace `keycloak` exists:  
  `kubectl create namespace keycloak`
- Validate your StorageClass matches your OpenStack CSI driver and supports dynamic PV provisioning.
- Make sure the CloudNativePG operator is installed and running in the cluster.

+++++++++++++++++++
A Kubernetes ServiceAccount is used to provide an identity for processes running in a Pod to interact securely with the Kubernetes API and other cluster resources. Here’s when and why you’d need a ServiceAccount, especially in your scenario with CloudNativePG and Keycloak:

Common Reasons to Use a ServiceAccount
Operator Permissions:
The CloudNativePG operator itself requires a ServiceAccount (with appropriate Roles or ClusterRoles) so it can manage PostgreSQL clusters, create/update resources, and interact with Custom Resource Definitions (CRDs).

Database Backups/Restores:
If you enable scheduled backups (e.g., to an object storage bucket), the backup job Pods may need a custom ServiceAccount with access to secrets or volumes (such as S3 credentials).

Monitoring/Exporters:
If you deploy monitoring agents (e.g., Prometheus exporters) as sidecars or standalone Pods, they might need a ServiceAccount to scrape metrics or access secrets.

Custom Initialization Jobs:
If you run custom Kubernetes Jobs or Pods to initialize, migrate, or manage the database (e.g., schema migrations on startup), those Pods may need a ServiceAccount to read/write secrets or connect to the database securely.

Network Policies:
In tightly secured clusters, you may use ServiceAccounts as selectors in NetworkPolicies to control which Pods can talk to the database.

External Integrations:
If Keycloak or other apps need to use Kubernetes API (rare for Keycloak itself), you’d use a ServiceAccount for that Pod.

For Your Keycloak + CloudNativePG Setup
Keycloak Pod:
Typically, Keycloak does not need a custom ServiceAccount for database access—it connects to PostgreSQL via host/port/username/password (via Kubernetes Secret/ConfigMap). The default ServiceAccount is sufficient unless Keycloak needs to read other Kubernetes secrets or interact with the API.

CloudNativePG Operator:
The operator must have a ServiceAccount with enough permissions (usually created by the operator’s Helm chart or manifests).

Database Jobs/Backups:
If you plan to use CloudNativePG’s backup or restore features, you may need to create a ServiceAccount with access to your object storage credentials.

Summary Table

Component	Needs ServiceAccount?	Why
CloudNativePG Op	Yes	To manage DB clusters, resources
Keycloak	No (default is fine)	Only if reading K8s secrets or API
Backup Jobs	Maybe	If accessing object storage, secrets
Monitoring Agents	Maybe	If scraping metrics or secrets
Best Practice:

Always use the minimal permissions required for each ServiceAccount.
Never give Pods cluster-admin rights unless absolutely necessary.

1. Kubernetes Cluster Requirements
A Kubernetes (or OpenShift) cluster, running on OpenStack (SCI).
cinder-csi StorageClass (or equivalent) for dynamic provisioning.
Validate: StorageClass supports dynamic provisioning and ReadWriteOnce (RWX is not required unless you need pods on multiple nodes accessing the same volume simultaneously, which is rare for PostgreSQL).
2. Namespace
A dedicated namespace for Keycloak and the database:
sh
kubectl create namespace keycloak
3. CloudNativePG Operator
Installed in the cluster (via Helm chart or Operator Lifecycle Manager).
The operator must have its own ServiceAccount, Role, and RoleBinding (usually created automatically by the operator installer).
CRDs for Cluster from CloudNativePG are available.
4. ServiceAccount for PostgreSQL Cluster
The CloudNativePG operator manages the DB cluster, but if you’re running custom jobs/pods that need DB access (e.g., for initialization, monitoring, or migrations), create a dedicated ServiceAccount.
For a basic POC, the default ServiceAccount is usually enough for the Keycloak pod, but you can explicitly create one if you want to define fine-grained access or network policies.

keycloak-db-serviceaccount.yaml
v1
apiVersion: v1
kind: ServiceAccount
metadata:
  name: keycloak-db-app
  namespace: keycloak

5. Secrets for Credentials
Superuser and application user secrets for PostgreSQL access.
6. PostgreSQL Cluster Manifest
Use the CloudNativePG Cluster manifest (as you provided and as I refined previously).
Use PostgreSQL 15.7+ for Keycloak 26.2.4 (per compatibility matrix).
At least 3 instances for HA.
7. Kubernetes Service
Internal ClusterIP service for Keycloak to reach PostgreSQL.
8. Keycloak Deployment
Keycloak deployment (not included here, but should reference the Service and DB credentials).
Summary Table
Requirement	Description	Example/Notes
Namespace	Dedicated for Keycloak resources	keycloak
StorageClass	Dynamic, Persistent, Cinder CSI	cinder-csi
CloudNativePG Operator	Installed, with ServiceAccount	Operator install docs
ServiceAccount (DB access)	For jobs needing DB credentials (optional for POC)	See manifest above
Secrets	For PostgreSQL superuser/app user	See previous manifests
Cluster CRD	CloudNativePG CRD for PostgreSQL	3 instances, 10Gi each
Service	ClusterIP for DB connectivity from Keycloak	keycloak-db-rw
Keycloak Deployment	Refers to DB Service and Credentials	Not included here
Manifests to Apply (for your POC)
You will need:


keycloak-db-serviceaccount.yaml
v2
apiVersion: v1
kind: ServiceAccount
metadata:
  name: keycloak-db-app
  namespace: keycloak


keycloak-db-superuser-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: keycloak-db-superuser
  namespace: keycloak
type: Opaque

keycloak-db-app-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: keycloak-db-app
  namespace: keycloak
type: Opaque

keycloak-db-cluster.yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: keycloak-db
  namespace: keycloak
spec:

keycloak-db-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: keycloak-db-rw
  namespace: keycloak
spec:
Operator ServiceAccount Example (for reference only)
You do not need to create this if you installed CloudNativePG via Helm or YAML, as it is auto-created:


cloudnative-pg-operator-serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: cloudnative-pg-controller-manager
  namespace: cnpg-system

Next Steps
Confirm your StorageClass is dynamic and matches your OpenStack Cinder CSI setup.
Apply the namespace, ServiceAccount, Secrets, Cluster, and Service manifests (in that order).
Deploy Keycloak, pointing its DB config to keycloak-db-rw.keycloak.svc:5432.








-------------------------------------------------

Assumptions
Namespace: keycloak

PostgreSQL DB Name: keycloak

PostgreSQL User: keycloak

DB Password: auto-generated as a Kubernetes Secret

TLS: ❌ Disabled for now (we’ll enable self-signed TLS later if needed)

PostgreSQL Operator: CloudNativePG

Keycloak: Installed via Helm with overrides

Kubernetes tools: helm, kubectl, kustomize available

Base directory: base/

Environment overlay: overlays/prod/

✅ Generated Directory Structure and Files (all Markdown-wrapped)
markdown
Copy
Edit
📁 keycloak-deploy/
├── base/
│   ├── keycloak-values.yaml
│   ├── postgres-cluster.yaml
│   ├── secret-db.yaml
│   └── kustomization.yaml
├── overlays/
│   └── prod/
│       ├── kustomization.yaml
│       └── namespace.yaml
yaml
Copy
Edit

---

```markdown
# 📄 base/keycloak-values.yaml

# Helm values override for Bitnami or Codecentric Keycloak
replicaCount: 3

ingress:
  enabled: true
  hostname: keycloak.example.com

keycloak:
  username: admin
  password: admin
  extraEnv:
    - name: KC_DB
      value: postgres
    - name: KC_DB_URL
      value: jdbc:postgresql://keycloak-db-rw:5432/keycloak
    - name: KC_DB_USERNAME
      valueFrom:
        secretKeyRef:
          name: keycloak-db-secret
          key: username
    - name: KC_DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: keycloak-db-secret
          key: password
yaml
Copy
Edit

---

```markdown
# 📄 base/postgres-cluster.yaml

apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: keycloak-db
  namespace: keycloak
spec:
  instances: 3
  imageName: ghcr.io/cloudnative-pg/postgresql:15
  primaryUpdateStrategy: unsupervised
  storage:
    size: 10Gi
  bootstrap:
    initdb:
      database: keycloak
      owner: keycloak
      secret:
        name: keycloak-db-secret
  monitoring:
    enablePodMonitor: false
  service:
    type: ClusterIP
yaml
Copy
Edit

---

```markdown
# 📄 base/secret-db.yaml

apiVersion: v1
kind: Secret
metadata:
  name: keycloak-db-secret
  namespace: keycloak
type: Opaque
stringData:
  username: keycloak
  password: changeme123
yaml
Copy
Edit

---

```markdown
# 📄 base/kustomization.yaml

resources:
  - postgres-cluster.yaml
  - secret-db.yaml
  - keycloak-values.yaml
yaml
Copy
Edit

---

```markdown
# 📄 overlays/prod/namespace.yaml

apiVersion: v1
kind: Namespace
metadata:
  name: keycloak
yaml
Copy
Edit

---

```markdown
# 📄 overlays/prod/kustomization.yaml

namespace: keycloak

resources:
  - ../../base

generatorOptions:
  disableNameSuffixHash: true

