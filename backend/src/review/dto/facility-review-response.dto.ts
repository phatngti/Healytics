import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { FacilityReview } from '@/common/entities/facility-review.entity';

export class FacilityReviewResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  id: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  appointmentId: string;

  @ApiProperty({ example: '660e8400-e29b-41d4-a716-556655440000' })
  @Expose()
  facilityId: string;

  @ApiProperty({ example: 5 })
  @Expose()
  rating: number;

  @ApiPropertyOptional({ example: 'Clean facility and easy to find.' })
  @Expose()
  comment: string | null;

  @ApiProperty({ example: ['Clean', 'Comfortable', 'Easy to Find'] })
  @Expose()
  tags: string[];

  @ApiProperty({
    example: ['https://cdn.healytics.com/reviews/photo1.jpg'],
  })
  @Expose()
  photoUrls: string[];

  @ApiProperty({ example: '2026-03-29T13:02:00.000Z' })
  @Expose()
  createdAt: Date;

  static fromEntity(entity: FacilityReview): FacilityReviewResponseDto {
    const dto = new FacilityReviewResponseDto();
    dto.id = entity.id;
    dto.appointmentId = entity.appointmentId;
    dto.facilityId = entity.facilityId;
    dto.rating = entity.rating;
    dto.comment = entity.comment;
    dto.tags = entity.tags ?? [];
    dto.photoUrls = entity.photoUrls ?? [];
    dto.createdAt = entity.createdAt;
    return dto;
  }
}
