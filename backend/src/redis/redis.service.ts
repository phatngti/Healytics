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
