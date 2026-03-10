---
description: Verify all Docker services are healthy and endpoints are reachable
---

# Docker Health Check

Verify the health status of all services in the stack.

// turbo
1. Check container status and health:
```bash
docker compose ps
```

// turbo
2. Check detailed healthcheck results for each service:
```bash
echo "=== kong-ee-database ===" && docker inspect --format='{{.State.Health.Status}}' kong-ee-database 2>/dev/null || echo "not running"
echo "=== kong-cp ===" && docker inspect --format='{{.State.Health.Status}}' kong-cp 2>/dev/null || echo "not running"
```

3. Test Kong Admin API endpoint:
```bash
curl -s -o /dev/null -w "Admin API: HTTP %{http_code}\n" http://localhost:8001/status
```

4. Test Kong Proxy endpoint:
```bash
curl -s -o /dev/null -w "Proxy: HTTP %{http_code}\n" http://localhost:8000/
```

5. Test Kong Manager GUI:
```bash
curl -s -o /dev/null -w "Manager GUI: HTTP %{http_code}\n" http://localhost:8002/
```

## Expected Healthy State
| Service | Status | Health |
|---|---|---|
| `kong-ee-database` | Running | healthy |
| `kong-bootstrap` | Exited (0) | N/A (one-shot) |
| `kong-cp` | Running | healthy |
| `kong-configurator` | Exited (0) | N/A (one-shot) |

## Port Reference
| Port | Service | Purpose |
|---|---|---|
| 5432 | PostgreSQL | Database |
| 8000 | Kong Proxy | HTTP traffic |
| 8443 | Kong Proxy | HTTPS traffic |
| 8001 | Kong Admin API | HTTP |
| 8444 | Kong Admin API | HTTPS |
| 8002 | Kong Manager | GUI (HTTP) |
| 8445 | Kong Manager | GUI (HTTPS) |
