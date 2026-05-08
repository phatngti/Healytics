#!/usr/bin/env bash
# =============================================================================
# setup-vps.sh — Provision a fresh VPS with all tools required to run the
#                Healytics Docker Compose stack
# =============================================================================
# Usage:
#   ssh root@<vps-ip> "bash -s" < scripts/setup-vps.sh
#   # — OR — copy to VPS and run:
#   chmod +x setup-vps.sh && sudo ./setup-vps.sh
#
# Supported OS:  Ubuntu 22.04+ / Debian 12+
#
# What this script installs / configures:
#   1. System updates + essential packages (curl, git, make, rsync, etc.)
#   2. Docker Engine (CE) + Docker Compose v2 plugin
#   3. UFW firewall with required port rules (incl. SMTP 25/465/587)
#   4. SMTP outbound connectivity verification
#   5. Docker daemon tuning (log rotation, overlay2)
#   6. Project directory setup
# =============================================================================
set -Eeuo pipefail

# ─── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()      { echo -e "${GREEN}[ OK ]${NC}  $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
err()     { echo -e "${RED}[ERROR]${NC} $*" >&2; }
section() { echo ""; echo -e "${BOLD}── $* ──${NC}"; }

# ─── Pre-flight checks ──────────────────────────────────────────────────────
if [[ $EUID -ne 0 ]] && ! sudo -n true 2>/dev/null; then
  err "This script must be run as root or with sudo privileges."
  exit 1
fi

# Detect OS
if [[ ! -f /etc/os-release ]]; then
  err "Cannot detect OS. /etc/os-release not found."
  exit 1
fi

source /etc/os-release

if [[ "${ID}" != "ubuntu" && "${ID}" != "debian" ]]; then
  err "This script only supports Ubuntu/Debian. Detected: ${ID}"
  exit 1
fi

info "Detected OS: ${PRETTY_NAME}"

echo ""
echo -e "${BOLD}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║        Healytics VPS Provisioning Script                 ║${NC}"
echo -e "${BOLD}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BOLD}║${NC}  Deploy as:    ${CYAN}root${NC}                                       ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}  Target OS:    ${CYAN}${PRETTY_NAME}${NC}"
echo -e "${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# =============================================================================
# 1. System Update & Essential Packages
# =============================================================================
section "System Update & Essential Packages"

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

# ── Wait for any boot-time apt/dpkg locks to release ─────────────────────────
# Fresh Ubuntu VPS instances often run unattended-upgrades on first boot,
# which holds the dpkg lock and causes apt-get to hang indefinitely.
info "Waiting for any existing apt/dpkg locks to release..."
while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || \
      fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || \
      fuser /var/cache/apt/archives/lock >/dev/null 2>&1; do
  warn "Another apt/dpkg process is running — waiting 5s..."
  sleep 5
done
ok "No apt/dpkg locks held"

# ── Disable needrestart interactive prompts ──────────────────────────────────
# Ubuntu 22.04+ ships needrestart which pops up TUI dialogs even with
# DEBIAN_FRONTEND=noninteractive. Setting it to auto-restart mode (a)
# via config ensures zero prompts.
if [[ -d /etc/needrestart ]]; then
  sudo mkdir -p /etc/needrestart/conf.d
  echo '$nrconf{restart} = "a";' | sudo tee /etc/needrestart/conf.d/50-autorestart.conf > /dev/null
  ok "needrestart set to auto-restart mode"
fi

