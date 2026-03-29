import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsString, ArrayMinSize } from 'class-validator';

/**
 * Request DTO for AI service recommendations endpoint.
 * The AI service sends a list of service IDs to retrieve
 * enriched recommendation data.
 */
export class AiRecommendationsRequestDto {
  @ApiProperty({
    description: 'List of service IDs to retrieve recommendations for',
    example: ['SV002', 'SV005'],
    type: [String],
  })
  @IsArray()
  @IsString({ each: true })
  @ArrayMinSize(1)
  serviceIds: string[];
}
