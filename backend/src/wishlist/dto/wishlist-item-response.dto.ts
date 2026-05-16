import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { UserWishlistItem } from '@/common/entities/user-wishlist-item.entity';

export class WishlistItemResponseDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String })
  productId: string;

  @ApiProperty({ type: String })
  title: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  imageUrl: string | null;

  @ApiProperty({ type: String, example: '799.000đ' })
  price: string;

  @ApiProperty({ type: String, format: 'date-time' })
  createdAt: Date;

  static fromEntity(item: UserWishlistItem): WishlistItemResponseDto {
    const dto = new WishlistItemResponseDto();
    const product = item.product;
    const price = product.salePrice ?? product.basePrice;
    dto.id = item.id;
    dto.productId = item.productId;
    dto.title = product.name;
    dto.imageUrl =
      product.media?.find((m) => m.isThumbnail)?.url ??
      product.media?.[0]?.url ??
      null;
    dto.price = new Intl.NumberFormat('vi-VN').format(Number(price)) + 'đ';
    dto.createdAt = item.createdAt;
    return dto;
  }
}
