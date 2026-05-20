import {
  applyDecorators,
  ClassSerializerInterceptor,
  Controller,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { ApiTags, ApiSecurity } from '@nestjs/swagger';
import { Public } from '@/common/decorators/auth/public.decorator';
import { AiTokenAuthGuard } from '@/ai-service/guards/ai-token-auth.guard';

/**
 * Composite decorator for AI service API controllers.
 * Bundles AI token guard, Swagger tags, and route prefix.
 *
 * Uses `@Public()` to bypass the global `JwtAuthGuard`, then protects
 * with the `AiTokenAuthGuard` which validates the `X-AI-API-Key` header.
 *
 * @example
 * ```ts
 * @AiApi('recommendations')
 * export class AiServiceController { ... }
 * // Routes: /v1/ai/recommendations/...
 * ```
 */
export function AiApi(resource: string) {
  return applyDecorators(
    ApiTags(`AI ${resource.charAt(0).toUpperCase() + resource.slice(1)}`),
    ApiSecurity('X-AI-API-Key'),
    Controller({ path: `ai/${resource}`, version: '1' }),
    Public(), // Bypass global JwtAuthGuard
    UseGuards(AiTokenAuthGuard), // Validate AI API token
    UseInterceptors(ClassSerializerInterceptor),
  );
}
