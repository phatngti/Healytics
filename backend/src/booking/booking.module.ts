import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HttpModule } from '@nestjs/axios';
import { ScheduleModule } from '@nestjs/schedule';
import { Booking } from '@/common/entities/booking.entity';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { Account } from '@/common/entities/account.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Product } from '@/common/entities/product.entity';
import { Partner } from '@/common/entities/partner.entity';
import { NotificationModule } from '@/notification/notification.module';
import { BookingController } from './booking.controller';
import { SlotsController } from './slots.controller';
import { EmployeeAppointmentsController } from './employee-appointments.controller';
import { BookingService } from './booking.service';
import { AcquireMicroLockHandler } from './application/handlers/acquire-micro-lock.handler';
import { CheckDuplicateSlotHandler } from './application/handlers/check-duplicate-slot.handler';
import { CheckSlotAvailabilityHandler } from './application/handlers/check-slot-availability.handler';
import { CreateCheckoutTicketHandler } from './application/handlers/create-checkout-ticket.handler';
import { ProcessCheckoutHandler } from './application/handlers/process-checkout.handler';
import { GetBookingHandler } from './application/handlers/get-booking.handler';
import { GetCheckoutTicketHandler } from './application/handlers/get-checkout-ticket.handler';
import { ListUserBookingsHandler } from './application/handlers/list-user-bookings.handler';
import { ListEmployeeAppointmentsHandler } from './application/handlers/list-employee-appointments.handler';
import { GetEmployeeAppointmentHandler } from './application/handlers/get-employee-appointment.handler';
import { StartEmployeeServiceHandler } from './application/handlers/start-employee-service.handler';
import { CompleteEmployeeServiceHandler } from './application/handlers/complete-employee-service.handler';
import { CancelEmployeeAppointmentHandler } from './application/handlers/cancel-employee-appointment.handler';
import { WebhookService } from './services/webhook.service';
import { PaymentExpiryService } from './services/payment-expiry.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Booking,
      CheckoutTicket,
      BookingStatusLog,
      Account,
      Employee,
      Product,
      Partner,
    ]),
    HttpModule.register({ timeout: 5000 }),
    NotificationModule,
    ScheduleModule.forRoot(),
  ],
  controllers: [
    BookingController,
    SlotsController,
    EmployeeAppointmentsController,
    ProcessCheckoutHandler,
  ],
  providers: [
    BookingService,
    AcquireMicroLockHandler,
    CheckDuplicateSlotHandler,
    CheckSlotAvailabilityHandler,
    CreateCheckoutTicketHandler,
    ProcessCheckoutHandler,
    GetBookingHandler,
    GetCheckoutTicketHandler,
    ListUserBookingsHandler,
    // Employee appointment handlers
    ListEmployeeAppointmentsHandler,
    GetEmployeeAppointmentHandler,
    StartEmployeeServiceHandler,
    CompleteEmployeeServiceHandler,
    CancelEmployeeAppointmentHandler,
    WebhookService,
    PaymentExpiryService,
  ],
  exports: [BookingService],
})
export class BookingModule {}
