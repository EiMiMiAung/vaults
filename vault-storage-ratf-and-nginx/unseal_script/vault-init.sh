#!/bin/sh

# Start the Vault server in the background
vault server -config=/vault/config/config.hcl &

sleep 0.5


# Check if Vault is already initialized
if vault status | grep -q 'Initialized.*true'; then
  echo "Vault is already initialized."
  
else
# Initialize Vault
  echo "Vault is not initialized. Initializing..."
  vault operator init > /unseal_script/unseal-output.txt
fi

# vault status | grep -q 'Initialized.*true'
# if [ $? -eq 0 ]; then
#   echo "[INFO] Already initialized; skipping raft join."
# else
#   vault operator raft join http://host.docker.internal:8200
# fi

# Unseal Vault (optional, depends on your setup)
if vault status | grep -q 'Sealed.*true'; then
  vault operator unseal $(grep 'Unseal Key 1' /unseal_script/unseal-output.txt | awk '{print $4}')
  vault operator unseal $(grep 'Unseal Key 2' /unseal_script/unseal-output.txt | awk '{print $4}')
  vault operator unseal $(grep 'Unseal Key 3' /unseal_script/unseal-output.txt | awk '{print $4}')

  vault login $(grep 'Initial Root Token' /unseal_script/unseal-output.txt | awk '{print $4}')
else
  echo "[INFO] Vault already unsealed"
fi

echo "Vault Unseal Successfully"

vault status
vault operator raft list-peers

# Keep container running
wait