import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { Product } from '@/common/entities/product.entity';

export class RecommendedServiceResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  id: string;

  @ApiProperty({ example: 'Deep Tissue Massage' })
  @Expose()
  name: string;

  @ApiProperty({ example: 'Full body deep tissue massage for relief' })
  @Expose()
  description: string;

  @ApiProperty({ example: 'https://example.com/image.jpg' })
  @Expose()
  imageUrl: string;

  @ApiProperty({ example: '$120.00' })
  @Expose()
  price: string;

  @ApiProperty({ example: '60 min' })
  @Expose()
  duration: string;

  static fromEntity(product: Product): RecommendedServiceResponseDto {
    const dto = new RecommendedServiceResponseDto();
    dto.id = product.id;
    dto.name = product.name;
    dto.description = product.description ?? '';
    dto.imageUrl = product.media?.[0]?.url ?? '';

    // Format price as currency string
    const price = product.salePrice ?? product.basePrice ?? 0;
    dto.price = `$${Number(price).toFixed(2)}`;

    // Duration from product definition
    const durationMinutes = product.productDefinition?.durationMinutes;
    dto.duration = durationMinutes ? `${durationMinutes} min` : '';

    return dto;
  }

  static fromEntities(products: Product[]): RecommendedServiceResponseDto[] {
    return products.map((p) => RecommendedServiceResponseDto.fromEntity(p));
  }
}
