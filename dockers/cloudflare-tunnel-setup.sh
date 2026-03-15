#!/usr/bin/env sh
# =============================================================================
# Cloudflare Tunnel Setup Script  (Multi-Tunnel Edition — JSON Config)
# =============================================================================
# Runs inside a Docker container to automate Cloudflare Tunnel setup:
#   1. Parse cloudflare-tunnels.json into tunnel → route mappings
#   2. For each tunnel: create (or reuse), configure ingress, create DNS CNAMEs
#
# All configuration is via environment variables (no interactive prompts).
#
# Required env vars:
#   CLOUDFLARE_API_TOKEN       – API token with Tunnel Write + DNS Write
#   CLOUDFLARE_ACCOUNT_ID      – Cloudflare account ID
#   CLOUDFLARE_ZONE_ID         – Zone ID for DNS records
#   CLOUDFLARE_TUNNELS_FILE    – Path to JSON config file (default: /app/cloudflare-tunnels.json)
#
# JSON config format (cloudflare-tunnels.json):
#   {
#     "tunnels": [
#       {
#         "name": "my-tunnel",
#         "token": "",
#         "routes": [
#           { "hostname": "api.example.com", "origin": "http://kong-cp:8000" }
#         ]
#       }
#     ]
#   }
#
# Per-tunnel token:
#   When a tunnel's "token" field is set, the script skips API-based tunnel
#   creation and uses the token directly for authentication. When empty or
#   missing, the script creates/reuses the tunnel via the Cloudflare API and
#   persists the resulting token back into the JSON config.
#
# Backward-compatible env vars (used when JSON file is missing):
#   CLOUDFLARE_TUNNELS          – Legacy delimiter format (deprecated)
#   CLOUDFLARE_TUNNEL_NAME      – Tunnel name (default: healytics-tunnel)
#   CLOUDFLARE_TUNNEL_HOSTNAME  – Public hostname
#   CLOUDFLARE_TUNNEL_ORIGIN    – Origin URL (default: http://kong-cp:8000)
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
Cloudflare Tunnel Setup Script — Multi-Tunnel Edition (JSON Config)

Creates one or more Cloudflare Tunnels via API, configures ingress to route
traffic to your services, and creates DNS CNAME records.

All configuration is read from environment variables — no interactive prompts.

Required env vars:
  CLOUDFLARE_API_TOKEN      Cloudflare API token
  CLOUDFLARE_ACCOUNT_ID     Cloudflare account ID
  CLOUDFLARE_ZONE_ID        Zone ID (for DNS records)
  CLOUDFLARE_TUNNELS_FILE   Path to JSON config (default: /app/cloudflare-tunnels.json)

JSON config format:
  {
    "tunnels": [
      {
        "name": "my-tunnel",
        "token": "",
        "routes": [
          { "hostname": "api.example.com", "origin": "http://kong-cp:8000" },
          { "hostname": "app.example.com", "origin": "http://frontend:3000" }
        ]
      },
      {
        "name": "another-tunnel",
        "token": "eyJhIjoiLi4uIiwidCI6Ii4uLiIsInMiOiIuLi4ifQ==",
        "routes": [
          { "hostname": "dash.example.com", "origin": "http://dashboard:4000" }
        ]
      }
    ]
  }

Per-tunnel token:
  When a tunnel's "token" field is set, the script skips API-based tunnel
  creation and uses the token directly. Newly created tokens are persisted
  back into the JSON config for subsequent runs.

Legacy env vars (used when JSON file is missing):
  CLOUDFLARE_TUNNELS          Legacy delimiter format (deprecated)
  CLOUDFLARE_TUNNEL_NAME      Legacy fallback tunnel name
  CLOUDFLARE_TUNNEL_HOSTNAME  Legacy fallback hostname
  CLOUDFLARE_TUNNEL_ORIGIN    Legacy fallback origin URL
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

# ── Load tunnel config from JSON file (with legacy fallbacks) ────────────────

