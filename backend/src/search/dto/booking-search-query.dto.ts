import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, MinLength } from 'class-validator';

export class BookingSearchQueryDto {
  @ApiProperty({
    description: 'Search text. Matches service names and specialist names.',
    minLength: 2,
    example: 'massage',
  })
  @IsString()
  @MinLength(2)
  q: string;

  @ApiPropertyOptional({
    description: 'Maximum results per group. Defaults to 5, max 20.',
    example: 5,
  })
  @IsOptional()
  limit?: string;
}
