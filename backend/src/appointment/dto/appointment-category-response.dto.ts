import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { Category } from '@/common/entities/category.entity';

export class AppointmentCategoryResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  id: string;

  @ApiProperty({ example: 'Spa & Wellness' })
  @Expose()
  name: string;

  @ApiProperty({ example: 'spa-wellness' })
  @Expose()
  iconSlug: string;

  static fromEntity(category: Category): AppointmentCategoryResponseDto {
    const dto = new AppointmentCategoryResponseDto();
    dto.id = category.id;
    dto.name = category.name;
    dto.iconSlug = category.slug;
    return dto;
  }

  static fromEntities(
    categories: Category[],
  ): AppointmentCategoryResponseDto[] {
    return categories.map((c) => AppointmentCategoryResponseDto.fromEntity(c));
  }
}
