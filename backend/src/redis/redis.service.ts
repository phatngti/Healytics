import { Injectable, Inject, Logger, OnModuleDestroy } from '@nestjs/common';
import Redis from 'ioredis';
import { randomUUID } from 'crypto';

export const REDIS_CLIENT = 'REDIS_CLIENT';

@Injectable()
export class RedisService implements OnModuleDestroy {
  private readonly logger = new Logger(RedisService.name);

  constructor(@Inject(REDIS_CLIENT) private readonly redis: Redis) {}

  // ── Distributed Lock helpers ────────────────────────────────

  /**
   * Acquire a distributed lock using SETNX + PEXPIRE.
   * Returns a unique token if acquired (use it to release), or null if lock is taken.
   */
  async acquireLock(key: string, ttlSeconds: number): Promise<string | null> {
    const token = randomUUID();
    const result = await this.redis.set(key, token, 'EX', ttlSeconds, 'NX');
    if (result === 'OK') {
      this.logger.debug(`Lock acquired: ${key} (TTL: ${ttlSeconds}s)`);
      return token;
    }
    this.logger.debug(`Lock denied: ${key} (already held)`);
    return null;
  }

  /**
   * Release a lock atomically — only if the token matches (prevents releasing someone else's lock).
   * Uses a Lua script for atomicity.
   */
  async releaseLock(key: string, token: string): Promise<boolean> {
    const script = `
      if redis.call("get", KEYS[1]) == ARGV[1] then
        return redis.call("del", KEYS[1])
      else
        return 0
      end
    `;
    const result = await this.redis.eval(script, 1, key, token);
    const released = result === 1;
    this.logger.debug(`Lock release ${released ? 'OK' : 'SKIPPED'}: ${key}`);
    return released;
  }

  /**
   * Check remaining TTL of a lock key (in seconds). Returns -2 if key doesn't exist.
   */
  async getLockTTL(key: string): Promise<number> {
    return this.redis.ttl(key);
  }

  /**
   * Validate that a lock is still held with the expected token.
   * Returns true if the key exists and its value matches the given token.
   */
  async validateLock(key: string, expectedToken: string): Promise<boolean> {
    const currentValue = await this.redis.get(key);
    const valid = currentValue === expectedToken;
    this.logger.debug(
      `Lock validation ${valid ? 'OK' : 'FAILED'}: ${key} (expected=${expectedToken}, actual=${currentValue ?? 'null'})`,
    );
    return valid;
  }

  // ── Generic Redis operations ────────────────────────────────

  async get(key: string): Promise<string | null> {
    return this.redis.get(key);
  }

  async set(key: string, value: string, ttlSeconds?: number): Promise<void> {
    if (ttlSeconds) {
      await this.redis.set(key, value, 'EX', ttlSeconds);
    } else {
      await this.redis.set(key, value);
    }
  }

  async del(key: string): Promise<number> {
    return this.redis.del(key);
  }

  async delMany(keys: string[]): Promise<number> {
    if (keys.length === 0) {
      return 0;
    }
    return this.redis.del(...keys);
  }

  async scanKeys(match: string, count = 100): Promise<string[]> {
    const keys: string[] = [];
    let cursor = '0';

    do {
      const [nextCursor, batch] = await this.redis.scan(
        cursor,
        'MATCH',
        match,
        'COUNT',
        count,
      );
      cursor = nextCursor;
      keys.push(...batch);
    } while (cursor !== '0');

    return keys;
  }

  async getJson<T>(key: string): Promise<T | null> {
    const value = await this.redis.get(key);
    if (!value) {
      return null;
    }

    try {
      return JSON.parse(value) as T;
    } catch (error) {
      this.logger.warn(
        `Invalid Redis JSON at key "${key}", deleting: ${(error as Error).message}`,
      );
      await this.redis.del(key).catch(() => undefined);
      return null;
    }
  }

  async setJson(
    key: string,
    value: unknown,
    ttlSeconds?: number,
  ): Promise<void> {
    await this.set(key, JSON.stringify(value), ttlSeconds);
  }

  /**
   * Atomically replace a JSON document only when its `hash` field matches.
   * Used for refresh-token rotation so two parallel refreshes cannot both win.
   */
  async compareJsonHashAndSet(
    key: string,
    expectedHash: string,
    nextValue: unknown,
    ttlSeconds: number,
  ): Promise<'ok' | 'missing' | 'mismatch'> {
    const script = `
      local current = redis.call("GET", KEYS[1])
      if not current then
        return -1
      end

      local ok, decoded = pcall(cjson.decode, current)
      if not ok or decoded["hash"] ~= ARGV[1] then
        return 0
      end

      redis.call("SET", KEYS[1], ARGV[2], "EX", ARGV[3])
      return 1
    `;

    const result = await this.redis.eval(
      script,
      1,
      key,
      expectedHash,
      JSON.stringify(nextValue),
      ttlSeconds,
    );

    if (result === 1) {
      return 'ok';
    }
    if (result === -1) {
      return 'missing';
    }
    return 'mismatch';
  }

  // ── Pub/Sub helpers ─────────────────────────────────────────

  /**
   * Publish a message to a Redis channel (Pub/Sub).
   * Returns the number of subscribers that received the message.
   */
  async publish(channel: string, message: string): Promise<number> {
    const receivers = await this.redis.publish(channel, message);
    this.logger.debug(
      `Published to "${channel}" (${receivers} receiver(s)): ${message}`,
    );
    return receivers;
  }

  async onModuleDestroy() {
    this.logger.log('Closing Redis connection...');
    await this.redis.quit();
  }
}
