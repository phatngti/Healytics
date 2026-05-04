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

# ── Production env files (pushed separately with rename) ──
.env.prod
backend.env.prod
deploy.env.prod

# ── Private keys and certificates ──
rabbitmq/certs/


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
# like .env, certs, etc.
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
  # This preserves .env, certs, and any other VPS-specific files that were
  # manually configured after initial deploy.
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

# ─── Push cloudflare-tunnels.json via scp ────────────────────────────────────
# This file is excluded from rsync (sensitive tunnel tokens) but we push it
# explicitly so the VPS always has the latest tunnel configuration.
CF_TUNNELS="${PROJECT_DIR}/cloudflare-tunnels.json"
if [[ -f "${CF_TUNNELS}" ]]; then
  info "Pushing cloudflare-tunnels.json..."
  if [[ "${DRY_RUN}" == "true" ]]; then
    info "(dry-run) Would copy ${CF_TUNNELS} → ${VPS_DEST}/cloudflare-tunnels.json"
  else
    SCP_OPTS="-i ${SSH_KEY} -P ${VPS_PORT} -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10"
    scp ${SCP_OPTS} "${CF_TUNNELS}" \
      "${VPS_USER}@${VPS_HOST}:${VPS_DEST}/cloudflare-tunnels.json"
    ok "cloudflare-tunnels.json pushed successfully"
  fi
else
  warn "cloudflare-tunnels.json not found locally — skipping"
fi

# ─── Push production env files (rename on VPS if not existing) ───────────────
# Push .env.prod → .env, backend.env.prod → backend.env, deploy.env.prod → deploy.env
# Only copies if the target file does NOT already exist on the VPS.
ENV_MAPPINGS=(
  ".env.prod:.env"
  "backend.env.prod:backend.env"
  "deploy.env.prod:deploy.env"
)

info "Pushing production env files..."
SCP_OPTS="-i ${SSH_KEY} -P ${VPS_PORT} -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10"

for mapping in "${ENV_MAPPINGS[@]}"; do
  LOCAL_NAME="${mapping%%:*}"
  REMOTE_NAME="${mapping##*:}"
  LOCAL_PATH="${PROJECT_DIR}/${LOCAL_NAME}"

  if [[ ! -f "${LOCAL_PATH}" ]]; then
    warn "${LOCAL_NAME} not found locally — skipping"
    continue
  fi

  # Check if target already exists on VPS
  if ssh ${SSH_OPTS} "${VPS_USER}@${VPS_HOST}" \
       "test -f ${VPS_DEST}/${REMOTE_NAME}" &>/dev/null; then
    ok "${REMOTE_NAME} already exists on VPS — skipping (not overwriting)"
  else
    if [[ "${DRY_RUN}" == "true" ]]; then
      info "(dry-run) Would copy ${LOCAL_NAME} → ${VPS_DEST}/${REMOTE_NAME}"
    else
      info "Copying ${LOCAL_NAME} → ${REMOTE_NAME}..."
      scp ${SCP_OPTS} "${LOCAL_PATH}" \
        "${VPS_USER}@${VPS_HOST}:${VPS_DEST}/${REMOTE_NAME}"
      ok "${REMOTE_NAME} pushed successfully"
    fi
  fi
done

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
    # ─── Initial deploy: env files auto-provisioned ──────────────────────────
    echo -e "${BOLD}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║  ✓  Initial deploy complete — env files provisioned      ║${NC}"
    echo -e "${BOLD}╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║${NC}  Production env files were pushed and renamed:           ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}    .env.prod       → .env                               ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}    backend.env.prod → backend.env                       ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}    deploy.env.prod  → deploy.env                        ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}                                                         ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  ${YELLOW}Note:${NC} Verify secrets are correct before starting.      ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  ${YELLOW}Note:${NC} RabbitMQ private keys may need manual setup.     ${BOLD}║${NC}"
    echo -e "${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
  fi

  # ─── Auto-start Docker Compose if no containers are running ────────────────
  info "Checking for running Docker containers on VPS..."
  CONTAINER_COUNT=$(ssh ${SSH_OPTS} "${VPS_USER}@${VPS_HOST}" \
    "cd ${VPS_DEST} && docker compose ps -q 2>/dev/null | wc -l | tr -d ' '" 2>/dev/null || echo "0")

  if [[ "${CONTAINER_COUNT}" -eq 0 ]]; then
    warn "No Docker containers found — starting services with prod + ci profiles..."
    echo ""
    ssh ${SSH_OPTS} "${VPS_USER}@${VPS_HOST}" \
      "cd ${VPS_DEST} && docker compose --profile prod --profile ci up -d --build"
    echo ""
    ok "Docker Compose started with --profile prod --profile ci --build"
  else
    ok "${CONTAINER_COUNT} container(s) already running — skipping Docker Compose start"
    info "To restart manually: cd ${VPS_DEST} && docker compose --profile prod --profile ci up -d --build"
  fi
fi

ok "Push complete!"
