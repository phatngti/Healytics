import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsBoolean, IsOptional, IsString, MaxLength } from 'class-validator';

export class FlagReviewDto {
  @ApiProperty({ type: Boolean, example: true, description: 'Whether to flag the transaction for review' })
  @IsBoolean()
  flaggedForReview: boolean;

  @ApiPropertyOptional({ type: String, description: 'Audit note', example: 'Partner requested finance review.' })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  note?: string;
}
