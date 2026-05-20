import {
  applyDecorators,
  ClassSerializerInterceptor,
  Controller,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Role } from '@/account/enum/role.enum';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/common/decorators/auth/roles.decorator';

export function AdminDashboardApi() {
  return applyDecorators(
    ApiTags('Admin Dashboard'),
    ApiBearerAuth(),
    Controller('admin/dashboard'),
    UseGuards(JwtAuthGuard, RolesGuard),
    Roles(Role.ADMIN),
    UseInterceptors(ClassSerializerInterceptor),
  );
}