TUNNELS_FILE="${CLOUDFLARE_TUNNELS_FILE:-/app/cloudflare-tunnels.json}"

if [ -f "$TUNNELS_FILE" ]; then
  # Validate JSON
  if ! jq empty "$TUNNELS_FILE" 2>/dev/null; then
    die "Invalid JSON in ${TUNNELS_FILE}"
  fi

  TUNNEL_COUNT=$(jq '.tunnels | length' "$TUNNELS_FILE")
  if [ "$TUNNEL_COUNT" -eq 0 ]; then
    die "No tunnels defined in ${TUNNELS_FILE}"
  fi

  info "Loaded ${TUNNEL_COUNT} tunnel(s) from ${TUNNELS_FILE}"
  USE_JSON=true
elif [ -n "${CLOUDFLARE_TUNNELS:-}" ]; then
  warn "JSON config not found at ${TUNNELS_FILE} — falling back to legacy CLOUDFLARE_TUNNELS env var (deprecated)."
  USE_JSON=false
elif [ -n "${CLOUDFLARE_TUNNEL_HOSTNAME:-}" ]; then
  _name="${CLOUDFLARE_TUNNEL_NAME:-healytics-tunnel}"
  _origin="${CLOUDFLARE_TUNNEL_ORIGIN:-http://kong-cp:8000}"
  CLOUDFLARE_TUNNELS="${_name}:${CLOUDFLARE_TUNNEL_HOSTNAME}|${_origin}"
  warn "JSON config not found — built from legacy env vars: ${CLOUDFLARE_TUNNELS}"
  USE_JSON=false
else
  die "Missing tunnel config. Provide ${TUNNELS_FILE} or set CLOUDFLARE_TUNNELS."
fi

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
# Helper: Create or reuse a tunnel, return TUNNEL_ID and TUNNEL_TOKEN
# =============================================================================
# Args: tunnel_name  [preconfigured_token]
# Sets: TUNNEL_ID, TUNNEL_TOKEN (as global variables)
# Sets: TUNNEL_TOKEN_SOURCE ("preconfigured" | "existing" | "created")

