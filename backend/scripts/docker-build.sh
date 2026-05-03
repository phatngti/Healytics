#!/usr/bin/env bash
# docker-build.sh — Build Docker images for linux/arm64.
#
# Usage:
#   docker-build.sh <image_tag> <image_name> [--target <stage>]
#
# Examples:
#   docker-build.sh abc123 phatngti/healytics-backend
#   docker-build.sh abc123 phatngti/healytics-migrate --target migrate
#
# The script:
#   1. Ensures a buildx builder with linux/arm64 support exists
#   2. Builds the image for linux/arm64 using Docker Buildx
#   3. Loads the image into the local Docker daemon

set -euo pipefail

# --- Resolve project root (Dockerfile lives next to package.json) ----------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# --- Configuration ---------------------------------------------------------
PLATFORM="linux/amd64"
BUILDER_NAME="healytics-amd64"

# --- Parse arguments --------------------------------------------------------
if [ $# -lt 2 ]; then
  echo "Usage: $0 <image_tag> <image_name> [--target <stage>]" >&2
  echo "" >&2
  echo "Examples:" >&2
  echo "  $0 abc123 phatngti/healytics-backend" >&2
  echo "  $0 abc123 phatngti/healytics-migrate --target migrate" >&2
  exit 1
fi

IMAGE_TAG="$1"; shift
IMAGE_NAME="$1"; shift

# Optional --target flag
TARGET_STAGE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --target)
      TARGET_STAGE="$2"
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

BUILD_ARGS=(
  --platform "${PLATFORM}"
  --tag "${FULL_TAG}"
  --load
  --file "${PROJECT_ROOT}/Dockerfile"
)

# Add --target if specified
if [ -n "${TARGET_STAGE}" ]; then
  BUILD_ARGS+=(--target "${TARGET_STAGE}")
fi

docker buildx build "${BUILD_ARGS[@]}" "${PROJECT_ROOT}"

echo "✅ Built ${FULL_TAG} (${PLATFORM})"
