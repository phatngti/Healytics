import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Query,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiNotFoundResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { EmployeesService } from './employees.service';
import { CreateEmployeeDto } from './dto/create-employee.dto';
import { CreateDoctorDto } from './dto/create-doctor.dto';
import { CreateTherapistDto } from './dto/create-therapist.dto';
import { GetEmployeesQueryDto } from './dto/get-employees-query.dto';
import { UpdateEmployeeDto } from './dto/update-employee.dto';
import { Employee } from './entities/employee.entity';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/auth/decorators/roles.decorator';
import { ADMIN_ROLES } from '@/auth/constants/role-groups';

@ApiTags('employees')
@ApiBearerAuth()
@Controller('employees')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(...ADMIN_ROLES)
export class EmployeesController {
  constructor(private readonly employeesService: EmployeesService) {}

  @Post('doctors')
  @ApiOperation({ summary: 'Create a new doctor' })
  @ApiCreatedResponse({
    description: 'The doctor has been successfully created.',
    type: Employee,
  })
  createDoctor(@Body() createDoctorDto: CreateDoctorDto) {
    return this.employeesService.createDoctor(createDoctorDto);
  }

  @Post('therapists')
  @ApiOperation({ summary: 'Create a new therapist' })
  @ApiCreatedResponse({
    description: 'The therapist has been successfully created.',
    type: Employee,
  })
  createTherapist(@Body() createTherapistDto: CreateTherapistDto) {
    return this.employeesService.createTherapist(createTherapistDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all employees' })
  @ApiOkResponse({
    description: 'Return all employees.',
    type: [Employee],
  })
  findAll(@Query() query: GetEmployeesQueryDto) {
    return this.employeesService.findAll(query);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get an employee by id' })
  @ApiOkResponse({
    description: 'Return the employee.',
    type: Employee,
  })
  @ApiNotFoundResponse({ description: 'Employee not found.' })
  findOne(@Param('id') id: string) {
    return this.employeesService.findOne(id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update an employee' })
  @ApiOkResponse({
    description: 'The employee has been successfully updated.',
    type: Employee,
  })
  @ApiNotFoundResponse({ description: 'Employee not found.' })
  update(
    @Param('id') id: string,
    @Body() updateEmployeeDto: UpdateEmployeeDto,
  ) {
    return this.employeesService.update(id, updateEmployeeDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete an employee' })
  @ApiOkResponse({ description: 'The employee has been successfully deleted.' })
  @ApiNotFoundResponse({ description: 'Employee not found.' })
  remove(@Param('id') id: string) {
    return this.employeesService.remove(id);
  }
}
