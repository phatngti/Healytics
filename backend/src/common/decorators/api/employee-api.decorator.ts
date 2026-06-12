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
import { Role } from '@/account/enum/role.enum';

/**
 * Composite decorator for employee API controllers.
 * Bundles auth guards, EMPLOYEE role, Swagger tags, and route prefix.
 *
 * @example
 * ```ts
 * @EmployeeApi('appointments')
 * export class EmployeeAppointmentsController { ... }
 * // Routes: /v1/employee/appointments/...
 * ```
 */
export function EmployeeApi(resource: string) {
  return applyDecorators(
    ApiTags(`Employee ${resource.charAt(0).toUpperCase() + resource.slice(1)}`),
    ApiBearerAuth(),
    Controller({ path: `employee/${resource}`, version: '1' }),
    UseGuards(JwtAuthGuard, RolesGuard),
    Roles(Role.EMPLOYEE),
    UseInterceptors(ClassSerializerInterceptor),
  );
}
