# CivicNet Node — ${{ values.componentId }}

${{ values.description }}

A **CivicNet (CIVIC)** node. CivicNet is a hybrid PoW+PoS network (60s target,
PoS ceiling 30%). This repo builds the node image from vendored upstream source
and deploys it with Docker Compose, wired for RPC, P2P, and ZMQ (for the pool
feed).

## What this is

Mirrors the `CivicLight/CivicNet` image-repo pattern:

- `civicnet/` — vendored upstream `CivicLight/CivicNet` source (refreshed via `git fetch`)
- `patches/` — local source patches (e.g. bump outbound/addnode connections 8→32)
- `Dockerfile` — builds `civicnet-node`, `civicnet-cli`, `civicnet-wallet` (ZMQ enabled)
- `build.sh` — builds `iotapi322/civicnet:<local-sha>` from the local tree
- `docker-compose.yml` — deploys the node with persistent data/logs

## Build

```bash
./patch.sh                                  # vendor upstream source into ./civicnet + apply patches in patches/
cp civicnet.conf.example civicnet.conf      # set rpcuser/rpcpassword
./build.sh                                  # -> iotapi322/civicnet:<sha>
```

### Patching the source
`patch.sh` clones `CivicLight/CivicNet` into `./civicnet/` and applies every
`patches/*.patch` with `patch -p1`. The Dockerfile re-applies the same patches
at image build time (so both local tree and image carry them). To add your own
change:

```sh
./patch.sh                     # ensure ./civicnet is present
cd civicnet
# edit source...
git diff > ../patches/99-my-change.patch
cd ..
./build.sh                     # image now includes your patch
```

To refresh vendored source from upstream:
```bash
git -C civicnet fetch origin && git -C civicnet reset --hard origin/master
```

## Deploy (systemd)

The node runs as a **systemd unit** wrapping `docker run`. No node flags are
passed on the command line — the daemon **picks up its config automatically**
from the datadir. The host config `civicnet.conf` is **mounted read-only** into
the container at `/root/.civicnet/civicnet.conf`, so the daemon's default
datadir lookup finds it.

```bash
sudo cp deploy-civicnet.service /etc/systemd/system/civicnet.service
sudo cp civicnet.conf.example /root/.civicnet/civicnet.conf
sudo nano /root/.civicnet/civicnet.conf      # set rpcpassword
sudo systemctl enable --now civicnet
```

State in a docker volume `<name>-data`. Ports:

| Port  | Purpose        |
|-------|----------------|
| ${{ values.rpcPort }} | JSON-RPC |
| ${{ values.p2pPort }} | P2P |
| 28332-28335 | ZMQ (hashblock/hashtx/rawblock/rawtx) |

## Healthcheck

`docker compose ps` shows health; the container runs `healthcheck.sh`
(check RPC reachable + node synced).
