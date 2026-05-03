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
#   3. A 'deploy' user with passwordless sudo + Docker group membership
#   4. UFW firewall with required port rules
#   5. Swap space (2 GB) for low-memory VPS
#   6. System tuning (vm.overcommit_memory for Redis, fs.inotify for file watches)
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
if [[ $EUID -ne 0 ]]; then
  err "This script must be run as root (or with sudo)."
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

# ─── Configuration ──────────────────────────────────────────────────────────
DEPLOY_USER="${DEPLOY_USER:-deploy}"
SWAP_SIZE="${SWAP_SIZE:-2G}"

echo ""
echo -e "${BOLD}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║        Healytics VPS Provisioning Script                 ║${NC}"
echo -e "${BOLD}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BOLD}║${NC}  Deploy user:  ${CYAN}${DEPLOY_USER}${NC}                                   ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}  Swap size:    ${CYAN}${SWAP_SIZE}${NC}                                       ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}  Target OS:    ${CYAN}${PRETTY_NAME}${NC}"
echo -e "${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# =============================================================================
# 1. System Update & Essential Packages
# =============================================================================
section "System Update & Essential Packages"

export DEBIAN_FRONTEND=noninteractive

info "Updating package index..."
apt-get update -qq

info "Upgrading installed packages..."
apt-get upgrade -y -qq

info "Installing essential packages..."
apt-get install -y -qq --no-install-recommends \
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
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL "https://download.docker.com/linux/${ID}/gpg" \
    -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc

  info "Adding Docker repository..."
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/${ID} \
    $(. /etc/os-release && echo "${VERSION_CODENAME}") stable" \
    > /etc/apt/sources.list.d/docker.list

  apt-get update -qq

  info "Installing Docker Engine, CLI, and plugins..."
  apt-get install -y -qq --no-install-recommends \
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
systemctl enable docker
systemctl start docker
ok "Docker service is running"

# =============================================================================
# 3. Deploy User Setup
# =============================================================================
section "Deploy User: ${DEPLOY_USER}"

if id "${DEPLOY_USER}" &>/dev/null; then
  warn "User '${DEPLOY_USER}' already exists"
else
  info "Creating user '${DEPLOY_USER}'..."
  useradd -m -s /bin/bash "${DEPLOY_USER}"
  ok "User '${DEPLOY_USER}' created"
fi

# Add to docker and sudo groups
usermod -aG docker "${DEPLOY_USER}"
usermod -aG sudo "${DEPLOY_USER}"
ok "User '${DEPLOY_USER}' added to docker and sudo groups"

# Passwordless sudo
SUDOERS_FILE="/etc/sudoers.d/${DEPLOY_USER}"
if [[ ! -f "${SUDOERS_FILE}" ]]; then
  echo "${DEPLOY_USER} ALL=(ALL) NOPASSWD:ALL" > "${SUDOERS_FILE}"
  chmod 440 "${SUDOERS_FILE}"
  ok "Passwordless sudo configured for '${DEPLOY_USER}'"
fi

# Copy authorized_keys from root if deploy user has none
DEPLOY_SSH_DIR="/home/${DEPLOY_USER}/.ssh"
if [[ -f /root/.ssh/authorized_keys ]] && [[ ! -f "${DEPLOY_SSH_DIR}/authorized_keys" ]]; then
  info "Copying root's authorized_keys to '${DEPLOY_USER}'..."
  mkdir -p "${DEPLOY_SSH_DIR}"
  cp /root/.ssh/authorized_keys "${DEPLOY_SSH_DIR}/authorized_keys"
  chown -R "${DEPLOY_USER}:${DEPLOY_USER}" "${DEPLOY_SSH_DIR}"
  chmod 700 "${DEPLOY_SSH_DIR}"
  chmod 600 "${DEPLOY_SSH_DIR}/authorized_keys"
  ok "SSH keys copied to '${DEPLOY_USER}'"
fi

# =============================================================================
# 4. UFW Firewall
# =============================================================================
section "Firewall (UFW)"

if ! command -v ufw &>/dev/null; then
  info "Installing UFW..."
  apt-get install -y -qq ufw
fi

# Reset UFW to clean state (non-interactive)
info "Configuring firewall rules..."
ufw --force reset >/dev/null 2>&1

# Default policies
ufw default deny incoming >/dev/null 2>&1
ufw default allow outgoing >/dev/null 2>&1

# SSH — always required
ufw allow 22/tcp comment "SSH" >/dev/null 2>&1

