#!/usr/bin/env sh
# =============================================================================
# Cloudflare Tunnel Setup Script
# =============================================================================
# Runs inside a Docker container to automate the Cloudflare Tunnel setup:
#   1. Create a tunnel (or skip if CLOUDFLARE_TUNNEL_TOKEN is already set)
#   2. Configure ingress (publish application)
#   3. Create DNS CNAME record
#
# All configuration is via environment variables (no interactive prompts).
#
# Required env vars:
#   CLOUDFLARE_API_TOKEN        – API token with Tunnel Write + DNS Write
#   CLOUDFLARE_ACCOUNT_ID       – Cloudflare account ID
#   CLOUDFLARE_ZONE_ID          – Zone ID for DNS record
#   CLOUDFLARE_TUNNEL_HOSTNAME  – Public hostname (e.g. api.example.com)
#
# Optional env vars:
#   CLOUDFLARE_TUNNEL_TOKEN     – If set, skips tunnel creation
#   CLOUDFLARE_TUNNEL_NAME      – Tunnel name (default: healytics-tunnel)
#   CLOUDFLARE_TUNNEL_ORIGIN    – Origin service URL (default: http://kong-cp:8000)
#
# Reference:
#   https://developers.cloudflare.com/cloudflare-one/networks/connectors/
#   cloudflare-tunnel/get-started/create-remote-tunnel-api/
# =============================================================================

set -eu

# ── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()    { printf "${CYAN}ℹ ${NC} %s\n" "$*"; }
success() { printf "${GREEN}✔ ${NC} %s\n" "$*"; }
warn()    { printf "${YELLOW}⚠ ${NC} %s\n" "$*"; }
error()   { printf "${RED}✖ ${NC} %s\n" "$*" >&2; }
die()     { error "$@"; exit 1; }

# ── Show help ────────────────────────────────────────────────────────────────

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  cat <<'EOF'
Cloudflare Tunnel Setup Script (Docker container mode)

Creates a Cloudflare Tunnel via API, configures ingress to route traffic
to your Kong Gateway, and creates a DNS CNAME record.

All configuration is read from environment variables — no interactive prompts.

Required env vars:
  CLOUDFLARE_API_TOKEN        Cloudflare API token
  CLOUDFLARE_ACCOUNT_ID       Cloudflare account ID
  CLOUDFLARE_ZONE_ID          Zone ID (for DNS record)
  CLOUDFLARE_TUNNEL_HOSTNAME  Public hostname (e.g. api.example.com)

