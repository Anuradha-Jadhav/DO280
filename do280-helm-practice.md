
# DO280 Helm Practice Questions

These questions help you practice Helm tasks relevant to the DO280 exam.

---

## 1. Install an Application using Helm Chart

**Task**:  
Install the `nginx` application using the `bitnami` Helm chart in the `webapps` project.  
Ensure the application is exposed via a route and accessible on HTTP port 80.

**Steps**:
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
oc new-project webapps
helm install nginx bitnami/nginx --set service.type=ClusterIP
oc expose service nginx
```

---

## 2. Customize Values during Helm Install

**Task**:  
Deploy a Helm chart called `etherpad` from the Bitnami repository in the `collab` project with:
- Admin username: `admin`
- Admin password: `admin123`
- Persistence disabled

**Steps**:
```bash
oc new-project collab
helm install etherpad bitnami/etherpad \
  --set etherpad.adminUsername=admin \
  --set etherpad.adminPassword=admin123 \
  --set persistence.enabled=false
```

Or use a `values.yaml`:

```yaml
etherpad:
  adminUsername: admin
  adminPassword: admin123
persistence:
  enabled: false
```

Then run:
```bash
helm install etherpad bitnami/etherpad -f values.yaml
```

---

## 3. Upgrade an Existing Helm Release

**Task**:  
Upgrade the existing Helm release `nginx-web` in the `webapps` project to change the replica count to `3`.

**Steps**:
```bash
helm upgrade nginx-web bitnami/nginx --reuse-values --set replicaCount=3
```

---

## 4. Uninstall a Helm Release

**Task**:  
Uninstall the Helm release `etherpad` from the `collab` project.

**Steps**:
```bash
helm uninstall etherpad
oc get all
```

---

## 5. Troubleshoot Helm Release

**Task**:  
A Helm release `myapp` has failed to deploy.

**Steps**:
```bash
helm status myapp
oc get pods
oc logs <pod-name>
oc describe pod <pod-name>
```

---

## 6. Install with Custom UID for OpenShift

**Task**:  
Fix UID-related deployment issues in OpenShift.

**values.yaml**:
```yaml
securityContext:
  runAsUser: 1001
```

**Steps**:
```bash
helm install appname chartname -f values.yaml
```

---

## 7. Use Helm with Internal Chart Repository

**Task**:  
Use OpenShift internal Helm repo at `http://helm.ocp4.example.com`.

**Steps**:
```bash
helm repo add internal http://helm.ocp4.example.com
helm repo update
helm search repo internal
helm install sampleapp internal/sampleapp
```

---
