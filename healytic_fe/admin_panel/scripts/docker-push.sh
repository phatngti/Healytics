#!/usr/bin/env bash
# docker-push.sh — Push admin_panel Docker images to Docker Hub.
#
# Usage:
#   docker-push.sh <image_tag> <image_1> [image_2 ...]
#
# Credentials are resolved in order:
#   1. Environment variables already set (e.g. by Jenkins withCredentials)
#   2. scripts/.env (local script-level config)
#   3. .env file in the project root
#
# The script:
#   1. Authenticates to Docker Hub via stdin (no CLI password exposure)
#   2. Pushes each image with the given tag
#   3. Also tags and pushes each image as "main-latest"
#   4. Logs out regardless of success or failure

set -euo pipefail

# --- Resolve candidate .env locations --------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILES=(
  "${SCRIPT_DIR}/.env"
  "${PROJECT_ROOT}/.env"
)

# --- Load .env files (only sets vars that are NOT already exported) ---------
for env_file in "${ENV_FILES[@]}"; do
  if [ -f "${env_file}" ]; then
    while IFS='=' read -r key value || [ -n "${key:-}" ]; do
      key="${key%$'\r'}"
      value="${value%$'\r'}"
      # skip blank lines and comments
      [[ -z "${key}" || "${key}" =~ ^# ]] && continue
      # strip surrounding quotes from value
      value="${value%\"}"
      value="${value#\"}"
      # set if current env value is unset or empty
      if [ -z "${!key:-}" ]; then
        export "${key}=${value}"
      fi
    done < "${env_file}"
  fi
done

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
