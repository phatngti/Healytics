import { Module, Global, Logger } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import Redis from 'ioredis';
import redisConfig from '@/config/redis.config';
import { RedisService, REDIS_CLIENT } from './redis.service';

@Global()
@Module({
  imports: [ConfigModule.forFeature(redisConfig)],
  providers: [
    {
      provide: REDIS_CLIENT,
      useFactory: (configService: ConfigService) => {
        const logger = new Logger('RedisModule');
        const cfg = configService.get('redis') as {
          host: string;
          port: number;
          password?: string;
          username?: string;
        };

        const isLocal =
          cfg.host === 'localhost' || cfg.host === '127.0.0.1';

        const client = new Redis({
          host: cfg.host,
          port: cfg.port,
          password: cfg.password,
          username: cfg.username,
          ...(isLocal ? {} : { tls: {} }),
          retryStrategy: (times) => {
            if (times > 5) {
              logger.error(
                'Redis: max retries reached, giving up. App will work without Redis.',
              );
              return null; // stop retrying
            }
            const delay = Math.min(times * 1000, 5000);
            logger.warn(`Redis: reconnecting in ${delay}ms (attempt ${times})`);
            return delay;
          },
          maxRetriesPerRequest: 1,
          enableOfflineQueue: false,
          lazyConnect: true,
        });

        client.on('connect', () => logger.log('Redis connected'));
        client.on('error', (err) => logger.error(`Redis error: ${err.message}`));
        client.on('close', () => logger.warn('Redis connection closed'));

        // Connect eagerly but don't crash the app if Redis is unavailable
        client.connect().catch((err) => {
          logger.error(`Redis initial connection failed: ${err.message}`);
        });

        return client;
      },
      inject: [ConfigService],
    },
    RedisService,
  ],
  exports: [REDIS_CLIENT, RedisService],
})
export class RedisModule {}
