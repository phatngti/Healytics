import { Injectable, Logger } from '@nestjs/common';
import { ListAppointmentsHandler } from './application/handlers/list-appointments.handler';
import { GetAppointmentHandler } from './application/handlers/get-appointment.handler';
import { ListAppointmentCategoriesHandler } from './application/handlers/list-appointment-categories.handler';
import { ListRecommendedServicesHandler } from './application/handlers/list-recommended-services.handler';
import { GetServiceManualHandler } from './application/handlers/get-service-manual.handler';
import { ListRecentActivityHandler, RecentActivityResult } from './application/handlers/list-recent-activity.handler';
import { AppointmentResponseDto } from './dto/appointment-response.dto';
import { AppointmentCategoryResponseDto } from './dto/appointment-category-response.dto';
import { RecommendedServiceResponseDto } from './dto/recommended-service-response.dto';
import { ServiceManualResponseDto } from './dto/service-manual-response.dto';
import { ListAppointmentsQueryDto } from './dto/list-appointments-query.dto';
import { RecentActivityQueryDto } from './dto/recent-activity-query.dto';

/**
 * Appointment service facade — delegates all operations to domain handlers.
 */
@Injectable()
export class AppointmentService {
  private readonly logger = new Logger(AppointmentService.name);

  constructor(
    private readonly listAppointmentsHandler: ListAppointmentsHandler,
    private readonly getAppointmentHandler: GetAppointmentHandler,
    private readonly listAppointmentCategoriesHandler: ListAppointmentCategoriesHandler,
    private readonly listRecommendedServicesHandler: ListRecommendedServicesHandler,
    private readonly getServiceManualHandler: GetServiceManualHandler,
    private readonly listRecentActivityHandler: ListRecentActivityHandler,
  ) {}

  // ── Appointments ─────────────────────────────────────────────

  async listAppointments(
    userId: string,
    query?: ListAppointmentsQueryDto,
  ): Promise<AppointmentResponseDto[]> {
    this.logger.log(`listAppointments: user=${userId}`);
    return this.listAppointmentsHandler.execute(userId, query);
  }

  async getAppointment(id: string): Promise<AppointmentResponseDto> {
    this.logger.log(`getAppointment: ${id}`);
    return this.getAppointmentHandler.execute(id);
  }

  // ── Categories ───────────────────────────────────────────────

  async listCategories(userId: string): Promise<AppointmentCategoryResponseDto[]> {
    this.logger.log(`listCategories: user=${userId}`);
    return this.listAppointmentCategoriesHandler.execute(userId);
  }

  // ── Recommendations ──────────────────────────────────────────

  async listRecommendedServices(): Promise<RecommendedServiceResponseDto[]> {
    this.logger.log('listRecommendedServices');
    return this.listRecommendedServicesHandler.execute();
  }

  // ── Service Manual ───────────────────────────────────────────

  async getServiceManual(appointmentId: string): Promise<ServiceManualResponseDto> {
    this.logger.log(`getServiceManual: ${appointmentId}`);
    return this.getServiceManualHandler.execute(appointmentId);
  }

  // ── Recent Activity ──────────────────────────────────────────

  async listRecentActivity(
    userId: string,
    query: RecentActivityQueryDto,
  ): Promise<RecentActivityResult> {
    this.logger.log(`listRecentActivity: user=${userId}`);
    return this.listRecentActivityHandler.execute(userId, query);
  }
}
