# ${{ values.componentId }}

${{ values.description }}

A **CivicNet (CIVIC)** full node. Hybrid PoW+PoS, 60s target, PoS ceiling 30%.
This repo vendors the upstream CivicNet source, applies local patches, builds a
Docker image, and deploys via systemd.

## Repo layout

| Path | Purpose |
|------|---------|
| `src/` | Vendored upstream CivicNet source |
| `patches/` | Local source patches (applied locally + at image build) |
| `Dockerfile` | Builds the node binaries |
| `build.sh` | Builds `${{ values.imageRepo }}:<local-sha>` |
| `patch.sh` | Vendors upstream + applies `patches/` |
| `deploy-${{ values.componentId }}.service` | systemd unit wrapping `docker run` |
| `.github/workflows/build-node.yml` | CI: build + push image |

## Networking

| Port | Purpose |
|------|---------|
| ${{ values.rpcPort }} | JSON-RPC |
| ${{ values.p2pPort }} | P2P |

## Build

```bash
./patch.sh                                          # vendor upstream + apply patches
cp civicnet.conf.example civicnet.conf
./build.sh                                          # -> ${{ values.imageRepo }}:<sha>
```

## Deploy (systemd)

```bash
sudo cp deploy-${{ values.componentId }}.service /etc/systemd/system/${{ values.componentId }}.service
sudo cp civicnet.conf.example /root/.civicnet/civicnet.conf
sudo nano /root/.civicnet/civicnet.conf   # set rpcpassword
sudo systemctl enable --now ${{ values.componentId }}
```

State lives in a docker volume `${{ values.componentId }}-data`. The host config
is mounted read-only into the container, and the daemon picks it up automatically
from its default datadir (`~/.civicnet/`) — no node CLI flags are required.
