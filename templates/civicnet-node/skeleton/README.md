# CivicNet Node — ${{ values.componentId }}

${{ values.description }}

A **CivicNet (CIVIC)** node running `civicnetd`. CivicNet is a hybrid
PoW+PoS network (60s target, PoS ceiling 30%).

## Quick reference

| Setting      | Value |
|--------------|-------|
| RPC user     | `${{ values.rpcUser }}` |
| RPC port     | `${{ values.rpcPort }}` |
| P2P port     | `${{ values.p2pPort }}` |
| Container    | ${{ values.containerized }} |
| Data dir     | `~/.civicnet` (host) / `/root/.civicnet` (container) |

## Service

Configured via `civicnet.conf` (RPC) and, on host, the systemd unit
`civicnetd.service`. See `deploy/`.

## Deploy

### Host (systemd)
```bash
sudo cp deploy/civicnetd.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now civicnetd
```

### Docker
```bash
docker compose -f deploy/docker-compose.yml up -d
```

## Healthcheck
```bash
./healthcheck.sh
```
Returns 0 and prints current block height if the node is synced and RPC
responds.

## RPC
```bash
civicnet-cli -rpcuser=${{ values.rpcUser }} \
  -rpcpassword=<your-password> \
  -rpcport=${{ values.rpcPort }} getblockchaininfo
```
> The RPC password is stored in `civicnet.conf`; treat it as a secret.
