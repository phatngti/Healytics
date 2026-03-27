import { Expose, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ProductFeatureTag } from '@/common/entities/product-feature-tag.entity';

/**
 * Response DTO for service tag data.
 * Controls serialization output via @Expose decorators.
 */
export class ServiceTagResponseDto {
  @Expose()
  @ApiProperty({ example: 'uuid-tag-id' })
  id: string;

  @Expose()
  @ApiProperty({ example: 'uuid-user-id' })
  userId: string;

  @Expose()
  @ApiProperty({ example: 'Premium Service' })
  name: string;

  @Expose()
  @ApiPropertyOptional({ example: 'Tags for premium tier services' })
  description: string | null;

  @Expose()
  @ApiProperty({ example: '#FF6366F1' })
  colorValue: string;

  @Expose()
  @ApiProperty({ example: 5 })
  usage: number;

  @Expose()
  @ApiProperty({ example: true })
  isActive: boolean;

  @Expose()
  @ApiProperty({ example: 0 })
  sortOrder: number;

  @Expose()
  @Type(() => Date)
  @ApiProperty({ example: '2026-01-14T22:45:00.000Z' })
  createdAt: Date;

  @Expose()
  @Type(() => Date)
  @ApiProperty({ example: '2026-01-14T22:45:00.000Z' })
  updatedAt: Date;

  static fromEntity(entity: ProductFeatureTag): ServiceTagResponseDto {
    const dto = new ServiceTagResponseDto();
    dto.id = entity.id;
    dto.userId = entity.userId;
    dto.name = entity.name;
    dto.description = entity.description ?? null;
    dto.colorValue = entity.colorValue;
    dto.usage = entity.usage;
    dto.isActive = entity.isActive;
    dto.sortOrder = entity.sortOrder;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }

  static fromEntities(entities: ProductFeatureTag[]): ServiceTagResponseDto[] {
    return entities.map((e) => this.fromEntity(e));
  }
}
