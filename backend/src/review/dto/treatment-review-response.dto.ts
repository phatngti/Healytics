import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';

export class TreatmentReviewResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  id: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  appointmentId: string;

  @ApiProperty({ example: 4 })
  @Expose()
  rating: number;

  @ApiPropertyOptional({ example: 'Great session, very relaxing atmosphere.' })
  @Expose()
  comment: string | null;

  @ApiProperty({ example: ['On-time', 'Relaxing', 'Clean'] })
  @Expose()
  tags: string[];

  @ApiProperty({
    example: ['https://cdn.healytics.com/reviews/photo1.jpg'],
  })
  @Expose()
  photoUrls: string[];

  @ApiProperty({ example: '2026-03-29T13:00:00.000Z' })
  @Expose()
  createdAt: Date;

  /**
   * Factory method — converts TreatmentReview entity → response DTO.
   */
  static fromEntity(entity: TreatmentReview): TreatmentReviewResponseDto {
    const dto = new TreatmentReviewResponseDto();
    dto.id = entity.id;
    dto.appointmentId = entity.appointmentId;
    dto.rating = entity.rating;
    dto.comment = entity.comment;
    dto.tags = entity.tags ?? [];
    dto.photoUrls = entity.photoUrls ?? [];
    dto.createdAt = entity.createdAt;
    return dto;
  }
}
