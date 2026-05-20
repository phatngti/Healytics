#!/usr/bin/env bash
# deploy-panel-dev.sh — Deploy the admin_panel DEV container on the VPS.
#
# Usage:
#   deploy-panel-dev.sh <immutable-tag>
#
# The script:
#   1. Writes deploy-panel-dev.env with the image + tag
#   2. Pulls the new image
#   3. Stops the old container, starts the new one
#   4. Waits for the Nginx healthcheck to pass
#   5. Rolls back to the previous tag on failure

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${COMPOSE_DIR}"

TAG="${1:-${PANEL_DEV_TAG:-}}"
if [[ -z "${TAG}" ]]; then
  echo "ERROR: panel-dev image tag is required." >&2
  echo "Usage: $0 <immutable-tag>" >&2
  exit 2
fi

if [[ "${TAG}" == "latest" ]]; then
  echo "ERROR: refusing to deploy mutable tag 'latest'." >&2
  exit 2
fi

# --- Load .env (only sets vars that are NOT already exported) ---------------
load_env_file() {
  local file="$1"
  [[ -f "${file}" ]] || return 0
  while IFS='=' read -r key value; do
    [[ -z "${key}" || "${key}" =~ ^# ]] && continue
    value="${value%\"}"
    value="${value#\"}"
    if [[ -z "${!key+x}" ]]; then
      export "${key}=${value}"
    fi
  done < "${file}"
}

load_env_file ".env"

PANEL_DEV_IMAGE="${PANEL_DEV_IMAGE:-nonameaaaa/healytics_panel_dev}"
DEPLOY_ENV="${DEPLOY_ENV_PANEL_DEV:-deploy-panel-dev.env}"
CONTAINER_NAME="healytics-panel-dev"

if [[ ! -f ".env" ]]; then
  echo "ERROR: .env is required in ${COMPOSE_DIR}." >&2
  exit 2
fi

compose() {
  docker compose --env-file .env --env-file "${DEPLOY_ENV}" "$@"
}

write_deploy_env() {
  local tag="$1"

  cat > "${DEPLOY_ENV}" <<EOF
PANEL_DEV_IMAGE=${PANEL_DEV_IMAGE}
PANEL_DEV_TAG=${tag}
PANEL_DEV_DEPLOYED_AT=$(date -u +%Y-%m-%dT%H:%M:%SZ)
EOF

  echo "Wrote ${DEPLOY_ENV}: PANEL_DEV_IMAGE=${PANEL_DEV_IMAGE} PANEL_DEV_TAG=${tag}"
}

wait_for_panel_dev() {
  echo "Waiting for panel-dev container health..."
  local max_attempts=30
  for i in $(seq 1 "${max_attempts}"); do
    local status
    status="$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}no-healthcheck:{{.State.Status}}{{end}}' "${CONTAINER_NAME}" 2>/dev/null || true)"

    echo "  [$i/${max_attempts}] status=${status}"

    if [[ "${status}" == "healthy" ]]; then
      echo "Panel-dev is healthy."
      return 0
    fi

    # If container has no healthcheck, accept "running" as success
    if [[ "${status}" == "no-healthcheck:running" ]]; then
      echo "Panel-dev is running (no healthcheck defined). Verifying with curl..."
      if docker exec "${CONTAINER_NAME}" curl -fsS http://localhost/ >/dev/null 2>&1; then
        echo "Panel-dev responded OK."
        return 0
      fi
    fi

    # Bail early on terminal states
    if [[ "${status}" =~ ^(unhealthy|exited|dead)$ || "${status}" == "no-healthcheck:exited" ]]; then
      echo "Panel-dev entered terminal state: ${status}" >&2
      docker logs --tail=100 "${CONTAINER_NAME}" || true
      return 1
    fi

    sleep 5
  done

  echo "Timed out waiting for panel-dev health (${max_attempts} × 5s)." >&2
  docker logs --tail=100 "${CONTAINER_NAME}" || true
  return 1
}

rollback() {
  local previous_tag="$1"

  # Reject empty, same-as-current, or obvious placeholder tags
  if [[ -z "${previous_tag}" || "${previous_tag}" == "${TAG}" ]]; then
    echo "No previous panel-dev tag available for rollback." >&2
    return 1
  fi

  if [[ "${previous_tag}" == *"replace-with"* || "${previous_tag}" == "latest" ]]; then
    echo "Previous tag '${previous_tag}' is a placeholder — skipping rollback." >&2
    return 1
  fi

  echo "Rolling back panel-dev to ${previous_tag}..."
  write_deploy_env "${previous_tag}"
  if ! compose --profile panel-dev pull panel-dev; then
    echo "Failed to pull rollback image ${PANEL_DEV_IMAGE}:${previous_tag}." >&2
    return 1
  fi
  compose --profile panel-dev up -d --no-deps panel-dev
  wait_for_panel_dev
}

# --- Load previous tag from deploy-panel-dev.env (if it exists) -------------
load_env_file "${DEPLOY_ENV}"
PREVIOUS_TAG="${PANEL_DEV_TAG:-}"
unset PANEL_DEV_TAG 2>/dev/null || true

echo "Deploying ${PANEL_DEV_IMAGE}:${TAG}"
[[ -n "${PREVIOUS_TAG}" ]] && echo "Previous panel-dev tag: ${PREVIOUS_TAG}"

write_deploy_env "${TAG}"

echo "Pulling panel-dev image..."
if ! compose --profile panel-dev pull panel-dev; then
  [[ -n "${PREVIOUS_TAG}" ]] && write_deploy_env "${PREVIOUS_TAG}"
  exit 1
fi

# --- Capture old image ID for cleanup later --------------------------------
OLD_IMAGE_ID=""
if docker inspect "${CONTAINER_NAME}" >/dev/null 2>&1; then
  OLD_IMAGE_ID="$(docker inspect --format '{{.Image}}' "${CONTAINER_NAME}" 2>/dev/null || true)"
fi

# --- Kill and remove old container before starting new one -----------------
echo "Stopping old panel-dev container..."
compose --profile panel-dev stop panel-dev 2>/dev/null || true
compose --profile panel-dev rm -f panel-dev 2>/dev/null || true

echo "Starting panel-dev..."
if ! compose --profile panel-dev up -d --no-deps panel-dev; then
  rollback "${PREVIOUS_TAG}"
  exit 1
fi

if ! wait_for_panel_dev; then
  echo "Deploy verification failed." >&2
  rollback "${PREVIOUS_TAG}"
  exit 1
fi

# --- Remove old image if it differs from the new one -----------------------
if [[ -n "${OLD_IMAGE_ID}" ]]; then
  NEW_IMAGE_ID="$(docker inspect --format '{{.Image}}' "${CONTAINER_NAME}" 2>/dev/null || true)"
  if [[ "${OLD_IMAGE_ID}" != "${NEW_IMAGE_ID}" ]]; then
    echo "Removing old panel-dev image ${OLD_IMAGE_ID}..."
    docker rmi "${OLD_IMAGE_ID}" 2>/dev/null || true
  fi
fi

docker image prune -f --filter "label=com.docker.compose.project" 2>/dev/null || true

echo "Deploy complete: ${PANEL_DEV_IMAGE}:${TAG}"
