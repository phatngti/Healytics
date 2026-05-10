#!/usr/bin/env bash
# =============================================================================
# backup-db.sh — Automated daily PostgreSQL backup via pg_dump
# =============================================================================
# Usage:
#   ./scripts/backup-db.sh                 # manual run
#   # Or add to crontab for daily backups:
#   # 0 2 * * * /root/dockers/scripts/backup-db.sh >> /var/log/healytics-backup.log 2>&1
#
# This script:
#   1. Dumps the PostgreSQL database using pg_dump (compressed .sql.gz)
#   2. Names each backup with a timestamp for easy identification
#   3. Cleans up backups older than RETENTION_DAYS (default: 7)
# =============================================================================
set -Eeuo pipefail

# ─── Configuration ──────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Load environment variables from .env
if [[ -f "${PROJECT_DIR}/.env" ]]; then
  set -a
  source "${PROJECT_DIR}/.env"
  set +a
fi

# Database connection (from .env or defaults)
DB_HOST="${POSTGRES_HOST:-localhost}"
DB_PORT="${POSTGRES_PORT:-5432}"
DB_USER="${POSTGRES_USER:?POSTGRES_USER is required}"
DB_NAME="${POSTGRES_DB:?POSTGRES_DB is required}"
DB_PASSWORD="${POSTGRES_PASSWORD:?POSTGRES_PASSWORD is required}"

# Backup settings
BACKUP_DIR="${BACKUP_DIR:-${PROJECT_DIR}/backups}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"
TIMESTAMP="$(date +%Y-%m-%d_%H-%M)"
BACKUP_FILE="healytics_backup_${TIMESTAMP}.sql.gz"

# ─── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[$(date '+%Y-%m-%d %H:%M:%S')] [INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] [ OK ]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] [WARN]${NC}  $*"; }
err()   { echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR]${NC} $*" >&2; }

# ─── Create backup directory ────────────────────────────────────────────────
mkdir -p "${BACKUP_DIR}"

# ─── Perform backup ─────────────────────────────────────────────────────────
info "Starting PostgreSQL backup..."
info "  Database: ${DB_NAME}@${DB_HOST}:${DB_PORT}"
info "  Output:   ${BACKUP_DIR}/${BACKUP_FILE}"

# Use pg_dump from the running postgres container (avoids needing pg_dump on host)
if docker exec docker_postgres pg_dump \
    -U "${DB_USER}" \
    -d "${DB_NAME}" \
    --no-owner \
    --no-acl \
    --clean \
    --if-exists \
  2>/dev/null | gzip > "${BACKUP_DIR}/${BACKUP_FILE}"; then

  BACKUP_SIZE=$(du -h "${BACKUP_DIR}/${BACKUP_FILE}" | cut -f1)
  ok "Backup completed successfully: ${BACKUP_FILE} (${BACKUP_SIZE})"
else
  err "Backup FAILED for database ${DB_NAME}"
  # Remove incomplete backup file
  rm -f "${BACKUP_DIR}/${BACKUP_FILE}"
  exit 1
fi

# ─── Verify backup is not empty ─────────────────────────────────────────────
BACKUP_BYTES=$(stat -f%z "${BACKUP_DIR}/${BACKUP_FILE}" 2>/dev/null || stat -c%s "${BACKUP_DIR}/${BACKUP_FILE}" 2>/dev/null || echo 0)
if [[ "${BACKUP_BYTES}" -lt 100 ]]; then
  err "Backup file is suspiciously small (${BACKUP_BYTES} bytes) — possible empty dump"
  exit 1
fi

# ─── Clean up old backups ───────────────────────────────────────────────────
info "Cleaning up backups older than ${RETENTION_DAYS} days..."
DELETED_COUNT=0
while IFS= read -r old_backup; do
  rm -f "${old_backup}"
  DELETED_COUNT=$((DELETED_COUNT + 1))
  info "  Deleted: $(basename "${old_backup}")"
done < <(find "${BACKUP_DIR}" -name "healytics_backup_*.sql.gz" -mtime +${RETENTION_DAYS} -type f 2>/dev/null)

if [[ ${DELETED_COUNT} -gt 0 ]]; then
  ok "Cleaned up ${DELETED_COUNT} old backup(s)"
else
  info "No old backups to clean up"
fi

# ─── List current backups ───────────────────────────────────────────────────
TOTAL_BACKUPS=$(find "${BACKUP_DIR}" -name "healytics_backup_*.sql.gz" -type f 2>/dev/null | wc -l | tr -d ' ')
TOTAL_SIZE=$(du -sh "${BACKUP_DIR}" 2>/dev/null | cut -f1)

ok "Backup summary:"
info "  Total backups: ${TOTAL_BACKUPS}"
info "  Total size:    ${TOTAL_SIZE}"
info "  Retention:     ${RETENTION_DAYS} days"
echo ""
