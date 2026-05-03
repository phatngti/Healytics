#!/bin/sh
set -e

# Run the make command to generate TLS certificates
make CN=${CN}

cat /app/basic/result/server_${CN}_certificate.pem /app/basic/result/server_${CN}_key.pem > /certs/bind_cert.pem

# Copy the generated files to the mounted directory
cp -R /app/basic/result/* /certs/

# Make all cert/key files world-readable so the rabbitmq user (UID 999)
# inside the RabbitMQ container can read them through the bind mount.
chmod 644 /certs/*.pem /certs/*.p12 2>/dev/null || true

echo "=== TLS certificates generated and permissions fixed ==="
ls -la /certs/

# Keep the container running
exec tail -f /dev/null