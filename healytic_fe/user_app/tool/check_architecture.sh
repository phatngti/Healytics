#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB_DIR="$ROOT_DIR/lib"
EXIT_CODE=0

echo "Checking architecture guardrails..."

echo "- Sign-up domain layer must stay Flutter-free"
if grep -R -n -E "package:flutter" \
  "$LIB_DIR/features/onboarding/sign_up/domain" --include="*.dart"; then
  echo "Sign-up domain imports Flutter packages."
  EXIT_CODE=1
fi

echo "- Home presentation must not import authenticate presentation provider"
if grep -R -n -E "authenticate.provider\\.dart" \
  "$LIB_DIR/features/home/presentation" --include="*.dart"; then
  echo "Home presentation still depends on authenticate presentation."
  EXIT_CODE=1
fi

echo "- Router should depend on auth session abstraction"
if grep -R -n -E "core/entities/store\\.entity\\.dart|core/models/store\\.model\\.dart" \
  "$LIB_DIR/router/app_router.dart"; then
  echo "Router still imports low-level store entities/models."
  EXIT_CODE=1
fi

echo "- Legacy typo imports should be removed from sign-up feature"
if grep -R -n -E "^import .*datasouces|^import .*surver\\.dart|^import .*completed_resgistration\\.dart|^import .*register_repo\\.dart" \
  "$LIB_DIR/features/onboarding/sign_up" --include="*.dart"; then
  echo "Legacy typo-based imports/usages found."
  EXIT_CODE=1
fi

if [[ $EXIT_CODE -eq 0 ]]; then
  echo "Architecture checks passed."
else
  echo "Architecture checks failed."
fi

exit $EXIT_CODE
