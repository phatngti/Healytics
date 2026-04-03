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
import { LogResponse } from '@/common/interceptors/response.interceptor';

/**
 * Partner controller for employee management.
 * All endpoints require HEALTH_PARTNER authentication.
 * All operations are scoped to the authenticated partner.
 * Route prefix: /v1/partner/employees
 */
@PartnerApi('employees')
export class PartnerEmployeesController {
  constructor(private readonly employeesService: EmployeesService) {}

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
    @Body() updateEmployeeDto: UpdateEmployeeDto,
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
