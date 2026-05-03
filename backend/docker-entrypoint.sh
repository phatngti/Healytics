#!/bin/sh
set -e

# ── Start the main NestJS application ────────────────────────────────────
echo "[entrypoint] Starting application..."
exec node dist/src/main
