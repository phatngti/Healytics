# syntax=docker/dockerfile:1.7
################################################################################
# Stage 1 — Build the Flutter web app
################################################################################
FROM --platform=$BUILDPLATFORM debian:bookworm-slim AS build

ARG FLUTTER_VERSION=3.35.5
ARG APT_MIRROR=http://ftp.sg.debian.org/debian
ARG APT_SECURITY_MIRROR=http://security.debian.org/debian-security

ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_HOME=/opt/flutter
ENV PUB_CACHE=/home/flutter/.pub-cache
ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PATH}"

RUN sed -i \
      -e "s|http://deb.debian.org/debian|${APT_MIRROR}|g" \
      -e "s|http://deb.debian.org/debian-security|${APT_SECURITY_MIRROR}|g" \
      /etc/apt/sources.list.d/debian.sources \
    && apt-get update && apt-get install -y --no-install-recommends \
      bash \
      ca-certificates \
      curl \
      file \
      git \
      unzip \
      xz-utils \
      zip \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch "${FLUTTER_VERSION}" https://github.com/flutter/flutter.git "${FLUTTER_HOME}" \
    && git config --global --add safe.directory "${FLUTTER_HOME}" \
    && useradd --create-home --shell /bin/bash flutter \
    && chown -R flutter:flutter "${FLUTTER_HOME}" /home/flutter

USER flutter

RUN mkdir -p "${PUB_CACHE}" \
    && flutter config --no-analytics --enable-web \
    && flutter precache --web

# Build arguments
ARG ENV=prod
ARG BASE_HREF=/

# Set the workspace root so `resolution: workspace` can resolve packages.
WORKDIR /workspace

# 1. Copy workspace-level pubspec (defines the workspace members).
COPY --chown=flutter:flutter pubspec.yaml pubspec.lock ./

# 2. Copy each workspace member's pubspec for dependency resolution.
COPY --chown=flutter:flutter admin_panel/pubspec.yaml admin_panel/pubspec.yaml
COPY --chown=flutter:flutter admin_panel/openapi/pubspec.yaml admin_panel/openapi/pubspec.yaml
COPY --chown=flutter:flutter common/pubspec.yaml       common/pubspec.yaml
COPY --chown=flutter:flutter user_app/pubspec.yaml     user_app/pubspec.yaml
COPY --chown=flutter:flutter user_app/openapi/pubspec.yaml user_app/openapi/pubspec.yaml
COPY --chown=flutter:flutter employee_app/pubspec.yaml employee_app/pubspec.yaml
COPY --chown=flutter:flutter employee_app/openapi/pubspec.yaml employee_app/openapi/pubspec.yaml

# 3. Resolve dependencies once (layer cache: rebuilds only if pubspecs change).
RUN --mount=type=cache,target=/home/flutter/.pub-cache,uid=1000,gid=1000 \
    flutter pub get --directory=admin_panel

# 4. Copy the full source trees (common first — admin_panel depends on it).
COPY --chown=flutter:flutter common/ common/
COPY --chown=flutter:flutter admin_panel/ admin_panel/

# 5. Re-resolve deps (source COPY can invalidate .dart_tool state) + code gen.
RUN --mount=type=cache,target=/home/flutter/.pub-cache,uid=1000,gid=1000 \
    flutter pub get --directory=admin_panel \
    && cd admin_panel \
    && dart run build_runner build --delete-conflicting-outputs

# 6. Build the optimised web bundle.
RUN --mount=type=cache,target=/home/flutter/.pub-cache,uid=1000,gid=1000 \
    cd admin_panel && flutter build web \
      --release \
      --dart-define=ENV=${ENV} \
      --base-href="${BASE_HREF}"

################################################################################
# Stage 2 — Serve with Nginx
################################################################################
FROM --platform=$TARGETPLATFORM nginx:1.27-alpine AS runtime

# Remove default site
RUN rm -rf /usr/share/nginx/html/*

# Copy Flutter web build output
COPY --from=build /workspace/admin_panel/build/web /usr/share/nginx/html

# Custom Nginx config: SPA fallback, gzip, caching
COPY admin_panel/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost/index.html || exit 1

CMD ["nginx", "-g", "daemon off;"]
