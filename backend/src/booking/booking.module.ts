import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HttpModule } from '@nestjs/axios';
import { ScheduleModule } from '@nestjs/schedule';
import { JwtModule } from '@nestjs/jwt';
import { jwtConstants } from '@/auth/constants';
import { Booking } from '@/common/entities/booking.entity';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { Account } from '@/common/entities/account.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Product } from '@/common/entities/product.entity';
import { Partner } from '@/common/entities/partner.entity';
import { PartnerStatistics } from '@/common/entities/partner-statistics.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { AccountModule } from '@/account/account.module';
import { NotificationModule } from '@/notification/notification.module';
import { BookingController } from './booking.controller';
import { SlotsController } from './slots.controller';
import { EmployeeAppointmentsController } from './employee-appointments.controller';
import { BookingStatusController } from './booking-status.controller';
import { PartnerBookingsController } from './partner-bookings.controller';
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
import { ListPartnerBookingsHandler } from './application/handlers/list-partner-bookings.handler';
import { StartEmployeeServiceHandler } from './application/handlers/start-employee-service.handler';
import { CompleteEmployeeServiceHandler } from './application/handlers/complete-employee-service.handler';
import { CancelEmployeeAppointmentHandler } from './application/handlers/cancel-employee-appointment.handler';
import { WebhookService } from './services/webhook.service';
import { PaymentExpiryService } from './services/payment-expiry.service';
import { BookingAccessService } from './services/booking-access.service';
import { BookingStatusLifecycleService } from './services/booking-status-lifecycle.service';
import { BookingStatusLogWriterService } from './services/booking-status-log-writer.service';
import { BookingStatusRealtimePublisher } from './services/booking-status-realtime.publisher';
import { PartnerStatisticsRefreshService } from './services/partner-statistics-refresh.service';
import { AutoStaffAssignmentService } from './services/auto-staff-assignment.service';
import { BookingOwnershipGuard } from './guards/booking-ownership.guard';
import { BookingEventsGateway } from './gateways/booking-events.gateway';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Booking,
      CheckoutTicket,
      BookingStatusLog,
      Account,
      Employee,
      Product,
      ProductEmployeeEligibility,
      Partner,
      PartnerStatistics,
    ]),
    HttpModule.register({ timeout: 5000 }),
    JwtModule.register({
      secret: jwtConstants.secret,
      signOptions: { expiresIn: '3600s' },
    }),
    AccountModule,
    NotificationModule,
    ScheduleModule.forRoot(),
  ],
  controllers: [
    BookingController,
    SlotsController,
    EmployeeAppointmentsController,
    PartnerBookingsController,
    ProcessCheckoutHandler,
    BookingStatusController,
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
    ListPartnerBookingsHandler,
    StartEmployeeServiceHandler,
    CompleteEmployeeServiceHandler,
    CancelEmployeeAppointmentHandler,
    WebhookService,
    PaymentExpiryService,
    BookingAccessService,
    BookingOwnershipGuard,
    BookingStatusLifecycleService,
    BookingStatusLogWriterService,
    BookingStatusRealtimePublisher,
    BookingEventsGateway,
    PartnerStatisticsRefreshService,
    AutoStaffAssignmentService,
  ],
  exports: [BookingService],
})
export class BookingModule {}
