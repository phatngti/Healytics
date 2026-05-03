#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB_DIR="$ROOT_DIR/lib"
EXIT_CODE=0

echo "Checking architecture guardrails..."

echo "- Domain layer must stay Flutter-free"
if grep -R -n -E "package:flutter" \
  "$LIB_DIR/features/authenticate/domain" --include="*.dart" 2>/dev/null; then
  echo "Authenticate domain imports Flutter packages."
  EXIT_CODE=1
fi

echo "- Presentation must not leak data-layer imports"
if grep -R -n -E "datasources/remote" \
  "$LIB_DIR/features/*/presentation" --include="*.dart" 2>/dev/null; then
  echo "Presentation layer imports data sources directly."
  EXIT_CODE=1
fi

echo "- No print() statements (use dart:developer log)"
if grep -R -n -E "^\s*print\(" \
  "$LIB_DIR" --include="*.dart" 2>/dev/null; then
  echo "print() usage found — use log() from dart:developer."
  EXIT_CODE=1
fi

if [[ $EXIT_CODE -eq 0 ]]; then
  echo "Architecture checks passed."
else
  echo "Architecture checks failed."
fi

exit $EXIT_CODE
