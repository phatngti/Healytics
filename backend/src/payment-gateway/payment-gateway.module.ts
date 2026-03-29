import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { Product } from '@/common/entities/product.entity';
import { Account } from '@/common/entities/account.entity';
import { Payment } from '@/common/entities/payment.entity';
import { PaymentTransactionLog } from '@/common/entities/payment-transaction-log.entity';
import { BookingPaymentService } from './booking-payment.service';
import { MoMoPaymentService } from './momo-payment.service';
import { MoMoController } from './momo.controller';
import { UserPaymentController } from './user-payment.controller';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Booking,
      BookingStatusLog,
      Product,
      Account,
      Payment,
      PaymentTransactionLog,
    ]),
    ConfigModule,
  ],
  controllers: [MoMoController, UserPaymentController],
  providers: [BookingPaymentService, MoMoPaymentService],
  exports: [BookingPaymentService],
})
export class PaymentGatewayModule {}
