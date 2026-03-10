---
name: docker-volume-management
description: Docker volume and data persistence — named volumes, bind mounts, volume lifecycle, backup/restore, and driver selection.
---

# Docker Volume Management

You are a Docker volume and data persistence expert covering named volumes, bind mounts, and data lifecycle strategies.

## Core Competencies

### Volume Types

#### Named Volumes (Preferred for data persistence)
```yaml
# Declaration in docker-compose.yml
volumes:
  kong_db_data:        # Uses default local driver
  # kong_db_data:
  #   driver: local
  #   driver_opts:
  #     type: none
  #     o: bind
  #     device: /path/on/host

# Usage in service
services:
  kong-ee-database:
    volumes:
      - kong_db_data:/var/lib/postgresql
```

#### Bind Mounts (For config files and development)
```yaml
# Mount a specific file (read-only recommended for configs)
volumes:
  - ./kong.yml:/kong.yml:ro

# Mount a directory
volumes:
  - ./config:/etc/app/config:ro
```

#### tmpfs Mounts (Temporary in-memory storage)
```yaml
tmpfs:
  - /tmp
  - /run
```

### Volume Lifecycle
```bash
# List all volumes
docker volume ls

# Inspect volume details (mount point, driver, etc.)
docker volume inspect kong_db_data

# Create a volume explicitly
docker volume create --name my-data

# Remove a specific volume
docker volume rm kong_db_data

# Remove ALL unused volumes (DANGEROUS)
docker volume prune
```

### Backup and Restore

#### Backup a Named Volume
```bash
docker run --rm \
  -v kong_db_data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/kong_db_backup_$(date +%Y%m%d).tar.gz -C /data .
```

#### Restore a Named Volume
```bash
docker run --rm \
  -v kong_db_data:/data \
  -v $(pwd)/backups:/backup \
  alpine sh -c "cd /data && tar xzf /backup/kong_db_backup_20240101.tar.gz"
```

### Best Practices
- **Always use named volumes** for database data — never anonymous volumes
- **Mount config files as read-only** (`:ro`) to prevent accidental writes
- **Never store application state in the container filesystem** — it's ephemeral
- **Back up volumes regularly** before destructive operations (`docker compose down -v`)
- **Use `.dockerignore`** to exclude unnecessary files from build context

### Volume Permissions
```yaml
# Fix permission issues by specifying user
services:
  database:
    user: "1000:1000"
    volumes:
      - db_data:/var/lib/postgresql/data
```

## When to Use This Skill
- Setting up data persistence for databases
- Mounting configuration files into containers
- Backing up or migrating volume data
- Debugging volume permission errors
- Cleaning up orphaned volumes

## Project Context

This workspace uses:
| Volume/Mount | Type | Service | Purpose |
|---|---|---|---|
| `kong_db_data` | Named volume | `kong-ee-database` | PostgreSQL data persistence |
| `./kong.yml:/kong.yml` | Bind mount | `kong-configurator` | Declarative Kong config |
