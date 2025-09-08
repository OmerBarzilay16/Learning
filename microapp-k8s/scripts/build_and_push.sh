#!/usr/bin/env bash
set -euo pipefail

# Edit these if needed
DOCKERHUB_USER="${DOCKERHUB_USER:-omerbarzolay16}"
API_IMG="${DOCKERHUB_USER}/microapp-api:0.1"
WEB_IMG="${DOCKERHUB_USER}/microapp-web:0.1"

echo "[1/3] Building API image: ${API_IMG}"
docker build -t "${API_IMG}" ./services/api

echo "[2/3] Building WEB image: ${WEB_IMG}"
docker build -t "${WEB_IMG}" ./services/web

echo "[3/3] Pushing images"
docker push "${API_IMG}"
docker push "${WEB_IMG}"

echo "Done. Images pushed:"
echo "  ${API_IMG}"
echo "  ${WEB_IMG}"