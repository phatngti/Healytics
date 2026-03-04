import { applyDecorators, ClassSerializerInterceptor, Controller, UseGuards, UseInterceptors } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/common/decorators/auth/roles.decorator';
import { Role } from '@/account/enum/role.enum';

/**
 * Composite decorator for user API controllers.
 * Bundles auth guards, USER role, Swagger tags, and route prefix.
 *
 * @example
 * ```ts
 * @UserApi('employees')
 * export class UserEmployeesController { ... }
 * // Routes: /v1/user/employees/...
 * ```
 */
export function UserApi(resource: string) {
  return applyDecorators(
    ApiTags(`User ${resource.charAt(0).toUpperCase() + resource.slice(1)}`),
    ApiBearerAuth(),
    Controller({ path: `user/${resource}`, version: '1' }),
    UseGuards(JwtAuthGuard, RolesGuard),
    Roles(Role.USER),
    UseInterceptors(ClassSerializerInterceptor),
  );
}
