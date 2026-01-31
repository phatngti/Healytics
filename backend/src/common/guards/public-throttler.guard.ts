import { Injectable, ExecutionContext } from '@nestjs/common';
import { ThrottlerGuard, ThrottlerException } from '@nestjs/throttler';
import { Reflector } from '@nestjs/core';
import { IS_PUBLIC_KEY } from '@/common/decorators/auth/public.decorator';

/**
 * Custom throttler guard that only applies rate limiting to public routes.
 * Authenticated routes (protected by JWT) are not rate limited since
 * they already have user-based access control.
 */
@Injectable()
export class PublicThrottlerGuard extends ThrottlerGuard {
  /**
   * Check if the request should be throttled.
   * Only applies rate limiting to routes marked with @Public() decorator.
   */
  async canActivate(context: ExecutionContext): Promise<boolean> {
    const reflector = new Reflector();
    const isPublic = reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    // Only apply rate limiting to public routes
    if (!isPublic) {
      return true;
    }

    return super.canActivate(context);
  }

  /**
   * Custom error handler for rate limit exceeded.
   */
  protected throwThrottlingException(): Promise<void> {
    throw new ThrottlerException('Too many requests. Please try again later.');
  }
}
