#!/usr/bin/env bash
# checkout.sh — Clone the Healytics repo using host SSH keys.
#
# Usage:
#   checkout.sh [git_ref]
#
# Arguments:
#   git_ref   Full ref from webhook (e.g. refs/heads/main). Defaults to refs/heads/main.
#
# Environment (set by the script, exported for downstream stages):
#   ACTIVE_BRANCH      Derived branch name (e.g. "main")
#   GIT_COMMIT_SHORT   First 12 chars of HEAD commit SHA
#   IMAGE_TAG          Alias for GIT_COMMIT_SHORT
#
# SSH keys are resolved from the host machine at ~/.ssh.
# The script ensures the key is available and GitHub is in known_hosts
# before performing a shallow clone.

set -euo pipefail

# --- Configuration ----------------------------------------------------------
REPO_URL="git@github.com:phatngti/Healytics.git"
TRUSTED_BRANCHES=("main" "master")
SSH_DIR="${HOME}/.ssh"

# --- Resolve branch ---------------------------------------------------------
GIT_REF="${1:-refs/heads/main}"
ACTIVE_BRANCH="${GIT_REF#refs/heads/}"

echo "==> Resolved branch: '${ACTIVE_BRANCH}' (from ref: '${GIT_REF}')"

# --- Validate branch --------------------------------------------------------
is_trusted=false
for b in "${TRUSTED_BRANCHES[@]}"; do
  if [ "${ACTIVE_BRANCH}" = "${b}" ]; then
    is_trusted=true
    break
  fi
done

if [ "${is_trusted}" = false ]; then
  echo "ERROR: Refusing to build/deploy branch '${ACTIVE_BRANCH}'." >&2
  echo "       Only ${TRUSTED_BRANCHES[*]} are trusted for production." >&2
  exit 1
fi

# --- Verify SSH keys --------------------------------------------------------
if [ ! -f "${SSH_DIR}/id_rsa" ]; then
  echo "ERROR: SSH private key not found at ${SSH_DIR}/id_rsa" >&2
  echo "       Ensure the host ~/.ssh directory is mounted into the agent." >&2
  exit 1
fi

echo "==> SSH key found at ${SSH_DIR}/id_rsa"

# Ensure correct permissions (SSH refuses keys that are too open)
chmod 600 "${SSH_DIR}/id_rsa" 2>/dev/null || true

# Add GitHub to known_hosts if not already present
if ! grep -q "github.com" "${SSH_DIR}/known_hosts" 2>/dev/null; then
  echo "==> Adding github.com to known_hosts..."
  mkdir -p "${SSH_DIR}"
  ssh-keyscan -t rsa,ed25519 github.com >> "${SSH_DIR}/known_hosts" 2>/dev/null
fi

# --- Configure SSH for this session -----------------------------------------
export GIT_SSH_COMMAND="ssh -i ${SSH_DIR}/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=${SSH_DIR}/known_hosts"

# --- Clean workspace and clone ----------------------------------------------
echo "==> Cleaning workspace..."
rm -rf ./* ./.[!.]* 2>/dev/null || true

echo "==> Cloning ${REPO_URL} (branch: ${ACTIVE_BRANCH}, shallow)..."
git clone --depth 1 --branch "${ACTIVE_BRANCH}" "${REPO_URL}" .

# --- Export metadata --------------------------------------------------------
GIT_COMMIT_SHORT=$(git rev-parse --short=12 HEAD)
IMAGE_TAG="${GIT_COMMIT_SHORT}"

echo "==> Commit: ${GIT_COMMIT_SHORT}"
echo "==> IMAGE_TAG: ${IMAGE_TAG}"

# Write env vars to a file that the Jenkinsfile can source
ENV_EXPORT_FILE="${WORKSPACE:-.}/.checkout-env"
cat > "${ENV_EXPORT_FILE}" <<EOF
ACTIVE_BRANCH=${ACTIVE_BRANCH}
GIT_COMMIT_SHORT=${GIT_COMMIT_SHORT}
IMAGE_TAG=${IMAGE_TAG}
EOF

echo "==> Checkout environment written to ${ENV_EXPORT_FILE}"
