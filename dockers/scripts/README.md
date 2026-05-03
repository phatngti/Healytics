# Healytics Dockers — Scripts

Operational scripts for deploying and managing the Healytics Docker infrastructure.

---

## `setup-vps.sh`

Provisions a fresh Ubuntu/Debian VPS with everything needed to run the Healytics Docker Compose stack. Run this **once** on a new server before pushing any project files.

### What It Installs

| Category | Details |
|---|---|
| **Docker Engine** | Docker CE + CLI + containerd |
| **Docker Compose** | v2 plugin (`docker compose`) |
| **Docker Buildx** | Multi-platform image builds |
| **System packages** | `curl`, `git`, `make`, `openssl`, `jq`, `rsync`, `wget`, `nano`, `htop`, `tree`, etc. |
| **Deploy user** | Creates a `deploy` user with Docker group + passwordless sudo |
| **UFW Firewall** | SSH (22), Kong Proxy (8000, 8443), Jenkins (8081) |
| **Swap** | 2 GB swap file (configurable) for low-memory VPS |
| **System tuning** | Redis overcommit, inotify watches, conntrack limits, Docker log rotation |

### Quick Start

```bash
# Option 1: Pipe directly over SSH (no files to copy)
ssh root@203.0.113.42 "bash -s" < scripts/setup-vps.sh

# Option 2: Copy to VPS and run
scp scripts/setup-vps.sh root@203.0.113.42:/tmp/
ssh root@203.0.113.42 "chmod +x /tmp/setup-vps.sh && /tmp/setup-vps.sh"
```

### Configuration

| Variable | Default | Description |
|---|---|---|
| `DEPLOY_USER` | `deploy` | Username to create for deployments |
| `SWAP_SIZE` | `2G` | Size of the swap file |

```bash
# Custom user and swap
DEPLOY_USER=healytics SWAP_SIZE=4G ssh root@203.0.113.42 "bash -s" < scripts/setup-vps.sh
```

### Prerequisites

- A fresh **Ubuntu 22.04+** or **Debian 12+** VPS
- Root access (or sudo)
- The script is **idempotent** — safe to run multiple times

### Services Supported

The installed tooling covers all services in `docker-compose.yml`:

| Service | Requires |
|---|---|
| PostgreSQL + PostGIS | Docker (builds custom image) |
| Redis | Docker |
| RabbitMQ cluster (×3) | Docker + `make` + `openssl` (TLS cert gen) |
| HAProxy | Docker |
| Kong Gateway | Docker |
| Cloudflared | Docker + `curl` + `jq` (tunnel setup) |
| Jenkins Controller | Docker (builds custom image) |
| Backend API | Docker |

---

## `push-to-vps.sh`

Syncs the entire `dockers/` project to a VPS using `rsync` over SSH.
Sensitive files (`.env`, private keys, credentials) are **automatically excluded** so they never leave the local machine.

### Prerequisites

| Requirement | Notes |
|---|---|
| `rsync` | Pre-installed on macOS. On Linux: `apt install rsync` |
| `ssh` | Pre-installed on macOS/Linux |
| SSH key pair | Your public key must be authorized on the VPS (`~/.ssh/authorized_keys`) |

### Quick Start

```bash
# From anywhere — just pass the VPS IP
./scripts/push-to-vps.sh 203.0.113.42
```

That's it. The script will:

1. Verify SSH connectivity
2. Create the remote directory if it doesn't exist
3. Sync all non-sensitive files
4. Set `+x` permission on all `.sh` files remotely
5. Print a reminder of which files you still need to create on the VPS

### Full Usage

```text
Usage: ./scripts/push-to-vps.sh <vps-ip-or-hostname>

       Or set the VPS_HOST environment variable:
         VPS_HOST=203.0.113.42 ./scripts/push-to-vps.sh
```

### Configuration

All configuration is via environment variables. Every variable has a sensible default:

| Variable | Default | Description |
|---|---|---|
| `VPS_HOST` | *(required — or pass as `$1`)* | IP address or hostname of the target VPS |
| `VPS_USER` | `deploy` | SSH user on the VPS |
| `VPS_PORT` | `22` | SSH port |
| `VPS_DEST` | `~/dockers` | Remote destination path |
| `SSH_KEY` | `~/.ssh/id_ed25519` | Path to your SSH private key |
| `DRY_RUN` | `false` | Set to `true` to preview without transferring |

### Examples

**Basic push (dynamic IP):**

