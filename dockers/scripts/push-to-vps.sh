#!/usr/bin/env bash
# =============================================================================
# push-to-vps.sh — Sync the dockers project to a VPS via rsync/SSH
# =============================================================================
# Usage:
#   ./scripts/push-to-vps.sh <vps-ip-or-hostname>
#   ./scripts/push-to-vps.sh                        # reads from env
#
# Environment variables (all optional if passed via CLI):
#   VPS_HOST          — IP or hostname of the target VPS
#   VPS_USER          — SSH user on the VPS              (default: deploy)
#   VPS_PORT          — SSH port                         (default: 22)
#   VPS_DEST          — Remote destination path          (default: ~/dockers)
#   SSH_KEY           — Path to SSH private key          (default: ~/.ssh/id_ed25519)
#   DRY_RUN           — Set to "true" for a dry run      (default: false)
# =============================================================================
set -Eeuo pipefail

# ─── Resolve paths ───────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# ─── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

info()  { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
err()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# ─── Parse arguments ────────────────────────────────────────────────────────
VPS_HOST="${1:-${VPS_HOST:-}}"
VPS_USER="${VPS_USER:-deploy}"
VPS_PORT="${VPS_PORT:-22}"
VPS_DEST="${VPS_DEST:-~/dockers}"
SSH_KEY="${SSH_KEY:-${HOME}/.ssh/id_ed25519}"
DRY_RUN="${DRY_RUN:-false}"

if [[ -z "${VPS_HOST}" ]]; then
  err "VPS host is required."
  echo ""
  echo "Usage: $0 <vps-ip-or-hostname>"
  echo ""
  echo "  Or set the VPS_HOST environment variable:"
  echo "    VPS_HOST=203.0.113.42 $0"
  exit 2
fi

# ─── Validate SSH key ───────────────────────────────────────────────────────
if [[ ! -f "${SSH_KEY}" ]]; then
  # Try common alternatives
  for alt in "${HOME}/.ssh/id_rsa" "${HOME}/.ssh/id_ecdsa"; do
    if [[ -f "${alt}" ]]; then
      SSH_KEY="${alt}"
      warn "Configured key not found, using ${SSH_KEY}"
      break
    fi
  done

  if [[ ! -f "${SSH_KEY}" ]]; then
    err "SSH key not found at ${SSH_KEY}"
    err "Set SSH_KEY to the path of your private key."
    exit 2
  fi
fi

# ─── Validate dependencies ──────────────────────────────────────────────────
for cmd in rsync ssh; do
  if ! command -v "${cmd}" &>/dev/null; then
    err "'${cmd}' is required but not installed."
    exit 1
  fi
done

# ─── Build exclude list ─────────────────────────────────────────────────────
# Sensitive files: env files with real secrets, private keys, credentials
# Runtime data: jenkins_home, docker volumes, node_modules
# Agent configs: .agents directory (dev tooling, not needed on VPS)
EXCLUDE_FILE="$(mktemp)"
trap 'rm -f "${EXCLUDE_FILE}"' EXIT

cat > "${EXCLUDE_FILE}" <<'EXCLUDES'
# ── Sensitive environment files (contain passwords, tokens, API keys) ──
.env
backend.env
deploy.env
jenkins-agent.env

# ── Private keys and certificates ──
rabbitmq/certs/ca_key.pem
rabbitmq/certs/server_localhost_key.pem
rabbitmq/certs/client_localhost_key.pem
rabbitmq/certs/*.p12

# ── Cloudflare tunnels (contains live tunnel config with tokens) ──
cloudflare-tunnels.json

# ── Jenkins runtime data ──
jenkins_home/

# ── Agent/IDE tooling (not needed on VPS) ──
.agents/

# ── Git metadata ──
.git/

# ── OS junk ──
.DS_Store
Thumbs.db

# ── Editor/IDE files ──
.vscode/
.idea/
*.swp
*.swo
*~
EXCLUDES

# ─── SSH options ─────────────────────────────────────────────────────────────
SSH_OPTS="-i ${SSH_KEY} -p ${VPS_PORT} -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10"

# ─── Detect existing deployment ──────────────────────────────────────────────
# Check if the project already exists on the VPS by looking for docker-compose.yml.
# If it exists, we use "update mode" (non-destructive) to preserve VPS-only files
# like .env, cloudflare-tunnels.json, certs, etc.
# If it doesn't exist, we do a full "initial deploy" with --delete flags.
# ─────────────────────────────────────────────────────────────────────────────

# ─── Display plan ────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║           Push Dockers Project to VPS                    ║${NC}"
echo -e "${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
info "Source:      ${PROJECT_DIR}/"
info "Destination: ${VPS_USER}@${VPS_HOST}:${VPS_DEST}"
info "SSH Key:     ${SSH_KEY}"
info "SSH Port:    ${VPS_PORT}"
[[ "${DRY_RUN}" == "true" ]] && warn "DRY RUN mode — no files will be transferred"
echo ""

# ─── Verify SSH connectivity ────────────────────────────────────────────────
info "Testing SSH connection..."
if ! ssh ${SSH_OPTS} "${VPS_USER}@${VPS_HOST}" "echo 'SSH OK'" &>/dev/null; then
  err "Cannot connect to ${VPS_USER}@${VPS_HOST}:${VPS_PORT}"
  err "Verify that:"
  err "  • The VPS is reachable at ${VPS_HOST}"
  err "  • SSH key ${SSH_KEY} is authorized on the VPS"
  err "  • User '${VPS_USER}' exists on the VPS"
  exit 1
fi
ok "SSH connection established"

# ─── Detect if project already exists on VPS ────────────────────────────────
info "Checking for existing deployment..."
REMOTE_EXISTS=false
if ssh ${SSH_OPTS} "${VPS_USER}@${VPS_HOST}" \
     "test -f ${VPS_DEST}/docker-compose.yml" &>/dev/null; then
  REMOTE_EXISTS=true
  ok "Existing deployment detected — using ${YELLOW}update mode${NC} (content-only, non-destructive)"
else
  warn "No existing deployment found — using ${CYAN}initial deploy mode${NC} (full sync)"
fi

# ─── Create remote directory ────────────────────────────────────────────────
info "Ensuring remote directory exists..."
ssh ${SSH_OPTS} "${VPS_USER}@${VPS_HOST}" "mkdir -p ${VPS_DEST}"

# ─── Build rsync flags ──────────────────────────────────────────────────────
RSYNC_FLAGS=(
  -avz                          # archive, verbose, compress
  --progress                    # show transfer progress
  --exclude-from="${EXCLUDE_FILE}"
  -e "ssh ${SSH_OPTS}"
)

if [[ "${REMOTE_EXISTS}" == "false" ]]; then
  # Initial deploy: full destructive sync to start clean
  RSYNC_FLAGS+=(
    --delete                    # remove files on VPS that were deleted locally
    --delete-excluded           # also remove excluded files if they exist on VPS
  )
else
  # Update mode: only push changed/new files, never delete remote-only files.
  # This preserves .env, cloudflare-tunnels.json, certs, and any other
  # VPS-specific files that were manually configured after initial deploy.
  RSYNC_FLAGS+=(
    --update                    # skip files that are newer on the receiver
  )
fi

if [[ "${DRY_RUN}" == "true" ]]; then
  RSYNC_FLAGS+=(--dry-run)
fi

# ─── Execute rsync ──────────────────────────────────────────────────────────
if [[ "${REMOTE_EXISTS}" == "true" ]]; then
  info "Updating content files (preserving VPS-only files)..."
else
  info "Syncing all files (initial deploy)..."
fi
echo ""
rsync "${RSYNC_FLAGS[@]}" \
  "${PROJECT_DIR}/" \
  "${VPS_USER}@${VPS_HOST}:${VPS_DEST}/"
echo ""

# ─── Post-sync: fix permissions on scripts ──────────────────────────────────
if [[ "${DRY_RUN}" != "true" ]]; then
  info "Setting executable permissions on scripts..."
  ssh ${SSH_OPTS} "${VPS_USER}@${VPS_HOST}" \
    "find ${VPS_DEST} -name '*.sh' -exec chmod +x {} +"

  # ─── Verify remote state ──────────────────────────────────────────────────
  info "Verifying remote file listing..."
  echo ""
  ssh ${SSH_OPTS} "${VPS_USER}@${VPS_HOST}" \
    "echo '── Remote: ${VPS_DEST} ──' && ls -la ${VPS_DEST}/"
  echo ""

  if [[ "${REMOTE_EXISTS}" == "true" ]]; then
    # ─── Update mode summary ────────────────────────────────────────────────
    echo -e "${BOLD}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║  ✓  Update complete — VPS-only files preserved           ║${NC}"
    echo -e "${BOLD}╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║${NC}  Config files (.env, certs, etc.) were ${GREEN}NOT${NC} overwritten.  ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  Only changed project files were synced.                ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}                                                         ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  ${CYAN}Tip:${NC} To force a full re-sync (destructive), delete     ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  ${VPS_DEST}/docker-compose.yml on VPS first.        ${BOLD}║${NC}"
    echo -e "${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
  else
    # ─── Initial deploy: remind about sensitive files ────────────────────────
    echo -e "${BOLD}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║  ⚠  Remember to set up these files on the VPS:          ║${NC}"
    echo -e "${BOLD}╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║${NC}  ${YELLOW}1.${NC} ${VPS_DEST}/.env                                     ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}     ${CYAN}cp .env.example .env && nano .env${NC}                ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  ${YELLOW}2.${NC} ${VPS_DEST}/backend.env                             ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}     ${CYAN}cp backend.env.example backend.env && nano ...${NC}   ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  ${YELLOW}3.${NC} ${VPS_DEST}/cloudflare-tunnels.json                  ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}     ${CYAN}Configure tunnel routes for production${NC}            ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  ${YELLOW}4.${NC} RabbitMQ private keys (if not auto-generated)       ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}     ${CYAN}rabbitmq/certs/*_key.pem, *.p12${NC}                  ${BOLD}║${NC}"
    echo -e "${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
  fi
fi

ok "Push complete!"
