import {
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { CART_ERROR_CODES } from '@/cart/constants/cart-error-codes';

@Injectable()
export class RemoveCartCouponHandler {
  constructor(
    @InjectRepository(CartItem)
    private readonly cartItemRepository: Repository<CartItem>,
  ) {}

  async execute(userId: string, cartItemId: string): Promise<CartItem> {
    const cartItem = await this.cartItemRepository.findOne({
      where: { id: cartItemId, userId },
    });

    if (!cartItem) {
      throw new NotFoundException({
        code: CART_ERROR_CODES.ITEM_NOT_FOUND,
        message: 'Cart item not found',
      });
    }

    cartItem.couponCode = null;
    cartItem.couponDiscountPercent = null;
    cartItem.couponDiscountAmount = null;

    await this.cartItemRepository.save(cartItem);

    const updated = await this.cartItemRepository.findOne({
      where: { id: cartItem.id, userId },
      relations: ['service', 'service.partner', 'service.media'],
    });

    if (!updated) {
      throw new InternalServerErrorException('Updated cart item was not found');
    }

    return updated;
  }
}
