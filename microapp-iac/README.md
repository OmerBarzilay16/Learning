# MicroApp IaC — Terraform + Helm

This installs **ingress-nginx** (optional) and the **microapp** Helm chart (web + api + postgres).

## Layout
```
microapp-iac/
├─ helm/
│  └─ microapp/          # Local Helm chart
└─ terraform/            # Terraform project
   ├─ main.tf
   ├─ providers.tf
   ├─ variables.tf
   ├─ outputs.tf
   └─ terraform.tfvars.example
```

## Clean slate (IMPORTANT if you deployed manually before)
```powershell
helm uninstall microapp -n microapp; kubectl delete ns microapp --ignore-not-found
kubectl delete ns ingress-nginx --ignore-not-found
```

## Deploy
```powershell
cd .\microapp-iac\terraform
terraform init
terraform apply -auto-approve
```

Add to hosts file (Windows):
```
127.0.0.1  microapp.local
```

Test:
```powershell
curl -H "Host: microapp.local" http://127.0.0.1/api/health
```

## Update
Edit `terraform.tfvars` or pass `-var` then:
```powershell
terraform apply -auto-approve
```

## Destroy
```powershell
terraform destroy -auto-approve
