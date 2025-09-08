# MicroApp — Kubernetes (K8s) Microservices Demo

Minimal microservices app ready for Kubernetes with **Kustomize** overlays:
- **web**: NGINX static site, proxies `/api` → backend
- **api**: Flask + SQLAlchemy REST API using Postgres
- **db**: PostgreSQL 16 (StatefulSet + PVC)

## Prereqs
- Docker (to build images)
- kubectl, kustomize (or kubectl >= 1.27 which includes 'kubectl kustomize')
- An Ingress controller (tested with ingress-nginx)
- A cluster (kind/minikube/AKS/GKE/etc.)

## Quick start (DEV overlay)
1. **Build & push images** (edit the Docker Hub username if needed; default set to `omerbarzolay16`):
   ```bash
   ./scripts/build_and_push.sh
   ```

2. **Install ingress-nginx** (if you don't already have one):
   ```bash
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
   ```

3. **Deploy**:
   ```bash
   ./scripts/apply_dev.sh
   ```

4. **Add hosts entry** (for local testing):
   - Add this line to your hosts file (`/etc/hosts` on Linux/Mac, `C:\Windows\System32\drivers\etc\hosts` on Windows):
     ```
     127.0.0.1   microapp.local
     ```
   - If using kind/minikube, map the Ingress controller's service IP instead of 127.0.0.1.

5. **Open**:
   - Web: http://microapp.local/
   - API: http://microapp.local/api/health

## Teardown
```bash
./scripts/teardown.sh
```

## Structure
```
microapp-k8s/
├─ services/
│  ├─ api/                 # Flask API (build this image)
│  └─ web/                 # NGINX static site + proxy
├─ k8s/
│  ├─ base/                # K8s objects (namespace, svc, sts/deploy, ingress)
│  └─ dev/                 # Kustomize overlay for dev (images, tags, host)
└─ scripts/
```

## Notes
- Postgres password is stored in a Secret (base64-encoded). **Change it** in `k8s/base/secret.db.yaml` and update envs if desired.
- Database data is persisted via a PVC (named `pg-data`).
- API auto-creates the `todos` table on first request.