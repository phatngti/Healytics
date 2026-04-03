import { Expose } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Location } from '@/common/entities/location.entity';

/**
 * Response DTO for a single location entity.
 * Used for provinces, districts, and wards.
 */
export class LocationResponseDto {
  @Expose()
  @ApiProperty({ example: 'uuid-string', description: 'Location UUID' })
  id: string;

  @Expose()
  @ApiProperty({ example: '01', description: 'Official administrative code' })
  code: string;

  @Expose()
  @ApiProperty({ example: 'Hà Nội', description: 'Location name' })
  name: string;

  @Expose()
  @ApiPropertyOptional({ example: 'Ha Noi', description: 'English name' })
  nameEn?: string;

  @Expose()
  @ApiProperty({
    example: 'Thành phố Hà Nội',
    description: 'Full name with prefix',
  })
  fullName: string;

  @Expose()
  @ApiPropertyOptional({
    example: 'Hanoi City',
    description: 'Full English name',
  })
  fullNameEn?: string;

  @Expose()
  @ApiProperty({ example: 'PROVINCE', description: 'Administrative level' })
  level: string;

  static fromEntity(entity: Location): LocationResponseDto {
    const dto = new LocationResponseDto();
    dto.id = entity.id;
    dto.code = entity.code;
    dto.name = entity.name;
    dto.nameEn = entity.nameEn;
    dto.fullName = entity.fullName;
    dto.fullNameEn = entity.fullNameEn;
    dto.level = entity.level;
    return dto;
  }

  static fromEntities(entities: Location[]): LocationResponseDto[] {
    return entities.map((e) => this.fromEntity(e));
  }
}

/**
 * Response DTO for location list endpoints.
 * Wraps an array of LocationResponseDto with total count.
 */
export class LocationListResponseDto {
  @Expose()
  @ApiProperty({
    type: [LocationResponseDto],
    description: 'List of locations',
  })
  data: LocationResponseDto[];

  @Expose()
  @ApiProperty({ example: 63, description: 'Total number of locations' })
  total: number;

  static create(entities: Location[]): LocationListResponseDto {
    const dto = new LocationListResponseDto();
    dto.data = LocationResponseDto.fromEntities(entities);
    dto.total = entities.length;
    return dto;
  }
}
