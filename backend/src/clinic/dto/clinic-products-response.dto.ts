import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ClinicProductCategoryDto {
  @ApiProperty({ example: 'a1b2c3d4-...' })
  id: string;

  @ApiProperty({ example: 'Massage Therapy' })
  label: string;
}

export class ClinicProductDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ example: 'Premium CO2 Laser' })
  title: string;

  @ApiPropertyOptional()
  imageUrl: string | null;

  @ApiProperty({ example: '990.000đ' })
  price: string;

  @ApiProperty({ example: 990000 })
  priceAmount: number;

  @ApiPropertyOptional({ example: '1.250.000đ' })
  originalPrice: string | null;

  @ApiPropertyOptional({ example: '-20%' })
  discountLabel: string | null;

  @ApiPropertyOptional({ example: 'HOT' })
  badgeLabel: string | null;

  @ApiPropertyOptional({ example: '60 min' })
  durationLabel: string | null;

  @ApiPropertyOptional({ example: 'Specialist' })
  specialistLabel: string | null;

  @ApiProperty()
  categoryId: string;

  @ApiProperty({ example: 320 })
  soldCount: number;

  @ApiProperty({ example: 1743465600000 })
  createdAtMs: number;
}

export class ClinicProductsResponseDto {
  @ApiProperty({ type: [ClinicProductCategoryDto] })
  categories: ClinicProductCategoryDto[];

  @ApiProperty({ type: [ClinicProductDto] })
  products: ClinicProductDto[];

  @ApiProperty({ example: 45 })
  totalCount: number;

  @ApiProperty({ example: true })
  hasMore: boolean;
}
