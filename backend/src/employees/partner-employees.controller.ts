import {
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  ParseUUIDPipe,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { StripNullPropertiesPipe } from '@/common/pipes/strip-null-properties.pipe';
import { Throttle } from '@nestjs/throttler';
import {
  ApiOperation,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiNotFoundResponse,
  ApiNoContentResponse,
} from '@nestjs/swagger';
import { PartnerApi } from '@/common/decorators/api/partner-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { EmployeesService } from './employees.service';
import { CreateDoctorDto } from './dto/create-doctor.dto';
import {
  CreateSpaTherapistDto,
  CreateMassageTherapistDto,
} from './dto/create-therapist.dto';
import { GetEmployeesQueryDto } from './dto/get-employees-query.dto';
import { UpdateEmployeeDto } from './dto/update-employee.dto';
import { EmployeeResponseDto } from './dto/employee-response.dto';
import {
  CreateSkillDto,
  SkillCatalogResponseDto,
} from './dto/skill-catalog.dto';
import { EmployeeAnalyticsQueryDto } from './dto/analytics/employee-analytics-query.dto';
import { EmployeeOverviewAnalyticsResponseDto } from './dto/analytics/employee-overview-analytics.dto';
import { EmployeeDetailAnalyticsResponseDto } from './dto/analytics/employee-detail-analytics.dto';
import { EmployeeAssignedServiceDto } from './dto/employee-assigned-service.dto';
import { DashboardTimePeriod } from '@/dashboard-partner/dto/query/dashboard-period-query.dto';

/**
 * Partner controller for employee management.
 * All endpoints require HEALTH_PARTNER authentication.
 * All operations are scoped to the authenticated partner.
 * Route prefix: /v1/partner/employees
 */
@PartnerApi('employees')
export class PartnerEmployeesController {
  constructor(private readonly employeesService: EmployeesService) {}

  // ─── Analytics Endpoints (must precede :id routes) ────────

  /**
   * Returns overview analytics for all partner employees.
   */
  @Get('analytics/overview')
  @ApiOperation({ summary: 'Get employee overview analytics' })
  @ApiOkResponse({ type: EmployeeOverviewAnalyticsResponseDto })
  getOverviewAnalytics(
    @CurrentUser('id') userId: string,
    @Query() query: EmployeeAnalyticsQueryDto,
  ): Promise<EmployeeOverviewAnalyticsResponseDto> {
    return this.employeesService.getOverviewAnalytics(
      userId,
      query.period ?? DashboardTimePeriod.THIS_MONTH,
    );
  }

  /**
   * Returns per-employee detail analytics.
   */
  @Get('analytics/:employeeId')
  @ApiOperation({ summary: 'Get per-employee detail analytics' })
  @ApiOkResponse({ type: EmployeeDetailAnalyticsResponseDto })
  @ApiNotFoundResponse({ description: 'Employee not found.' })
  getDetailAnalytics(
    @CurrentUser('id') userId: string,
    @Param('employeeId', ParseUUIDPipe) employeeId: string,
    @Query() query: EmployeeAnalyticsQueryDto,
  ): Promise<EmployeeDetailAnalyticsResponseDto> {
    return this.employeesService.getDetailAnalytics(
      userId,
      employeeId,
      query.period ?? DashboardTimePeriod.THIS_MONTH,
    );
  }

  // ─── CRUD Endpoints ──────────────────────────────────────

  /**
   * Creates a new doctor employee for the authenticated partner.
   */
  @Post('doctors')
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Create a new doctor' })
  @ApiCreatedResponse({
    description: 'The doctor has been successfully created.',
    type: EmployeeResponseDto,
  })
  async createDoctor(
    @CurrentUser('id') userId: string,
    @Body() createDoctorDto: CreateDoctorDto,
  ): Promise<EmployeeResponseDto> {
    const partnerId =
      await this.employeesService.getPartnerIdByAccountId(userId);
    return this.employeesService.createDoctor(createDoctorDto, partnerId);
  }

  /**
   * Creates a new spa therapist employee for the authenticated partner.
   */
  @Post('spa-therapists')
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Create a new spa therapist' })
  @ApiCreatedResponse({
    description: 'The spa therapist has been successfully created.',
    type: EmployeeResponseDto,
  })
  async createSpaTherapist(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateSpaTherapistDto,
  ): Promise<EmployeeResponseDto> {
    const partnerId =
      await this.employeesService.getPartnerIdByAccountId(userId);
    return this.employeesService.createSpaTherapist(dto, partnerId);
  }

  /**
   * Creates a new massage therapist employee for the authenticated partner.
   */
  @Post('massage-therapists')
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Create a new massage therapist' })
  @ApiCreatedResponse({
    description: 'The massage therapist has been successfully created.',
    type: EmployeeResponseDto,
  })
  async createMassageTherapist(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateMassageTherapistDto,
  ): Promise<EmployeeResponseDto> {
    const partnerId =
      await this.employeesService.getPartnerIdByAccountId(userId);
    return this.employeesService.createMassageTherapist(dto, partnerId);
  }

  // ─── Skill Catalog Endpoints ──────────────────────────────

  /**
   * Retrieves all massage skills for the authenticated partner.
   */
  @Get('massage-skills')
  @ApiOperation({ summary: 'Get massage skill catalog' })
  @ApiOkResponse({
    description: 'Return all massage skills for the partner.',
    type: [SkillCatalogResponseDto],
  })
  async getMassageSkills(
    @CurrentUser('id') userId: string,
  ): Promise<SkillCatalogResponseDto[]> {
    const partnerId =
      await this.employeesService.getPartnerIdByAccountId(userId);
    return this.employeesService.getSkillsByType(partnerId, 'MASSAGE');
  }

  /**
   * Creates a new massage skill for the authenticated partner.
   */
  @Post('massage-skills')
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Create a massage skill' })
  @ApiCreatedResponse({
    description: 'The massage skill has been created.',
    type: SkillCatalogResponseDto,
  })
  async createMassageSkill(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateSkillDto,
  ): Promise<SkillCatalogResponseDto> {
    const partnerId =
      await this.employeesService.getPartnerIdByAccountId(userId);
    return this.employeesService.createSkill(partnerId, dto, 'MASSAGE');
  }

  /**
   * Retrieves all spa skills for the authenticated partner.
   */
  @Get('spa-skills')
  @ApiOperation({ summary: 'Get spa skill catalog' })
  @ApiOkResponse({
    description: 'Return all spa skills for the partner.',
    type: [SkillCatalogResponseDto],
  })
  async getSpaSkills(
    @CurrentUser('id') userId: string,
  ): Promise<SkillCatalogResponseDto[]> {
    const partnerId =
      await this.employeesService.getPartnerIdByAccountId(userId);
    return this.employeesService.getSkillsByType(partnerId, 'SPA');
  }

  /**
   * Creates a new spa skill for the authenticated partner.
   */
  @Post('spa-skills')
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Create a spa skill' })
  @ApiCreatedResponse({
    description: 'The spa skill has been created.',
    type: SkillCatalogResponseDto,
  })
  async createSpaSkill(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateSkillDto,
  ): Promise<SkillCatalogResponseDto> {
    const partnerId =
      await this.employeesService.getPartnerIdByAccountId(userId);
    return this.employeesService.createSkill(partnerId, dto, 'SPA');
  }

  /**
   * Retrieves all employees belonging to the authenticated partner.
   */
  @Get()
  @ApiOperation({ summary: 'Get all employees for this partner' })
  @ApiOkResponse({
    description: 'Return all employees for the authenticated partner.',
    type: [EmployeeResponseDto],
  })
  async findAll(
    @CurrentUser('id') userId: string,
    @Query() query: GetEmployeesQueryDto,
  ): Promise<EmployeeResponseDto[]> {
    const partnerId =
      await this.employeesService.getPartnerIdByAccountId(userId);
    return this.employeesService.findAll(query, partnerId);
  }

  /**
   * Retrieves all services assigned to a partner-owned employee.
   */
  @Get(':id/services')
  @ApiOperation({ summary: 'Get services assigned to an employee' })
  @ApiOkResponse({
    description: 'Return services assigned to the employee.',
    type: [EmployeeAssignedServiceDto],
  })
  @ApiNotFoundResponse({ description: 'Employee not found.' })
  async findAssignedServices(
    @CurrentUser('id') userId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<EmployeeAssignedServiceDto[]> {
    const partnerId =
      await this.employeesService.getPartnerIdByAccountId(userId);
    return this.employeesService.findAssignedServicesForPartner(id, partnerId);
  }

  /**
   * Retrieves an employee by ID (must belong to the authenticated partner).
   */
  @Get(':id')
  @ApiOperation({ summary: 'Get an employee by id' })
  @ApiOkResponse({
    description: 'Return the employee.',
    type: EmployeeResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Employee not found.' })
  async findOne(
    @CurrentUser('id') userId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<EmployeeResponseDto> {
    const partnerId =
      await this.employeesService.getPartnerIdByAccountId(userId);
    return this.employeesService.findOneForPartner(id, partnerId);
  }

  /**
   * Updates an employee (must belong to the authenticated partner).
   */
  @Patch(':id')
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Update an employee' })
  @ApiOkResponse({
    description: 'The employee has been successfully updated.',
    type: EmployeeResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Employee not found.' })
  async update(
    @CurrentUser('id') userId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body(new StripNullPropertiesPipe()) updateEmployeeDto: UpdateEmployeeDto,
  ): Promise<EmployeeResponseDto> {
    const partnerId =
      await this.employeesService.getPartnerIdByAccountId(userId);
    return this.employeesService.updateForPartner(
      id,
      partnerId,
      updateEmployeeDto,
    );
  }

  /**
   * Deletes an employee (must belong to the authenticated partner, soft delete).
   */
  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Delete an employee' })
  @ApiNoContentResponse({
    description: 'The employee has been successfully deleted.',
  })
  @ApiNotFoundResponse({ description: 'Employee not found.' })
  async remove(
    @CurrentUser('id') userId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<void> {
    const partnerId =
      await this.employeesService.getPartnerIdByAccountId(userId);
    return this.employeesService.removeForPartner(id, partnerId);
  }
}