```bash
./scripts/push-to-vps.sh 203.0.113.42
```

**Custom SSH user and port:**

```bash
VPS_USER=root VPS_PORT=2222 ./scripts/push-to-vps.sh 203.0.113.42
```

**Custom remote path:**

```bash
VPS_DEST=/opt/healytics/dockers ./scripts/push-to-vps.sh 203.0.113.42
```

**Use a specific SSH key:**

```bash
SSH_KEY=~/.ssh/healytics_deploy ./scripts/push-to-vps.sh 203.0.113.42
```

**Dry run (preview what would be synced):**

```bash
DRY_RUN=true ./scripts/push-to-vps.sh 203.0.113.42
```

**Combine multiple options:**

```bash
VPS_USER=deploy \
VPS_PORT=2222 \
VPS_DEST=/opt/healytics/dockers \
SSH_KEY=~/.ssh/healytics_deploy \
  ./scripts/push-to-vps.sh my-vps.example.com
```

### Excluded Files

The script automatically excludes these sensitive and non-essential files:

| Category | Files |
|---|---|
| **Environment files** | `.env`, `backend.env`, `deploy.env`, `jenkins-agent.env` |
| **Private keys** | `rabbitmq/certs/ca_key.pem`, `rabbitmq/certs/*_key.pem`, `rabbitmq/certs/*.p12` |
| **Tunnel config** | `cloudflare-tunnels.json` (contains live tunnel tokens) |
| **Runtime data** | `jenkins_home/` |
| **Dev tooling** | `.agents/`, `.git/`, `.vscode/`, `.idea/` |
| **OS junk** | `.DS_Store`, `Thumbs.db` |

### Post-Push Setup on VPS

After the first push, you must create the sensitive files manually on the VPS:

```bash
# SSH into the VPS
ssh deploy@203.0.113.42

# Navigate to the project
cd ~/dockers

# 1. Create .env from template
cp .env.example .env
nano .env                  # Fill in all passwords, tokens, API keys

# 2. Create backend.env from template
cp backend.env.example backend.env
nano backend.env           # Fill in JWT secrets, Stripe keys, etc.

# 3. Create cloudflare-tunnels.json from template
cp cloudflare-tunnels.example.json cloudflare-tunnels.json
nano cloudflare-tunnels.json  # Configure tunnel routes

# 4. RabbitMQ certs — generated automatically on first `docker compose up`
#    If you need to pre-seed them, copy from a trusted source.
```

### How It Works

The script uses `rsync` with the following behavior:

- **`--delete`** — Files deleted locally are also deleted on the VPS
- **`--delete-excluded`** — Excluded files already on the VPS are removed (prevents stale sensitive files from a prior manual copy)
- **`-avz`** — Archive mode (preserves permissions), verbose, compressed transfer
- **`--progress`** — Shows real-time transfer progress

SSH uses `StrictHostKeyChecking=accept-new` so the first connection auto-accepts the host key, but subsequent connections verify it hasn't changed (TOFU model).

### Troubleshooting

**"SSH key not found"**

The script auto-detects keys in this order: `id_ed25519` → `id_rsa` → `id_ecdsa`. If your key has a custom name:

```bash
SSH_KEY=~/.ssh/my_custom_key ./scripts/push-to-vps.sh 203.0.113.42
```

**"Cannot connect to VPS"**

Verify manually:

```bash
ssh -i ~/.ssh/id_ed25519 deploy@203.0.113.42 "echo OK"
```

Common fixes:
- Ensure your public key is in `~/.ssh/authorized_keys` on the VPS
- Check that the VPS firewall allows SSH on the configured port
- Verify the `VPS_USER` exists on the VPS

**"Permission denied" on remote scripts**

The script automatically runs `chmod +x` on all `.sh` files after sync. If you still see issues:

```bash
ssh deploy@203.0.113.42 "chmod +x ~/dockers/scripts/*.sh ~/dockers/*.sh"
```

---

## `deploy-backend.sh`

Deploys a specific backend image tag on the VPS. This script is called by the Jenkins pipeline after pushing a new image to DockerHub.

```bash
# Run on the VPS
./scripts/deploy-backend.sh <immutable-image-tag>

# Example
./scripts/deploy-backend.sh abc1234
```

The script handles: pulling the image, running migrations, starting the container, applying Kong config, health checks, and automatic rollback on failure.

See [`jenkins/README.md`](../jenkins/README.md) for the full CI/CD pipeline documentation.
