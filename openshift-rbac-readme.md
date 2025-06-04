# OpenShift RBAC, Groups, Projects, and SCC Configuration

_Last updated: 2025-06-04_

## 🔐 Identity Providers (IdPs)

OpenShift supports external IdPs like LDAP, GitHub, Google, or Keystone for user authentication.

### Example: Configure HTpasswd IdP

```bash
htpasswd -c -B -b users.htpasswd user1 password1
oc create secret generic htpasswd-secret --from-file=htpasswd=users.htpasswd -n openshift-config
```

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

---

## 🛡️ OpenShift Roles Overview

| Role             | Scope        | Permissions Summary                                   |
|------------------|--------------|--------------------------------------------------------|
| `cluster-admin`  | Cluster-wide | Full access to all resources                          |
| `admin`          | Project      | Manage project resources and RBAC                     |
| `edit`           | Project      | Modify resources but not RBAC                         |
| `view`           | Project      | Read-only access to project resources                 |
| `self-provisioner` | Cluster    | Allows users to create new projects                   |

---

## 🚫 Disable Self-Provisioning

```bash
oc edit clusterrolebinding self-provisioners
# In annotations, set: "rbac.authorization.kubernetes.io/autoupdate": "false"

oc adm policy remove-cluster-role-to-group self-provisioner system:authenticated:oauth
```

---

## 📂 OpenShift Projects & Permissions

### Assign SCC to User in Project

```bash
oc adm policy add-scc-to-user restricted dev-user -n demo-project
```

### Label and Annotate Namespace

```bash
oc label namespace demo-project team=dev environment=staging
oc annotate namespace demo-project owner=devops@example.com
```

---

## 👥 Managing Groups in OpenShift

### Create Group with Users

```bash
oc adm groups new dev-team dev1 dev2 dev3
```

### Add Users to Group

```bash
oc adm groups add-users dev-team dev4 dev5
```

### Remove User from Group

```bash
oc adm groups remove-users dev-team dev3
```

### Assign Role to Group in a Namespace

```bash
oc adm policy add-role-to-group edit dev-team -n demo-project
```

### Assign Cluster Role to Group

```bash
oc adm policy add-cluster-role-to-group cluster-admin dev-team
```

---

## 🧠 Example Full Setup

```bash
# Create group and add users
oc adm groups new qa-team tester1 tester2

# Assign role
oc adm policy add-role-to-group edit qa-team -n test-project

# Annotate group
oc annotate group qa-team owner=qa-lead@example.com
```

---

## 🗑️ Optional Cleanup

```bash
oc delete secret kubeadmin -n kube-system
```

---

## 🧾 Notes

- Labels: used for filtering and automation.
- Annotations: used for documentation and tooling.
- SCC: defines security rules for pods.

