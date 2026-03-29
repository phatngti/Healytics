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
  IsBoolean,
} from 'class-validator';
import { Transform } from 'class-transformer';

export class CreateSpecialistReviewDto {
  @ApiProperty({
    example: '550e8400-e29b-41d4-a716-446655440000',
    description: 'ID of the completed appointment',
  })
  @IsUUID()
  @IsNotEmpty()
  appointmentId: string;

  @ApiProperty({
    example: '660e8400-e29b-41d4-a716-556655440000',
    description: 'ID of the specialist/employee who performed the service',
  })
  @IsUUID()
  @IsNotEmpty()
  specialistId: string;

  @ApiProperty({ example: 5, description: 'Rating from 1 to 5' })
  @IsInt()
  @Min(1)
  @Max(5)
  rating: number;

  @ApiPropertyOptional({
    example: 'Very attentive and professional throughout.',
    description: 'Free-text comment (max 2000 chars)',
  })
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  @Transform(({ value }) => value?.trim())
  comment?: string;

  @ApiPropertyOptional({
    example: ['Professional', 'Attentive'],
    description: 'Feedback tags (max 10)',
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  @ArrayMaxSize(10)
  tags?: string[];

  @ApiProperty({
    example: true,
    description: 'Whether the user would recommend this specialist',
  })
  @IsBoolean()
  wouldRecommend: boolean;
}
