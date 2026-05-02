import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { EmployeeTrendPointDto } from './employee-trend-point.dto';
import { EmployeeMixMetricDto } from './employee-mix-metric.dto';
import { EmployeeScheduleLoadDto } from './employee-schedule-load.dto';
import { EmployeeQualityMetricDto } from './employee-quality-metric.dto';
import { EmployeeComplianceItemDto } from './employee-compliance-item.dto';

export class EmployeeDetailAnalyticsResponseDto {
  @ApiProperty({
    type: String,
    example: '8ad71f50-2f44-4c12-a57d-b1c4c92f5a7d',
  })
  @Expose()
  employeeId: string;

  // ── Session KPIs ─────────────────────────────────

  @ApiProperty({ type: Number, example: 26 })
  @Expose()
  completedSessions: number;

  @ApiProperty({
    type: Number,
    example: 8.3,
    description: '% change vs previous period',
  })
  @Expose()
  sessionsDelta: number;

  @ApiProperty({
    type: Number,
    example: 15600000,
    description: 'Contribution value in VND',
  })
  @Expose()
  contributionValue: number;

  @ApiProperty({ type: Number, example: 10.1 })
  @Expose()
  contributionDelta: number;

  // ── Utilization KPIs ─────────────────────────────

  @ApiProperty({ type: Number, example: 77.4 })
  @Expose()
  utilizationRate: number;

  @ApiProperty({ type: Number, example: 4.8 })
  @Expose()
  utilizationDelta: number;

  // ── Rating KPIs ──────────────────────────────────

  @ApiProperty({ type: Number, example: 4.8 })
  @Expose()
  averageRating: number;

  @ApiProperty({ type: Number, example: 18 })
  @Expose()
  reviewCount: number;

  // ── Trend ────────────────────────────────────────

  @ApiProperty({ type: [EmployeeTrendPointDto] })
  @Expose()
  @Type(() => EmployeeTrendPointDto)
  trendPoints: EmployeeTrendPointDto[];

  // ── Mix Metrics ──────────────────────────────────

  @ApiProperty({ type: [EmployeeMixMetricDto] })
  @Expose()
  @Type(() => EmployeeMixMetricDto)
  mixMetrics: EmployeeMixMetricDto[];

  // ── Schedule Load ────────────────────────────────

  @ApiProperty({ type: [EmployeeScheduleLoadDto] })
  @Expose()
  @Type(() => EmployeeScheduleLoadDto)
  scheduleLoad: EmployeeScheduleLoadDto[];

  // ── Quality Metrics ──────────────────────────────

  @ApiProperty({ type: [EmployeeQualityMetricDto] })
  @Expose()
  @Type(() => EmployeeQualityMetricDto)
  qualityMetrics: EmployeeQualityMetricDto[];

  // ── Compliance ───────────────────────────────────

  @ApiProperty({ type: [EmployeeComplianceItemDto] })
  @Expose()
  @Type(() => EmployeeComplianceItemDto)
  complianceItems: EmployeeComplianceItemDto[];
}
