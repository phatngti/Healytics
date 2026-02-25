import { applyDecorators, ClassSerializerInterceptor, Controller, UseGuards, UseInterceptors } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/common/decorators/auth/roles.decorator';
import { Role } from '@/account/enum/role.enum';

/**
 * Composite decorator for health partner API controllers.
 * Bundles auth guards, HEALTH_PARTNER role, Swagger tags, and route prefix.
 *
 * @example
 * ```ts
 * @PartnerApi('products')
 * export class PartnerProductsController { ... }
 * // Routes: /v1/partner/products/...
 * ```
 */
export function PartnerApi(resource: string) {
  return applyDecorators(
    ApiTags(`Partner ${resource.charAt(0).toUpperCase() + resource.slice(1)}`),
    ApiBearerAuth(),
    Controller({ path: `partner/${resource}`, version: '1' }),
    UseGuards(JwtAuthGuard, RolesGuard),
    Roles(Role.HEALTH_PARTNER),
    UseInterceptors(ClassSerializerInterceptor),
  );
}
