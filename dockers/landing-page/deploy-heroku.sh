#!/usr/bin/env bash
set -euo pipefail

HEROKU_GIT_URL="${HEROKU_GIT_URL:-https://git.heroku.com/healytics-landing-page.git}"
HEROKU_BRANCH="${HEROKU_BRANCH:-main}"
HEROKU_FORCE_PUSH="${HEROKU_FORCE_PUSH:-true}"
HEROKU_DRY_RUN="${HEROKU_DRY_RUN:-false}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

for cmd in git rsync; do
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "ERROR: ${cmd} is required." >&2
    exit 1
  fi
done

rsync -a \
  --exclude ".git/" \
  --exclude "node_modules/" \
  --exclude ".DS_Store" \
  "${SCRIPT_DIR}/" "${TMP_DIR}/"

git -C "${TMP_DIR}" init -q
git -C "${TMP_DIR}" config user.name "Healytics Deploy"
git -C "${TMP_DIR}" config user.email "deploy@healytics.local"
git -C "${TMP_DIR}" add .
git -C "${TMP_DIR}" commit -q -m "Deploy Healytics landing page"
git -C "${TMP_DIR}" remote add heroku "${HEROKU_GIT_URL}"

push_args=(heroku "HEAD:${HEROKU_BRANCH}")
if [[ "${HEROKU_FORCE_PUSH}" == "true" ]]; then
  push_args=(--force "${push_args[@]}")
fi

echo "Deploying landing-page to ${HEROKU_GIT_URL} (${HEROKU_BRANCH})"
if [[ "${HEROKU_DRY_RUN}" == "true" ]]; then
  git -C "${TMP_DIR}" status --short
  git -C "${TMP_DIR}" log --oneline -1
  echo "Dry run enabled; skipping Heroku push."
  exit 0
fi

git -C "${TMP_DIR}" push "${push_args[@]}"
