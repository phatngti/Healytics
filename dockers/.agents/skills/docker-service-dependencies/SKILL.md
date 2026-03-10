---
name: docker-service-dependencies
description: Docker service dependency orchestration — depends_on conditions, healthcheck design, startup ordering, init container patterns, and failure recovery.
---

# Docker Service Dependencies

You are an expert in Docker service dependency orchestration, ensuring services start in the correct order and only when their dependencies are truly ready.

## Core Competencies

### `depends_on` with Conditions

Docker Compose V2 supports three conditions:

```yaml
depends_on:
  database:
    condition: service_healthy              # Wait until healthcheck passes
  migrations:
    condition: service_completed_successfully  # Wait until exit code 0
  cache:
    condition: service_started              # Just wait for container start (default)
```

> **Rule**: Never use bare `depends_on: [service]` — always specify a condition for reliable ordering.

### Healthcheck Design Patterns

#### Database (PostgreSQL)
```yaml
healthcheck:
  test: ["CMD", "pg_isready", "-U", "kong"]
  interval: 5s
  timeout: 10s
  retries: 10
```

#### HTTP API (Kong, Nginx, etc.)
```yaml
healthcheck:
  test: ["CMD", "kong", "health"]
  interval: 10s
  timeout: 10s
  retries: 10
```

#### Generic HTTP Endpoint
```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8001/status"]
  interval: 10s
  timeout: 5s
  retries: 5
  start_period: 30s    # Grace period before first check
```

#### TCP Port Check
```yaml
healthcheck:
  test: ["CMD", "nc", "-z", "localhost", "5432"]
  interval: 5s
  timeout: 3s
  retries: 10
```

### Startup Ordering Patterns

#### Pattern 1: Database → Migrations → Application
```yaml
services:
  database:
    healthcheck: ...

  migrations:
    depends_on:
      database:
        condition: service_healthy
    restart: on-failure
    command: migrate up

  app:
    depends_on:
      migrations:
        condition: service_completed_successfully
```

#### Pattern 2: Database → Bootstrap → App → Configurator
This is the pattern used in this project:
```
kong-ee-database (service_healthy)
  └── kong-bootstrap (service_completed_successfully)
        └── kong-cp (service_healthy)
              └── kong-configurator
```

### Init Container Pattern
For one-shot setup tasks (migrations, seeding, config application):
```yaml
services:
  init-task:
    image: my-app:latest
    restart: "no"           # Run once and exit
    command: setup-script
    depends_on:
      database:
        condition: service_healthy
```

### Failure Recovery
- `restart: on-failure` — restart on non-zero exit (good for bootstrap/migration)
- `restart: unless-stopped` — always restart unless manually stopped
- `restart: "no"` — never restart (for one-shot tasks)
- `restart: always` — always restart (avoid in most cases)

### Debugging Dependency Issues
```bash
# Check service status and health
docker compose ps

# View dependency graph
docker compose config --services

# Check why a service isn't starting
docker compose logs <service-name>

# Check healthcheck status
docker inspect --format='{{json .State.Health}}' <container-name> | jq

# Force restart a specific service
docker compose restart <service-name>

# Start a specific service and its dependencies
docker compose up <service-name>
```

### Common Pitfalls
1. **Missing healthcheck**: `service_healthy` condition requires a healthcheck on the dependency
2. **Too-short intervals**: Database containers may need 30+ seconds to initialize
3. **Wrong restart policy**: Bootstrap services should use `on-failure`, not `always`
4. **Port vs. readiness**: A port being open does NOT mean the service is ready (use app-specific checks)
5. **Circular dependencies**: Compose will error — restructure with shared networks instead

## When to Use This Skill
- Adding new services that depend on existing ones
- Debugging "connection refused" errors during startup
- Designing healthcheck configurations
- Setting up migration or seed containers
- Troubleshooting services that start before dependencies are ready

## Project Context

Current dependency chain:
```
kong-ee-database (PostgreSQL, healthcheck: pg_isready)
  └── kong-bootstrap (migrations, condition: service_healthy, restart: on-failure)
        └── kong-cp (Control Plane, condition: service_completed_successfully, healthcheck: kong health)
              └── kong-configurator (deck sync, condition: service_healthy)
```
