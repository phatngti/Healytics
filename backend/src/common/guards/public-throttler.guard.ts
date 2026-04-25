import { Injectable, ExecutionContext } from '@nestjs/common';
import { ThrottlerGuard, ThrottlerException } from '@nestjs/throttler';
import { Reflector } from '@nestjs/core';
import { IS_PUBLIC_KEY } from '@/common/decorators/auth/public.decorator';

/**
 * Custom throttler guard that only applies rate limiting to public routes.
 * Authenticated routes (protected by JWT) are not rate limited since
 * they already have user-based access control.
 *
 * Tracker strategy:
 *  - Login endpoints → `email` from request body (per-account brute-force protection)
 *  - All other public endpoints → IP address (default)
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
   * Produce a tracker key that identifies the throttle subject.
   *
   * For login routes, use the target email so each account gets its own
   * rate-limit bucket — regardless of how many IPs the attacker uses.
   * Falls back to IP for register and other public routes.
   */
  protected async getTracker(req: Record<string, any>): Promise<string> {
    const email = req.body?.email;
    if (email && typeof email === 'string') {
      return `user:${email.toLowerCase().trim()}`;
    }
    return req.ip;
  }

  /**
   * Custom error handler for rate limit exceeded.
   */
  protected throwThrottlingException(): Promise<void> {
    throw new ThrottlerException('Too many requests. Please try again later.');
  }
}
