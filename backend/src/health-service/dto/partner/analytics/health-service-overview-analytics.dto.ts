import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { AnalyticsBookingMetricsDto } from './analytics-booking-metrics.dto';
import { AnalyticsTrendPointDto } from './analytics-trend-point.dto';
import { AnalyticsCategoryPerformanceDto } from './analytics-category-performance.dto';
import { AnalyticsServicePerformanceDto } from './analytics-service-performance.dto';

export class HealthServiceOverviewAnalyticsResponseDto {
  // ── Catalog KPIs ─────────────────────────────────

  @ApiProperty({ type: Number, example: 12 })
  @Expose()
  totalProducts: number;

  @ApiProperty({ type: Number, example: 8 })
  @Expose()
  activeProducts: number;

  // ── Booking KPIs ─────────────────────────────────

  @ApiProperty({
    type: Number,
    example: 142,
    description: 'Completed bookings in the selected period',
  })
  @Expose()
  bookings: number;

  @ApiProperty({
    type: Number,
    example: 6.2,
    description: '% change vs previous period',
  })
  @Expose()
  bookingsDelta: number;

  @ApiProperty({
    type: Number,
    example: 42500000,
    description: 'Revenue in VND',
  })
  @Expose()
  revenue: number;

  @ApiProperty({ type: Number, example: 4.8 })
  @Expose()
  revenueDelta: number;

  @ApiProperty({ type: Number, example: 4.5 })
  @Expose()
  averageRating: number;

  @ApiProperty({ type: Number, example: 1.3 })
  @Expose()
  ratingDelta: number;

  @ApiProperty({ type: Number, example: 89 })
  @Expose()
  reviewCount: number;

  // ── Booking Operations ───────────────────────────

  @ApiProperty({ type: AnalyticsBookingMetricsDto })
  @Expose()
  @Type(() => AnalyticsBookingMetricsDto)
  bookingMetrics: AnalyticsBookingMetricsDto;

  // ── Trend ────────────────────────────────────────

  @ApiProperty({ type: [AnalyticsTrendPointDto] })
  @Expose()
  @Type(() => AnalyticsTrendPointDto)
  trendPoints: AnalyticsTrendPointDto[];

  // ── Category Performance ─────────────────────────

  @ApiProperty({ type: [AnalyticsCategoryPerformanceDto] })
  @Expose()
  @Type(() => AnalyticsCategoryPerformanceDto)
  categoryPerformance: AnalyticsCategoryPerformanceDto[];

  // ── Top Services ─────────────────────────────────

  @ApiProperty({ type: [AnalyticsServicePerformanceDto] })
  @Expose()
  @Type(() => AnalyticsServicePerformanceDto)
  topServices: AnalyticsServicePerformanceDto[];
}
