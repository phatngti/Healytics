import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Product } from '@/common/entities/product.entity';
import { UserWishlistItem } from '@/common/entities/user-wishlist-item.entity';
import { WishlistItemResponseDto } from './dto/wishlist-item-response.dto';

@Injectable()
export class WishlistService {
  constructor(
    @InjectRepository(UserWishlistItem)
    private readonly wishlistRepo: Repository<UserWishlistItem>,
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,
  ) {}

  async list(userId: string): Promise<WishlistItemResponseDto[]> {
    const items = await this.wishlistRepo.find({
      where: { userId },
      relations: ['product', 'product.media'],
      order: { createdAt: 'DESC' },
    });
    return items.map(WishlistItemResponseDto.fromEntity);
  }

  async add(
    userId: string,
    productId: string,
  ): Promise<WishlistItemResponseDto> {
    const product = await this.productRepo.findOne({
      where: { id: productId },
      relations: ['media'],
    });
    if (!product) {
      throw new NotFoundException(`Product with ID ${productId} not found`);
    }

    let item = await this.wishlistRepo.findOne({
      where: { userId, productId },
      relations: ['product', 'product.media'],
    });
    if (!item) {
      item = await this.wishlistRepo.save(
        this.wishlistRepo.create({ userId, productId }),
      );
      item.product = product;
    }
    return WishlistItemResponseDto.fromEntity(item);
  }

  async remove(userId: string, productId: string): Promise<void> {
    await this.wishlistRepo.delete({ userId, productId });
  }
}
