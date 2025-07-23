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