# Kong Gateway ports
ufw allow 8000/tcp comment "Kong Proxy HTTP" >/dev/null 2>&1
ufw allow 8443/tcp comment "Kong Proxy HTTPS" >/dev/null 2>&1

# Optional: Kong Admin API — restrict to trusted IPs in production
# ufw allow 8001/tcp comment "Kong Admin API"
# ufw allow 8002/tcp comment "Kong Manager GUI"

# Jenkins (if running ci profile)
ufw allow 8081/tcp comment "Jenkins Web UI" >/dev/null 2>&1

# Enable UFW
ufw --force enable >/dev/null 2>&1
ok "UFW enabled with the following rules:"
ufw status numbered 2>/dev/null | head -20

# =============================================================================
# 5. Swap Space
# =============================================================================
section "Swap Space"

if swapon --show | grep -q '/swapfile'; then
  warn "Swap already configured:"
  swapon --show
else
  info "Creating ${SWAP_SIZE} swap file..."
  fallocate -l "${SWAP_SIZE}" /swapfile
  chmod 600 /swapfile
  mkswap /swapfile >/dev/null
  swapon /swapfile

  # Persist across reboots
  if ! grep -q '/swapfile' /etc/fstab; then
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
  fi

  ok "Swap configured: ${SWAP_SIZE}"
  swapon --show
fi

# =============================================================================
# 6. System Tuning (sysctl)
# =============================================================================
section "System Tuning"

SYSCTL_CONF="/etc/sysctl.d/99-healytics.conf"

cat > "${SYSCTL_CONF}" <<'SYSCTL'
# ── Healytics Docker Stack Tuning ──

# Redis: disable THP warning + allow overcommit
vm.overcommit_memory = 1

# Increase inotify watches (for file-watching services like Jenkins, Node.js)
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 1024

# Network: increase connection tracking for many containers
net.netfilter.nf_conntrack_max = 131072

# Network: allow more TIME_WAIT sockets for high-throughput services
net.ipv4.tcp_tw_reuse = 1
net.core.somaxconn = 65535
SYSCTL

sysctl --system >/dev/null 2>&1
ok "sysctl tuning applied"

# Disable Transparent Huge Pages (Redis requirement)
if [[ -f /sys/kernel/mm/transparent_hugepage/enabled ]]; then
  echo never > /sys/kernel/mm/transparent_hugepage/enabled 2>/dev/null || true
  echo never > /sys/kernel/mm/transparent_hugepage/defrag 2>/dev/null || true
  ok "Transparent Huge Pages disabled (Redis optimization)"
fi

# =============================================================================
# 7. Docker Daemon Tuning
# =============================================================================
section "Docker Daemon Configuration"

DOCKER_DAEMON_JSON="/etc/docker/daemon.json"

if [[ ! -f "${DOCKER_DAEMON_JSON}" ]]; then
  cat > "${DOCKER_DAEMON_JSON}" <<'DAEMON'
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

  systemctl restart docker
  ok "Docker daemon configured with log rotation + overlay2"
else
  warn "Docker daemon.json already exists — skipping"
fi

# =============================================================================
# 8. Prepare Project Directory
# =============================================================================
section "Project Directory"

PROJECT_DIR="/home/${DEPLOY_USER}/dockers"

if [[ ! -d "${PROJECT_DIR}" ]]; then
  mkdir -p "${PROJECT_DIR}"
  chown "${DEPLOY_USER}:${DEPLOY_USER}" "${PROJECT_DIR}"
  ok "Created ${PROJECT_DIR}"
else
  warn "${PROJECT_DIR} already exists"
fi

# =============================================================================
# 9. Verification
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
echo -e "  Swap:            ${GREEN}$(swapon --show --noheadings 2>/dev/null | awk '{print $3}' || echo 'None')${NC}"
echo -e "  Deploy User:     ${GREEN}${DEPLOY_USER} (groups: $(id -nG ${DEPLOY_USER} 2>/dev/null))${NC}"
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
echo -e "${BOLD}║${NC}     ${CYAN}ssh ${DEPLOY_USER}@<vps-ip>${NC}                                  ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}     ${CYAN}cd ~/dockers${NC}                                         ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}     ${CYAN}cp .env.example .env && nano .env${NC}                    ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}     ${CYAN}cp backend.env.example backend.env${NC}                   ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}                                                           ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}  ${CYAN}3.${NC} Start the stack:                                     ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}     ${CYAN}docker compose --profile prod up -d${NC}                  ${BOLD}║${NC}"
echo -e "${BOLD}║${NC}                                                           ${BOLD}║${NC}"
echo -e "${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
