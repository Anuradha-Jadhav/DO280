Excellent question — practicing troubleshooting is one of the smartest ways to get ready for the **Red Hat DO280 (OpenShift Administration II) exam**. I’ll help you with both:

* **Common troubleshooting scenarios asked in DO280**
* **Steps to manually recreate those on your OpenShift cluster (CRC/Minishift/real cluster)**

---

## 📌 Common DO280 Troubleshooting Scenarios

Here are scenarios typically covered:

| 📌 Scenario Type                    | 📌 Problem Example                                                 | 📌 How to Create it for Practice       |
| :---------------------------------- | :----------------------------------------------------------------- | :------------------------------------- |
| **Service Account Issue**           | Pod fails due to missing or wrong service account                  | Delete SA binding, deploy pod          |
| **Pod CrashLoopBackOff**            | Pod stuck in CrashLoopBackOff due to wrong image, bad env var, etc | Deploy pod with bad image/env          |
| **Image Pull Error**                | Pod can't pull image due to wrong image name or private registry   | Use non-existent image name            |
| **Missing Route**                   | App not accessible via URL                                         | Delete route, test curl access         |
| **ResourceQuota Limit Error**       | New pod won't start due to ResourceQuota limit exceeded            | Create tight quota, deploy large pod   |
| **Network Policy Blocking Traffic** | Service unreachable because of network policy                      | Apply deny-all, test connectivity      |
| **PVC Pending**                     | Pod stuck due to unbound PVC                                       | Request non-existing storageClass      |
| **Wrong Deployment Configuration**  | Env variable or image missing in deployment config                 | Edit DC, remove env or set wrong image |
| **Readiness Probe Failure**         | Pod ready state never turns true                                   | Add failing readiness probe            |
| **RBAC Permission Error**           | User can't perform action (oc get, oc delete etc.)                 | Remove rolebinding for user            |

---

## 📒 How to Create Each Scenario (Manual Practice)

Let’s break down a few:

---

### 📌 1️⃣ Service Account Issue

**Problem**: Pod fails to start due to missing SA permission.

**Create It**:

```bash
oc new-project sa-test
oc create sa testsa
oc run testpod --image=nginx --serviceaccount=testsa
# Now remove policy
oc adm policy remove-scc-from-user anyuid -z testsa
# Check pod status
oc get pods
```

**Troubleshoot**:

* Check pod events: `oc describe pod testpod`
* Add SCC back if needed

---

### 📌 2️⃣ Pod CrashLoopBackOff

**Problem**: App crashes due to bad image.

**Create It**:

```bash
oc run badpod --image=nonexistentimage
oc get pods
```

**Troubleshoot**:

* `oc describe pod badpod`
* `oc logs badpod`

---

### 📌 3️⃣ Image Pull Error

**Create It**:

```bash
oc run test --image=registry.redhat.io/wrong/image:latest
```

**Troubleshoot**:

* Check `oc describe pod`
* Fix image reference in DC or pod spec

---

### 📌 4️⃣ ResourceQuota Issue

**Create It**:

```bash
oc create quota mem-cpu-demo --hard=cpu=500m,memory=1Gi
# Now try to run a pod with more resources
oc run bigpod --image=nginx --requests='cpu=600m,memory=2Gi'
```

**Troubleshoot**:

* Check quota: `oc describe quota mem-cpu-demo`
* Reduce pod requests or increase quota

---

### 📌 5️⃣ Network Policy Block

**Create It**:

```bash
oc new-project np-test
oc create deployment nginx --image=nginx
oc expose deployment nginx
oc create networkpolicy deny-all --pod-selector={} --policy-types=Ingress
```

**Troubleshoot**:

* Test route access: `curl <route>`
* Remove network policy: `oc delete networkpolicy deny-all`

---

## 📒 Other Good Practices

✅ Always practice with:

* `oc get all`
* `oc describe` for resource inspection
* `oc logs` for pod/container issues
* `oc exec` to debug inside a running pod

---

## 📜 Save Scenario Steps in a Manual

You can maintain a **text or markdown file** like this:

```
# DO280 Troubleshooting Practice Manual

## Scenario: Service Account Issue
1. Create a service account:
   oc create sa testsa
2. Create a pod using SA:
   oc run pod1 --image=nginx --serviceaccount=testsa
3. Remove SCC:
   oc adm policy remove-scc-from-user anyuid -z testsa
4. Check pod status:
   oc get pods
5. Troubleshoot:
   oc describe pod pod1
   oc logs pod1

## Scenario: CrashLoopBackOff
...
```

---

## ✅ Would You Like Me to Write a Full Practice Manual in Text or Markdown for You?

If yes — I can prepare a structured troubleshooting practice guide covering **10+ scenarios** that you can run directly. Just confirm 👌.
