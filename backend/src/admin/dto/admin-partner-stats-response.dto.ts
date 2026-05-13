import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

/**
 * KPI card values for the admin partner manager
 * dashboard.
 */
export class AdminPartnerStatsResponseDto {
  @ApiProperty({
    example: 12,
    description: 'Partners awaiting admin review',
  })
  @Expose()
  pendingReview: number;

  @ApiProperty({
    example: 3,
    description: 'Review-queue partners with HIGH or URGENT priority',
  })
  @Expose()
  highPriority: number;

  @ApiProperty({
    example: 42,
    description: 'Approved providers (active today v1)',
  })
  @Expose()
  activeToday: number;

  @ApiProperty({
    example: 15120,
    description: 'Average wait time in seconds',
  })
  @Expose()
  avgWaitSeconds: number;

  @ApiProperty({
    example: '4h 12m',
    description: 'Formatted average wait time',
  })
  @Expose()
  avgWaitTime: string;

  @ApiProperty({
    example: 150,
    description: 'Total providers across all statuses',
  })
  @Expose()
  totalProviders: number;

  @ApiProperty({
    example: 5,
    description: 'Partners in REQUIRED_RESUBMIT status',
  })
  @Expose()
  requiredResubmit: number;

  @ApiProperty({
    example: 100,
    description: 'Partners with APPROVED status',
  })
  @Expose()
  approved: number;

  @ApiProperty({
    example: 3,
    description: 'Partners with REJECTED status',
  })
  @Expose()
  rejected: number;
}
