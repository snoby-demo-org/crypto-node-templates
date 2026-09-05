# crypto-node-templates

Backstage **software templates** for scaffolding crypto node deployments.

Discovered via Backstage's catalog from this repo's `catalog-info.yaml`.

## Templates

- [`templates/civicnet-node/`](templates/civicnet-node/) — **CivicNet (CIVIC) node**:
  scaffolds a `civicnetd` daemon repo with config, systemd unit, Docker
  compose, healthcheck, and README. Generates and *pushes* a fresh private
  GitHub repo.

## How it works

Using a template in Backstage (`/create`) walks you through a form, then runs
the scaffolder actions (`fetch:template` → `publish:github` → `catalog:register`).
The result is a new private repo under `snoby/` registered in the catalog.

## Structure

```
catalog-info.yaml                 # catalog Location -> discovers templates
templates/
  <name>/
    template.yaml                 # Backstage Template entity (v1beta3)
    skeleton/                     # files scaffolded into new repos (Nunjucks)
```
