FROM postgres:16

# Install PostGIS extension on the native postgres:16 image
# This ensures arm64 compatibility on Apple Silicon
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       postgresql-16-postgis-3 \
       postgresql-16-postgis-3-scripts \
    && rm -rf /var/lib/apt/lists/*
