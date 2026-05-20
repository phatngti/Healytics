import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsUUID,
  IsNotEmpty,
  IsInt,
  Min,
  Max,
  IsOptional,
  IsString,
  MaxLength,
  IsArray,
  ArrayMaxSize,
} from 'class-validator';
import { Transform } from 'class-transformer';

export class CreateFacilityReviewDto {
  @ApiProperty({
    example: '550e8400-e29b-41d4-a716-446655440000',
    description: 'ID of the completed appointment to review',
  })
  @IsUUID()
  @IsNotEmpty()
  appointmentId: string;

  @ApiProperty({
    example: '660e8400-e29b-41d4-a716-556655440000',
    description: 'ID of the clinic or facility being reviewed',
  })
  @IsUUID()
  @IsNotEmpty()
  facilityId: string;

  @ApiProperty({ example: 5, description: 'Rating from 1 to 5' })
  @IsInt()
  @Min(1)
  @Max(5)
  rating: number;

  @ApiPropertyOptional({
    example: 'Clean facility and easy to find.',
    description: 'Free-text comment (max 2000 chars)',
  })
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  @Transform(({ value }) => value?.trim())
  comment?: string;

  @ApiPropertyOptional({
    example: ['Clean', 'Comfortable', 'Easy to Find'],
    description: 'Feedback tags (max 10)',
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  @ArrayMaxSize(10)
  tags?: string[];

  @ApiPropertyOptional({
    example: ['review-photos/1234-photo1.jpg'],
    description:
      'S3 keys of uploaded photos (max 5). Upload via POST /v1/s3/presign first.',
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  @ArrayMaxSize(5)
  photoKeys?: string[];
}
