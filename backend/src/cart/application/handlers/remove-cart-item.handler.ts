import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { CART_ERROR_CODES } from '@/cart/constants/cart-error-codes';

@Injectable()
export class RemoveCartItemHandler {
  constructor(
    @InjectRepository(CartItem)
    private readonly cartItemRepository: Repository<CartItem>,
  ) {}

  async execute(userId: string, cartItemId: string): Promise<void> {
    const result = await this.cartItemRepository.delete({
      id: cartItemId,
      userId,
    });

    if (!result.affected) {
      throw new NotFoundException({
        code: CART_ERROR_CODES.ITEM_NOT_FOUND,
        message: 'Cart item not found',
      });
    }
  }
}
