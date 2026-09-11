# ${{ values.componentId }}

${{ values.description }}

## Overview

This component was onboarded into Backstage via the **golden path** template,
which added continuous integration and documentation to an existing project.

## Repository layout

| Path | Purpose |
|------|---------|
| `.github/workflows/build.yml` | CI: compile + self-test on the self-hosted runner |
| `.github/workflows/ci.yml` | Cheap YAML/format gate on push & PR |
| `.github/workflows/techdocs.yml` | Publish these docs to Backstage TechDocs (MinIO) |
| `catalog-info.yaml` | Backstage Component entity (this repo's registry entry) |
| `docs/` | This documentation |

## Build

The project is built automatically on every push/PR by the self-hosted ARC
runner. To build locally:

```bash
./autogen.sh        # if present, else: autoreconf -fiv
./configure --with-crypto --with-curl
make -j"$(nproc)"
```
