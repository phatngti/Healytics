import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CartController } from '@/cart/cart.controller';
import { CartService } from '@/cart/cart.service';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { Product } from '@/common/entities/product.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Booking } from '@/common/entities/booking.entity';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { AddCartItemHandler } from '@/cart/application/handlers/add-cart-item.handler';
import { RemoveCartItemHandler } from '@/cart/application/handlers/remove-cart-item.handler';
import { ClearCartHandler } from '@/cart/application/handlers/clear-cart.handler';
import { CheckSlotAvailabilityHandler } from '@/booking/application/handlers/check-slot-availability.handler';
import { AutoStaffAssignmentService } from '@/booking/services/auto-staff-assignment.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      CartItem,
      Product,
      Employee,
      Booking,
      CheckoutTicket,
      ProductEmployeeEligibility,
    ]),
  ],
  controllers: [CartController],
  providers: [
    CartService,
    AddCartItemHandler,
    RemoveCartItemHandler,
    ClearCartHandler,
    CheckSlotAvailabilityHandler,
    AutoStaffAssignmentService,
  ],
  exports: [CartService],
})
export class CartModule {}
