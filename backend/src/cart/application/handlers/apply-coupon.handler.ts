import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { ApplyCouponDto } from '@/cart/dto/apply-coupon.dto';
import { Coupon } from '@/cart/entities/coupon.entity';
import { CART_ERROR_CODES } from '@/cart/constants/cart-error-codes';

@Injectable()
export class ApplyCouponHandler {
  private readonly logger = new Logger(ApplyCouponHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    userId: string,
    cartItemId: string,
    dto: ApplyCouponDto,
  ): Promise<CartItem> {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const cartItem = await queryRunner.manager.findOne(CartItem, {
        where: { id: cartItemId, userId },
        relations: ['service'],
      });

      if (!cartItem) {
        throw new NotFoundException({
          code: CART_ERROR_CODES.ITEM_NOT_FOUND,
          message: 'Cart item not found',
        });
      }

      const coupon = await queryRunner.manager
        .createQueryBuilder(Coupon, 'coupon')
        .where('LOWER(coupon.code) = LOWER(:code)', { code: dto.couponCode })
        .getOne();

      if (!coupon || !coupon.isActive) {
        throw new BadRequestException({
          code: CART_ERROR_CODES.INVALID_COUPON,
          message: 'Coupon code is invalid or inactive',
        });
      }

      if (coupon.expiresAt && coupon.expiresAt <= new Date()) {
        throw new BadRequestException({
          code: CART_ERROR_CODES.COUPON_EXPIRED,
          message: 'Coupon has expired',
        });
      }

      if (coupon.usageLimit !== null && coupon.usedCount >= coupon.usageLimit) {
        throw new BadRequestException({
          code: CART_ERROR_CODES.COUPON_LIMIT_REACHED,
          message: 'Coupon usage limit reached',
        });
      }

      const serviceCategoryId = cartItem.service?.categoryId ?? null;
      const matchesService = !coupon.serviceId || coupon.serviceId === cartItem.serviceId;
      const matchesCategory =
        !coupon.categoryId || coupon.categoryId === serviceCategoryId;

      if (!matchesService || !matchesCategory) {
        throw new BadRequestException({
          code: CART_ERROR_CODES.COUPON_NOT_APPLICABLE,
          message: 'Coupon is not applicable to this service',
        });
      }

      const servicePrice = Number(
        cartItem.service?.salePrice ?? cartItem.service?.basePrice ?? 0,
      );

      const discountAmount = this.calculateDiscountAmount(
        servicePrice,
        coupon.discountPercent,
        coupon.maxDiscountAmount,
      );

      cartItem.couponCode = coupon.code;
      cartItem.couponDiscountPercent = coupon.discountPercent;
      cartItem.couponDiscountAmount = discountAmount;

      const saved = await queryRunner.manager.save(CartItem, cartItem);

      await queryRunner.commitTransaction();

      return this.loadCartItem(saved.id, userId);
    } catch (error) {
      await queryRunner.rollbackTransaction();

      if (
        error instanceof NotFoundException ||
        error instanceof BadRequestException
      ) {
        throw error;
      }

      this.logger.error(`Failed to apply coupon: ${error.message}`, error.stack);
      throw new InternalServerErrorException('Failed to apply coupon');
    } finally {
      await queryRunner.release();
    }
  }

  private calculateDiscountAmount(
    servicePrice: number,
    discountPercent: number,
    maxDiscountAmount: number | null,
  ): number {
    const calculated = Math.floor((servicePrice * discountPercent) / 100);

    if (maxDiscountAmount === null) {
      return calculated;
    }

    return Math.min(calculated, maxDiscountAmount);
  }

  private async loadCartItem(cartItemId: string, userId: string): Promise<CartItem> {
    const item = await this.dataSource.manager.findOne(CartItem, {
      where: { id: cartItemId, userId },
      relations: ['service', 'service.partner', 'service.media'],
    });

    if (!item) {
      throw new InternalServerErrorException(
        'Updated cart item was not found',
      );
    }

    return item;
  }
}
