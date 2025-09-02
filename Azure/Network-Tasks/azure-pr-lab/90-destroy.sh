#!/usr/bin/env bash
set -euo pipefail
source ./00-load-vars.sh

echo "==> Deallocating VM (optional)"
az vm deallocate -g "$RG" -n "$VM_NAME" >/dev/null || true

echo "==> Deleting entire resource group (this removes all lab resources)"
az group delete -n "$RG" -y
