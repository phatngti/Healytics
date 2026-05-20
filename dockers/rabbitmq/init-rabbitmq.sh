#!/bin/sh
set -e

# ============================================================================
# RabbitMQ Init Script
# Creates the backend vhost, user, and sets permissions via Management API.
# Runs as a one-shot init container after rabbitmq1 is up.
#
# Uses -k (insecure) because certs are generated with CN=localhost
# but we connect via Docker hostname (rabbitmq1). This is safe since
# we are inside the Docker network.
# ============================================================================

RABBITMQ_HOST="${RABBITMQ_HOST:-rabbitmq1}"
MGMT_PORT="${RABBITMQ_MGMT_PORT:-15671}"
BASE_URL="https://${RABBITMQ_HOST}:${MGMT_PORT}/api"
CURL_OPTS="-k -s -f -u ${RABBITMQ_DEFAULT_USER}:${RABBITMQ_DEFAULT_PASS}"

echo "=== RabbitMQ Init ==="
echo "Waiting for Management API at ${BASE_URL}..."

# Wait for Management API to be ready (up to 120s)
MAX_RETRIES=60
for i in $(seq 1 $MAX_RETRIES); do
    if curl ${CURL_OPTS} "${BASE_URL}/overview" > /dev/null 2>&1; then
        echo "Management API is ready."
        break
    fi
    if [ "$i" -eq "$MAX_RETRIES" ]; then
        echo "ERROR: Management API not ready after $((MAX_RETRIES * 2))s. Exiting."
        # Print the actual curl error for debugging
        echo "--- Debug: curl output ---"
        curl -k -v -u "${RABBITMQ_DEFAULT_USER}:${RABBITMQ_DEFAULT_PASS}" "${BASE_URL}/overview" 2>&1 || true
        echo "--- End debug ---"
        exit 1
    fi
    sleep 2
done

# --- Create backend vhost ---
echo "Creating vhost: ${RABBITMQ_BACKEND_VHOST}..."
curl ${CURL_OPTS} -X PUT \
    -H "Content-Type: application/json" \
    -d '{"description": "Backend application vhost", "tags": "backend"}' \
    "${BASE_URL}/vhosts/${RABBITMQ_BACKEND_VHOST}"
echo " ✔ Vhost '${RABBITMQ_BACKEND_VHOST}' created."

# --- Create backend user ---
echo "Creating user: ${RABBITMQ_BACKEND_USER}..."
curl ${CURL_OPTS} -X PUT \
    -H "Content-Type: application/json" \
    -d "{\"password\": \"${RABBITMQ_BACKEND_PASS}\", \"tags\": \"management\"}" \
    "${BASE_URL}/users/${RABBITMQ_BACKEND_USER}"
echo " ✔ User '${RABBITMQ_BACKEND_USER}' created with 'management' tag."

# --- Set backend user permissions on backend vhost ---
echo "Setting permissions for ${RABBITMQ_BACKEND_USER} on vhost ${RABBITMQ_BACKEND_VHOST}..."
curl ${CURL_OPTS} -X PUT \
    -H "Content-Type: application/json" \
    -d '{"configure": ".*", "write": ".*", "read": ".*"}' \
    "${BASE_URL}/permissions/${RABBITMQ_BACKEND_VHOST}/${RABBITMQ_BACKEND_USER}"
echo " ✔ Permissions set (configure/write/read: .*)."

echo ""
echo "=== RabbitMQ Init Complete ==="
echo "  Admin:   ${RABBITMQ_DEFAULT_USER} (administrator) on vhost /"
echo "  Backend: ${RABBITMQ_BACKEND_USER} (management) on vhost ${RABBITMQ_BACKEND_VHOST}"
