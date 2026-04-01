import { Get, Query } from '@nestjs/common';
import { ApiOperation, ApiOkResponse } from '@nestjs/swagger';
import { AdminApi } from '@/common/decorators/api/admin-api.decorator';
import { AuditService } from './audit.service';
import { AuditLog } from '@/common/entities/audit-log.entity';
import { GetAuditLogsQueryDto } from './dto/get-audit-logs-query.dto';

/**
 * Admin controller for viewing audit logs.
 * Uses @AdminApi() composite decorator → ADMIN_ROLES, /v1/admin/audit-logs.
 *
 * Security: JwtAuthGuard → RolesGuard → ADMIN_ROLES
 */
@AdminApi('audit-logs')
export class AuditController {
  constructor(private readonly auditService: AuditService) {}

  @Get()
  @ApiOperation({ summary: 'Get audit logs with optional filters' })
  @ApiOkResponse({ description: 'List of audit logs.', type: [AuditLog] })
  async getAuditLogs(
    @Query() query: GetAuditLogsQueryDto,
  ): Promise<AuditLog[]> {
    return this.auditService.findAll(query);
  }
}
