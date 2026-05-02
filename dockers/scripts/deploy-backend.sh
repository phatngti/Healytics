#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${COMPOSE_DIR}"

TAG="${1:-${BACKEND_TAG:-}}"
if [[ -z "${TAG}" ]]; then
  echo "ERROR: backend image tag is required." >&2
  echo "Usage: $0 <immutable-tag>" >&2
  exit 2
fi

if [[ "${TAG}" == "latest" ]]; then
  echo "ERROR: refusing to deploy mutable tag 'latest'." >&2
  exit 2
fi

BACKEND_IMAGE="${BACKEND_IMAGE:-giahung2111/healytics_backend}"
BACKEND_MIGRATION_IMAGE="${BACKEND_MIGRATION_IMAGE:-giahung2111/healytics_backend-migrate}"
BACKEND_MIGRATION_TAG="${BACKEND_MIGRATION_TAG:-${TAG}}"
BACKEND_RUN_MIGRATIONS="${BACKEND_RUN_MIGRATIONS:-true}"
COMPOSE_NETWORK_NAME="${COMPOSE_NETWORK_NAME:-healytics_services}"
KONG_PROXY_URL="${KONG_PROXY_URL:-http://127.0.0.1:8000}"
DEPLOY_ENV="${DEPLOY_ENV:-deploy.env}"
APP_ENV_FILE="${APP_ENV_FILE:-backend.env}"

if [[ ! -f ".env" ]]; then
  echo "ERROR: .env is required in ${COMPOSE_DIR}." >&2
  exit 2
fi

if [[ ! -f "${APP_ENV_FILE}" ]]; then
  echo "ERROR: ${APP_ENV_FILE} is required in ${COMPOSE_DIR}." >&2
  exit 2
fi

compose() {
  docker compose --env-file .env --env-file "${DEPLOY_ENV}" "$@"
}

read_env_value() {
  local file="$1"
  local key="$2"

  if [[ ! -f "${file}" ]]; then
    return 1
  fi

  awk -F= -v key="${key}" '$1 == key { print substr($0, length(key) + 2); found = 1 } END { exit found ? 0 : 1 }' "${file}"
}

write_deploy_env() {
  local tag="$1"
  local migration_tag="${2:-${tag}}"

  cat > "${DEPLOY_ENV}" <<EOF
BACKEND_IMAGE=${BACKEND_IMAGE}
BACKEND_TAG=${tag}
BACKEND_MIGRATION_IMAGE=${BACKEND_MIGRATION_IMAGE}
BACKEND_MIGRATION_TAG=${migration_tag}
BACKEND_RUN_MIGRATIONS=${BACKEND_RUN_MIGRATIONS}
COMPOSE_NETWORK_NAME=${COMPOSE_NETWORK_NAME}
BACKEND_DEPLOYED_AT=$(date -u +%Y-%m-%dT%H:%M:%SZ)
EOF
}

wait_for_backend() {
  echo "Waiting for backend container health..."
  for _ in $(seq 1 24); do
    local status
    status="$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' healytics-backend 2>/dev/null || true)"

    if [[ "${status}" == "healthy" ]]; then
      return 0
    fi

    sleep 5
  done

  docker logs --tail=200 healytics-backend || true
  return 1
}

verify_kong_route() {
  echo "Verifying Kong route ${KONG_PROXY_URL}/backend/health..."
  for _ in $(seq 1 24); do
    if curl -fsS "${KONG_PROXY_URL}/backend/health" >/dev/null; then
      return 0
    fi

    sleep 5
  done

  return 1
}

apply_kong_config() {
  echo "Applying Kong declarative config..."
  compose --profile prod rm -sf kong-configurator >/dev/null 2>&1 || true
  compose --profile prod up --no-deps kong-configurator
}

run_migrations() {
  if [[ "${BACKEND_RUN_MIGRATIONS}" != "true" ]]; then
    echo "Skipping migrations because BACKEND_RUN_MIGRATIONS=${BACKEND_RUN_MIGRATIONS}."
    return 0
  fi

  local postgres_user
  local postgres_password
  local postgres_db

  postgres_user="${POSTGRES_USER:-$(read_env_value .env POSTGRES_USER)}"
  postgres_password="${POSTGRES_PASSWORD:-$(read_env_value .env POSTGRES_PASSWORD)}"
  postgres_db="${POSTGRES_DB:-$(read_env_value .env POSTGRES_DB)}"

  echo "Pulling migration image ${BACKEND_MIGRATION_IMAGE}:${BACKEND_MIGRATION_TAG}..."
  docker pull "${BACKEND_MIGRATION_IMAGE}:${BACKEND_MIGRATION_TAG}"

  echo "Running backend migrations..."
  docker run --rm \
    --network "${COMPOSE_NETWORK_NAME}" \
    --env-file "${APP_ENV_FILE}" \
    -e NODE_ENV=production \
    -e POSTGRES_HOST=postgres \
    -e POSTGRES_PORT=5432 \
    -e POSTGRES_USER="${postgres_user:?POSTGRES_USER is required}" \
    -e POSTGRES_PASSWORD="${postgres_password:?POSTGRES_PASSWORD is required}" \
    -e POSTGRES_DB="${postgres_db:?POSTGRES_DB is required}" \
    "${BACKEND_MIGRATION_IMAGE}:${BACKEND_MIGRATION_TAG}"
}

rollback() {
  local previous_tag="$1"

  if [[ -z "${previous_tag}" || "${previous_tag}" == "${TAG}" ]]; then
    echo "No previous backend tag available for rollback." >&2
    return 1
  fi

  echo "Rolling back backend to ${previous_tag}..."
  write_deploy_env "${previous_tag}" "${previous_tag}"
  compose --profile prod pull backend
  compose --profile prod up -d --no-deps backend
  wait_for_backend
  apply_kong_config
  verify_kong_route
}

PREVIOUS_TAG="$(read_env_value "${DEPLOY_ENV}" BACKEND_TAG || true)"

echo "Deploying ${BACKEND_IMAGE}:${TAG}"
[[ -n "${PREVIOUS_TAG}" ]] && echo "Previous backend tag: ${PREVIOUS_TAG}"

write_deploy_env "${TAG}" "${BACKEND_MIGRATION_TAG}"

echo "Pulling backend image..."
if ! compose --profile prod pull backend; then
  [[ -n "${PREVIOUS_TAG}" ]] && write_deploy_env "${PREVIOUS_TAG}" "${PREVIOUS_TAG}"
  exit 1
fi

if ! run_migrations; then
  echo "Migration failed; backend container was not replaced." >&2
  [[ -n "${PREVIOUS_TAG}" ]] && write_deploy_env "${PREVIOUS_TAG}" "${PREVIOUS_TAG}"
  exit 1
fi

echo "Starting backend..."
if ! compose --profile prod up -d --no-deps backend; then
  rollback "${PREVIOUS_TAG}"
  exit 1
fi

if ! wait_for_backend || ! apply_kong_config || ! verify_kong_route; then
  echo "Deploy verification failed." >&2
  rollback "${PREVIOUS_TAG}"
  exit 1
fi

echo "Deploy complete: ${BACKEND_IMAGE}:${TAG}"
