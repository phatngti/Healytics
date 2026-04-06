import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { AddToCartDto } from '@/cart/dto/add-to-cart.dto';
import { ApplyCouponDto } from '@/cart/dto/apply-coupon.dto';
import { CartItemResponseDto } from '@/cart/dto/cart-item-response.dto';
import { AddCartItemHandler } from '@/cart/application/handlers/add-cart-item.handler';
import { RemoveCartItemHandler } from '@/cart/application/handlers/remove-cart-item.handler';
import { ApplyCouponHandler } from '@/cart/application/handlers/apply-coupon.handler';
import { RemoveCartCouponHandler } from '@/cart/application/handlers/remove-cart-coupon.handler';
import { ClearCartHandler } from '@/cart/application/handlers/clear-cart.handler';

@Injectable()
export class CartService {
  private readonly logger = new Logger(CartService.name);

  constructor(
    @InjectRepository(CartItem)
    private readonly cartItemRepository: Repository<CartItem>,
    private readonly addCartItemHandler: AddCartItemHandler,
    private readonly removeCartItemHandler: RemoveCartItemHandler,
    private readonly applyCouponHandler: ApplyCouponHandler,
    private readonly removeCartCouponHandler: RemoveCartCouponHandler,
    private readonly clearCartHandler: ClearCartHandler,
  ) {}

  async getCartItems(userId: string): Promise<CartItemResponseDto[]> {
    this.logger.log(`Getting cart items for user: ${userId}`);

    const items = await this.cartItemRepository.find({
      where: { userId },
      relations: ['service', 'service.partner', 'service.media'],
      order: { createdAt: 'DESC' },
    });

    return CartItemResponseDto.fromEntities(items);
  }

  async addItem(userId: string, dto: AddToCartDto): Promise<CartItemResponseDto> {
    const created = await this.addCartItemHandler.execute(userId, dto);
    return CartItemResponseDto.fromEntity(created);
  }

  async removeItem(userId: string, cartItemId: string): Promise<void> {
    await this.removeCartItemHandler.execute(userId, cartItemId);
  }

  async applyCoupon(
    userId: string,
    cartItemId: string,
    dto: ApplyCouponDto,
  ): Promise<CartItemResponseDto> {
    const updated = await this.applyCouponHandler.execute(userId, cartItemId, dto);
    return CartItemResponseDto.fromEntity(updated);
  }

  async removeCoupon(
    userId: string,
    cartItemId: string,
  ): Promise<CartItemResponseDto> {
    const updated = await this.removeCartCouponHandler.execute(userId, cartItemId);
    return CartItemResponseDto.fromEntity(updated);
  }

  async clearCart(userId: string): Promise<void> {
    await this.clearCartHandler.execute(userId);
  }
}
