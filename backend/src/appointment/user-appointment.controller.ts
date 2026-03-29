import { Get, Param, ParseUUIDPipe, Query } from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { AppointmentService } from './appointment.service';
import { AppointmentResponseDto } from './dto/appointment-response.dto';
import { AppointmentCategoryResponseDto } from './dto/appointment-category-response.dto';
import { RecommendedServiceResponseDto } from './dto/recommended-service-response.dto';
import { ServiceManualResponseDto } from './dto/service-manual-response.dto';
import { ListAppointmentsQueryDto } from './dto/list-appointments-query.dto';
import { RecentActivityQueryDto } from './dto/recent-activity-query.dto';
import { LogResponse } from '@/common/interceptors/response.interceptor';

/**
 * User controller for appointment endpoints.
 * All endpoints require USER authentication.
 * Route prefix: /v1/user/appointments
 */
@UserApi('appointments')
export class UserAppointmentController {
  constructor(private readonly appointmentService: AppointmentService) {}

  /**
   * List all appointments for the current user.
   */
  @Get()
  @ApiOperation({ summary: 'List all user appointments with optional distance calculation' })
  @ApiOkResponse({ type: [AppointmentResponseDto] })
  async listAppointments(
    @CurrentUser('id') userId: string,
    @Query() query: ListAppointmentsQueryDto,
  ): Promise<AppointmentResponseDto[]> {
    return this.appointmentService.listAppointments(userId, query);
  }

  /**
   * Get appointment category filter chips.
   */
  @Get('categories')
  @ApiOperation({ summary: 'Get appointment categories for filter chips' })
  @ApiOkResponse({ type: [AppointmentCategoryResponseDto] })
  async listCategories(
    @CurrentUser('id') userId: string,
  ): Promise<AppointmentCategoryResponseDto[]> {
    return this.appointmentService.listCategories(userId);
  }

  /**
   * Get recommended services section.
   */
  @Get('recommendations')
  @ApiOperation({ summary: 'Get recommended services' })
  @ApiOkResponse({ type: [RecommendedServiceResponseDto] })
  async listRecommendedServices(): Promise<RecommendedServiceResponseDto[]> {
    return this.appointmentService.listRecommendedServices();
  }

  /**
   * Get recent activity for the home page dashboard widget.
   * Returns a paginated list of recent appointments sorted by:
   * upcoming (nearest future first), then past (most recent first).
   */
  @Get('recent-activity')
    @LogResponse()
  @ApiOperation({ summary: 'Get recent appointment activity for home dashboard' })
  @ApiOkResponse({
    description: 'Paginated list of recent activities with meta',
  })
  async listRecentActivity(
    @CurrentUser('id') userId: string,
    @Query() query: RecentActivityQueryDto,
  ) {
    return this.appointmentService.listRecentActivity(userId, query);
  }

  /**
   * Get a single appointment detail by ID.
   */
  @Get(':id')
  @ApiOperation({ summary: 'Get appointment details by ID' })
  @ApiOkResponse({ type: AppointmentResponseDto })
  @ApiNotFoundResponse({ description: 'Appointment not found' })
  async getAppointment(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<AppointmentResponseDto> {
    return this.appointmentService.getAppointment(id);
  }

  /**
   * Get service manual for an appointment.
   */
  @Get(':appointmentId/manual')
  @ApiOperation({ summary: 'Get service manual for an appointment' })
  @ApiOkResponse({ type: ServiceManualResponseDto })
  @ApiNotFoundResponse({ description: 'Appointment not found' })
  async getServiceManual(
    @Param('appointmentId', ParseUUIDPipe) appointmentId: string,
  ): Promise<ServiceManualResponseDto> {
    return this.appointmentService.getServiceManual(appointmentId);
  }
}
