import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ClinicReviewSummaryDto {
  @ApiProperty({ type: Number, example: 4.9 })
  averageRating: number;

  @ApiProperty({ type: Number, example: 2500 })
  totalReviewCount: number;

  @ApiProperty({ type: String, example: 'Excellent' })
  ratingLabel: string;

  @ApiProperty({
    example: { 5: 0.92, 4: 0.06, 3: 0.01, 2: 0.005, 1: 0.005 },
  })
  starDistribution: Record<number, number>;
}

export class ClinicReviewFilterDto {
  @ApiProperty({ type: String, example: 'all' })
  id: string;

  @ApiProperty({ type: String, example: 'All (2.5k)' })
  label: string;

  @ApiPropertyOptional({ type: Number, nullable: true, example: 5 })
  starCount: number | null;

  @ApiProperty({ type: Boolean, example: false })
  requiresMedia: boolean;
}

export class ClinicReviewResponseSubDto {
  @ApiPropertyOptional({ type: String, nullable: true })
  responseText: string | null;
}

export class ClinicReviewDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({
    type: String,
    example: 'n***a',
    description: 'Masked name for privacy',
  })
  reviewerName: string;

  @ApiProperty({ type: String, example: 'N' })
  reviewerInitial: string;

  @ApiProperty({ type: Number, example: 5, minimum: 1, maximum: 5 })
  starCount: number;

  @ApiPropertyOptional({ type: String, nullable: true, description: 'null for MVP' })
  memberBadge: string | null;

  @ApiProperty({ type: String, example: '04-04-2026' })
  dateLabel: string;

  @ApiPropertyOptional({ type: String, nullable: true, example: 'Salt Stone Massage (90 min)' })
  serviceName: string | null;

  @ApiPropertyOptional({ type: String, nullable: true, example: 'spa' })
  serviceIcon: string | null;

  @ApiProperty({ type: String })
  reviewText: string;

  @ApiProperty({ type: [String] })
  mediaUrls: string[];

  @ApiPropertyOptional({ type: ClinicReviewResponseSubDto, nullable: true })
  clinicResponse: ClinicReviewResponseSubDto | null;
}

export class ClinicReviewsResponseDto {
  @ApiProperty({ type: ClinicReviewSummaryDto })
  summary: ClinicReviewSummaryDto;

  @ApiProperty({ type: [ClinicReviewFilterDto] })
  filters: ClinicReviewFilterDto[];

  @ApiProperty({ type: [ClinicReviewDto] })
  reviews: ClinicReviewDto[];

  @ApiProperty({ type: Number, example: 150 })
  totalCount: number;

  @ApiProperty({ type: Boolean, example: true })
  hasMore: boolean;
}
