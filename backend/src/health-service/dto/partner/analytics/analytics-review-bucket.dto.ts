import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class AnalyticsReviewBucketDto {
  @ApiProperty({
    type: Number,
    example: 5,
    description: 'Star rating (1-5)',
  })
  @Expose()
  stars: number;

  @ApiProperty({
    type: Number,
    example: 48,
    description: 'Number of reviews with this rating',
  })
  @Expose()
  count: number;
}
