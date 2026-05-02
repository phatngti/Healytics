import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, TransformFnParams } from 'class-transformer';
import {
  IsString,
  IsNotEmpty,
  MaxLength,
  IsOptional,
  Matches,
} from 'class-validator';

/**
 * Input DTO for admin-created system-wide broadcasts.
 */
const trimString = ({ value }: TransformFnParams): unknown => {
  const input: unknown = value;
  return typeof input === 'string' ? input.trim() : input;
};

export class CreateBroadcastDto {
  @ApiProperty({
    description: 'Broadcast title',
    example: 'System Maintenance Notice',
    maxLength: 255,
  })
  @IsString()
  @Transform(trimString)
  @IsNotEmpty()
  @Matches(/\S/, {
    message: 'title must contain at least one non-whitespace character',
  })
  @MaxLength(255)
  title: string;

  @ApiProperty({
    description: 'Broadcast body text',
    example:
      'The platform will undergo scheduled maintenance on April 5th from 2:00 AM to 4:00 AM.',
    maxLength: 5000,
  })
  @IsString()
  @Transform(trimString)
  @IsNotEmpty()
  @Matches(/\S/, {
    message: 'body must contain at least one non-whitespace character',
  })
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
