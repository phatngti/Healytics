import { applyDecorators, ClassSerializerInterceptor, Controller, UseInterceptors } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Public } from '@/common/decorators/auth/public.decorator';

/**
 * Composite decorator for public API controllers.
 * Bundles Swagger tags, versioned route prefix, serialization, and @Public() at class level.
 * No authentication required — all endpoints are publicly accessible.
 *
 * @example
 * ```ts
 * @PublicApi('categories')
 * export class CategoriesController { ... }
 * // Routes: /v1/categories/...
 * ```
 */
export function PublicApi(resource: string) {
  return applyDecorators(
    ApiTags(resource.charAt(0).toUpperCase() + resource.slice(1)),
    Controller({ path: resource, version: '1' }),
    UseInterceptors(ClassSerializerInterceptor),
    Public(),
  );
}
