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
- `docker-compose.yml` — deploys the node with persistent data/logs

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

## Deploy (Docker Compose)

```bash
cp .env.example .env && nano .env
docker compose up -d
```

State in `./data/`, logs in `./logs/`. Ports:

| Port | Purpose |
|------|---------|
| ${{ values.rpcPort }} | JSON-RPC |
| ${{ values.p2pPort }} | P2P |
| 28332-28335 | ZMQ (hashblock/hashtx/rawblock/rawtx) |
