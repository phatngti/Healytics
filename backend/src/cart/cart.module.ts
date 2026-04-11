import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CartController } from '@/cart/cart.controller';
import { CartService } from '@/cart/cart.service';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { Product } from '@/common/entities/product.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Booking } from '@/common/entities/booking.entity';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { AddCartItemHandler } from '@/cart/application/handlers/add-cart-item.handler';
import { RemoveCartItemHandler } from '@/cart/application/handlers/remove-cart-item.handler';
import { ClearCartHandler } from '@/cart/application/handlers/clear-cart.handler';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      CartItem,
      Product,
      Employee,
      Booking,
      CheckoutTicket,
    ]),
  ],
  controllers: [CartController],
  providers: [
    CartService,
    AddCartItemHandler,
    RemoveCartItemHandler,
    ClearCartHandler,
  ],
  exports: [CartService],
})
export class CartModule {}
