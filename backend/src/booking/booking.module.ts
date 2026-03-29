import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HttpModule } from '@nestjs/axios';
import { Booking } from '@/common/entities/booking.entity';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { BookingController } from './booking.controller';
import { SlotsController } from './slots.controller';
import { BookingService } from './booking.service';
import { AcquireMicroLockHandler } from './application/handlers/acquire-micro-lock.handler';
import { CheckSlotAvailabilityHandler } from './application/handlers/check-slot-availability.handler';
import { CreateCheckoutTicketHandler } from './application/handlers/create-checkout-ticket.handler';
import { ProcessCheckoutHandler } from './application/handlers/process-checkout.handler';
import { GetBookingHandler } from './application/handlers/get-booking.handler';
import { GetCheckoutTicketHandler } from './application/handlers/get-checkout-ticket.handler';
import { ListUserBookingsHandler } from './application/handlers/list-user-bookings.handler';
import { WebhookService } from './services/webhook.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([Booking, CheckoutTicket, BookingStatusLog]),
    HttpModule.register({ timeout: 5000 }),
  ],
  controllers: [BookingController, SlotsController, ProcessCheckoutHandler],
  providers: [
    BookingService,
    AcquireMicroLockHandler,
    CheckSlotAvailabilityHandler,
    CreateCheckoutTicketHandler,
    ProcessCheckoutHandler,
    GetBookingHandler,
    GetCheckoutTicketHandler,
    ListUserBookingsHandler,
    WebhookService,
  ],
  exports: [BookingService],
})
export class BookingModule {}
