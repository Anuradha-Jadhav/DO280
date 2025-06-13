Excellent — now let me generate for you a **single clean `.md` file** which you can directly save as your **DO280-Troubleshooting-Lab.md** for your preparation.

---

Here’s your full lab doc:

---

````markdown
# DO280 Troubleshooting Lab Pack

> Full practical scenarios for DO280 Exam Simulation

---

## 🛠 Lab Setup

### 1️⃣ Create Project

```bash
oc new-project path-finder
````

### 2️⃣ Label your Node (Important for NodeSelector test)

```bash
oc get nodes --show-labels
oc label node <your-node-name> trek=star
```

---

## 🚩 Scenario 1: NodeSelector Mismatch

### YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: voyager
  namespace: path-finder
spec:
  replicas: 1
  selector:
    matchLabels:
      app: voyager
  template:
    metadata:
      labels:
        app: voyager
    spec:
      nodeSelector:
        Trek: star   # Intentional mistake (capital T)
      containers:
      - name: voyager
        image: registry.ocp4.example.com:8443/redhattraining/hello-world-nginx
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: voyager
  namespace: path-finder
spec:
  selector:
    app: voyager
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

### Troubleshooting

* `oc get pods`
* `oc describe pod voyager-xxxx`
* `oc get events`
* `oc edit deployment voyager`
* Fix NodeSelector: `trek: star`

---

## 🚩 Scenario 2: Ingress Host Mismatch

### YAML

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: voyager
  namespace: path-finder
spec:
  rules:
  - host: voyager.app.ocp4.example.com  # Intentional mistake
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: voyager
            port:
              number: 80
```

### Troubleshooting

* `oc get ingress`
* `oc describe ingress voyager`
* `oc edit ingress voyager`
* Fix host: `voyager.apps.ocp4.example.com`

---

## 🚩 Scenario 3: Service Selector Issue

### YAML

```yaml
apiVersion: v1
kind: Service
metadata:
  name: voyager-broken
  namespace: path-finder
spec:
  selector:
    app: voyager-wrong  # Wrong selector
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

### Troubleshooting

* `oc get svc voyager-broken`
* `oc describe svc voyager-broken`
* `oc edit svc voyager-broken`
* Fix selector to `app: voyager`

---

## 🚩 Scenario 4: CrashLoopBackOff Pod

### YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: failapp
  namespace: path-finder
spec:
  replicas: 1
  selector:
    matchLabels:
      app: failapp
  template:
    metadata:
      labels:
        app: failapp
    spec:
      containers:
      - name: failapp
        image: busybox
        args:
        - /bin/sh
        - -c
        - "exit 1"  # Will fail immediately
```

### Troubleshooting

* `oc get pods`
* `oc logs failapp-xxxx`
* `oc edit deployment failapp`
* Fix args: `args: ["sleep", "3600"]`

---

## 🚩 Scenario 5: PVC Binding Failure

### YAML

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: broken-pvc
  namespace: path-finder
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: non-existing-storage  # Invalid StorageClass
```

### Troubleshooting

* `oc get pvc broken-pvc`
* `oc describe pvc broken-pvc`
* Fix storageClassName to valid storage class

---

## 🚩 Scenario 6: Memory Mismatch

### YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: memory-mismatch
  namespace: path-finder
spec:
  replicas: 1
  selector:
    matchLabels:
      app: memory-mismatch
  template:
    metadata:
      labels:
        app: memory-mismatch
    spec:
      containers:
      - name: memory-mismatch
        image: nginx
        resources:
          requests:
            memory: "64Gi"   # Intentionally too high
            cpu: "500m"
          limits:
            memory: "64Gi"
            cpu: "1"
        ports:
        - containerPort: 80
```

### Troubleshooting

* `oc describe pod memory-mismatch-xxxx`
* `oc get events`
* `oc describe node`
* `oc edit deployment memory-mismatch`
* Reduce memory request/limit to cluster capacity

---

## ✅ Exam Commands Summary

| Command               | Purpose              |
| --------------------- | -------------------- |
| `oc get pods`         | Pod status           |
| `oc describe pod`     | Node selector issues |
| `oc get events`       | Scheduling failures  |
| `oc describe node`    | Check node capacity  |
| `oc get ingress`      | Ingress status       |
| `oc describe ingress` | Ingress host issues  |
| `oc get svc`          | Service issues       |
| `oc describe svc`     | Wrong selector       |
| `oc logs`             | CrashLoopBackOff     |
| `oc get pvc`          | PVC issues           |
| `oc describe pvc`     | Binding problems     |
| `oc edit`             | Live editing         |

---



---

```

---

