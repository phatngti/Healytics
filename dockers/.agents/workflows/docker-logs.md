---
description: View and tail Docker container logs for debugging
---

# Docker Logs

View logs from services for debugging and monitoring.

## View logs for all services
// turbo
1. Show recent logs from all services:
```bash
docker compose logs --tail=50
```

## View logs for a specific service
// turbo
2. Show logs for a specific service (replace `<service>` with one of: `kong-ee-database`, `kong-bootstrap`, `kong-cp`, `kong-configurator`):
```bash
docker compose logs --tail=100 kong-cp
```

## Tail logs in real-time
3. Follow logs live (press Ctrl+C to stop):
```bash
docker compose logs -f kong-cp
```

## View logs with timestamps
// turbo
4. Add timestamps to log output:
```bash
docker compose logs -t --tail=50
```

## Common Debug Scenarios
- **Bootstrap failures**: `docker compose logs kong-bootstrap`
- **Database issues**: `docker compose logs kong-ee-database`
- **Config sync errors**: `docker compose logs kong-configurator`
- **API/Proxy errors**: `docker compose logs kong-cp`
