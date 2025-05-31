#!/bin/sh

# Start the Vault server in the background
vault server -config=/vault/config/config.hcl &

sleep 0.5

# Initialize Vault
vault operator init > /unseal-script/unseal-output.txt

# Unseal Vault (optional, depends on your setup)
vault operator unseal $(grep 'Unseal Key 1' /unseal-script/unseal-output.txt | awk '{print $4}')
vault operator unseal $(grep 'Unseal Key 2' /unseal-script/unseal-output.txt | awk '{print $4}')
vault operator unseal $(grep 'Unseal Key 3' /unseal-script/unseal-output.txt | awk '{print $4}')

vault login $(grep 'Initial Root Token' /unseal-script/unseal-output.txt | awk '{print $4}')

echo "Vault Unseal Successfully"

vault status
vault operator raft list-peers
