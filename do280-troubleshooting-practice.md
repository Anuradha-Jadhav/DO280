
# DO280 Exam - Troubleshooting Scenario Practice

## 🚨 General Troubleshooting Checklist

1. Check current project:
   ```bash
   oc project
   ```
2. Switch to target project if required:
   ```bash
   oc project <project-name>
   ```

---

## 1. **Pod Not Running / CrashLoopBackOff**

### 🔍 Steps:
```bash
oc get pods
oc describe pod <pod-name>
oc logs <pod-name>
```

### 🛠️ Common Fixes:
- Image not found or typo in image name.
- Wrong entrypoint or CMD.
- Environment variable missing.
- Readiness/liveness probes failing.

### 📝 Sample Exam Question:
> A pod in the `orange` project is stuck in CrashLoopBackOff. Identify and fix the issue so the pod runs successfully.

---

## 2. **Route Not Working**

### 🔍 Steps:
```bash
oc get route
oc describe route <route-name>
curl -kv https://<route-host>
```

### 🛠️ Common Fixes:
- Service selector mismatch.
- Route points to wrong service or port.
- Missing or incorrect TLS termination.

### 📝 Sample Exam Question:
> The route `classified.apps.ocp4.com` returns "Loading..." and fails to load the actual app. Fix it so the application becomes accessible.

---

## 3. **Service Not Exposing Application**

### 🔍 Steps:
```bash
oc get svc
oc describe svc <svc-name>
```

### 🛠️ Common Fixes:
- Selector mismatch with pod labels.
- Incorrect port or targetPort.

### 📝 Sample Exam Question:
> A service named `oxcart` is not routing traffic correctly. Fix the label or selector issue to restore connectivity.

---

## 4. **NetworkPolicy Blocking Traffic**

### 🔍 Steps:
```bash
oc get networkpolicy
oc describe networkpolicy <np-name>
```

### 🛠️ Common Fixes:
- Wrong `podSelector` or `namespaceSelector`.
- Ports not allowed in policy.
- Policy too restrictive.

### 📝 Sample Exam Question:
> A network policy `db-allow-sysql-conn` is deployed in the `database` project but blocks traffic from the `checker` project. Fix the policy so the connection is allowed.

---

## 5. **PVC/PV Not Bound or Mounted**

### 🔍 Steps:
```bash
oc get pvc
oc describe pvc <pvc-name>
```

### 🛠️ Common Fixes:
- Check for available PVs.
- Access mode mismatch.
- StorageClass mismatch.

### 📝 Sample Exam Question:
> A pod using a PVC is not starting due to volume issues. Fix the problem and ensure the volume mounts correctly.

---

## 6. **SecurityContextConstraint (SCC) Issues**

### 🔍 Steps:
```bash
oc get scc
oc describe pod <pod-name> | grep scc
```

### 🛠️ Common Fixes:
- Add correct SCC to service account:
  ```bash
  oc adm policy add-scc-to-user anyuid -z <sa-name>
  ```

### 📝 Sample Exam Question:
> The pod `rocky` is failing due to SCC restrictions. Modify the deployment to use an appropriate service account and grant it `anyuid`.

---

## 7. **Wrong or Missing Labels/Selectors**

### 🔍 Steps:
```bash
oc get pod --show-labels
oc get svc -o yaml
oc get deploy -o yaml
```

### 🛠️ Common Fixes:
- Labels on pods not matching service selectors.
- Use:
  ```bash
  oc label pod <pod-name> key=value --overwrite
  ```

### 📝 Sample Exam Question:
> The `oranges` service is not able to discover its pods. Fix the label/selector mismatch so service routing works.

---

## 8. **Resource Quota or LimitRange Issues**

### 🔍 Steps:
```bash
oc describe limitrange
oc describe resourcequota
```

### 🛠️ Common Fixes:
- Increase quota or reduce resource requests/limits.
- Modify deployment resource section.

### 📝 Sample Exam Question:
> A deployment is failing due to memory limits defined in a LimitRange. Adjust the deployment to match the allowed limits.

---

## 9. **Helm Chart Errors**

### 🔍 Steps:
```bash
helm repo list
helm repo update
helm install <name> <repo/chart>
```

### 🛠️ Common Fixes:
- Add correct repo:
  ```bash
  helm repo add bitnami https://charts.bitnami.com/bitnami
  ```
- Ensure proper values.yaml if provided.

### 📝 Sample Exam Question:
> You are asked to install Etherpad using Helm but encounter a `chart not found` error. Fix the repo and install the chart.

---

## 10. **Debugging a Pod**

### 🔍 Steps:
```bash
oc debug pod/<pod-name>
```

### 🛠️ Tips:
- Use `/host` for host troubleshooting.
- Use `chroot /host` to troubleshoot host OS.

### 📝 Sample Exam Question:
> Use `oc debug` to troubleshoot why the pod `app-crash` is failing and fix the root cause.

---

## ✅ Bonus Commands

### Check events:
```bash
oc get events --sort-by='.lastTimestamp'
```

### Copy file to pod:
```bash
oc cp ./index.html <pod-name>:/usr/share/nginx/html
```

### Set service account:
```bash
oc set serviceaccount deployment/<deploy-name> <sa-name>
```

---

## 📝 Tips for DO280 Exam

- Read the task carefully — **don’t overconfigure**.
- Always verify the result (`oc get`, `oc describe`, `curl`, etc.)
- Use `oc explain` if unsure of resource definitions.
- If stuck, rollback the last change and retry methodically.

---

## 🧪 How to Practice These Scenarios

### 1. Create a Practice Project
```bash
oc new-project troubleshoot-lab
```

### 2. Simulate Common Failures
Create intentionally broken configurations (see each scenario above).

### Example: Pod CrashLoopBackOff
```bash
oc run crashpod --image=busybox --command -- sleep 1
oc get pods
oc logs crashpod
```

Fix:
```bash
oc delete pod crashpod
oc run fixedpod --image=busybox --command -- sleep 3600
```

### Example: Route Issue
```bash
oc new-app nginx
oc expose svc nginx
oc edit svc nginx  # Change targetPort to incorrect value
curl <route>
# Then fix it
```

Repeat for all scenarios.

---

*Practice these issues repeatedly in a CRC or lab setup to build speed and accuracy.*
