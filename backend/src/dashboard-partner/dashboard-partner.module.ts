import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PartnersModule } from '@/partners/partners.module';
import {
  Booking,
  Employee,
  Product,
  Payment,
  TreatmentReview,
  SpecialistReview,
  Notification,
  NotificationRead,
  UserProfile,
} from '@/common/entities';
import { PartnerDashboardController } from './partner-dashboard.controller';
import { PartnerDashboardService } from './partner-dashboard.service';
import { GetDashboardStatsHandler } from './handlers/get-dashboard-stats.handler';
import { GetRevenueDataHandler } from './handlers/get-revenue-data.handler';
import { ListUpcomingAppointmentsHandler } from './handlers/list-upcoming-appointments.handler';
import { GetServicePerformanceHandler } from './handlers/get-service-performance.handler';
import { GetEmployeeDistributionHandler } from './handlers/get-employee-distribution.handler';
import { ListRecentReviewsHandler } from './handlers/list-recent-reviews.handler';
import { GetStaffScheduleHandler } from './handlers/get-staff-schedule.handler';
import { ListDashboardNotificationsHandler } from './handlers/list-dashboard-notifications.handler';
import { GetInventoryAlertsHandler } from './handlers/get-inventory-alerts.handler';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Booking,
      Employee,
      Product,
      Payment,
      TreatmentReview,
      SpecialistReview,
      Notification,
      NotificationRead,
      UserProfile,
    ]),
    PartnersModule,
  ],
  controllers: [PartnerDashboardController],
  providers: [
    PartnerDashboardService,
    GetDashboardStatsHandler,
    GetRevenueDataHandler,
    ListUpcomingAppointmentsHandler,
    GetServicePerformanceHandler,
    GetEmployeeDistributionHandler,
    ListRecentReviewsHandler,
    GetStaffScheduleHandler,
    ListDashboardNotificationsHandler,
    GetInventoryAlertsHandler,
  ],
})
export class DashboardPartnerModule {}
