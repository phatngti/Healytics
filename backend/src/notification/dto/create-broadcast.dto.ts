import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsNotEmpty, MaxLength, IsOptional } from 'class-validator';

/**
 * Input DTO for admin-created system-wide broadcasts.
 */
export class CreateBroadcastDto {
  @ApiProperty({
    description: 'Broadcast title',
    example: 'System Maintenance Notice',
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  title: string;

  @ApiProperty({
    description: 'Broadcast body text',
    example:
      'The platform will undergo scheduled maintenance on April 5th from 2:00 AM to 4:00 AM.',
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(5000)
  body: string;

  @ApiPropertyOptional({
    description: 'Optional deep-link data for frontend routing',
    type: 'object',
    example: { action: 'open_announcements' },
  })
  @IsOptional()
  data?: Record<string, any>;
}
