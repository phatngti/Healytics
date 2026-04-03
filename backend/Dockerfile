# ─────────────────────────────────────────────────────────────
# Stage 1 — Install production dependencies
# ─────────────────────────────────────────────────────────────
FROM node:22-alpine AS deps

WORKDIR /app

# Copy only manifests for maximum layer caching
COPY package.json yarn.lock ./

# Install production deps only (no devDependencies)
RUN yarn install --production --frozen-lockfile \
    && yarn cache clean

# ─────────────────────────────────────────────────────────────
# Stage 2 — Build the TypeScript application
# ─────────────────────────────────────────────────────────────
FROM node:22-alpine AS build

WORKDIR /app

COPY package.json yarn.lock ./

# Install ALL deps (need devDeps for @nestjs/cli, typescript, etc.)
RUN yarn install --frozen-lockfile \
    && yarn cache clean

# Copy source files needed for compilation
COPY tsconfig.json tsconfig.build.json nest-cli.json ./
COPY src/ src/

# Build → produces dist/
RUN yarn build

# ─────────────────────────────────────────────────────────────
# Stage 3 — Production runtime (minimal)
# ─────────────────────────────────────────────────────────────
FROM node:22-alpine AS runtime

# dumb-init: lightweight PID 1 for proper signal forwarding
RUN apk add --no-cache dumb-init

# Non-root for security
USER node
WORKDIR /app

# Production deps from Stage 1 (no devDependencies)
COPY --from=deps --chown=node:node /app/node_modules ./node_modules

# Compiled JS from Stage 2
COPY --from=build --chown=node:node /app/dist ./dist

# Needed at runtime for package metadata
COPY --chown=node:node package.json ./

# Runtime configuration
ENV NODE_ENV=production
EXPOSE 8080

# dumb-init ensures SIGTERM reaches the Node process
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "dist/main"]
