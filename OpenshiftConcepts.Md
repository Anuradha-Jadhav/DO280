Here is the complete README file covering all the OpenShift RBAC, identity providers, SCC, project configuration, groups, and related administrative concepts.

📄 **Download the full README:** [openshift-rbac-complete-readme.md](sandbox:/mnt/data/openshift-rbac-complete-readme.md)

---

### 📘 Preview of Contents:

````markdown
# OpenShift RBAC, Groups, Projects, and SCC Configuration

_Last updated: 2025-06-04_

## 🔐 Identity Providers (IdPs)

OpenShift supports external IdPs like LDAP, GitHub, Google, or Keystone for user authentication.

### Example: Configure HTpasswd IdP

```bash
htpasswd -c -B -b users.htpasswd user1 password1
oc create secret generic htpasswd-secret --from-file=htpasswd=users.htpasswd -n openshift-config
````

Edit OAuth config:

```yaml
oc edit oauth cluster
```

Add:

```yaml
identityProviders:
- name: htpasswd_provider
  mappingMethod: claim
  type: HTPasswd
  htpasswd:
    fileData:
      name: htpasswd-secret
```

## 🛡️ OpenShift Roles Overview

| Role               | Scope        | Description                                                      |
| ------------------ | ------------ | ---------------------------------------------------------------- |
| `cluster-admin`    | Cluster-wide | Full control over the entire cluster                             |
| `admin`            | Project      | Full control within a namespace/project                          |
| `edit`             | Project      | Modify most objects in a project                                 |
| `view`             | Project      | Read-only access to objects                                      |
| `self-provisioner` | Cluster      | Create new projects (enabled by default for authenticated users) |

## 🔒 Disable Self-Provisioning

```bash
oc edit clusterrolebinding self-provisioners
# Set this annotation:
# rbac.authorization.kubernetes.io/autoupdate: "false"

oc adm policy remove-cluster-role-to-group self-provisioner system:authenticated:oauth
oc adm policy add-cluster-role-to-user self-provisioner collins
```

## 📁 Project Setup & Permissions

### Example Commands

```bash
oc adm policy add-cluster-role-to-user cluster-admin jobs
oc login -u jobs -p indionce
oc get nodes
oc delete secret kubeadmin -n kube-system
```

### Configure SCC (Security Context Constraints)

```bash
oc adm policy add-scc-to-user restricted dev-user -n demo-project
```

## 🏷️ Label and Annotate Projects

```bash
oc label namespace demo-project team=dev environment=staging
oc annotate namespace demo-project owner=devops@example.com
```

## 👥 OpenShift Group Management

### Create Group and Add Users

```bash
oc adm groups new dev-team dev1 dev2 dev3
```

### Add/Remove Users from Group

```bash
oc adm groups add-users dev-team dev4
oc adm groups remove-users dev-team dev3
```

### Assign Roles to Group

```bash
# Project-specific role
oc adm policy add-role-to-group edit dev-team -n demo-project

# Cluster-wide role
oc adm policy add-cluster-role-to-group cluster-admin dev-team
```

### Annotate Group

```bash
oc annotate group dev-team owner=lead@example.com
```

## 🌲 RBAC Tree Diagram (Text Representation)

```
Cluster
└── ClusterRoles
    ├── cluster-admin
    ├── self-provisioner
    └── view/edit/admin
└── ClusterRoleBindings
    └── Bind ClusterRoles to users/groups
└── Projects (Namespaces)
    └── RoleBindings
        └── Bind Roles to users/groups within namespace
```

## 🧠 Example Full Setup Script

```bash
# Create group and users
oc adm groups new qa-team tester1 tester2

# Assign permissions
oc adm policy add-role-to-group edit qa-team -n test-project

# Annotate for documentation
oc annotate group qa-team owner=qa-lead@example.com

# Disable self-provisioning
oc edit clusterrolebinding self-provisioners
# Set: rbac.authorization.kubernetes.io/autoupdate: "false"

oc adm policy remove-cluster-role-to-group self-provisioner system:authenticated:oauth
```

## 🗑️ Optional Cleanup

```bash
oc delete secret kubeadmin -n kube-system
```

## 🧾 Notes

* **Labels** are used for filtering and automation.
* **Annotations** provide metadata for tooling and documentation.
* **SCCs** control pod-level security.
* **Groups** simplify permission management across users.

```

---

```
