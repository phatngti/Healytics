#!/bin/sh
set -e

# Run the make command
make CN=${CN}

cat /app/basic/result/server_${CN}_certificate.pem /app/basic/result/server_${CN}_key.pem > /certs/bind_cert.pem

# Copy the generated files to the mounted directory
cp -R /app/basic/result/* /certs/

# Keep the container running
exec tail -f /dev/null