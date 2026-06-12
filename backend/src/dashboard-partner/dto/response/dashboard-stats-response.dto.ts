import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class DashboardStatsResponseDto {
  // ── Appointment Metrics ────────────────────
  @ApiProperty({ example: 342 })
  @Expose()
  totalAppointments: number;

  @ApiProperty({ example: 285 })
  @Expose()
  completedAppointments: number;

  @ApiProperty({ example: 18 })
  @Expose()
  cancelledAppointments: number;

  @ApiProperty({ example: 39 })
  @Expose()
  pendingAppointments: number;

  // ── Revenue Metrics ────────────────────────
  @ApiProperty({ example: 48750000, description: 'Total revenue in VND' })
  @Expose()
  totalRevenue: number;

  @ApiProperty({
    example: 12.5,
    description: 'Revenue growth % vs previous period',
  })
  @Expose()
  revenueGrowthPercent: number;

  // ── Service Metrics ────────────────────────
  @ApiProperty({ example: 24 })
  @Expose()
  totalServices: number;

  @ApiProperty({ example: 18 })
  @Expose()
  activeServices: number;

  // ── Employee Metrics ───────────────────────
  @ApiProperty({ example: 15 })
  @Expose()
  totalEmployees: number;

  @ApiProperty({ example: 12 })
  @Expose()
  activeEmployees: number;

  // ── Rating Metrics ─────────────────────────
  @ApiProperty({ example: 4.7, description: 'Weighted average rating' })
  @Expose()
  averageRating: number;

  @ApiProperty({ example: 156 })
  @Expose()
  totalReviews: number;
}
