import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  UseInterceptors,
  ClassSerializerInterceptor,
  Query,
  ParseUUIDPipe,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiNotFoundResponse,
  ApiNoContentResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { EmployeesService } from './employees.service';
import { CreateDoctorDto } from './dto/create-doctor.dto';
import { CreateTherapistDto } from './dto/create-therapist.dto';
import { GetEmployeesQueryDto } from './dto/get-employees-query.dto';
import { UpdateEmployeeDto } from './dto/update-employee.dto';
import { EmployeeResponseDto } from './dto/employee-response.dto';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/auth/decorators/roles.decorator';
import { ADMIN_ROLES } from '@/auth/constants/role-groups';

/**
 * Controller for employee management endpoints.
 * API Version 1.
 */
@ApiTags('employees')
@ApiBearerAuth()
@Controller({ path: 'employees', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
@UseInterceptors(ClassSerializerInterceptor)
@Roles(...ADMIN_ROLES)
export class EmployeesController {
  constructor(private readonly employeesService: EmployeesService) {}

  /**
   * Creates a new doctor employee.
   */
  @Post('doctors')
  @ApiOperation({ summary: 'Create a new doctor' })
  @ApiCreatedResponse({
    description: 'The doctor has been successfully created.',
    type: EmployeeResponseDto,
  })
  createDoctor(@Body() createDoctorDto: CreateDoctorDto): Promise<EmployeeResponseDto> {
    return this.employeesService.createDoctor(createDoctorDto);
  }

  /**
   * Creates a new therapist employee.
   */
  @Post('therapists')
  @ApiOperation({ summary: 'Create a new therapist' })
  @ApiCreatedResponse({
    description: 'The therapist has been successfully created.',
    type: EmployeeResponseDto,
  })
  createTherapist(
    @Body() createTherapistDto: CreateTherapistDto,
  ): Promise<EmployeeResponseDto> {
    return this.employeesService.createTherapist(createTherapistDto);
  }

  /**
   * Retrieves all employees.
   */
  @Get()
  @ApiOperation({ summary: 'Get all employees' })
  @ApiOkResponse({
    description: 'Return all employees.',
    type: [EmployeeResponseDto],
  })
  findAll(@Query() query: GetEmployeesQueryDto): Promise<EmployeeResponseDto[]> {
    return this.employeesService.findAll(query);
  }

  /**
   * Retrieves an employee by ID.
   */
  @Get(':id')
  @ApiOperation({ summary: 'Get an employee by id' })
  @ApiOkResponse({
    description: 'Return the employee.',
    type: EmployeeResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Employee not found.' })
  findOne(@Param('id', ParseUUIDPipe) id: string): Promise<EmployeeResponseDto> {
    return this.employeesService.findOne(id);
  }

  /**
   * Updates an employee.
   */
  @Patch(':id')
  @ApiOperation({ summary: 'Update an employee' })
  @ApiOkResponse({
    description: 'The employee has been successfully updated.',
    type: EmployeeResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Employee not found.' })
  update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updateEmployeeDto: UpdateEmployeeDto,
  ): Promise<EmployeeResponseDto> {
    return this.employeesService.update(id, updateEmployeeDto);
  }

  /**
   * Deletes an employee (soft delete).
   */
  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete an employee' })
  @ApiNoContentResponse({
    description: 'The employee has been successfully deleted.',
  })
  @ApiNotFoundResponse({ description: 'Employee not found.' })
  remove(@Param('id', ParseUUIDPipe) id: string): Promise<void> {
    return this.employeesService.remove(id);
  }
}
