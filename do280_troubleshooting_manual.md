
# 🎯 DO280 Troubleshooting Scenarios Practice Manual

> Use this manual to simulate and troubleshoot real-world issues you'd face in DO280.

---

## 📦 Scenario 1: Service Account Issue

**Goal**: Pod fails to start due to missing permissions.

### 📌 Setup:
```bash
oc new-project sa-test
oc create sa testsa
oc run pod1 --image=nginx --serviceaccount=testsa
oc adm policy remove-scc-from-user anyuid -z testsa
```

### 🛠️ Troubleshoot:
```bash
oc describe pod pod1
oc logs pod1
oc adm policy add-scc-to-user anyuid -z testsa
```

---

## 📦 Scenario 2: CrashLoopBackOff Pod

**Goal**: App crashes due to bad image.

### 📌 Setup:
```bash
oc new-project crash-test
oc run badpod --image=nonexistentimage
```

### 🛠️ Troubleshoot:
```bash
oc describe pod badpod
oc logs badpod
oc delete pod badpod
oc run goodpod --image=nginx
```

---

## 📦 Scenario 3: Image Pull Error

**Goal**: Pod fails to pull image from wrong repo.

### 📌 Setup:
```bash
oc new-project imagepull-test
oc run badimagepod --image=registry.redhat.io/wrong/image:latest
```

### 🛠️ Troubleshoot:
```bash
oc describe pod badimagepod
oc delete pod badimagepod
oc run nginxpod --image=nginx
```

---

## 📦 Scenario 4: Missing Route

**Goal**: Application not accessible via URL.

### 📌 Setup:
```bash
oc new-project route-test
oc new-app --name=myweb nginx
oc expose service myweb
oc delete route myweb
```

### 🛠️ Troubleshoot:
```bash
oc get routes
oc expose svc myweb
```

---

## 📦 Scenario 5: ResourceQuota Limit Exceeded

**Goal**: Pod fails due to quota violation.

### 📌 Setup:
```bash
oc new-project quota-test
oc create quota mem-cpu-demo --hard=cpu=500m,memory=1Gi
oc run bigpod --image=nginx --requests='cpu=600m,memory=2Gi'
```

### 🛠️ Troubleshoot:
```bash
oc describe quota mem-cpu-demo
```

---

## 📦 Scenario 6: Network Policy Blocking

**Goal**: Application unreachable due to deny policy.

### 📌 Setup:
```bash
oc new-project netpol-test
oc create deployment nginx --image=nginx
oc expose deployment nginx
oc create networkpolicy deny-all --pod-selector={} --policy-types=Ingress
```

### 🛠️ Troubleshoot:
```bash
curl <route_url>
oc get networkpolicy
oc delete networkpolicy deny-all
```

---

## 📦 Scenario 7: PVC Pending

**Goal**: Pod stuck waiting for unbound PVC.

### 📌 Setup:
```bash
oc new-project pvc-test
echo '
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: testpvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: nonexistent
' | oc create -f -

oc run pvc-pod --image=nginx --overrides='
{
  "apiVersion": "v1",
  "spec": {
    "volumes": [
      {
        "name": "data",
        "persistentVolumeClaim": {
          "claimName": "testpvc"
        }
      }
    ],
    "containers": [
      {
        "name": "nginx",
        "image": "nginx",
        "volumeMounts": [
          {
            "mountPath": "/data",
            "name": "data"
          }
        ]
      }
    ]
  }
}'
```

### 🛠️ Troubleshoot:
```bash
oc get pvc
oc describe pvc testpvc
```

---

## 📦 Scenario 8: Failing Readiness Probe

**Goal**: Pod stuck in not-ready state.

### 📌 Setup:
```bash
oc new-project readiness-test
oc run probe-pod --image=nginx --port=8080 --overrides='
{
  "spec": {
    "containers": [
      {
        "name": "nginx",
        "image": "nginx",
        "readinessProbe": {
          "httpGet": {
            "path": "/fail",
            "port": 80
          },
          "initialDelaySeconds": 5,
          "periodSeconds": 5
        }
      }
    ]
  }
}'
```

### 🛠️ Troubleshoot:
```bash
oc describe pod probe-pod
```

---

## 📦 Scenario 9: RBAC Permission Error

**Goal**: User cannot perform an operation.

### 📌 Setup:
```bash
oc new-project rbac-test
oc create role pod-reader --verb=get,list --resource=pods
oc create rolebinding pod-reader-binding --role=pod-reader --user=developer
oc delete rolebinding pod-reader-binding
```

### 🛠️ Troubleshoot:
- Switch to developer context
- Attempt `oc get pods`
- Recreate rolebinding:
```bash
oc create rolebinding pod-reader-binding --role=pod-reader --user=developer
```

---

## 📦 Scenario 10: DeploymentConfig Misconfiguration

**Goal**: App doesn't start due to bad env or image.

### 📌 Setup:
```bash
oc new-project dc-test
oc new-app --name=myapp nginx
oc set image dc/myapp nginx=nonexistentimage
oc rollout latest dc/myapp
```

### 🛠️ Troubleshoot:
```bash
oc describe dc myapp
oc get pods
oc logs <pod>
oc set image dc/myapp nginx=nginx
oc rollout latest dc/myapp
```

---

## ✅ How to Use This Manual:
- Pick a scenario
- Follow the setup commands
- Try to diagnose it yourself before checking the Troubleshoot section
- Clean up (`oc delete project <name>`) after each