# Common dpkg options to suppress all interactive prompts
APT_OPTS=(-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold")

info "Updating package index..."
sudo apt-get update -qq

info "Installing essential packages..."
sudo apt-get install -y -qq "${APT_OPTS[@]}" --no-install-recommends \
  apt-transport-https \
  bash-completion \
  ca-certificates \
  curl \
  git \
  gnupg \
  htop \
  iotop \
  jq \
  lsb-release \
  make \
  nano \
  net-tools \
  openssl \
  rsync \
  software-properties-common \
  sudo \
  tree \
  unzip \
  wget \
  zip

ok "Essential packages installed"

# =============================================================================
# 2. Docker Engine (CE) + Compose v2
# =============================================================================
section "Docker Engine + Docker Compose v2"

if command -v docker &>/dev/null; then
  warn "Docker is already installed: $(docker --version)"
else
  info "Adding Docker's official GPG key..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL "https://download.docker.com/linux/${ID}/gpg" \
    | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  info "Adding Docker repository..."
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/${ID} \
    $(. /etc/os-release && echo "${VERSION_CODENAME}") stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update -qq

  info "Installing Docker Engine, CLI, and plugins..."
  sudo apt-get install -y -qq "${APT_OPTS[@]}" --no-install-recommends \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

  ok "Docker installed: $(docker --version)"
fi

# Verify Docker Compose v2
if docker compose version &>/dev/null; then
  ok "Docker Compose: $(docker compose version --short)"
else
  err "Docker Compose plugin not found. Installation may have failed."
  exit 1
fi

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker
ok "Docker service is running"

# =============================================================================
# 3. UFW Firewall
# =============================================================================
section "Firewall (UFW)"

if ! command -v ufw &>/dev/null; then
  info "Installing UFW..."
  sudo apt-get install -y -qq ufw
fi

# Reset UFW to clean state (non-interactive)
info "Configuring firewall rules..."
sudo ufw --force reset >/dev/null 2>&1

# Default policies
sudo ufw default deny incoming >/dev/null 2>&1
sudo ufw default allow outgoing >/dev/null 2>&1

# SSH — always required
sudo ufw allow 22/tcp comment "SSH" >/dev/null 2>&1

# Kong Gateway ports
sudo ufw allow 8000/tcp comment "Kong Proxy HTTP" >/dev/null 2>&1
sudo ufw allow 8443/tcp comment "Kong Proxy HTTPS" >/dev/null 2>&1

# Optional: Kong Admin API — restrict to trusted IPs in production
# sudo ufw allow 8001/tcp comment "Kong Admin API"
# sudo ufw allow 8002/tcp comment "Kong Manager GUI"

# Jenkins (if running ci profile)
sudo ufw allow 8081/tcp comment "Jenkins Web UI" >/dev/null 2>&1

# SMTP — required for sending emails (outbound)
sudo ufw allow out 25/tcp comment "SMTP outbound" >/dev/null 2>&1
sudo ufw allow out 465/tcp comment "SMTPS outbound" >/dev/null 2>&1
sudo ufw allow out 587/tcp comment "SMTP submission outbound" >/dev/null 2>&1
ok "SMTP outbound ports (25, 465, 587) allowed in UFW"

# Enable UFW
sudo ufw --force enable >/dev/null 2>&1
ok "UFW enabled with the following rules:"
sudo ufw status numbered 2>/dev/null | head -25

# =============================================================================
# 3b. SMTP Outbound Connectivity Check
# =============================================================================
section "SMTP Outbound Connectivity Check"

info "Testing outbound SMTP connectivity to smtp.gmail.com..."
info "(Many VPS providers block SMTP at the network level to prevent spam)"

SMTP_BLOCKED_PORTS=()
SMTP_OK_PORTS=()

for port in 25 465 587; do
  if timeout 5 bash -c "echo >/dev/tcp/smtp.gmail.com/${port}" 2>/dev/null; then
    SMTP_OK_PORTS+=("${port}")
    ok "Port ${port} → smtp.gmail.com  ✅  REACHABLE"
  else
    SMTP_BLOCKED_PORTS+=("${port}")
    err "Port ${port} → smtp.gmail.com  ❌  BLOCKED / UNREACHABLE"
  fi
done

if [[ ${#SMTP_BLOCKED_PORTS[@]} -gt 0 ]]; then
  echo ""
  echo -e "${RED}${BOLD}╔═══════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${RED}${BOLD}║                                                                   ║${NC}"
  echo -e "${RED}${BOLD}║   ⚠️  ⚠️  ⚠️   SMTP PORT(S) BLOCKED — EMAIL WILL NOT WORK   ⚠️  ⚠️  ⚠️    ║${NC}"
  echo -e "${RED}${BOLD}║                                                                   ║${NC}"
  echo -e "${RED}${BOLD}╠═══════════════════════════════════════════════════════════════════╣${NC}"
  echo -e "${RED}${BOLD}║${NC}                                                                   ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}  ${RED}Blocked port(s): ${YELLOW}${BOLD}${SMTP_BLOCKED_PORTS[*]}${NC}                                        ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}                                                                   ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}  Your VPS provider is likely blocking outbound SMTP traffic.      ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}  This means your application ${RED}CANNOT send emails${NC} via direct SMTP.  ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}                                                                   ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}  ${YELLOW}${BOLD}How to fix:${NC}                                                     ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}                                                                   ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}  ${CYAN}Option 1:${NC} Contact your VPS provider and request them to         ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}             unblock outbound SMTP ports (25, 465, 587).           ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}             Common providers that block by default:               ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}             • AWS EC2 / Lightsail                                ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}             • Google Cloud                                      ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}             • Oracle Cloud                                      ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}             • Azure (new subscriptions)                          ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}                                                                   ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}  ${CYAN}Option 2:${NC} Use an API-based email service instead of SMTP:       ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}             • ${GREEN}SendGrid${NC} (HTTP API)                                ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}             • ${GREEN}Mailgun${NC}  (HTTP API)                                ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}             • ${GREEN}AWS SES${NC}  (SDK/API)                                 ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}             • ${GREEN}Resend${NC}   (HTTP API)                                ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}             These bypass SMTP entirely and are not affected       ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}             by port-level blocks.                                ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}                                                                   ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}  ${CYAN}Option 3:${NC} Use an SMTP relay that supports port ${GREEN}2525${NC}             ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}             (Mailgun, Mailtrap, SendGrid all support 2525).       ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}║${NC}                                                                   ${RED}${BOLD}║${NC}"
  echo -e "${RED}${BOLD}╚═══════════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  warn "Provisioning will continue, but email delivery WILL FAIL"
  warn "until SMTP connectivity is resolved."
  echo ""
else
  echo ""
  echo -e "${GREEN}${BOLD}╔═══════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}${BOLD}║            ✅  ALL SMTP PORTS ARE REACHABLE — EMAIL READY         ║${NC}"
  echo -e "${GREEN}${BOLD}╠═══════════════════════════════════════════════════════════════════╣${NC}"
  echo -e "${GREEN}${BOLD}║${NC}                                                                   ${GREEN}${BOLD}║${NC}"
  echo -e "${GREEN}${BOLD}║${NC}  Reachable ports: ${GREEN}${BOLD}${SMTP_OK_PORTS[*]}${NC}                                    ${GREEN}${BOLD}║${NC}"
  echo -e "${GREEN}${BOLD}║${NC}  Your VPS can send emails via SMTP.                               ${GREEN}${BOLD}║${NC}"
  echo -e "${GREEN}${BOLD}║${NC}  Configure your SMTP host in ${CYAN}backend.env${NC} to start sending.       ${GREEN}${BOLD}║${NC}"
  echo -e "${GREEN}${BOLD}║${NC}                                                                   ${GREEN}${BOLD}║${NC}"
  echo -e "${GREEN}${BOLD}╚═══════════════════════════════════════════════════════════════════╝${NC}"
  echo ""
fi

# =============================================================================
# 5. Docker Daemon Tuning
# =============================================================================
section "Docker Daemon Configuration"

DOCKER_DAEMON_JSON="/etc/docker/daemon.json"

if [[ ! -f "${DOCKER_DAEMON_JSON}" ]]; then
  sudo tee "${DOCKER_DAEMON_JSON}" > /dev/null <<'DAEMON'
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "20m",
    "max-file": "5"
  },
  "storage-driver": "overlay2",
  "default-address-pools": [
    { "base": "172.20.0.0/16", "size": 24 }
  ]
}
DAEMON

  sudo systemctl restart docker
  ok "Docker daemon configured with log rotation + overlay2"
else
  warn "Docker daemon.json already exists — skipping"
fi

# =============================================================================
# 6. Prepare Project Directory
# =============================================================================
section "Project Directory"

PROJECT_DIR="/root/dockers"

if [[ ! -d "${PROJECT_DIR}" ]]; then
  sudo mkdir -p "${PROJECT_DIR}"
  ok "Created ${PROJECT_DIR}"
else
  warn "${PROJECT_DIR} already exists"
fi

# =============================================================================
# 7. Verification
# =============================================================================
section "Verification"

echo ""
echo -e "${BOLD}Installed Tools:${NC}"
echo -e "  Docker Engine:   ${GREEN}$(docker --version 2>/dev/null || echo 'NOT FOUND')${NC}"
echo -e "  Docker Compose:  ${GREEN}$(docker compose version 2>/dev/null || echo 'NOT FOUND')${NC}"
echo -e "  Docker Buildx:   ${GREEN}$(docker buildx version 2>/dev/null || echo 'NOT FOUND')${NC}"
echo -e "  Git:             ${GREEN}$(git --version 2>/dev/null || echo 'NOT FOUND')${NC}"
echo -e "  Make:            ${GREEN}$(make --version 2>/dev/null | head -1 || echo 'NOT FOUND')${NC}"
echo -e "  OpenSSL:         ${GREEN}$(openssl version 2>/dev/null || echo 'NOT FOUND')${NC}"
echo -e "  curl:            ${GREEN}$(curl --version 2>/dev/null | head -1 || echo 'NOT FOUND')${NC}"
echo -e "  jq:              ${GREEN}$(jq --version 2>/dev/null || echo 'NOT FOUND')${NC}"
echo -e "  rsync:           ${GREEN}$(rsync --version 2>/dev/null | head -1 || echo 'NOT FOUND')${NC}"
echo ""

echo -e "${BOLD}System:${NC}"
echo -e "  Deploy as:       ${GREEN}root${NC}"
echo -e "  Project Dir:     ${GREEN}${PROJECT_DIR}${NC}"
echo ""

# =============================================================================
# Summary
# =============================================================================
echo ""
echo -e "${BOLD}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║              ✅  VPS Provisioning Complete               ║${NC}"
echo -e "${BOLD}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BOLD}║${NC}                                                           ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}  ${YELLOW}Next steps:${NC}                                             ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}                                                           ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}  ${CYAN}1.${NC} Push project files from your local machine:           ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}     ${CYAN}./scripts/push-to-vps.sh <vps-ip>${NC}                    ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}                                                           ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}  ${CYAN}2.${NC} SSH into VPS and create env files:                   ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}     ${CYAN}ssh root@<vps-ip>${NC}                                    ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}     ${CYAN}cd ~/dockers${NC}                                         ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}     ${CYAN}cp .env.example .env && nano .env${NC}                    ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}     ${CYAN}cp backend.env.example backend.env${NC}                   ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}                                                           ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}  ${CYAN}3.${NC} Start the stack:                                     ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}     ${CYAN}docker compose --profile prod up -d${NC}                  ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}                                                           ${BOLD}║${NC}"
echo -e "${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
