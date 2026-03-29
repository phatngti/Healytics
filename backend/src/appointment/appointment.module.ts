import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { Product } from '@/common/entities/product.entity';
import { Category } from '@/common/entities/category.entity';
import { Partner } from '@/common/entities/partner.entity';
import { UserAppointmentController } from './user-appointment.controller';
import { AppointmentService } from './appointment.service';
import { ListAppointmentsHandler } from './application/handlers/list-appointments.handler';
import { GetAppointmentHandler } from './application/handlers/get-appointment.handler';
import { ListAppointmentCategoriesHandler } from './application/handlers/list-appointment-categories.handler';
import { ListRecommendedServicesHandler } from './application/handlers/list-recommended-services.handler';
import { GetServiceManualHandler } from './application/handlers/get-service-manual.handler';
import { ListRecentActivityHandler } from './application/handlers/list-recent-activity.handler';

@Module({
  imports: [TypeOrmModule.forFeature([Booking, Product, Category, Partner])],
  controllers: [UserAppointmentController],
  providers: [
    AppointmentService,
    ListAppointmentsHandler,
    GetAppointmentHandler,
    ListAppointmentCategoriesHandler,
    ListRecommendedServicesHandler,
    GetServiceManualHandler,
    ListRecentActivityHandler,
  ],
  exports: [AppointmentService],
})
export class AppointmentModule {}
