#!/usr/bin/env bash
# docker-build.sh — Build the admin_panel Docker image for linux/amd64.
#
# Usage:
#   docker-build.sh <image_tag> <image_name> [--env <ENV>] [--base-href <path>]
#
# Examples:
#   docker-build.sh abc123 nonameaaaa/healytics_panel
#   docker-build.sh abc123 nonameaaaa/healytics_panel --env uat
#   docker-build.sh abc123 nonameaaaa/healytics_panel --base-href /admin/
#
# The script:
#   1. Ensures a buildx builder with linux/amd64 support exists
#   2. Builds the image using the Dockerfile in admin_panel/
#      with the workspace root (healytic_fe/) as build context
#   3. Loads the image into the local Docker daemon

set -euo pipefail

# --- Resolve paths ----------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADMIN_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
# The build context must be the workspace root so that `common/` is accessible.
WORKSPACE_ROOT="$(cd "${ADMIN_DIR}/.." && pwd)"

# --- Configuration ----------------------------------------------------------
PLATFORM="linux/amd64"
BUILDER_NAME="healytics-amd64"

# --- Parse arguments --------------------------------------------------------
if [ $# -lt 2 ]; then
  echo "Usage: $0 <image_tag> <image_name> [--env <ENV>] [--base-href <path>]" >&2
  exit 1
fi

IMAGE_TAG="$1"; shift
IMAGE_NAME="$1"; shift

BUILD_ENV="prod"
BASE_HREF="/"

while [ $# -gt 0 ]; do
  case "$1" in
    --env)
      BUILD_ENV="$2"
      shift 2
      ;;
    --base-href)
      BASE_HREF="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

# --- Ensure buildx builder exists ------------------------------------------
if ! docker buildx inspect "${BUILDER_NAME}" &>/dev/null; then
  echo "🔧 Creating buildx builder '${BUILDER_NAME}' for ${PLATFORM}..."
  docker buildx create \
    --name "${BUILDER_NAME}" \
    --platform "${PLATFORM}" \
    --driver docker-container \
    --use
else
  docker buildx use "${BUILDER_NAME}"
fi

# --- Build ------------------------------------------------------------------
FULL_TAG="${IMAGE_NAME}:${IMAGE_TAG}"
echo "🏗️  Building ${FULL_TAG} for ${PLATFORM}..."
echo "   ENV=${BUILD_ENV}  BASE_HREF=${BASE_HREF}"
echo "   Context: ${WORKSPACE_ROOT}"
echo "   Dockerfile: ${ADMIN_DIR}/Dockerfile"

docker buildx build \
  --platform "${PLATFORM}" \
  --tag "${FULL_TAG}" \
  --load \
  --file "${ADMIN_DIR}/Dockerfile" \
  --build-arg ENV="${BUILD_ENV}" \
  --build-arg BASE_HREF="${BASE_HREF}" \
  "${WORKSPACE_ROOT}"

echo "✅ Built ${FULL_TAG} (${PLATFORM})"
