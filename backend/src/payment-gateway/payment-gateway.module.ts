import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { Product } from '@/common/entities/product.entity';
import { Account } from '@/common/entities/account.entity';
import { Payment } from '@/common/entities/payment.entity';
import { PaymentTransactionLog } from '@/common/entities/payment-transaction-log.entity';
import { UserPaymentCustomer } from '@/common/entities/user-payment-customer.entity';
import { UserPaymentMethod } from '@/common/entities/user-payment-method.entity';
import { BookingPaymentService } from './booking-payment.service';
import { MoMoPaymentService } from './momo-payment.service';
import { StripePaymentService } from './stripe-payment.service';
import { MoMoController } from './momo.controller';
import { StripeWebhookController } from './stripe-webhook.controller';
import { UserPaymentController } from './user-payment.controller';
import { BookingStatusLogWriterService } from '@/booking/services/booking-status-log-writer.service';
import { NotificationModule } from '@/notification/notification.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Booking,
      BookingStatusLog,
      Product,
      Account,
      Payment,
      PaymentTransactionLog,
      UserPaymentCustomer,
      UserPaymentMethod,
    ]),
    ConfigModule,
    NotificationModule,
  ],
  controllers: [MoMoController, StripeWebhookController, UserPaymentController],
  providers: [
    BookingPaymentService,
    MoMoPaymentService,
    StripePaymentService,
    BookingStatusLogWriterService,
  ],
  exports: [BookingPaymentService],
})
export class PaymentGatewayModule {}
