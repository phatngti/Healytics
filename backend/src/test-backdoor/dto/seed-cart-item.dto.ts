import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class SeedCartItemDto {
  @ApiPropertyOptional({ type: String, description: 'Unique lookup key' })
  @IsOptional()
  @IsString()
  key?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Key of a previously seeded user',
  })
  @IsOptional()
  @IsString()
  userKey?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Email to look up the user',
  })
  @IsOptional()
  @IsString()
  userEmail?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Key of a previously seeded service',
  })
  @IsOptional()
  @IsString()
  serviceKey?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Slug to look up the service',
  })
  @IsOptional()
  @IsString()
  serviceSlug?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Key of a previously seeded employee',
  })
  @IsOptional()
  @IsString()
  employeeKey?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Email to look up the employee',
  })
  @IsOptional()
  @IsString()
  employeeEmail?: string;

  @ApiProperty({
    type: String,
    example: '2026-06-01T10:00:00Z',
    description: 'ISO 8601 start time',
  })
  @IsString()
  @IsNotEmpty()
  startsAt: string;
}
