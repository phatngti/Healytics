import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ClinicProductCategoryDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String, example: 'Facial Treatments' })
  label: string;
}

export class ClinicProductDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String, example: 'Premium CO2 Laser' })
  title: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  imageUrl: string | null;

  @ApiProperty({ type: String, example: '990.000đ' })
  price: string;

  @ApiProperty({ type: Number, example: 990000 })
  priceAmount: number;

  @ApiPropertyOptional({ type: String, nullable: true, example: '1.250.000đ' })
  originalPrice: string | null;

  @ApiPropertyOptional({ type: String, nullable: true, example: '-20%' })
  discountLabel: string | null;

  @ApiPropertyOptional({ type: String, nullable: true, example: 'HOT' })
  badgeLabel: string | null;

  @ApiPropertyOptional({ type: String, nullable: true, example: '60 min' })
  durationLabel: string | null;

  @ApiPropertyOptional({ type: String, nullable: true, example: 'Specialist' })
  specialistLabel: string | null;

  @ApiProperty({ type: String })
  categoryId: string;

  @ApiProperty({ type: Number, example: 320 })
  soldCount: number;

  @ApiProperty({ type: Number, example: 1743465600000 })
  createdAtMs: number;
}

export class ClinicProductsResponseDto {
  @ApiProperty({ type: [ClinicProductCategoryDto] })
  categories: ClinicProductCategoryDto[];

  @ApiProperty({ type: [ClinicProductDto] })
  products: ClinicProductDto[];

  @ApiProperty({ type: Number, example: 45 })
  totalCount: number;

  @ApiProperty({ type: Boolean, example: true })
  hasMore: boolean;
}
