import { Logger } from '@nestjs/common';
import { ThrottlerStorage } from '@nestjs/throttler';
import Redis from 'ioredis';

/** Shape returned by ThrottlerStorage.increment() — not exported by @nestjs/throttler */
interface ThrottlerStorageRecord {
  totalHits: number;
  timeToExpire: number;
  isBlocked: boolean;
  timeToBlockExpire: number;
}

/**
 * Redis-backed storage for @nestjs/throttler.
 *
 * Replaces the default in-memory storage so that rate-limit counters
 * are shared across all server instances and survive restarts.
 *
 * Key format:  throttle:{throttlerName}:{tracker}
 * Each key is a simple counter with a TTL matching the throttle window.
 */
export class ThrottlerRedisStorage implements ThrottlerStorage {
  private readonly logger = new Logger(ThrottlerRedisStorage.name);

  constructor(private readonly redis: Redis) {}

  /**
   * Atomically increment the hit counter for `key`.
   *
   * Uses a Lua script for atomicity:
   *  - INCR the key
   *  - If it's the first hit (value == 1), set PEXPIRE to `ttl` ms
   *  - Return [totalHits, PTTL]
   */
  async increment(
    key: string,
    ttl: number,
    limit: number,
    blockDuration: number,
    throttlerName: string,
  ): Promise<ThrottlerStorageRecord> {
    try {
      return await this._doIncrement(
        key,
        ttl,
        limit,
        blockDuration,
        throttlerName,
      );
    } catch (err) {
      // Graceful degradation: if Redis is down, allow the request through
      // instead of crashing with a 500. Rate limiting is temporarily disabled.
      this.logger.warn(
        `Redis unavailable — rate limiting bypassed: ${(err as Error).message}`,
      );
      return {
        totalHits: 0,
        timeToExpire: ttl,
        isBlocked: false,
        timeToBlockExpire: 0,
      };
    }
  }

  /** Internal increment logic — separated so the public method can wrap it with error handling. */
  private async _doIncrement(
    key: string,
    ttl: number,
    limit: number,
    blockDuration: number,
    throttlerName: string,
  ): Promise<ThrottlerStorageRecord> {
    const redisKey = `throttle:${throttlerName}:${key}`;
    const blockedKey = `${redisKey}:blocked`;

    // Check if currently blocked
    const blockedTtl = await this.redis.pttl(blockedKey);
    if (blockedTtl > 0) {
      return {
        totalHits: limit + 1,
        timeToExpire: await this.safeGetPttl(redisKey, ttl),
        isBlocked: true,
        timeToBlockExpire: blockedTtl,
      };
    }

    // Lua script: INCR + conditional PEXPIRE (atomic)
    const luaScript = `
      local current = redis.call('INCR', KEYS[1])
      if current == 1 then
        redis.call('PEXPIRE', KEYS[1], ARGV[1])
      end
      local pttl = redis.call('PTTL', KEYS[1])
      return {current, pttl}
    `;

    const [totalHits, timeToExpire] = (await this.redis.eval(
      luaScript,
      1,
      redisKey,
      ttl,
    )) as [number, number];

    // If limit exceeded, set a block key
    const isBlocked = totalHits > limit;
    let timeToBlockExpire = 0;

    if (isBlocked) {
      await this.redis.set(blockedKey, '1', 'PX', blockDuration);
      timeToBlockExpire = blockDuration;
      this.logger.warn(
        `Rate limit exceeded for key "${redisKey}" — blocked for ${blockDuration}ms`,
      );
    }

    return {
      totalHits,
      timeToExpire: Math.max(timeToExpire, 0),
      isBlocked,
      timeToBlockExpire,
    };
  }

  /** Safely get PTTL, returning the default TTL if the key doesn't exist. */
  private async safeGetPttl(key: string, defaultTtl: number): Promise<number> {
    const pttl = await this.redis.pttl(key);
    return pttl > 0 ? pttl : defaultTtl;
  }
}

