################################################################################
# Stage 1 — Build the Flutter web app
################################################################################
FROM ghcr.io/cirruslabs/flutter:3.29.3 AS build

# Build arguments
ARG ENV=prod
ARG BASE_HREF=/

# Set the workspace root so `resolution: workspace` can resolve packages.
WORKDIR /workspace

# 1. Copy workspace-level pubspec (defines the workspace members).
COPY pubspec.yaml pubspec.lock ./

# 2. Copy each workspace member's pubspec for dependency resolution.
COPY admin_panel/pubspec.yaml admin_panel/pubspec.yaml
COPY common/pubspec.yaml       common/pubspec.yaml

# 3. Resolve dependencies once (layer cache: rebuilds only if pubspecs change).
RUN flutter pub get --directory=admin_panel

# 4. Copy the full source trees (common first — admin_panel depends on it).
COPY common/ common/
COPY admin_panel/ admin_panel/

# 5. Run code generation (Freezed, Riverpod, GoRouter, Slang, …).
RUN cd admin_panel && dart run build_runner build --delete-conflicting-outputs

# 6. Build the optimised web bundle.
RUN cd admin_panel && flutter build web \
      --release \
      --dart-define=ENV=${ENV} \
      --base-href="${BASE_HREF}"

################################################################################
# Stage 2 — Serve with Nginx
################################################################################
FROM nginx:1.27-alpine AS runtime

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