Optional env vars:
  CLOUDFLARE_TUNNEL_TOKEN     Skip tunnel creation if already set
  CLOUDFLARE_TUNNEL_NAME      Tunnel name (default: healytics-tunnel)
  CLOUDFLARE_TUNNEL_ORIGIN    Origin URL (default: http://kong-cp:8000)
EOF
  exit 0
fi

# ── Validate required env vars ───────────────────────────────────────────────

require_var() {
  eval val="\${$1:-}"
  if [ -z "$val" ]; then
    die "Missing required environment variable: $1"
  fi
}

require_var "CLOUDFLARE_API_TOKEN"
require_var "CLOUDFLARE_ACCOUNT_ID"
require_var "CLOUDFLARE_ZONE_ID"
require_var "CLOUDFLARE_TUNNEL_HOSTNAME"

TUNNEL_NAME="${CLOUDFLARE_TUNNEL_NAME:-healytics-tunnel}"
ORIGIN_SERVICE="${CLOUDFLARE_TUNNEL_ORIGIN:-http://kong-cp:8000}"

info "Tunnel name:  ${TUNNEL_NAME}"
info "Hostname:     ${CLOUDFLARE_TUNNEL_HOSTNAME}"
info "Origin:       ${ORIGIN_SERVICE}"

# ── API base ─────────────────────────────────────────────────────────────────

CF_API="https://api.cloudflare.com/client/v4"

# ── Helper: check API response ───────────────────────────────────────────────

check_response() {
  response="$1"
  step_name="$2"

  is_success=$(echo "$response" | jq -r '.success // false')
  if [ "$is_success" != "true" ]; then
    errors=$(echo "$response" | jq -r '.errors[]?.message // "Unknown error"')
    die "${step_name} failed: ${errors}"
  fi
}

# =============================================================================
# Step 1: Create or reuse the Tunnel
# =============================================================================

if [ -n "${CLOUDFLARE_TUNNEL_TOKEN:-}" ]; then
  info "CLOUDFLARE_TUNNEL_TOKEN already set — skipping tunnel creation."
  # Extract tunnel ID from the token (base64-decoded JSON contains 'a' = account, 't' = tunnel id, 's' = secret)
  TUNNEL_ID=$(echo "${CLOUDFLARE_TUNNEL_TOKEN}" | base64 -d 2>/dev/null | jq -r '.t // empty' 2>/dev/null || true)
  if [ -z "$TUNNEL_ID" ]; then
    warn "Could not extract tunnel ID from token. Ingress config may fail."
    warn "Set CLOUDFLARE_TUNNEL_ID env var manually if needed."
    TUNNEL_ID="${CLOUDFLARE_TUNNEL_ID:-}"
  fi
else
  echo ""
  info "Step 1/3 — Checking if tunnel '${TUNNEL_NAME}' already exists..."

  # ── Check for existing tunnel with the same name ───────────────────────────
  LIST_RESPONSE=$(curl -s "${CF_API}/accounts/${CLOUDFLARE_ACCOUNT_ID}/cfd_tunnel?name=${TUNNEL_NAME}&is_deleted=false" \
    --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    --header "Content-Type: application/json")

  check_response "$LIST_RESPONSE" "List tunnels"

  EXISTING_TUNNEL_ID=$(echo "$LIST_RESPONSE" | jq -r '.result[0].id // empty')

  if [ -n "$EXISTING_TUNNEL_ID" ]; then
    # ── Tunnel exists — reuse it and fetch a fresh token ─────────────────────
    TUNNEL_ID="$EXISTING_TUNNEL_ID"
    success "Tunnel '${TUNNEL_NAME}' already exists (ID: ${TUNNEL_ID}). Skipping creation."

    info "Fetching tunnel token..."
    TOKEN_RESPONSE=$(curl -s "${CF_API}/accounts/${CLOUDFLARE_ACCOUNT_ID}/cfd_tunnel/${TUNNEL_ID}/token" \
      --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
      --header "Content-Type: application/json")

    check_response "$TOKEN_RESPONSE" "Get tunnel token"

    TUNNEL_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.result // empty')

    if [ -z "$TUNNEL_TOKEN" ] || [ "$TUNNEL_TOKEN" = "null" ]; then
      die "Failed to retrieve token for existing tunnel."
    fi

    success "Token retrieved for existing tunnel."
    info "  Tunnel ID:    ${TUNNEL_ID}"
    info "  Tunnel Token: $(echo "$TUNNEL_TOKEN" | cut -c1-20)..."
  else
    # ── No existing tunnel — create a new one ────────────────────────────────
    info "No existing tunnel found. Creating tunnel '${TUNNEL_NAME}'..."

    CREATE_RESPONSE=$(curl -s "${CF_API}/accounts/${CLOUDFLARE_ACCOUNT_ID}/cfd_tunnel" \
      --request POST \
      --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
      --header "Content-Type: application/json" \
      --data "{
        \"name\": \"${TUNNEL_NAME}\",
        \"config_src\": \"cloudflare\"
      }")

    check_response "$CREATE_RESPONSE" "Create tunnel"

    TUNNEL_ID=$(echo "$CREATE_RESPONSE" | jq -r '.result.id')
    TUNNEL_TOKEN=$(echo "$CREATE_RESPONSE" | jq -r '.result.token')

    if [ -z "$TUNNEL_ID" ] || [ "$TUNNEL_ID" = "null" ]; then
      die "Failed to extract tunnel ID from response."
    fi

    success "Tunnel created!"
    info "  Tunnel ID:    ${TUNNEL_ID}"
    info "  Tunnel Token: $(echo "$TUNNEL_TOKEN" | cut -c1-20)..."
  fi

  # Persist token to the mounted .env file so future docker-compose runs have it
  ENV_FILE="/app/.env"
  if [ -f "$ENV_FILE" ]; then
    if grep -q "^CLOUDFLARE_TUNNEL_TOKEN=" "$ENV_FILE"; then
      sed "s|^CLOUDFLARE_TUNNEL_TOKEN=.*|CLOUDFLARE_TUNNEL_TOKEN=${TUNNEL_TOKEN}|" "$ENV_FILE" > "${ENV_FILE}.tmp" \
        && cp "${ENV_FILE}.tmp" "$ENV_FILE" && rm -f "${ENV_FILE}.tmp"
    else
      echo "CLOUDFLARE_TUNNEL_TOKEN=${TUNNEL_TOKEN}" >> "$ENV_FILE"
    fi
    success "Token written to ${ENV_FILE}"
  else
    warn "Could not find ${ENV_FILE} — token not persisted to .env."
    warn "Set CLOUDFLARE_TUNNEL_TOKEN in your .env file manually."
  fi

  # Write token to shared volume for cloudflared container (first-run support)
  TOKEN_DIR="/tmp/tunnel-token"
  mkdir -p "$TOKEN_DIR"
  printf '%s' "$TUNNEL_TOKEN" > "${TOKEN_DIR}/TUNNEL_TOKEN"
  success "Token written to ${TOKEN_DIR}/TUNNEL_TOKEN"

  CLOUDFLARE_TUNNEL_TOKEN="$TUNNEL_TOKEN"
fi

# =============================================================================
# Step 2: Configure Ingress (Publish Application)
# =============================================================================

if [ -n "$TUNNEL_ID" ]; then
  echo ""
  info "Step 2/3 — Configuring ingress: ${CLOUDFLARE_TUNNEL_HOSTNAME} → ${ORIGIN_SERVICE}..."

  CONFIG_RESPONSE=$(curl -s "${CF_API}/accounts/${CLOUDFLARE_ACCOUNT_ID}/cfd_tunnel/${TUNNEL_ID}/configurations" \
    --request PUT \
    --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    --header "Content-Type: application/json" \
    --data "{
      \"config\": {
        \"ingress\": [
          {
            \"hostname\": \"${CLOUDFLARE_TUNNEL_HOSTNAME}\",
            \"service\": \"${ORIGIN_SERVICE}\",
            \"originRequest\": {}
          },
          {
            \"service\": \"http_status:404\"
          }
        ]
      }
    }")

  check_response "$CONFIG_RESPONSE" "Configure ingress"
  success "Ingress configured! ${CLOUDFLARE_TUNNEL_HOSTNAME} → ${ORIGIN_SERVICE}"
