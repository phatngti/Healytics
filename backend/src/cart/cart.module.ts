import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CartController } from '@/cart/cart.controller';
import { CartService } from '@/cart/cart.service';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { Coupon } from '@/cart/entities/coupon.entity';
import { Product } from '@/common/entities/product.entity';
import { AddCartItemHandler } from '@/cart/application/handlers/add-cart-item.handler';
import { RemoveCartItemHandler } from '@/cart/application/handlers/remove-cart-item.handler';
import { ApplyCouponHandler } from '@/cart/application/handlers/apply-coupon.handler';
import { RemoveCartCouponHandler } from '@/cart/application/handlers/remove-cart-coupon.handler';
import { ClearCartHandler } from '@/cart/application/handlers/clear-cart.handler';

@Module({
  imports: [TypeOrmModule.forFeature([CartItem, Coupon, Product])],
  controllers: [CartController],
  providers: [
    CartService,
    AddCartItemHandler,
    RemoveCartItemHandler,
    ApplyCouponHandler,
    RemoveCartCouponHandler,
    ClearCartHandler,
  ],
  exports: [CartService],
})
export class CartModule {}
