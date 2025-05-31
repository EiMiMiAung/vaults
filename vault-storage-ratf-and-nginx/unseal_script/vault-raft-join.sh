#!/bin/sh

# Start the Vault server in the background
vault server -config=/vault/config/config.hcl &

# Wait for the server to start
sleep 20


# Unseal Vault (optional, depends on your setup)
vault operator unseal $(grep 'Unseal Key 1' /unseal_script/unseal-output.txt | awk '{print $4}')
sleep 1
vault operator unseal $(grep 'Unseal Key 2' /unseal_script/unseal-output.txt | awk '{print $4}')
sleep 1
vault operator unseal $(grep 'Unseal Key 3' /unseal_script/unseal-output.txt | awk '{print $4}')
sleep 1

vault login $(grep 'Initial Root Token' /unseal_script/unseal-output.txt | awk '{print $4}')

echo "Vault Unseal Successfully"

vault status
vault operator raft list-peers
# Keep container running
wait