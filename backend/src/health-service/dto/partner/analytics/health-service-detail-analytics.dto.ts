import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { AnalyticsTrendPointDto } from './analytics-trend-point.dto';
import { AnalyticsReviewBucketDto } from './analytics-review-bucket.dto';
import { AnalyticsOperationalMetricDto } from './analytics-operational-metric.dto';
import { AnalyticsServicePerformanceDto } from './analytics-service-performance.dto';
import { AnalyticsAlertDto } from './analytics-alert.dto';

export class HealthServiceDetailAnalyticsResponseDto {
  @ApiProperty({ type: String, example: 'a1b2c3d4-...' })
  @Expose()
  productId: string;

  // ── KPIs ─────────────────────────────────────────

  @ApiProperty({ type: Number, example: 42 })
  @Expose()
  bookings: number;

  @ApiProperty({ type: Number, example: 5.4 })
  @Expose()
  bookingsDelta: number;

  @ApiProperty({
    type: Number,
    example: 12600000,
    description: 'Revenue in VND',
  })
  @Expose()
  revenue: number;

  @ApiProperty({ type: Number, example: 4.2 })
  @Expose()
  revenueDelta: number;

  @ApiProperty({
    type: Number,
    example: 91.5,
    description: '% of bookings that completed',
  })
  @Expose()
  completionRate: number;

  @ApiProperty({ type: Number, example: 1.1 })
  @Expose()
  completionRateDelta: number;

  @ApiProperty({ type: Number, example: 4.6 })
  @Expose()
  averageRating: number;

  @ApiProperty({ type: Number, example: 38 })
  @Expose()
  reviewCount: number;

  // ── Trend ────────────────────────────────────────

  @ApiProperty({ type: [AnalyticsTrendPointDto] })
  @Expose()
  @Type(() => AnalyticsTrendPointDto)
  trendPoints: AnalyticsTrendPointDto[];

  // ── Review Distribution ──────────────────────────

  @ApiProperty({ type: [AnalyticsReviewBucketDto] })
  @Expose()
  @Type(() => AnalyticsReviewBucketDto)
  reviewDistribution: AnalyticsReviewBucketDto[];

  // ── Operational Readiness ────────────────────────

  @ApiProperty({ type: [AnalyticsOperationalMetricDto] })
  @Expose()
  @Type(() => AnalyticsOperationalMetricDto)
  operationalMetrics: AnalyticsOperationalMetricDto[];

  // ── Peer Ranking ─────────────────────────────────

  @ApiProperty({ type: [AnalyticsServicePerformanceDto] })
  @Expose()
  @Type(() => AnalyticsServicePerformanceDto)
  peerRanking: AnalyticsServicePerformanceDto[];

  // ── Alerts ───────────────────────────────────────

  @ApiProperty({ type: [AnalyticsAlertDto] })
  @Expose()
  @Type(() => AnalyticsAlertDto)
  alerts: AnalyticsAlertDto[];
}
