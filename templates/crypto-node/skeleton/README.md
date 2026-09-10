# ${{ values.coinName }} Node — ${{ values.componentId }}

${{ values.description }}

A **${{ values.coinName }}** full node. This repo vendors the upstream source,
applies local patches, builds a Docker image, and deploys with Docker Compose
(RPC / P2P / ZMQ).

## What this is

- `${{ values.sourceDir }}/` — vendored upstream source (${{ values.upstreamUrl }})
- `patches/` — local source patches (applied both locally and at image build)
- `Dockerfile` — builds the node binaries (${{ values.binaryName }})
- `build.sh` — builds `${{ values.imageRepo }}:<local-sha>` from the local tree
- `patch.sh` — vendors the upstream source + applies `patches/`
- `.github/workflows/` — GitHub Actions workflows (selected at scaffold time):
  - `build-node.yml` — build+push the node image on the k8s self-hosted runner
    (ARC scale set `${{ values.runnerLabel }}`). Trigger with "Run workflow",
    optionally passing an upstream tag to vendor+build.
  - `ci.yml` — validates the repo's YAML parses on push/PR.
  - `dagger-checks.yml` — lint + PII scan via the shared Dagger engine.
  - `smoke.yml` — builds the image and boots the node to confirm RPC/health.
- `deploy-${{ values.componentId }}.service` — systemd unit wrapping `docker run`

## Build

```bash
./patch.sh                                          # vendor upstream + apply patches
cp ${{ values.coinName | lower }}.conf.example ${{ values.coinName | lower }}.conf
./build.sh                                          # -> ${{ values.imageRepo }}:<sha>
```

### Patching
`patch.sh` clones `${{ values.upstreamUrl }}` into `./${{ values.sourceDir }}`
and applies every `patches/*.patch` with `patch -p1`. The Dockerfile re-applies
the same patches at build time. To add your own change:

```sh
./patch.sh
cd ${{ values.sourceDir }}
# edit source...
git diff > ../patches/99-my-change.patch
cd ..
./build.sh
```

## Deploy (systemd)

The node runs as a **systemd unit** wrapping `docker run`. No node flags are
passed on the command line — the daemon **picks up its config automatically**
from the datadir. The host config `${{ values.coinName | lower }}.conf` is
**mounted read-only** into the container at
`/root/.${{ values.coinName | lower }}/${{ values.coinName | lower }}.conf`,
so the daemon's default datadir lookup finds it.

```bash
sudo cp deploy-${{ values.componentId }}.service /etc/systemd/system/${{ values.componentId }}.service
sudo cp ${{ values.coinName | lower }}.conf.example /root/.${{ values.coinName | lower }}/${{ values.coinName | lower }}.conf
sudo nano /root/.${{ values.coinName | lower }}/${{ values.coinName | lower }}.conf   # set rpcpassword
sudo systemctl enable --now ${{ values.componentId }}
```

State in a docker volume `${{ values.componentId }}-data`. Ports:

| Port | Purpose |
|------|---------|
| ${{ values.rpcPort }} | JSON-RPC |
| ${{ values.p2pPort }} | P2P |
| 28332-28335 | ZMQ (hashblock/hashtx/rawblock/rawtx) |
