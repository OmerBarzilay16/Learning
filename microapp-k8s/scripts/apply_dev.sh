#!/usr/bin/env bash
set -euo pipefail

echo "Applying DEV overlay..."
kubectl apply -k ./k8s/dev

echo "Waiting for pods..."
kubectl -n microapp rollout status deploy/api
kubectl -n microapp rollout status deploy/web
kubectl -n microapp get all -o wide -n microapp