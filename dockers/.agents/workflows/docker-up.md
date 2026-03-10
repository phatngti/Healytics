---
description: Start the full Docker Compose stack (Kong Gateway + PostgreSQL)
---

# Docker Up

Start all services in the Kong Gateway stack.

// turbo
1. Navigate to the dockers directory and start all services in detached mode:
```bash
docker compose up -d
```

// turbo
2. Wait for all services to become healthy (may take 30-60 seconds):
```bash
docker compose ps
```

3. Verify Kong Admin API is accessible:
```bash
curl -s http://localhost:8001/status | head -20
```

4. Verify Kong Manager GUI is accessible at: `http://localhost:8002`

## Expected Startup Order
1. `kong-ee-database` → PostgreSQL starts and becomes healthy
2. `kong-bootstrap` → Runs migrations and exits successfully
3. `kong-cp` → Kong Control Plane starts and becomes healthy
4. `kong-configurator` → Applies `kong.yml` config via `deck sync`

## Troubleshooting
- If `kong-bootstrap` keeps restarting, check database connectivity: `docker compose logs kong-bootstrap`
- If `kong-configurator` fails, ensure `kong-cp` is healthy first: `docker inspect --format='{{json .State.Health.Status}}' kong-cp`
