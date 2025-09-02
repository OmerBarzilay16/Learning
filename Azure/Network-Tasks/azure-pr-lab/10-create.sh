#!/usr/bin/env bash
set -euo pipefail
# load variables
source ./00-load-vars.sh

echo "==> Creating Resource Group"
az group create -n "$RG" -l "$LOC" >/dev/null

echo "==> Creating VNet & workload subnet"
az network vnet create -g "$RG" -n "$VNET" --address-prefix "$ADDR" \
  --subnet-name "$SUBNET_VM" --subnet-prefix "$CIDR_VM" >/dev/null

echo "==> Creating private-endpoint subnet"
az network vnet subnet create -g "$RG" --vnet-name "$VNET" -n "$SUBNET_PE" \
  --address-prefixes "$CIDR_PE" >/dev/null

echo "==> Creating NSG and allow-SSH-from-your-IP"
az network nsg create -g "$RG" -n "$NSG" >/dev/null
az network nsg rule create -g "$RG" --nsg-name "$NSG" -n allow-ssh-from-me \
  --priority 100 --access Allow --direction Inbound --protocol Tcp \
  --source-address-prefixes "${MYIP}/32" \
  --source-port-ranges "*" --destination-address-prefixes "*" \
  --destination-port-ranges 22 >/dev/null

echo "==> Attaching NSG to workload subnet"
az network vnet subnet update -g "$RG" --vnet-name "$VNET" -n "$SUBNET_VM" \
  --network-security-group "$NSG" >/dev/null

echo "==> Creating Storage Account (public network disabled)"
az storage account create -g "$RG" -n "$STG" -l "$LOC" \
  --sku Standard_LRS --kind StorageV2 --min-tls-version TLS1_2 >/dev/null
az storage account update -g "$RG" -n "$STG" --public-network-access Disabled >/dev/null

echo "==> Creating Private DNS zone + VNet link"
PDNS="privatelink.blob.core.windows.net"
az network private-dns zone create -g "$RG" -n "$PDNS" >/dev/null
az network private-dns link vnet create -g "$RG" -n "link-$VNET" \
  -z "$PDNS" -v "$VNET" -e true >/dev/null

echo "==> Creating Private Endpoint to Blob"
STG_ID="$(az storage account show -g "$RG" -n "$STG" --query id -o tsv)"
az network private-endpoint create -g "$RG" -n "pe-$STG" -l "$LOC" \
  --vnet-name "$VNET" --subnet "$SUBNET_PE" \
  --private-connection-resource-id "$STG_ID" \
  --group-ids blob \
  --connection-name "peconn-$STG" >/dev/null

echo "==> Wiring DNS zone group"
az network private-endpoint dns-zone-group create -g "$RG" \
  --endpoint-name "pe-$STG" -n zonegroup \
  --private-dns-zone "$PDNS" --zone-name "$PDNS" >/dev/null

echo "==> Creating tiny test VM"
az vm create -g "$RG" -n "$VM_NAME" -l "$LOC" \
  --image "$IMG" --size "$SIZE" \
  --vnet-name "$VNET" --subnet "$SUBNET_VM" \
  --public-ip-sku Basic \
  --admin-username azureuser --generate-ssh-keys >/dev/null

VMIP="$(az vm list-ip-addresses -g "$RG" -n "$VM_NAME" --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" -o tsv)"
echo "==> VM public IP: $VMIP"
echo "Now SSH:  ssh azureuser@${VMIP}"
