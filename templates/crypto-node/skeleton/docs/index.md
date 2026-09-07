# ${{ values.coinName }} Node — ${{ values.componentId }}

${{ values.description }}

A **${{ values.coinName }}** full node. This repo vendors the upstream source,
applies local patches, builds a Docker image, and deploys via systemd.

## Quick Links

- **Upstream source:** ${{ values.upstreamUrl }}
- **Binaries:** ${{ values.binaryName }}

## Repository layout

| Path | Purpose |
|------|---------|
| `${{ values.sourceDir }}/` | Vendored upstream source |
| `patches/` | Local source patches (applied locally + at image build) |
| `Dockerfile` | Builds the node binaries |
| `build.sh` | Builds `${{ values.imageRepo }}:<local-sha>` |
| `patch.sh` | Vendors upstream + applies `patches/` |
| `deploy-${{ values.componentId }}.service` | systemd unit wrapping `docker run` |
| `.github/workflows/build-node.yml` | CI: build + push image on self-hosted runner |

## Networking

| Port | Purpose |
|------|---------|
| ${{ values.rpcPort }} | JSON-RPC |
| ${{ values.p2pPort }} | P2P |

## Build

```bash
./patch.sh                                          # vendor upstream + apply patches
cp ${{ values.coinName | lower }}.conf.example ${{ values.coinName | lower }}.conf
./build.sh                                          # -> ${{ values.imageRepo }}:<sha>
```

## Deploy (systemd)

```bash
sudo cp deploy-${{ values.componentId }}.service /etc/systemd/system/${{ values.componentId }}.service
sudo cp ${{ values.coinName | lower }}.conf.example /root/.${{ values.coinName | lower }}/${{ values.coinName | lower }}.conf
sudo nano /root/.${{ values.coinName | lower }}/${{ values.coinName | lower }}.conf   # set rpcpassword
sudo systemctl enable --now ${{ values.componentId }}
```

State lives in a docker volume `${{ values.componentId }}-data`. The host config
is mounted read-only into the container, and the daemon picks it up automatically
from its default datadir — no node CLI flags are required.
