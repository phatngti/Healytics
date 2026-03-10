---
description: Rebuild Docker images and restart services with fresh configuration
---

# Docker Rebuild

Rebuild images and restart services. Use when `docker-compose.yml`, `kong.yml`, or Dockerfiles have changed.

// turbo
1. Stop existing services:
```bash
docker compose down
```

// turbo
2. Pull latest base images:
```bash
docker compose pull
```

// turbo
3. Rebuild and start with fresh containers:
```bash
docker compose up -d --force-recreate
```

// turbo
4. Verify all services are healthy:
```bash
docker compose ps
```

## When to Use
- After modifying `docker-compose.yml`
- After updating `kong.yml` (declarative config)
- After changing image versions in `.env`
- After modifying any mounted config files
