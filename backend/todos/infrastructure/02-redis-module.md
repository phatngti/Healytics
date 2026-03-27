# 02 — Redis Module

**Status:** ✅ COMPLETED

## Context

Redis provides distributed locking for the booking system's anti-race-condition strategy. The module wraps `ioredis` with lock/unlock helpers.

## Prerequisites

- ✅ Redis server provisioned
- ✅ `ioredis` package installed
- ✅ Env vars: `REDIS_HOST`, `REDIS_PORT`, `REDIS_PASSWORD`

## Tasks

### 1. Create `src/redis/redis.module.ts`
```typescript
@Global()
@Module({
  providers: [
    {
      provide: 'REDIS_CLIENT',
      useFactory: () => new Redis({ host, port, password }),
    },
    RedisService,
  ],
  exports: ['REDIS_CLIENT', RedisService],
})
```
Global module — available to all other modules without explicit import.

### 2. Create `src/redis/redis.service.ts`
Methods:
- `acquireLock(key, ttlSeconds)` — SET NX with expiry, returns token or null
- `releaseLock(key, token)` — Lua script for atomic check-and-delete
- `getLockTTL(key)` — returns remaining TTL for a key
- `get(key)`, `set(key, value, ttl)`, `del(key)` — basic operations

## Completed

Global Redis module with lock helpers. Atomic lock release via Lua script. Used by booking module for micro-locks (120s) and checkout locks (600s).
