import { Controller, Get, Query, UseGuards, HttpStatus, HttpCode } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { AuditService } from './audit.service';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/auth/decorators/roles.decorator';
import { Role } from '@/account/enum/role.enum';
import { AuditLog } from './entities/audit-log.entity';

@ApiTags('Audit Logs')
@Controller('audit-logs')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(Role.ADMIN)
@ApiBearerAuth()
export class AuditController {
    constructor(private readonly auditService: AuditService) { }

    @Get()
    @HttpCode(HttpStatus.OK)
    @ApiOperation({ summary: 'Get audit logs' })
    @ApiQuery({ name: 'targetId', required: false, description: 'Filter by Target ID' })
    @ApiQuery({ name: 'actorId', required: false, description: 'Filter by Actor ID' })
    @ApiQuery({ name: 'action', required: false, description: 'Filter by Action type' })
    @ApiResponse({ status: 200, description: 'List of audit logs', type: [AuditLog] })
    async getAuditLogs(
        @Query('targetId') targetId?: string,
        @Query('actorId') actorId?: string,
        @Query('action') action?: string,
    ) {
        return this.auditService.findAll({ targetId, actorId, action });
    }
}
