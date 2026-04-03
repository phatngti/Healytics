import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { SpecialistReview } from '@/common/entities/specialist-review.entity';

export class SpecialistReviewResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  id: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  appointmentId: string;

  @ApiProperty({ example: '660e8400-e29b-41d4-a716-556655440000' })
  @Expose()
  specialistId: string;

  @ApiProperty({ example: 5 })
  @Expose()
  rating: number;

  @ApiPropertyOptional({
    example: 'Very attentive and professional throughout.',
  })
  @Expose()
  comment: string | null;

  @ApiProperty({ example: ['Professional', 'Attentive'] })
  @Expose()
  tags: string[];

  @ApiProperty({ example: true })
  @Expose()
  wouldRecommend: boolean;

  @ApiProperty({ example: '2026-03-29T13:01:00.000Z' })
  @Expose()
  createdAt: Date;

  /**
   * Factory method — converts SpecialistReview entity → response DTO.
   */
  static fromEntity(entity: SpecialistReview): SpecialistReviewResponseDto {
    const dto = new SpecialistReviewResponseDto();
    dto.id = entity.id;
    dto.appointmentId = entity.appointmentId;
    dto.specialistId = entity.specialistId;
    dto.rating = entity.rating;
    dto.comment = entity.comment;
    dto.tags = entity.tags ?? [];
    dto.wouldRecommend = entity.wouldRecommend;
    dto.createdAt = entity.createdAt;
    return dto;
  }
}
