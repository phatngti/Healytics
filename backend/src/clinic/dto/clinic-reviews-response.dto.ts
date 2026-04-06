import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ClinicReviewSummaryDto {
  @ApiProperty({ example: 4.9 })
  averageRating: number;

  @ApiProperty({ example: 2500 })
  totalReviewCount: number;

  @ApiProperty({ example: 'Excellent' })
  ratingLabel: string;

  @ApiProperty({
    example: { 5: 0.92, 4: 0.06, 3: 0.01, 2: 0.005, 1: 0.005 },
  })
  starDistribution: Record<number, number>;
}

export class ClinicReviewFilterDto {
  @ApiProperty({ example: 'all' })
  id: string;

  @ApiProperty({ example: 'All (2.5k)' })
  label: string;

  @ApiPropertyOptional({ example: 5 })
  starCount: number | null;

  @ApiProperty({ example: false })
  requiresMedia: boolean;
}

export class ClinicReviewResponseSubDto {
  @ApiPropertyOptional()
  responseText: string | null;
}

export class ClinicReviewDto {
  @ApiProperty()
  id: string;

  @ApiProperty({
    example: 'n***a',
    description: 'Masked name for privacy',
  })
  reviewerName: string;

  @ApiProperty({ example: 'N' })
  reviewerInitial: string;

  @ApiProperty({ example: 5, minimum: 1, maximum: 5 })
  starCount: number;

  @ApiPropertyOptional({ description: 'null for MVP' })
  memberBadge: string | null;

  @ApiProperty({ example: '04-04-2026' })
  dateLabel: string;

  @ApiPropertyOptional({ example: 'Salt Stone Massage (90 min)' })
  serviceName: string | null;

  @ApiPropertyOptional({ example: 'spa' })
  serviceIcon: string | null;

  @ApiProperty()
  reviewText: string;

  @ApiProperty({ type: [String] })
  mediaUrls: string[];

  @ApiPropertyOptional({ type: ClinicReviewResponseSubDto })
  clinicResponse: ClinicReviewResponseSubDto | null;
}

export class ClinicReviewsResponseDto {
  @ApiProperty({ type: ClinicReviewSummaryDto })
  summary: ClinicReviewSummaryDto;

  @ApiProperty({ type: [ClinicReviewFilterDto] })
  filters: ClinicReviewFilterDto[];

  @ApiProperty({ type: [ClinicReviewDto] })
  reviews: ClinicReviewDto[];

  @ApiProperty({ example: 150 })
  totalCount: number;

  @ApiProperty({ example: true })
  hasMore: boolean;
}
