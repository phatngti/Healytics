# Docker Project Rules

## Compose File Conventions

1. **Always use named volumes** — never anonymous volumes. Every volume must be declared in the top-level `volumes:` section.
2. **Always include healthchecks** on database and application containers. Use `pg_isready` for PostgreSQL, `kong health` for Kong.
3. **Use YAML anchors** (`x-*` extensions) for shared environment blocks. Avoid duplicating environment variables across services.
4. **Use `depends_on` with conditions** — never bare `depends_on: [service]`. Always specify `service_healthy` or `service_completed_successfully`.
5. **Set `container_name`** on every service for predictable DNS and log readability.

## Image Management

6. **Pin image versions** in production. Use `postgres:16.2` not `postgres:latest`.
7. **Support image overrides** via env vars with defaults: `'${GW_IMAGE:-kong/kong-gateway:3.12.0.2}'`
8. **Use `latest` only** for development tooling (e.g., `kong/deck:latest`).

## Environment and Config

9. **Never commit `.env` files** — add to `.gitignore`. Provide `.env.example` instead.
10. **Mount config files as read-only** — use `:ro` suffix on bind mounts (e.g., `./kong.yml:/kong.yml:ro`).
11. **Never hardcode secrets** in `docker-compose.yml` — use `.env` files or Docker secrets.

## Service Design

12. **One-shot services** (migrations, config sync) should use `restart: on-failure` or `restart: "no"`.
13. **Long-running services** should use `restart: on-failure` or `restart: unless-stopped`.
14. **All services** must be on the project's custom bridge network — never use the default network.

## Networking

15. **Use internal service names** for inter-container communication (e.g., `http://kong-cp:8001`).
16. **Expose only necessary ports** to the host. Internal-only services should not map ports.
17. **Document port mappings** with comments when the purpose isn't obvious.