setup_tunnel() {
  _tunnel_name="$1"
  _preconfigured_token="${2:-}"

  # ── Fast path: use preconfigured token from JSON config ─────────────────
  if [ -n "$_preconfigured_token" ]; then
    info "Using preconfigured token for tunnel '${_tunnel_name}' — skipping API calls."

    TUNNEL_TOKEN="$_preconfigured_token"
    TUNNEL_TOKEN_SOURCE="preconfigured"

    # Try to extract tunnel ID from the JWT-like token (base64 JSON with .t field)
    TUNNEL_ID=$(printf '%s' "$_preconfigured_token" | base64 -d 2>/dev/null | jq -r '.t // empty' 2>/dev/null || true)

    if [ -z "$TUNNEL_ID" ]; then
      warn "Could not extract tunnel ID from token — looking up by name..."

      LIST_RESPONSE=$(curl -s "${CF_API}/accounts/${CLOUDFLARE_ACCOUNT_ID}/cfd_tunnel?name=${_tunnel_name}&is_deleted=false" \
        --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
        --header "Content-Type: application/json")

      check_response "$LIST_RESPONSE" "List tunnels"
      TUNNEL_ID=$(echo "$LIST_RESPONSE" | jq -r '.result[0].id // empty')

      if [ -z "$TUNNEL_ID" ]; then
        die "Could not determine tunnel ID for '${_tunnel_name}'. Check the token or create the tunnel first."
      fi
    fi

    success "Tunnel '${_tunnel_name}' using preconfigured token (ID: ${TUNNEL_ID})."
    info "  Tunnel ID:    ${TUNNEL_ID}"
    info "  Tunnel Token: $(printf '%s' "$TUNNEL_TOKEN" | cut -c1-20)..."
    return
  fi

  # ── Standard path: create or reuse via API ──────────────────────────────
  info "Checking if tunnel '${_tunnel_name}' already exists..."

  LIST_RESPONSE=$(curl -s "${CF_API}/accounts/${CLOUDFLARE_ACCOUNT_ID}/cfd_tunnel?name=${_tunnel_name}&is_deleted=false" \
    --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    --header "Content-Type: application/json")

  check_response "$LIST_RESPONSE" "List tunnels"

  EXISTING_TUNNEL_ID=$(echo "$LIST_RESPONSE" | jq -r '.result[0].id // empty')

  if [ -n "$EXISTING_TUNNEL_ID" ]; then
    TUNNEL_ID="$EXISTING_TUNNEL_ID"
    TUNNEL_TOKEN_SOURCE="existing"
    success "Tunnel '${_tunnel_name}' already exists (ID: ${TUNNEL_ID}). Skipping creation."

    info "Fetching tunnel token..."
    TOKEN_RESPONSE=$(curl -s "${CF_API}/accounts/${CLOUDFLARE_ACCOUNT_ID}/cfd_tunnel/${TUNNEL_ID}/token" \
      --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
      --header "Content-Type: application/json")

    check_response "$TOKEN_RESPONSE" "Get tunnel token"
    TUNNEL_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.result // empty')

    if [ -z "$TUNNEL_TOKEN" ] || [ "$TUNNEL_TOKEN" = "null" ]; then
      die "Failed to retrieve token for existing tunnel '${_tunnel_name}'."
    fi

    success "Token retrieved for existing tunnel."
  else
    info "No existing tunnel found. Creating tunnel '${_tunnel_name}'..."

    CREATE_RESPONSE=$(curl -s "${CF_API}/accounts/${CLOUDFLARE_ACCOUNT_ID}/cfd_tunnel" \
      --request POST \
      --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
      --header "Content-Type: application/json" \
      --data "{
        \"name\": \"${_tunnel_name}\",
        \"config_src\": \"cloudflare\"
      }")

    check_response "$CREATE_RESPONSE" "Create tunnel '${_tunnel_name}'"

    TUNNEL_ID=$(echo "$CREATE_RESPONSE" | jq -r '.result.id')
    TUNNEL_TOKEN=$(echo "$CREATE_RESPONSE" | jq -r '.result.token')
    TUNNEL_TOKEN_SOURCE="created"

    if [ -z "$TUNNEL_ID" ] || [ "$TUNNEL_ID" = "null" ]; then
      die "Failed to extract tunnel ID from response."
    fi

    success "Tunnel '${_tunnel_name}' created!"
  fi

  info "  Tunnel ID:    ${TUNNEL_ID}"
  info "  Tunnel Token: $(printf '%s' "$TUNNEL_TOKEN" | cut -c1-20)..."
}

# =============================================================================
# Helper: Configure ingress for a tunnel from JSON routes
# =============================================================================
# Args: tunnel_id  tunnel_index (index into the JSON file)

