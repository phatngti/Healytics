#!/usr/bin/env bash
# docker-build.sh — Build the admin_panel Docker image for linux/amd64.
#
# Usage:
#   docker-build.sh <image_tag> <image_name> [--env <ENV>] [--base-href <path>] [--push]
#
# Examples:
#   docker-build.sh abc123 nonameaaaa/healytics_panel
#   docker-build.sh abc123 nonameaaaa/healytics_panel --env uat
#   docker-build.sh abc123 nonameaaaa/healytics_panel --base-href /admin/
#   docker-build.sh abc123 nonameaaaa/healytics_panel --push
#
# The script:
#   1. Ensures a buildx builder with linux/amd64 support exists
#   2. Builds the image using the Dockerfile in admin_panel/
#      with the workspace root (healytic_fe/) as build context
#   3. With --push: pushes directly to registry (required for cross-arch builds)
#      Without --push: loads into local Docker daemon (only works if host arch matches)
#
# IMPORTANT: When building on ARM64 (Apple Silicon) for AMD64 (VPS), you MUST use --push
# to avoid "exec format error". The --load flag corrupts platform metadata during cross-arch builds.

set -euo pipefail

# --- Resolve paths ----------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADMIN_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
# The build context must be the workspace root so that `common/` is accessible.
WORKSPACE_ROOT="$(cd "${ADMIN_DIR}/.." && pwd)"

# --- Configuration ----------------------------------------------------------
PLATFORM="linux/amd64"
BUILDER_NAME="healytics-amd64"
ENV_FILES=(
  "${SCRIPT_DIR}/.env"
  "${ADMIN_DIR}/.env"
)

# --- Load .env files (only sets vars that are NOT already exported) ---------
for env_file in "${ENV_FILES[@]}"; do
  if [ -f "${env_file}" ]; then
    while IFS='=' read -r key value || [ -n "${key:-}" ]; do
      key="${key%$'\r'}"
      value="${value%$'\r'}"
      [[ -z "${key}" || "${key}" =~ ^# ]] && continue
      value="${value%\"}"
      value="${value#\"}"
      if [ -z "${!key:-}" ]; then
        export "${key}=${value}"
      fi
    done < "${env_file}"
  fi
done

# --- Parse arguments --------------------------------------------------------
if [ $# -lt 2 ]; then
  echo "Usage: $0 <image_tag> <image_name> [--env <ENV>] [--base-href <path>] [--push]" >&2
  exit 1
fi

IMAGE_TAG="$1"; shift
IMAGE_NAME="$1"; shift

BUILD_ENV="prod"
BASE_HREF="/"
DO_PUSH=false

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
    --push)
      DO_PUSH=true
      shift
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

# --- Detect host architecture -----------------------------------------------
HOST_ARCH="$(uname -m)"
IS_CROSS_COMPILE=false
if [[ "${HOST_ARCH}" == "arm64" || "${HOST_ARCH}" == "aarch64" ]]; then
  IS_CROSS_COMPILE=true
fi

# --- Detect buildx availability ---------------------------------------------
HAS_BUILDX=false
if docker buildx version &>/dev/null; then
  HAS_BUILDX=true
fi

# --- Warn about cross-compilation without --push ----------------------------
if [[ "${IS_CROSS_COMPILE}" == true && "${DO_PUSH}" == false && "${HAS_BUILDX}" == true ]]; then
  echo "⚠️  WARNING: Building for ${PLATFORM} on ${HOST_ARCH} without --push"
  echo "   The loaded image may have incorrect platform metadata."
  echo "   This will cause 'exec format error' when running on AMD64 servers."
  echo "   Consider using: $0 ${IMAGE_TAG} ${IMAGE_NAME} --push"
  echo ""
fi

# --- Build ------------------------------------------------------------------
FULL_TAG="${IMAGE_NAME}:${IMAGE_TAG}"
LATEST_TAG="${IMAGE_NAME}:main-latest"
echo "🏗️  Building ${FULL_TAG} for ${PLATFORM}..."
echo "   ENV=${BUILD_ENV}  BASE_HREF=${BASE_HREF}"
echo "   Context: ${WORKSPACE_ROOT}"
echo "   Dockerfile: ${ADMIN_DIR}/Dockerfile"
echo "   Buildx available: ${HAS_BUILDX}"
echo "   Host arch: ${HOST_ARCH} (cross-compile: ${IS_CROSS_COMPILE})"
echo "   Push mode: ${DO_PUSH}"

if [ "${HAS_BUILDX}" = true ]; then
  # --- Ensure buildx builder exists ----------------------------------------
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

  if [ "${DO_PUSH}" = true ]; then
    # --- Authenticate to Docker Hub ----------------------------------------
    : "${DOCKERHUB_CREDS_USR:?DOCKERHUB_CREDS_USR is required for --push}"
    : "${DOCKERHUB_CREDS_PSW:?DOCKERHUB_CREDS_PSW is required for --push}"
    
    echo "🔐 Authenticating to Docker Hub..."
    echo "${DOCKERHUB_CREDS_PSW}" | docker login -u "${DOCKERHUB_CREDS_USR}" --password-stdin
    
    cleanup() { docker logout 2>/dev/null || true; }
    trap cleanup EXIT

    # Build and push in one step - this correctly preserves platform metadata
    docker buildx build \
      --platform "${PLATFORM}" \
      --tag "${FULL_TAG}" \
      --tag "${LATEST_TAG}" \
      --push \
      --file "${ADMIN_DIR}/Dockerfile" \
      --build-arg ENV="${BUILD_ENV}" \
      --build-arg BASE_HREF="${BASE_HREF}" \
      "${WORKSPACE_ROOT}"
    echo "✅ Built and pushed ${FULL_TAG} (${PLATFORM})"
  else
    # Load locally - only reliable when host arch matches target
    docker buildx build \
      --platform "${PLATFORM}" \
      --tag "${FULL_TAG}" \
      --load \
      --file "${ADMIN_DIR}/Dockerfile" \
      --build-arg ENV="${BUILD_ENV}" \
      --build-arg BASE_HREF="${BASE_HREF}" \
      "${WORKSPACE_ROOT}"
    echo "✅ Built ${FULL_TAG} (${PLATFORM}) - loaded locally"
  fi
else
  # Fallback: plain docker build (works when host arch matches target)
  echo "ℹ️  buildx not available — falling back to docker build"
  DOCKER_DEFAULT_PLATFORM="${PLATFORM}" docker build \
    --tag "${FULL_TAG}" \
    --file "${ADMIN_DIR}/Dockerfile" \
    --build-arg ENV="${BUILD_ENV}" \
    --build-arg BASE_HREF="${BASE_HREF}" \
    "${WORKSPACE_ROOT}"
  echo "✅ Built ${FULL_TAG} (${PLATFORM})"
fi
