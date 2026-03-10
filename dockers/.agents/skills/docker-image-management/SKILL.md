---
name: docker-image-management
description: Docker image lifecycle management — pulling, building, tagging, pruning, multi-arch builds, and environment-variable-based image selection.
---

# Docker Image Management

You are a Docker image management expert covering the full image lifecycle from selection to cleanup.

## Core Competencies

### Image Selection and Pinning
- **Production**: Always pin to specific versions — `kong/kong-gateway:3.12.0.2`
- **Development**: Allow `latest` only for non-critical tools (e.g., `kong/deck:latest`)
- **Override pattern**: Use env vars with defaults — `'${GW_IMAGE:-kong/kong-gateway:3.12.0.2}'`
- Store default image versions in `.env` file for easy updates

### Pulling Images
```bash
# Pull all images defined in compose
docker compose pull

# Pull a specific service's image
docker compose pull kong-cp

# Pull with platform specification
docker pull --platform linux/amd64 kong/kong-gateway:3.12.0.2
```

### Building Custom Images
```bash
# Build from Dockerfile
docker build -t my-app:1.0 .

# Build with build args
docker build --build-arg VERSION=1.0 -t my-app:1.0 .

# Multi-stage build (keep images small)
# Use builder pattern: build stage → runtime stage

# Build via compose
docker compose build [service-name]
docker compose build --no-cache [service-name]
```

### Tagging Strategy
- Use semantic versioning: `app:1.2.3`
- Tag with git SHA for traceability: `app:abc1234`
- Always tag `latest` alongside version: `app:1.2.3` + `app:latest`

### Image Inspection
```bash
# View image details
docker image inspect <image>

# View image layers
docker history <image>

# Check image size
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
```

### Pruning and Cleanup
```bash
# Remove dangling images (untagged)
docker image prune

# Remove ALL unused images
docker image prune -a

# Remove specific image
docker rmi <image>

# Full system cleanup (images + containers + volumes + networks)
docker system prune -a --volumes
```

### Multi-Architecture Builds
```bash
# Create and use buildx builder
docker buildx create --use

# Build for multiple platforms
docker buildx build --platform linux/amd64,linux/arm64 -t app:1.0 --push .
```

## When to Use This Skill
- Selecting or updating base images for services
- Debugging image pull failures or version mismatches
- Cleaning up disk space from unused images
- Setting up CI/CD image build pipelines
- Investigating image size or layer optimization

## Project Context

This workspace uses these images:
| Service | Image | Pinned? |
|---|---|---|
| `kong-ee-database` | `postgres:latest` | ⚠️ No — consider pinning |
| `kong-bootstrap` | `${GW_IMAGE:-kong/kong-gateway:3.12.0.2}` | ✅ Yes (with override) |
| `kong-cp` | `${GW_IMAGE:-kong/kong-gateway:3.12.0.2}` | ✅ Yes (with override) |
| `kong-configurator` | `kong/deck:latest` | ⚠️ No — acceptable for tooling |
