import { IoAdapter } from '@nestjs/platform-socket.io';
import { ServerOptions } from 'socket.io';
import { createAdapter } from '@socket.io/redis-adapter';
import Redis from 'ioredis';
import { Logger } from '@nestjs/common';

/**
 * Custom WebSocket adapter that uses Redis Pub/Sub to synchronize
 * Socket.IO events across multiple server instances.
 *
 * Required for horizontal scaling — without this, events emitted
 * on one instance would not reach clients connected to another.
 */
export class RedisIoAdapter extends IoAdapter {
  private readonly logger = new Logger(RedisIoAdapter.name);
  private adapterConstructor: ReturnType<typeof createAdapter> | null = null;

  /**
   * Initialize Redis Pub/Sub clients for the Socket.IO adapter.
   * Must be called before the server starts.
   */
  async connectToRedis(redisConfig: {
    host: string;
    port: number;
    password?: string;
    username?: string;
    tls?: boolean;
  }): Promise<void> {
    try {
      const baseOptions = {
        host: redisConfig.host,
        port: redisConfig.port,
        password: redisConfig.password,
        username: redisConfig.username,
        ...(redisConfig.tls ? { tls: {} } : {}),
        retryStrategy: (times: number) => {
          if (times > 5) return null;
          return Math.min(times * 1000, 5000);
        },
        lazyConnect: true,
      };

      const pubClient = new Redis(baseOptions);
      const subClient = new Redis(baseOptions);

      pubClient.on('error', (err) =>
        this.logger.error(`Redis adapter PUB error: ${err.message}`),
      );
      subClient.on('error', (err) =>
        this.logger.error(`Redis adapter SUB error: ${err.message}`),
      );

      // Attempt connection — if it fails, fall back to single-instance mode
      await Promise.all([pubClient.connect(), subClient.connect()]);

      this.adapterConstructor = createAdapter(pubClient, subClient);
      this.logger.log(
        `Redis IO Adapter connected to ${redisConfig.host}:${redisConfig.port}`,
      );
    } catch (err) {
      this.logger.error(
        `Redis IO Adapter failed to connect: ${(err as Error).message}. ` +
          `WebSocket will run in single-instance mode.`,
      );
      // adapterConstructor stays null → createIOServer uses default adapter
    }
  }

  createIOServer(port: number, options?: Partial<ServerOptions>): any {
    const server = super.createIOServer(port, options);
    if (this.adapterConstructor) {
      server.adapter(this.adapterConstructor);
    }
    return server;
  }
}
