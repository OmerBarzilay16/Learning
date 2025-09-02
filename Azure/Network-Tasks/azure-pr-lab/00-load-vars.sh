#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f ".env" ]]; then
  echo "Missing .env file. Copy from the example and edit values."
  exit 1
fi

# shellcheck source=/dev/null
source ./.env

# Basic echo so you see what’s loaded (no secrets here)
echo "Env loaded:"
echo "  RG=$RG  LOC=$LOC"
echo "  VNET=$VNET  ADDR=$ADDR"
echo "  SUBNET_VM=$SUBNET_VM  CIDR_VM=$CIDR_VM"
echo "  SUBNET_PE=$SUBNET_PE  CIDR_PE=$CIDR_PE"
echo "  NSG=$NSG  VM_NAME=$VM_NAME  SIZE=$SIZE"
echo "  STG=$STG  MYIP=$MYIP"
