import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, MaxLength } from 'class-validator';

/**
 * Request DTO for creating a new skill in the catalog.
 */
export class CreateSkillDto {
  @ApiProperty({
    description: 'Display name of the skill',
    example: 'Deep Tissue',
    maxLength: 200,
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(200)
  name: string;
}

/**
 * Response DTO for a skill catalog entry.
 */
export class SkillCatalogResponseDto {
  @ApiProperty({
    description: 'Unique slug identifier',
    example: 'deep_tissue',
  })
  key: string;

  @ApiProperty({
    description: 'Display label',
    example: 'Deep Tissue',
  })
  label: string;
}