else
  warn "Skipping ingress config — no tunnel ID available."
fi

# =============================================================================
# Step 3: Create or verify DNS CNAME Record
# =============================================================================

TUNNEL_CNAME_TARGET="${TUNNEL_ID}.cfargotunnel.com"

if [ -n "$TUNNEL_ID" ]; then
  echo ""
  info "Step 3/3 — Checking DNS CNAME for ${CLOUDFLARE_TUNNEL_HOSTNAME}..."

  # ── Look up existing CNAME records matching the hostname ───────────────────
  DNS_LOOKUP=$(curl -s "${CF_API}/zones/${CLOUDFLARE_ZONE_ID}/dns_records?type=CNAME&name=${CLOUDFLARE_TUNNEL_HOSTNAME}" \
    --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    --header "Content-Type: application/json")

  check_response "$DNS_LOOKUP" "Lookup DNS records"

  EXISTING_RECORD_ID=$(echo "$DNS_LOOKUP" | jq -r '.result[0].id // empty')
  EXISTING_CONTENT=$(echo "$DNS_LOOKUP" | jq -r '.result[0].content // empty')

  if [ -n "$EXISTING_RECORD_ID" ]; then
    if [ "$EXISTING_CONTENT" = "$TUNNEL_CNAME_TARGET" ]; then
      # ── Record exists and already points to the correct tunnel ─────────────
      success "DNS CNAME already exists and points to ${TUNNEL_CNAME_TARGET}. Skipping."
    else
      # ── Record exists but points elsewhere — update it ─────────────────────
      warn "DNS CNAME exists but points to '${EXISTING_CONTENT}' instead of '${TUNNEL_CNAME_TARGET}'."
      info "Updating DNS record (ID: ${EXISTING_RECORD_ID})..."

      DNS_UPDATE=$(curl -s "${CF_API}/zones/${CLOUDFLARE_ZONE_ID}/dns_records/${EXISTING_RECORD_ID}" \
        --request PUT \
        --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
        --header "Content-Type: application/json" \
        --data "{
          \"type\": \"CNAME\",
          \"proxied\": true,
          \"name\": \"${CLOUDFLARE_TUNNEL_HOSTNAME}\",
          \"content\": \"${TUNNEL_CNAME_TARGET}\"
        }")

      check_response "$DNS_UPDATE" "Update DNS record"
      success "DNS CNAME record updated → ${TUNNEL_CNAME_TARGET}"
    fi
  else
    # ── No existing record — create a new one ────────────────────────────────
    info "No existing CNAME found. Creating DNS record: ${CLOUDFLARE_TUNNEL_HOSTNAME} → ${TUNNEL_CNAME_TARGET}..."

    DNS_RESPONSE=$(curl -s "${CF_API}/zones/${CLOUDFLARE_ZONE_ID}/dns_records" \
      --request POST \
      --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
      --header "Content-Type: application/json" \
      --data "{
        \"type\": \"CNAME\",
        \"proxied\": true,
        \"name\": \"${CLOUDFLARE_TUNNEL_HOSTNAME}\",
        \"content\": \"${TUNNEL_CNAME_TARGET}\"
      }")

    check_response "$DNS_RESPONSE" "Create DNS record"
    success "DNS CNAME record created!"
  fi
else
  warn "Skipping DNS record — no tunnel ID available."
fi

# =============================================================================
# Done
# =============================================================================

echo ""
printf "${GREEN}════════════════════════════════════════════════════════════════${NC}\n"
printf "${GREEN}  Cloudflare Tunnel setup complete!${NC}\n"
printf "${GREEN}════════════════════════════════════════════════════════════════${NC}\n"
echo ""
info "Tunnel Name:  ${TUNNEL_NAME}"
[ -n "${TUNNEL_ID:-}" ] && info "Tunnel ID:    ${TUNNEL_ID}"
info "Hostname:     ${CLOUDFLARE_TUNNEL_HOSTNAME}"
info "Origin:       ${ORIGIN_SERVICE}"
echo ""
