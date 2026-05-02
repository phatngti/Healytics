import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { EmployeeTrendPointDto } from './employee-trend-point.dto';
import { EmployeeRoleDistributionDto } from './employee-role-distribution.dto';
import { EmployeePerformanceSummaryDto } from './employee-performance-summary.dto';
import { EmployeeComplianceItemDto } from './employee-compliance-item.dto';

export class EmployeeOverviewAnalyticsResponseDto {
  // ── Roster KPIs ──────────────────────────────────

  @ApiProperty({ type: Number, example: 12 })
  @Expose()
  totalEmployees: number;

  @ApiProperty({ type: Number, example: 10 })
  @Expose()
  activeEmployees: number;

  @ApiProperty({ type: Number, example: 1 })
  @Expose()
  onLeaveEmployees: number;

  @ApiProperty({ type: Number, example: 1 })
  @Expose()
  inactiveEmployees: number;

  // ── Utilization KPIs ─────────────────────────────

  @ApiProperty({
    type: Number,
    example: 74.5,
    description: 'Aggregate utilization rate percentage',
  })
  @Expose()
  utilizationRate: number;

  @ApiProperty({
    type: Number,
    example: 6.2,
    description: '% change vs previous period',
  })
  @Expose()
  utilizationDelta: number;

  // ── Rating KPIs ──────────────────────────────────

  @ApiProperty({ type: Number, example: 4.7 })
  @Expose()
  averageRating: number;

  @ApiProperty({ type: Number, example: 1.4 })
  @Expose()
  ratingDelta: number;

  @ApiProperty({ type: Number, example: 86 })
  @Expose()
  reviewCount: number;

  // ── Trend ────────────────────────────────────────

  @ApiProperty({ type: [EmployeeTrendPointDto] })
  @Expose()
  @Type(() => EmployeeTrendPointDto)
  trendPoints: EmployeeTrendPointDto[];

  // ── Role Distribution ────────────────────────────

  @ApiProperty({ type: [EmployeeRoleDistributionDto] })
  @Expose()
  @Type(() => EmployeeRoleDistributionDto)
  roleDistribution: EmployeeRoleDistributionDto[];

  // ── Top Performers ───────────────────────────────

  @ApiProperty({ type: [EmployeePerformanceSummaryDto] })
  @Expose()
  @Type(() => EmployeePerformanceSummaryDto)
  topPerformers: EmployeePerformanceSummaryDto[];

  // ── Compliance ───────────────────────────────────

  @ApiProperty({ type: [EmployeeComplianceItemDto] })
  @Expose()
  @Type(() => EmployeeComplianceItemDto)
  complianceItems: EmployeeComplianceItemDto[];
}
