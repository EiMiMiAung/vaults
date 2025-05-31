

# Vault runs entirely in-memory
# and starts unsealed with a single unseal key.


docker run --cap-add=IPC_LOCK -d --name=vault-dev-server1 hashicorp/vault:1.17

CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS      NAMES
b01976478972   hashicorp/vault:1.17   "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   8200/tcp   vault-dev-server1

docker run --cap-add=IPC_LOCK -d -p 8200:8200 --name=vault-dev-server1 hashicorp/vault:1.17

`-p 8200:8200`
docker run --cap-add=IPC_LOCK -d -p 8200:8200 --name=vault-dev-server1 --hostname=vault-dev-server1 hashicorp/vault:1.18

`--network=host`
docker run --cap-add=IPC_LOCK -d --network=host --name=vault-dev-server2 --hostname=vault-dev-server1 hashicorp/vault:1.18 server -dev -dev-listen-address=0.0.0.0:8200


docker run --cap-add=IPC_LOCK -d -p 8202:8200 --name=vault-dev-server2 --hostname=vault-dev-server2 hashicorp/vault:1.17

docker run --cap-add=IPC_LOCK -d -p 8204:8202 --name=vault-dev-server3 --hostname=vault-dev-server3 hashicorp/vault:1.18

# Containers on the default bridge network can only access each other by IP addresses, not by container names. There's no automatic DNS resolution between containers by default.

docker run --cap-add=IPC_LOCK -d --name=vault-dev-server1 --hostname=vault-dev-server1 hashicorp/vault:1.18
docker run --cap-add=IPC_LOCK -d --name=vault-dev-server2 --hostname=vault-dev-server2 hashicorp/vault:1.18
docker run --cap-add=IPC_LOCK -d --name=vault-dev-server3 --hostname=vault-dev-server3 hashicorp/vault:1.18

$ docker exec vault-dev-server1 ping -c 5 vault-dev-server2
ping: bad address 'vault-dev-server2'

$ docker exec vault-dev-server1 ping -c 5 vault-dev-server3
ping: bad address 'vault-dev-server3'

# When you run containers on a custom bridge network, you get automatic DNS resolution between containers using container names, as well as several other advantages like network isolation and the ability to connect/disconnect containers from the network on the fly.
docker network create vault_cluster_network

docker run --cap-add=IPC_LOCK -d --name=vault-dev-server4 --network=vault_cluster_network --hostname=vault-dev-server4 hashicorp/vault:1.18
docker run --cap-add=IPC_LOCK -d --name=vault-dev-server5 --network=vault_cluster_network --hostname=vault-dev-server5 hashicorp/vault:1.18
docker run --cap-add=IPC_LOCK -d --name=vault-dev-server6 --network=vault_cluster_network --hostname=vault-dev-server6 hashicorp/vault:1.18

docker exec vault-dev-server4 ping -c 5 vault-dev-server5
docker exec vault-dev-server4 ping -c 5 vault-dev-server6

docker exec vault-dev-server5 ping -c 5 vault-dev-server4
docker exec vault-dev-server5 ping -c 5 vault-dev-server6

docker exec vault-dev-server6 ping -c 5 vault-dev-server4
docker exec vault-dev-server6 ping -c 5 vault-dev-server5


# Compose File Ref
https://docs.docker.com/reference/compose-file/



DRIVER    VOLUME NAME
local     3d40b4d298bdef374edc27a06c21af3c14858a7d3c50e9f5ca7e3af16d60a4a2
local     1403c5846f7e18c6cfa4b912ba06bbe17247ebc2c9dfd404f7d1ad28c5cf216d
local     2082d21dbcb23b9b26948aac614f45180b9f36f66df6fecbcba3c57a5699def2
local     a0921170c032f9a6b5ae393cbb7bfdb5ed006232e0c968a63d4a920ed2776081
local     d0e3a2f51571932a233f8bf07806ef5e4436aa677df334a252c3c11848e79de7
local     ecaa02b9913703543fc2c5246ceae5fb5ac620155efa41bec661153b290e76be


local     2082d21dbcb23b9b26948aac614f45180b9f36f66df6fecbcba3c57a5699def2
local     946816b52503d1071f648b9eda22776d48d413beef5f68bc748ed300dc558220
local     a0921170c032f9a6b5ae393cbb7bfdb5ed006232e0c968a63d4a920ed2776081
local     ae53ca004622e7aac8d3fb46da3d3a7c979bd85c16a6d3c6c12af36166a9bf3f
local     d0e3a2f51571932a233f8bf07806ef5e4436aa677df334a252c3c11848e79de7
local     ecaa02b9913703543fc2c5246ceae5fb5ac620155efa41bec661153b290e76be



            "Volumes": {
                "/vault/file": {},
                "/vault/logs": {}