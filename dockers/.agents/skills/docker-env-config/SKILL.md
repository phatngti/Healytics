---
name: docker-env-config
description: Docker environment variables, .env files, config file mounting, secrets management, and YAML anchor patterns for shared environment blocks.
---

# Docker Environment and Config Management

You are an expert in Docker environment variable management, configuration file mounting, and secrets handling.

## Core Competencies

### Environment Variable Sources (Precedence Order)
1. `environment:` key in compose file (highest priority)
2. Shell environment variables
3. `.env` file in the compose project directory
4. `env_file:` directive
5. Dockerfile `ENV` instruction (lowest priority)

### `.env` File
```bash
# .env (auto-loaded by docker compose)
GW_IMAGE=kong/kong-gateway:3.12.0.2
GW_HOST=localhost
KONG_LICENSE_DATA=
POSTGRES_PASSWORD=kong
```

- Placed in the same directory as `docker-compose.yml`
- Auto-loaded by `docker compose` — no extra config needed
- Use for **default values** and **host-specific overrides**
- **Never commit `.env` to version control** — add to `.gitignore`
- Provide a `.env.example` with placeholder values

### `env_file` Directive
```yaml
services:
  my-service:
    env_file:
      - .env              # defaults
      - .env.local        # local overrides (git-ignored)
```

### Inline Environment Variables
```yaml
services:
  kong-ee-database:
    environment:
      POSTGRES_USER: kong
      POSTGRES_DB: kong
      POSTGRES_PASSWORD: kong
```

### YAML Anchors for Shared Environment
```yaml
# Define once at the top
x-kong-config: &kong-env
  KONG_DATABASE: postgres
  KONG_PG_HOST: kong-ee-database
  KONG_PG_DATABASE: kong
  KONG_PG_USER: kong
  KONG_PG_PASSWORD: kong

# Reuse in services with merge key
services:
  kong-bootstrap:
    environment:
      <<: *kong-env                  # merges all keys from anchor
      KONG_PASSWORD: handyshake      # adds/overrides specific keys
```

### Variable Substitution
```yaml
# With default value
image: '${GW_IMAGE:-kong/kong-gateway:3.12.0.2}'

# Required (fails if not set)
image: '${GW_IMAGE:?GW_IMAGE must be set}'

# Empty string fallback
image: '${GW_IMAGE-}'
```

### Config File Mounting
```yaml
volumes:
  - ./kong.yml:/kong.yml:ro           # Single file, read-only
  - ./config/:/etc/app/config/:ro     # Directory, read-only
```

Best practices for config mounts:
- Always use `:ro` (read-only) for config files
- Use relative paths for portability
- Keep config files in the project directory

### Docker Secrets (Swarm / Compose v3.1+)
```yaml
secrets:
  db_password:
    file: ./secrets/db_password.txt

services:
  database:
    secrets:
      - db_password
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password
```

### Environment Variable Debugging
```bash
# View resolved config (with interpolated env vars)
docker compose config

# Check a running container's environment
docker exec <container> env

# Check what compose file vars resolve to
docker compose config --format json | jq '.services.<name>.environment'
```

## When to Use This Skill
- Setting up environment variables for new services
- Creating/updating `.env` files
- Debugging environment variable resolution issues
- Refactoring hardcoded values into env vars or YAML anchors
- Mounting configuration files into containers
- Setting up secrets management

## Project Context

This workspace uses:
- **YAML anchor** `x-kong-config: &kong-env` for shared Kong database connection settings
- **Variable substitution** `${GW_IMAGE:-...}` and `${KONG_LICENSE_DATA}` and `${GW_HOST:-localhost}`
- **Bind mount** `./kong.yml` for declarative Kong configuration
- **Inline `environment:`** blocks with merge keys (`<<: *kong-env`) plus service-specific overrides
