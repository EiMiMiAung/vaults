#!/bin/sh

# Start the Vault server in the background
vault server -config=/vault/config/config.hcl &

# Wait for the server to start
sleep 10

# raft join vault-server1
vault operator raft join http://vault-server1:8200

echo "raft joined successfully"

# Unseal Vault (optional, depends on your setup)
vault operator unseal $(grep 'Unseal Key 1' /unseal-script/unseal-output.txt | awk '{print $4}')
sleep 1
vault operator unseal $(grep 'Unseal Key 2' /unseal-script/unseal-output.txt | awk '{print $4}')
sleep 1
vault operator unseal $(grep 'Unseal Key 3' /unseal-script/unseal-output.txt | awk '{print $4}')
sleep 1

vault login $(grep 'Initial Root Token' /unseal-script/unseal-output.txt | awk '{print $4}')

echo "Vault Unseal Successfully"

vault status
vault operator raft list-peers
