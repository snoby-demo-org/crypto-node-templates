#!/usr/bin/env bash
# CivicNet node healthcheck — verifies the node is up, synced, and RPC responds.
set -euo pipefail
# Configure to match your node.
RPC_USER="${RPC_USER:-${{ values.rpcUser }}}"
RPC_PORT="${RPC_PORT:-${{ values.rpcPort }}}"
RPC_PASS="${RPC_PASS:-${{ values.rpcPassword }}}"

info="$(curl -sS --user "$RPC_USER:$RPC_PASS" \
  --data-binary '{"jsonrpc":"1.0","id":"healthcheck","method":"getblockchaininfo","params":[]}' \
  -H 'content-type: text/plain;' \
  "http://127.0.0.1:$RPC_PORT/" 2>/dev/null || true)"

if [ -z "$info" ] || echo "$info" | grep -q '"error"'; then
  echo "ERROR: RPC did not respond or returned an error." >&2
  exit 1
fi

height="$(echo "$info" | sed -n 's/.*"blocks":\([0-9]*\).*/\1/p')"
verification="$(echo "$info" | sed -n 's/.*"verificationprogress":\([0-9.]*\).*/\1/p')"

echo "height=$height verificationprogress=$verification"
awk -v v="$verification" 'BEGIN{exit !(v>=0.9999)}' || {
  echo "ERROR: node is not fully synced (verificationprogress < 1.0)." >&2
  exit 1
}
echo "OK"
