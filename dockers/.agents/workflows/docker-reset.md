---
description: Full nuclear reset — remove all containers, volumes, images, and start from scratch
---

# Docker Reset

Complete teardown and fresh start. **This destroys ALL data including database volumes.**

> ⚠️ **WARNING**: This workflow deletes all data. Back up volumes first if needed.

1. Stop and remove everything (containers, networks, volumes):
```bash
docker compose down -v --remove-orphans
```

2. Remove pulled images (optional, forces re-download):
```bash
docker compose down --rmi all
```

3. Prune any remaining dangling resources:
```bash
docker system prune -f
```

// turbo
4. Start fresh:
```bash
docker compose up -d
```

// turbo
5. Verify the fresh stack is healthy:
```bash
docker compose ps
```

## When to Use
- Database is in a corrupt or unrecoverable state
- Switching between incompatible image versions
- Starting development from a completely clean slate
- Testing first-run initialization flow
