import {
  Get,
  Patch,
  Param,
  Query,
  Body,
  ParseUUIDPipe,
} from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
  ApiConflictResponse,
} from '@nestjs/swagger';
import { EmployeeApi } from '@/common/decorators/api/employee-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { GetEmployeeAppointmentsQueryDto } from './dto/employee/get-employee-appointments-query.dto';
import { EmployeeAppointmentResponseDto } from './dto/employee/employee-appointment-response.dto';
import { PaginatedEmployeeAppointmentsResponseDto } from './dto/employee/paginated-employee-appointments-response.dto';
import { CancelEmployeeAppointmentDto } from './dto/employee/cancel-employee-appointment.dto';
import { ListEmployeeAppointmentsHandler } from './application/handlers/list-employee-appointments.handler';
import { GetEmployeeAppointmentHandler } from './application/handlers/get-employee-appointment.handler';
import { StartEmployeeServiceHandler } from './application/handlers/start-employee-service.handler';
import { CompleteEmployeeServiceHandler } from './application/handlers/complete-employee-service.handler';
import { CancelEmployeeAppointmentHandler } from './application/handlers/cancel-employee-appointment.handler';

/**
 * Employee controller for appointment management.
 * All endpoints require EMPLOYEE authentication.
 * All operations are scoped to the authenticated employee's bookings.
 * Route prefix: /v1/employee/appointments
 */
@EmployeeApi('appointments')
export class EmployeeAppointmentsController {
  constructor(
    private readonly listHandler: ListEmployeeAppointmentsHandler,
    private readonly getHandler: GetEmployeeAppointmentHandler,
    private readonly startHandler: StartEmployeeServiceHandler,
    private readonly completeHandler: CompleteEmployeeServiceHandler,
    private readonly cancelHandler: CancelEmployeeAppointmentHandler,
  ) {}

  /**
   * Lists appointments assigned to the authenticated employee.
   * Supports filtering by status and pagination.
   */
  @Get()
  @ApiOperation({ summary: 'List my appointments' })
  @ApiOkResponse({
    description: 'Return paginated list of employee appointments.',
    type: PaginatedEmployeeAppointmentsResponseDto,
  })
  async listMyAppointments(
    @CurrentUser('id') accountId: string,
    @Query() query: GetEmployeeAppointmentsQueryDto,
  ): Promise<PaginatedEmployeeAppointmentsResponseDto> {
    return this.listHandler.execute(accountId, query);
  }

  /**
   * Gets a single appointment detail.
   */
  @Get(':id')
  @ApiOperation({ summary: 'Get appointment detail' })
  @ApiOkResponse({
    description: 'Return appointment details.',
    type: EmployeeAppointmentResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Appointment not found.' })
  async getAppointment(
    @CurrentUser('id') accountId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<EmployeeAppointmentResponseDto> {
    return this.getHandler.execute(accountId, id);
  }

  /**
   * Starts a service (CONFIRMED → IN_PROGRESS).
   */
  @Patch(':id/start')
  @ApiOperation({ summary: 'Start service for an appointment' })
  @ApiOkResponse({
    description: 'Service started, booking moved to IN_PROGRESS.',
    type: EmployeeAppointmentResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Appointment not found.' })
  @ApiConflictResponse({ description: 'Invalid status transition.' })
  async startService(
    @CurrentUser('id') accountId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<EmployeeAppointmentResponseDto> {
    return this.startHandler.execute(accountId, id);
  }

  /**
   * Completes a service (IN_PROGRESS → COMPLETED).
   */
  @Patch(':id/complete')
  @ApiOperation({ summary: 'Complete service for an appointment' })
  @ApiOkResponse({
    description: 'Service completed.',
    type: EmployeeAppointmentResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Appointment not found.' })
  @ApiConflictResponse({ description: 'Invalid status transition.' })
  async completeService(
    @CurrentUser('id') accountId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<EmployeeAppointmentResponseDto> {
    return this.completeHandler.execute(accountId, id);
  }

  /**
   * Cancels an appointment (CONFIRMED | IN_PROGRESS → CANCELLED).
   */
  @Patch(':id/cancel')
  @ApiOperation({ summary: 'Cancel an appointment' })
  @ApiOkResponse({
    description: 'Appointment cancelled.',
    type: EmployeeAppointmentResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Appointment not found.' })
  @ApiConflictResponse({ description: 'Invalid status transition.' })
  async cancelAppointment(
    @CurrentUser('id') accountId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: CancelEmployeeAppointmentDto,
  ): Promise<EmployeeAppointmentResponseDto> {
    return this.cancelHandler.execute(accountId, id, dto.reason);
  }
}
