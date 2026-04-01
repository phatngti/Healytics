import { IsOptional, IsString, IsUUID } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

/**
 * Query DTO for filtering audit logs.
 * Replaces inline @ApiQuery decorators on the controller.
 */
export class GetAuditLogsQueryDto {
  @ApiPropertyOptional({ description: 'Filter by Target ID' })
  @IsOptional()
  @IsUUID()
  targetId?: string;

  @ApiPropertyOptional({ description: 'Filter by Actor ID' })
  @IsOptional()
  @IsUUID()
  actorId?: string;

  @ApiPropertyOptional({
    description: 'Filter by Action type',
    example: 'PARTNER_REVIEW',
  })
  @IsOptional()
  @IsString()
  action?: string;
}
