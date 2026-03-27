---
description: Gracefully stop and remove all Docker Compose services
---

# Docker Down

Stop and remove all containers in the stack. Data in named volumes is preserved.

// turbo
1. Stop all services and remove containers and networks:
```bash
docker compose down
```

// turbo
2. Verify all containers are stopped:
```bash
docker compose ps -a
```

## Options

- **Preserve data** (default above): `docker compose down`
- **Remove data volumes too**: `docker compose down -v` ⚠️ This deletes all database data!
- **Remove images too**: `docker compose down --rmi all`
