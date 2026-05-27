#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PERF_SWARM_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
PERF_SWARM_ENV="${PERF_SWARM_ENV:-${PERF_SWARM_DIR}/env/swarm.env}"

info() { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*" >&2; }
die() { printf '[ERROR] %s\n' "$*" >&2; exit 1; }

load_env() {
  if [[ -f "${PERF_SWARM_ENV}" ]]; then
    set -a
    # shellcheck disable=SC1090
    source "${PERF_SWARM_ENV}"
    set +a
  else
    warn "Performance Swarm env not found: ${PERF_SWARM_ENV}. Using exported environment and defaults."
  fi
  STACK_NAME="${STACK_NAME:-healytics}"
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

require_swarm_manager() {
  require_cmd docker
  docker info >/dev/null 2>&1 || die "Docker is not reachable from this shell."

  local state control
  state="$(docker info --format '{{.Swarm.LocalNodeState}}' 2>/dev/null || true)"
  control="$(docker info --format '{{.Swarm.ControlAvailable}}' 2>/dev/null || true)"
  [[ "${state}" == "active" ]] || die "This Docker engine is not in an active Swarm."
  [[ "${control}" == "true" ]] || die "Run this script on a Swarm manager."
}

service_name() {
  printf '%s_%s\n' "${STACK_NAME}" "$1"
}

require_positive_int() {
  local name="$1"
  local value="$2"
  [[ "${value}" =~ ^[0-9]+$ && "${value}" -gt 0 ]] || die "${name} must be a positive integer, got '${value}'."
}

require_non_negative_number() {
  local name="$1"
  local value="$2"
  awk -v value="${value}" 'BEGIN { exit(value ~ /^[0-9]+([.][0-9]+)?$/ ? 0 : 1) }' \
    || die "${name} must be a non-negative number, got '${value}'."
}

float_ge() {
  awk -v left="$1" -v right="$2" 'BEGIN { exit(left >= right ? 0 : 1) }'
}

float_le() {
  awk -v left="$1" -v right="$2" 'BEGIN { exit(left <= right ? 0 : 1) }'
}

float_lt() {
  awk -v left="$1" -v right="$2" 'BEGIN { exit(left < right ? 0 : 1) }'
}

current_replicas() {
  docker service inspect \
    --format '{{if .Spec.Mode.Replicated}}{{.Spec.Mode.Replicated.Replicas}}{{else}}0{{end}}' \
    "${SERVICE}"
}

average_backend_cpu() {
  local containers=()
  while IFS= read -r container_id; do
    [[ -n "${container_id}" ]] && containers+=("${container_id}")
  done < <(
    docker ps \
      --filter "label=com.docker.swarm.service.name=${SERVICE}" \
      --filter "status=running" \
      --format '{{.ID}}'
  )

  if [[ "${#containers[@]}" -eq 0 ]]; then
    return 1
  fi

  docker stats --no-stream --format '{{.CPUPerc}}' "${containers[@]}" \
    | tr -d '%' \
    | awk '
        NF {
          sum += $1
          count += 1
        }
        END {
          if (count == 0) {
            exit 1
          }
          printf "%.2f", sum / count
        }
      '
}

scale_backend() {
  local desired="$1"
  info "Scaling ${SERVICE} to ${desired} replica(s)."
  docker service scale "${SERVICE}=${desired}" >/dev/null
}

load_env
require_swarm_manager

SERVICE="$(service_name backend)"
MIN_REPLICAS="${BACKEND_AUTOSCALE_MIN_REPLICAS:-1}"
MAX_REPLICAS="${BACKEND_AUTOSCALE_MAX_REPLICAS:-4}"
CPU_UP_PERCENT="${BACKEND_AUTOSCALE_CPU_UP_PERCENT:-80}"
CPU_DOWN_PERCENT="${BACKEND_AUTOSCALE_CPU_DOWN_PERCENT:-35}"
POLL_SECONDS="${BACKEND_AUTOSCALE_POLL_SECONDS:-30}"
COOLDOWN_SECONDS="${BACKEND_AUTOSCALE_COOLDOWN_SECONDS:-120}"

require_positive_int BACKEND_AUTOSCALE_MIN_REPLICAS "${MIN_REPLICAS}"
require_positive_int BACKEND_AUTOSCALE_MAX_REPLICAS "${MAX_REPLICAS}"
require_non_negative_number BACKEND_AUTOSCALE_CPU_UP_PERCENT "${CPU_UP_PERCENT}"
require_non_negative_number BACKEND_AUTOSCALE_CPU_DOWN_PERCENT "${CPU_DOWN_PERCENT}"
require_positive_int BACKEND_AUTOSCALE_POLL_SECONDS "${POLL_SECONDS}"
require_positive_int BACKEND_AUTOSCALE_COOLDOWN_SECONDS "${COOLDOWN_SECONDS}"

[[ "${MIN_REPLICAS}" -le "${MAX_REPLICAS}" ]] \
  || die "BACKEND_AUTOSCALE_MIN_REPLICAS must be <= BACKEND_AUTOSCALE_MAX_REPLICAS."
float_lt "${CPU_DOWN_PERCENT}" "${CPU_UP_PERCENT}" \
  || die "BACKEND_AUTOSCALE_CPU_DOWN_PERCENT must be lower than BACKEND_AUTOSCALE_CPU_UP_PERCENT."

docker service inspect "${SERVICE}" >/dev/null 2>&1 \
  || die "Service ${SERVICE} does not exist. Deploy the app stack first."

stopping=false
last_scale_at=0

stop_autoscaler() {
  stopping=true
  info "Stopping backend autoscaler for ${SERVICE}."
}

trap stop_autoscaler INT TERM HUP

info "Backend autoscaler started for ${SERVICE}: min=${MIN_REPLICAS}, max=${MAX_REPLICAS}, scale-up>=${CPU_UP_PERCENT}%, scale-down<=${CPU_DOWN_PERCENT}%."

while [[ "${stopping}" != "true" ]]; do
  replicas="$(current_replicas)"

  if ! cpu="$(average_backend_cpu)"; then
    warn "No running local backend task containers found for ${SERVICE}; cannot sample docker stats yet."
    sleep "${POLL_SECONDS}"
    continue
  fi

  now="$(date +%s)"
  cooldown_remaining=$((COOLDOWN_SECONDS - (now - last_scale_at)))
  decision="hold"
  desired="${replicas}"

  if float_ge "${cpu}" "${CPU_UP_PERCENT}" && [[ "${replicas}" -lt "${MAX_REPLICAS}" ]]; then
    desired=$((replicas + 1))
    decision="scale-up"
  elif float_le "${cpu}" "${CPU_DOWN_PERCENT}" && [[ "${replicas}" -gt "${MIN_REPLICAS}" ]]; then
    desired=$((replicas - 1))
    decision="scale-down"
  fi

  if [[ "${decision}" != "hold" ]]; then
    if [[ "${last_scale_at}" -eq 0 || "${cooldown_remaining}" -le 0 ]]; then
      info "cpu=${cpu}% replicas=${replicas} decision=${decision} desired=${desired}"
      scale_backend "${desired}"
      last_scale_at="$(date +%s)"
    else
      info "cpu=${cpu}% replicas=${replicas} decision=${decision} skipped=cooldown_remaining_${cooldown_remaining}s"
    fi
  else
    info "cpu=${cpu}% replicas=${replicas} decision=hold"
  fi

  sleep "${POLL_SECONDS}"
done
