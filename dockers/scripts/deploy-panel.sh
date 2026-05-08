#!/usr/bin/env bash
# deploy-panel.sh — Deploy the admin_panel container on the VPS.
#
# Usage:
#   deploy-panel.sh <immutable-tag>
#
# The script:
#   1. Writes deploy-panel.env with the image + tag
#   2. Pulls the new image
#   3. Stops the old container, starts the new one
#   4. Waits for the Nginx healthcheck to pass
#   5. Rolls back to the previous tag on failure

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${COMPOSE_DIR}"

TAG="${1:-${PANEL_TAG:-}}"
if [[ -z "${TAG}" ]]; then
  echo "ERROR: panel image tag is required." >&2
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

PANEL_IMAGE="${PANEL_IMAGE:-nonameaaaa/healytics_panel}"
DEPLOY_ENV="${DEPLOY_ENV_PANEL:-deploy-panel.env}"
CONTAINER_NAME="healytics-panel"

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
PANEL_IMAGE=${PANEL_IMAGE}
PANEL_TAG=${tag}
PANEL_DEPLOYED_AT=$(date -u +%Y-%m-%dT%H:%M:%SZ)
EOF

  echo "Wrote ${DEPLOY_ENV}: PANEL_IMAGE=${PANEL_IMAGE} PANEL_TAG=${tag}"
}

wait_for_panel() {
  echo "Waiting for panel container health..."
  local max_attempts=30
  for i in $(seq 1 "${max_attempts}"); do
    local status
    status="$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}no-healthcheck:{{.State.Status}}{{end}}' "${CONTAINER_NAME}" 2>/dev/null || true)"

    echo "  [$i/${max_attempts}] status=${status}"

    if [[ "${status}" == "healthy" ]]; then
      echo "Panel is healthy."
      return 0
    fi

    # If container has no healthcheck, accept "running" as success
    if [[ "${status}" == "no-healthcheck:running" ]]; then
      echo "Panel is running (no healthcheck defined). Verifying with curl..."
      if docker exec "${CONTAINER_NAME}" curl -fsS http://localhost/ >/dev/null 2>&1; then
        echo "Panel responded OK."
        return 0
      fi
    fi

    # Bail early on terminal states
    if [[ "${status}" =~ ^(unhealthy|exited|dead)$ || "${status}" == "no-healthcheck:exited" ]]; then
      echo "Panel entered terminal state: ${status}" >&2
      docker logs --tail=100 "${CONTAINER_NAME}" || true
      return 1
    fi

    sleep 5
  done

  echo "Timed out waiting for panel health (${max_attempts} × 5s)." >&2
  docker logs --tail=100 "${CONTAINER_NAME}" || true
  return 1
}

rollback() {
  local previous_tag="$1"

  # Reject empty, same-as-current, or obvious placeholder tags
  if [[ -z "${previous_tag}" || "${previous_tag}" == "${TAG}" ]]; then
    echo "No previous panel tag available for rollback." >&2
    return 1
  fi

  if [[ "${previous_tag}" == *"replace-with"* || "${previous_tag}" == "latest" ]]; then
    echo "Previous tag '${previous_tag}' is a placeholder — skipping rollback." >&2
    return 1
  fi

  echo "Rolling back panel to ${previous_tag}..."
  write_deploy_env "${previous_tag}"
  if ! compose --profile panel-prod pull panel; then
    echo "Failed to pull rollback image ${PANEL_IMAGE}:${previous_tag}." >&2
    return 1
  fi
  compose --profile panel-prod up -d --no-deps panel
  wait_for_panel
}

# --- Load previous tag from deploy-panel.env (if it exists) -----------------
load_env_file "${DEPLOY_ENV}"
PREVIOUS_TAG="${PANEL_TAG:-}"
unset PANEL_TAG 2>/dev/null || true

echo "Deploying ${PANEL_IMAGE}:${TAG}"
[[ -n "${PREVIOUS_TAG}" ]] && echo "Previous panel tag: ${PREVIOUS_TAG}"

write_deploy_env "${TAG}"

echo "Pulling panel image..."
if ! compose --profile panel-prod pull panel; then
  [[ -n "${PREVIOUS_TAG}" ]] && write_deploy_env "${PREVIOUS_TAG}"
  exit 1
fi

# --- Capture old image ID for cleanup later --------------------------------
OLD_IMAGE_ID=""
if docker inspect "${CONTAINER_NAME}" >/dev/null 2>&1; then
  OLD_IMAGE_ID="$(docker inspect --format '{{.Image}}' "${CONTAINER_NAME}" 2>/dev/null || true)"
fi

# --- Kill and remove old container before starting new one -----------------
echo "Stopping old panel container..."
compose --profile panel-prod stop panel 2>/dev/null || true
compose --profile panel-prod rm -f panel 2>/dev/null || true

echo "Starting panel..."
if ! compose --profile panel-prod up -d --no-deps panel; then
  rollback "${PREVIOUS_TAG}"
  exit 1
fi

if ! wait_for_panel; then
  echo "Deploy verification failed." >&2
  rollback "${PREVIOUS_TAG}"
  exit 1
fi

# --- Remove old image if it differs from the new one -----------------------
if [[ -n "${OLD_IMAGE_ID}" ]]; then
  NEW_IMAGE_ID="$(docker inspect --format '{{.Image}}' "${CONTAINER_NAME}" 2>/dev/null || true)"
  if [[ "${OLD_IMAGE_ID}" != "${NEW_IMAGE_ID}" ]]; then
    echo "Removing old panel image ${OLD_IMAGE_ID}..."
    docker rmi "${OLD_IMAGE_ID}" 2>/dev/null || true
  fi
fi

docker image prune -f --filter "label=com.docker.compose.project" 2>/dev/null || true

echo "Deploy complete: ${PANEL_IMAGE}:${TAG}"
