#!/usr/bin/env bash
set -euo pipefail

echo "Deleting stack..."
kubectl delete -k ./k8s/dev || true

echo "Deleting PVCs (this removes Postgres data!)"
kubectl delete pvc -n microapp --all || true