configure_ingress_json() {
  _tunnel_id="$1"
  _tunnel_idx="$2"

  # Build ingress JSON array directly from the JSON config
  # Merges per-route originRequest (e.g. noTLSVerify) instead of discarding it
  INGRESS_JSON=$(jq -c --arg idx "$_tunnel_idx" '
    [ .tunnels[$idx | tonumber].routes[] |
      { hostname, service: .origin, originRequest: (.originRequest // {}) }
    ] + [{ service: "http_status:404" }]
  ' "$TUNNELS_FILE")

  # Log routes
  jq -r --arg idx "$_tunnel_idx" '
    .tunnels[$idx | tonumber].routes[] |
    "  Route: \(.hostname) → \(.origin)"
  ' "$TUNNELS_FILE" | while IFS= read -r line; do info "$line"; done

  info "Configuring ingress for tunnel ${_tunnel_id}..."

  CONFIG_RESPONSE=$(curl -s "${CF_API}/accounts/${CLOUDFLARE_ACCOUNT_ID}/cfd_tunnel/${_tunnel_id}/configurations" \
    --request PUT \
    --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    --header "Content-Type: application/json" \
    --data "{\"config\":{\"ingress\":${INGRESS_JSON}}}")

  check_response "$CONFIG_RESPONSE" "Configure ingress"
  success "Ingress configured for tunnel ${_tunnel_id}!"
}

# =============================================================================
# Helper: Configure ingress for a tunnel (legacy delimiter format)
# =============================================================================
# Args: tunnel_id  routes_csv  (csv = "hostname|origin,hostname|origin,...")

configure_ingress_legacy() {
  _tunnel_id="$1"
  _routes_csv="$2"

  # Build the ingress JSON array from the routes
  INGRESS_JSON="["

  _remaining="$_routes_csv"
  _first=true
  while [ -n "$_remaining" ]; do
    # Split on comma
    _route="${_remaining%%,*}"
    if [ "$_route" = "$_remaining" ]; then
      _remaining=""
    else
      _remaining="${_remaining#*,}"
    fi

    _hostname="${_route%%|*}"
    _origin="${_route#*|}"

    if [ "$_first" = true ]; then
      _first=false
    else
      INGRESS_JSON="${INGRESS_JSON},"
    fi

    INGRESS_JSON="${INGRESS_JSON}{\"hostname\":\"${_hostname}\",\"service\":\"${_origin}\",\"originRequest\":{}}"

    info "  Route: ${_hostname} → ${_origin}"
  done

  # Append the mandatory catch-all rule
  INGRESS_JSON="${INGRESS_JSON},{\"service\":\"http_status:404\"}]"

  info "Configuring ingress for tunnel ${_tunnel_id}..."

  CONFIG_RESPONSE=$(curl -s "${CF_API}/accounts/${CLOUDFLARE_ACCOUNT_ID}/cfd_tunnel/${_tunnel_id}/configurations" \
    --request PUT \
    --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    --header "Content-Type: application/json" \
    --data "{\"config\":{\"ingress\":${INGRESS_JSON}}}")

  check_response "$CONFIG_RESPONSE" "Configure ingress"
  success "Ingress configured for tunnel ${_tunnel_id}!"
}

# =============================================================================
# Helper: Create / update DNS CNAME for a single hostname
# =============================================================================

setup_dns_cname() {
  _hostname="$1"
  _tunnel_id="$2"
  _origin="${3:-}"
  _cname_target="${_tunnel_id}.cfargotunnel.com"

  # For non-HTTP origins (tcp://, ssh://, rdp://), a proxied CNAME is still
  # required so Cloudflare's edge can route the traffic through the tunnel.
  # Clients connect via `cloudflared access tcp --hostname <host> --url localhost:<port>`.
  case "$_origin" in
    tcp://*|ssh://*|rdp://*)
      info "Non-HTTP origin detected for ${_hostname} (${_origin})."
      info "  Connect via: cloudflared access tcp --hostname ${_hostname} --url localhost:<LOCAL_PORT>"
      ;;
  esac

  info "Checking DNS CNAME for ${_hostname}..."

  DNS_LOOKUP=$(curl -s "${CF_API}/zones/${CLOUDFLARE_ZONE_ID}/dns_records?type=CNAME&name=${_hostname}" \
    --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    --header "Content-Type: application/json")

  check_response "$DNS_LOOKUP" "Lookup DNS records"

  EXISTING_RECORD_ID=$(echo "$DNS_LOOKUP" | jq -r '.result[0].id // empty')
  EXISTING_CONTENT=$(echo "$DNS_LOOKUP" | jq -r '.result[0].content // empty')

  if [ -n "$EXISTING_RECORD_ID" ]; then
    if [ "$EXISTING_CONTENT" = "$_cname_target" ]; then
      success "DNS CNAME for ${_hostname} already points to ${_cname_target}. Skipping."
    else
      warn "DNS CNAME for ${_hostname} points to '${EXISTING_CONTENT}' — updating..."

      DNS_UPDATE=$(curl -s "${CF_API}/zones/${CLOUDFLARE_ZONE_ID}/dns_records/${EXISTING_RECORD_ID}" \
        --request PUT \
        --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
        --header "Content-Type: application/json" \
        --data "{
          \"type\": \"CNAME\",
          \"proxied\": true,
          \"name\": \"${_hostname}\",
          \"content\": \"${_cname_target}\"
        }")

      check_response "$DNS_UPDATE" "Update DNS record"
      success "DNS CNAME for ${_hostname} updated → ${_cname_target}"
    fi
  else
    info "Creating DNS CNAME: ${_hostname} → ${_cname_target}..."

    DNS_RESPONSE=$(curl -s "${CF_API}/zones/${CLOUDFLARE_ZONE_ID}/dns_records" \
      --request POST \
      --header "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
      --header "Content-Type: application/json" \
      --data "{
        \"type\": \"CNAME\",
        \"proxied\": true,
        \"name\": \"${_hostname}\",
        \"content\": \"${_cname_target}\"
      }")

    check_response "$DNS_RESPONSE" "Create DNS record"
    success "DNS CNAME for ${_hostname} created!"
  fi
}

# =============================================================================
# Helper: Persist tunnel token to shared volume
# =============================================================================

persist_token() {
  _token="$1"

  # Write to shared volume for cloudflared container
  TOKEN_DIR="/tmp/tunnel-token"
  mkdir -p "$TOKEN_DIR"
  printf '%s' "$_token" > "${TOKEN_DIR}/TUNNEL_TOKEN"
  success "Token written to ${TOKEN_DIR}/TUNNEL_TOKEN"
}

# =============================================================================
# Helper: Write a token back into the JSON config for a specific tunnel index
# =============================================================================
# Args: tunnel_index  token

persist_token_to_json() {
  _idx="$1"
  _token="$2"

  if [ ! -f "$TUNNELS_FILE" ]; then
    warn "Tunnels file not found — cannot persist token."
    return
  fi

  jq --arg idx "$_idx" --arg tok "$_token" \
    '.tunnels[$idx | tonumber].token = $tok' \
    "$TUNNELS_FILE" > "${TUNNELS_FILE}.tmp" \
    && cp "${TUNNELS_FILE}.tmp" "$TUNNELS_FILE" \
    && rm -f "${TUNNELS_FILE}.tmp"

  success "Token persisted to ${TUNNELS_FILE} for tunnel index ${_idx}."
}

# =============================================================================
# Main loop: Process each tunnel
# =============================================================================

FIRST_TOKEN=""
SUMMARY=""

if [ "$USE_JSON" = true ]; then
  # ── JSON-based tunnel processing ──────────────────────────────────────
  _idx=0
  while [ "$_idx" -lt "$TUNNEL_COUNT" ]; do
    _tunnel_name=$(jq -r --arg i "$_idx" '.tunnels[$i | tonumber].name' "$TUNNELS_FILE")
    _route_count=$(jq -r --arg i "$_idx" '.tunnels[$i | tonumber].routes | length' "$TUNNELS_FILE")
    _preconfigured_token=$(jq -r --arg i "$_idx" '.tunnels[$i | tonumber].token // empty' "$TUNNELS_FILE")

    echo ""
    printf "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    info "Tunnel $((_idx + 1)): ${_tunnel_name}  (${_route_count} route(s))"
    printf "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

    # ── Step A: Create or reuse the tunnel (uses token if available) ────
    setup_tunnel "$_tunnel_name" "$_preconfigured_token"

    # Save first tunnel's token for persistence to shared volume
    if [ "$_idx" -eq 0 ]; then
      FIRST_TOKEN="$TUNNEL_TOKEN"
    fi

    # ── Step A.1: Persist newly obtained token back to JSON config ──────
    if [ "$TUNNEL_TOKEN_SOURCE" != "preconfigured" ]; then
      info "Persisting token back to JSON config..."
      persist_token_to_json "$_idx" "$TUNNEL_TOKEN"
    fi

    # ── Step B: Configure ingress (all routes for this tunnel) ───────────
    echo ""
    info "Configuring ingress routes..."
    configure_ingress_json "$TUNNEL_ID" "$_idx"

    # ── Step C: Create DNS CNAME for each hostname ───────────────────────
    echo ""
    info "Setting up DNS CNAME records..."
    jq -r --arg i "$_idx" '
      .tunnels[$i | tonumber].routes[] |
      "\(.hostname) \(.origin)"
    ' "$TUNNELS_FILE" | while IFS=' ' read -r _hostname _origin; do
      setup_dns_cname "$_hostname" "$TUNNEL_ID" "$_origin"
      SUMMARY="${SUMMARY}\n  ${_hostname} → ${_origin}  (tunnel: ${_tunnel_name})"
    done

    _idx=$((_idx + 1))
  done
else
  # ── Legacy delimiter-based tunnel processing ──────────────────────────
  TUNNEL_COUNT_LEGACY=0
  _tunnels_remaining="$CLOUDFLARE_TUNNELS"
  while [ -n "$_tunnels_remaining" ]; do
    _tunnel_spec="${_tunnels_remaining%%;*}"
    if [ "$_tunnel_spec" = "$_tunnels_remaining" ]; then
      _tunnels_remaining=""
    else
      _tunnels_remaining="${_tunnels_remaining#*;}"
    fi

    [ -z "$_tunnel_spec" ] && continue

    TUNNEL_COUNT_LEGACY=$((TUNNEL_COUNT_LEGACY + 1))
    _tunnel_name="${_tunnel_spec%%:*}"
    _routes="${_tunnel_spec#*:}"

    echo ""
    printf "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    info "Tunnel ${TUNNEL_COUNT_LEGACY}: ${_tunnel_name}"
    printf "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

    setup_tunnel "$_tunnel_name"

    if [ "$TUNNEL_COUNT_LEGACY" -eq 1 ]; then
      FIRST_TOKEN="$TUNNEL_TOKEN"
    fi

    echo ""
    info "Configuring ingress routes..."
    configure_ingress_legacy "$TUNNEL_ID" "$_routes"

    echo ""
    info "Setting up DNS CNAME records..."
    _routes_remaining="$_routes"
    while [ -n "$_routes_remaining" ]; do
      _route="${_routes_remaining%%,*}"
      if [ "$_route" = "$_routes_remaining" ]; then
        _routes_remaining=""
      else
        _routes_remaining="${_routes_remaining#*,}"
      fi
      _hostname="${_route%%|*}"
      _origin="${_route#*|}"
      setup_dns_cname "$_hostname" "$TUNNEL_ID" "$_origin"

      SUMMARY="${SUMMARY}\n  ${_hostname} → ${_origin}  (tunnel: ${_tunnel_name})"
    done
  done
fi

# ── Persist the first tunnel's token to shared volume ────────────────────────
if [ -n "$FIRST_TOKEN" ]; then
  echo ""
  info "Persisting tunnel token to shared volume..."
  persist_token "$FIRST_TOKEN"
fi

# =============================================================================
# Done
# =============================================================================

echo ""
printf "${GREEN}════════════════════════════════════════════════════════════════${NC}\n"
printf "${GREEN}  Cloudflare Tunnel setup complete!${NC}\n"
printf "${GREEN}════════════════════════════════════════════════════════════════${NC}\n"
echo ""

if [ -n "${SUMMARY:-}" ]; then
  info "Configured routes:"
  printf "${SUMMARY}\n"
  echo ""
elif [ "$USE_JSON" = true ]; then
  info "Configured from: ${TUNNELS_FILE}"
  jq -r '.tunnels[] | "  Tunnel: \(.name)\(.routes[] | "\n    \(.hostname) → \(.origin)")"' "$TUNNELS_FILE" | while IFS= read -r line; do
    info "$line"
  done
  echo ""
else
  info "Tunnel config: ${CLOUDFLARE_TUNNELS}"
  echo ""
fi
