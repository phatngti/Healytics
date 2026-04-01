import {
  applyDecorators,
  ClassSerializerInterceptor,
  Controller,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/common/decorators/auth/roles.decorator';
import { ADMIN_ROLES } from '@/auth/constants/role-groups';

/**
 * Composite decorator for admin API controllers.
 * Bundles auth guards, ADMIN_ROLES, Swagger tags, and route prefix.
 *
 * @example
 * ```ts
 * @AdminApi('products')
 * export class AdminProductsController { ... }
 * // Routes: /v1/admin/products/...
 * ```
 */
export function AdminApi(resource: string) {
  return applyDecorators(
    ApiTags(`Admin ${resource.charAt(0).toUpperCase() + resource.slice(1)}`),
    ApiBearerAuth(),
    Controller({ path: `admin/${resource}`, version: '1' }),
    UseGuards(JwtAuthGuard, RolesGuard),
    Roles(...ADMIN_ROLES),
    UseInterceptors(ClassSerializerInterceptor),
  );
}
