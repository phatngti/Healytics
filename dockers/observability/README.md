# Healytics Observability

Private backend observability stack for Docker Compose.

## Start

Set a strong scrape token in `.env`:

```sh
METRICS_BEARER_TOKEN="$(openssl rand -hex 32)"
```

Start the monitoring services:

```sh
docker compose --profile observability up -d
```

## Backend Metrics Target

By default Prometheus scrapes the backend through Docker DNS:

```env
BACKEND_METRICS_SCHEME=http
BACKEND_METRICS_TARGET=backend:8080
BACKEND_METRICS_PATH=/metrics
```

To scrape another backend source, change those values in `.env`, or use the
single URL override:

```env
BACKEND_METRICS_URL=https://dev.healytics.me/backend/metrics
```

This split form is also supported:

```env
BACKEND_METRICS_SCHEME=https
BACKEND_METRICS_TARGET=dev.healytics.me/backend
BACKEND_METRICS_PATH=/metrics
```

Use a full URL with `http://` or `https://`; do not omit the colon after the
scheme.

## Private URLs

Services bind to `OBS_BIND_ADDR`, which defaults to `127.0.0.1`.

- Grafana: `http://127.0.0.1:${GRAFANA_PORT:-3001}`
- Prometheus: `http://127.0.0.1:${PROMETHEUS_PORT:-9090}`
- Kibana: `http://127.0.0.1:${KIBANA_PORT:-5601}`

Cloudflare tunnel routes can also be enabled from:

- `cloudflare-tunnels.json`
- `cloudflare-tunnels.dev.json`

The configured dashboard routes are:

- Production Grafana: `https://grafana.healytics.me`
- Production Kibana: `https://kibana.healytics.me` and `https://es.healytics.me`
- Production Kong Manager: `https://kong.healytics.me`
- Dev Grafana: `https://grafana-dev.healytics.me`
- Dev Kibana: `https://kibana-dev.healytics.me` and `https://es-dev.healytics.me`
- Dev Kong Manager: `https://kong-dev.healytics.me`

## Checks

```sh
docker compose --profile observability ps
docker compose --profile observability logs prometheus grafana filebeat
```

Prometheus should show these targets:

- `healytics-backend`
- `cadvisor`
- `node-exporter`
- `prometheus`
