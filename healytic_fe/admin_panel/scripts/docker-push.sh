#!/usr/bin/env bash
# docker-push.sh — Push admin_panel Docker images to Docker Hub.
#
# Usage:
#   docker-push.sh <image_tag> <image_1> [image_2 ...]
#
# Credentials are resolved in order:
#   1. Environment variables already set (e.g. by Jenkins withCredentials)
#   2. .env file in the workspace root
#
# The script:
#   1. Authenticates to Docker Hub via stdin (no CLI password exposure)
#   2. Pushes each image with the given tag
#   3. Also tags and pushes each image as "main-latest"
#   4. Logs out regardless of success or failure

set -euo pipefail

# --- Resolve workspace root (.env lives at healytic_fe/) --------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ENV_FILE="${WORKSPACE_ROOT}/.env"

# --- Load .env (only sets vars that are NOT already exported) ---------------
if [ -f "${ENV_FILE}" ]; then
  while IFS='=' read -r key value; do
    [[ -z "${key}" || "${key}" =~ ^# ]] && continue
    value="${value%\"}"
    value="${value#\"}"
    if [ -z "${!key+x}" ]; then
      export "${key}=${value}"
    fi
  done < "${ENV_FILE}"
fi

# --- Validate inputs -------------------------------------------------------
if [ $# -lt 2 ]; then
  echo "Usage: $0 <image_tag> <image_1> [image_2 ...]" >&2
  exit 1
fi

IMAGE_TAG="$1"; shift
IMAGES=("$@")

: "${DOCKERHUB_CREDS_USR:?DOCKERHUB_CREDS_USR is required}"
: "${DOCKERHUB_CREDS_PSW:?DOCKERHUB_CREDS_PSW is required}"

# --- Authenticate ----------------------------------------------------------
echo "${DOCKERHUB_CREDS_PSW}" | docker login -u "${DOCKERHUB_CREDS_USR}" --password-stdin

# --- Push images ------------------------------------------------------------
cleanup() { docker logout 2>/dev/null || true; }
trap cleanup EXIT

for img in "${IMAGES[@]}"; do
  docker push "${img}:${IMAGE_TAG}"
  docker tag  "${img}:${IMAGE_TAG}" "${img}:main-latest"
  docker push "${img}:main-latest"
done
