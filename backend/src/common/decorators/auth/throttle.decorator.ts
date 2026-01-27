import { SetMetadata } from '@nestjs/common';
import { Throttle, SkipThrottle } from '@nestjs/throttler';

/**
 * Rate limit configuration decorator.
 * Use to override default throttle settings for specific routes.
 *
 * @example
 * // 5 requests per 60 seconds
 * @RateLimit({ default: { limit: 5, ttl: 60000 } })
 */
export { Throttle, SkipThrottle };

/**
 * Metadata key for custom throttle configuration.
 */
export const THROTTLE_LIMIT_KEY = 'throttle:limit';
export const THROTTLE_TTL_KEY = 'throttle:ttl';
