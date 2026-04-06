import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { CartItem } from '@/cart/entities/cart-item.entity';

export class CartItemResponseDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ format: 'uuid' })
  serviceId: string;

  @ApiProperty({ example: 'Swedish Relax Massage' })
  serviceName: string;

  @ApiProperty({ example: 'https://cdn.example.com/service.jpg' })
  serviceImageUrl: string;

  @ApiProperty({ example: '500.000đ' })
  price: string;

  @ApiProperty({ example: 500000 })
  priceAmount: number;

  @ApiProperty({ format: 'uuid' })
  clinicId: string;

  @ApiProperty({ example: 'Spa An Nhien' })
  clinicName: string;

  @ApiProperty({ example: '123 Dien Bien Phu, Q1, HCM' })
  clinicAddress: string;

  @ApiPropertyOptional({ example: null })
  clinicImageUrl: string | null;

  @ApiPropertyOptional({ nullable: true, example: 'WELCOME10' })
  couponCode: string | null;

  @ApiPropertyOptional({ nullable: true, example: 10 })
  couponDiscountPercent: number | null;

  @ApiPropertyOptional({ nullable: true, example: 50000 })
  couponDiscountAmount: number | null;

  @ApiProperty({ format: 'date-time' })
  createdAt: string;

  static fromEntity(entity: CartItem): CartItemResponseDto {
    const dto = new CartItemResponseDto();
    const service = entity.service;
    const clinic = service?.partner;
    const priceAmount = CartItemResponseDto.resolvePriceAmount(entity);

    dto.id = entity.id;
    dto.serviceId = entity.serviceId;
    dto.serviceName = service?.name ?? '';
    dto.serviceImageUrl = CartItemResponseDto.resolveServiceImageUrl(entity);
    dto.price = CartItemResponseDto.formatVnd(priceAmount);
    dto.priceAmount = priceAmount;
    dto.clinicId = clinic?.id ?? '';
    dto.clinicName = clinic?.brandName ?? '';
    dto.clinicAddress = clinic?.streetAddress ?? '';
    dto.clinicImageUrl = null;
    dto.couponCode = entity.couponCode;
    dto.couponDiscountPercent = entity.couponDiscountPercent;
    dto.couponDiscountAmount = entity.couponDiscountAmount;
    dto.createdAt = entity.createdAt.toISOString();

    return dto;
  }

  static fromEntities(entities: CartItem[]): CartItemResponseDto[] {
    return entities.map((entity) => CartItemResponseDto.fromEntity(entity));
  }

  private static resolvePriceAmount(entity: CartItem): number {
    const raw = entity.service?.salePrice ?? entity.service?.basePrice ?? 0;
    return Number(raw);
  }

  private static resolveServiceImageUrl(entity: CartItem): string {
    const mediaList = entity.service?.media ?? [];
    if (mediaList.length === 0) {
      return '';
    }

    const thumbnail = mediaList.find((media) => media.isThumbnail);
    return (thumbnail ?? mediaList[0]).url;
  }

  private static formatVnd(amount: number): string {
    return `${new Intl.NumberFormat('vi-VN').format(amount)}đ`;
  }
}
