#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# start-agent.sh — Download and launch a Jenkins inbound (JNLP) agent
#
# Required env vars:
#   JENKINS_URL     — Controller URL  (e.g. http://jenkins-controller:8080)
#   AGENT_NAME      — Node name       (default: local-docker-builder)
#   AGENT_WORKDIR   — Working dir     (default: $HOME/jenkins-agent)
#
# Optional env vars:
#   JENKINS_SECRET  — Agent secret. If empty, the script auto-fetches it from
#                     the controller API (requires admin credentials via
#                     JENKINS_ADMIN_USER / JENKINS_ADMIN_PASSWORD env vars).
# ---------------------------------------------------------------------------
set -euo pipefail

AGENT_NAME="${AGENT_NAME:-local-docker-builder}"
AGENT_WORKDIR="${AGENT_WORKDIR:-$HOME/jenkins-agent}"
AGENT_JAR="${AGENT_WORKDIR}/agent.jar"

: "${JENKINS_URL:?JENKINS_URL is required}"

mkdir -p "${AGENT_WORKDIR}"

# Download agent.jar with retry + exponential backoff
MAX_RETRIES=15
RETRY_DELAY=2

for i in $(seq 1 "$MAX_RETRIES"); do
  echo "Downloading agent.jar from ${JENKINS_URL} (attempt ${i}/${MAX_RETRIES}) ..."
  if curl -fsSL "${JENKINS_URL}/jnlpJars/agent.jar" -o "${AGENT_JAR}"; then
    echo "agent.jar downloaded successfully"
    break
  fi

  if [ "$i" -eq "$MAX_RETRIES" ]; then
    echo "Failed to download agent.jar after ${MAX_RETRIES} attempts"
    exit 1
  fi

  echo "Controller not ready, retrying in ${RETRY_DELAY}s ..."
  sleep "$RETRY_DELAY"
  RETRY_DELAY=$((RETRY_DELAY * 2 > 60 ? 60 : RETRY_DELAY * 2))
done

# ---------------------------------------------------------------------------
# Auto-fetch secret if not provided (ci-local mode)
# ---------------------------------------------------------------------------
if [ -z "${JENKINS_SECRET:-}" ]; then
  ADMIN_USER="admin"
  ADMIN_PASS="${JENKINS_ADMIN_PASSWORD:-admin}"
  echo "JENKINS_SECRET not set — fetching from controller API ..."

  for i in $(seq 1 "$MAX_RETRIES"); do
    SECRET=$(curl -fsSL -u "${ADMIN_USER}:${ADMIN_PASS}" \
      "${JENKINS_URL}/computer/${AGENT_NAME}/jenkins-agent.jnlp" 2>/dev/null \
      | sed -n 's/.*<argument>\([a-f0-9]\{64\}\)<\/argument>.*/\1/p' || true)

    if [ -n "${SECRET}" ]; then
      JENKINS_SECRET="${SECRET}"
      echo "Auto-fetched agent secret successfully"
      break
    fi

    if [ "$i" -eq "$MAX_RETRIES" ]; then
      echo "ERROR: Failed to fetch agent secret after ${MAX_RETRIES} attempts."
      echo "  Make sure the '${AGENT_NAME}' node exists in Jenkins (JCasC should create it)."
      exit 1
    fi

    echo "Waiting for node '${AGENT_NAME}' to be ready (attempt ${i}/${MAX_RETRIES}) ..."
    sleep "$RETRY_DELAY"
  done
fi

echo "Starting Jenkins agent '${AGENT_NAME}' ..."
exec java -jar "${AGENT_JAR}" \
  -url "${JENKINS_URL}" \
  -secret "${JENKINS_SECRET}" \
  -name "${AGENT_NAME}" \
  -webSocket \
  -workDir "${AGENT_WORKDIR}"

