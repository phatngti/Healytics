#!/bin/bash
# ============================================================================
# Auto-create extra PostgreSQL databases from POSTGRES_EXTRA_DATABASES env var.
# Runs as a separate init container AFTER Postgres is healthy.
#
# POSTGRES_EXTRA_DATABASES should be a comma-separated list of database names.
# Example: POSTGRES_EXTRA_DATABASES=kong_db,app_db,analytics_db
# ============================================================================

set -e

echo "========================================"
echo "[init-databases] Starting database initialization"
echo "[init-databases] POSTGRES_HOST=$POSTGRES_HOST"
echo "[init-databases] POSTGRES_USER=$POSTGRES_USER"
echo "[init-databases] POSTGRES_DB=$POSTGRES_DB"
echo "[init-databases] POSTGRES_EXTRA_DATABASES=$POSTGRES_EXTRA_DATABASES"
echo "========================================"

if [ -z "$POSTGRES_EXTRA_DATABASES" ]; then
  echo "[init-databases] POSTGRES_EXTRA_DATABASES is empty — skipping."
  exit 0
fi

export PGPASSWORD="$POSTGRES_PASSWORD"

echo "[init-databases] Creating extra databases: $POSTGRES_EXTRA_DATABASES"

IFS=',' read -ra DBS <<< "$POSTGRES_EXTRA_DATABASES"
for db in "${DBS[@]}"; do
  # Trim whitespace
  db=$(echo "$db" | xargs)
  if [ -z "$db" ]; then
    continue
  fi

  # Check if database already exists
  EXISTS=$(psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -tAc \
    "SELECT 1 FROM pg_database WHERE datname = '$db'")

  if [ "$EXISTS" = "1" ]; then
    echo "[init-databases] Database '$db' already exists — skipping."
  else
    echo "[init-databases] Creating database: $db ..."
    psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE DATABASE \"$db\";"
    echo "[init-databases] Database '$db' created successfully."
  fi
done

echo "========================================"
echo "[init-databases] Done. All databases processed."
echo "========================================"
