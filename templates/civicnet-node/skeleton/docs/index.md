# ${{ values.componentId }}

!!! abstract "What this is"
    ${{ values.description }}

    A **CivicNet (CIVIC)** full node — a hybrid **Proof-of-Work + Proof-of-Stake** blockchain node with a 60-second target block time and a 30% PoS ceiling. This repository vendors the upstream CivicNet source code, applies local patches, builds a Docker image, and deploys it as a systemd unit.

<!-- status badges: rendered by the GitHub Actions + GitHub Insights plugins in Backstage -->

## Quick facts

| | |
|---|---|
| Network | CivicNet (CIVIC) |
| Consensus | Hybrid PoW + PoS (60s target, PoS ceiling 30%) |
| Component | `${{ values.componentId }}` |
| System | `${{ values.system }}` |
| Owner | `${{ values.owner }}` |
| Repository | [`${{ values.repoUrl }}`](${{ values.repoUrl }}) |
| RPC | port `${{ values.rpcPort }}` |
| P2P | port `${{ values.p2pPort }}` |
| Lifecycle | Experimental |

## What's in this documentation

This documentation is authored as **markdown in the repository** and rendered by
**Backstage TechDocs**. It is built and published automatically by CI on every
change to `main` — there is no separate documentation source to maintain.

- **[Architecture](architecture.md)** — how the node works under the hood
- **[Deployment runbook](deployment.md)** — from zero to a running node
- **[Configuration](configuration.md)** — every config option explained
- **[API & monitoring](api.md)** — RPC endpoints, health checks, metrics
- **[Troubleshooting](troubleshooting.md)** — how to recover from common issues

!!! tip "In Backstage"
    This entity is registered in the Backstage **software catalog**. Use the
    **GitHub Actions** tab to see CI status, the **GitHub Insights** tab for repo
    metrics, and the **graph** view to see how this node relates to its system and
    API.
