import {
  Get,
  Param,
  Query,
  ParseUUIDPipe,
  DefaultValuePipe,
  ParseIntPipe,
} from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
  ApiQuery,
} from '@nestjs/swagger';
import { EmployeesService } from './employees.service';
import { GetEmployeesQueryDto } from './dto/get-employees-query.dto';
import { GetTimeSlotsQueryDto } from './dto/get-time-slots-query.dto';
import { EmployeeResponseDto } from './dto/employee-response.dto';
import { BookingServiceResponseDto } from './dto/booking-service-response.dto';
import { FeaturedSpecialistResponseDto } from './dto/featured-specialist-response.dto';
import { EmployeeTimeSlotsResponseDto } from './dto/employee-time-slots-response.dto';
import { PublicEmployeeReviewResponseDto } from './dto/public-employee-review-response.dto';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { LogResponse } from '@/common/interceptors/response.interceptor';

/**
 * User controller for employee browsing.
 * All endpoints require USER authentication.
 * Route prefix: /v1/user/employees
 */
@UserApi('employees')
export class UserEmployeesController {
  constructor(private readonly employeesService: EmployeesService) {}

  /**
   * Returns featured specialists for the home page.
   * Ranked by completed booking count, then rating.
   */
  @Get('featured-specialists')
  @ApiOperation({ summary: 'Get featured specialists for home page' })
  @ApiOkResponse({
    description: 'Return list of featured specialists.',
    type: [FeaturedSpecialistResponseDto],
  })
  @ApiQuery({
    name: 'limit',
    required: false,
    type: Number,
    description: 'Max specialists to return (default 10)',
  })
  getFeaturedSpecialists(
    @Query('limit', new DefaultValuePipe(10), ParseIntPipe) limit: number,
  ): Promise<FeaturedSpecialistResponseDto[]> {
    return this.employeesService.getFeaturedSpecialists(limit);
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
  findAll(
    @Query() query: GetEmployeesQueryDto,
  ): Promise<EmployeeResponseDto[]> {
    return this.employeesService.findAll(query);
  }

  /**
   * Retrieves public reviews for an employee.
   */
  @Get(':id/reviews')
  @ApiOperation({ summary: 'Get reviews for an employee' })
  @ApiOkResponse({
    description: 'Return list of public employee reviews.',
    type: [PublicEmployeeReviewResponseDto],
  })
  @ApiNotFoundResponse({ description: 'Employee not found.' })
  findReviews(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<PublicEmployeeReviewResponseDto[]> {
    return this.employeesService.findReviewsByEmployee(id);
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
  findOne(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<EmployeeResponseDto> {
    return this.employeesService.findOne(id);
  }

  /**
   * Returns all configured time slots for an employee with availability.
   * Each slot is marked as 'free' or 'busy' based on existing bookings.
   * Slots are derived from the employee's weekly work schedule config.
   */
  @Get(':id/time-slots')
  @ApiOperation({ summary: 'Get time slots with availability for an employee' })
  @ApiOkResponse({
    description:
      'Return all time slots from the employee schedule, each marked free or busy.',
    type: EmployeeTimeSlotsResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Employee not found.' })
  getTimeSlots(
    @Param('id', ParseUUIDPipe) id: string,
    @Query() query: GetTimeSlotsQueryDto,
  ): Promise<EmployeeTimeSlotsResponseDto> {
    return this.employeesService.getTimeSlots(id, query);
  }

  /**
   * Retrieves all services a specialist can perform.
   * Used by the Book Appointment flow after selecting a specialist.
   */
  @Get(':id/services')
  @LogResponse()
  @ApiOperation({ summary: 'Get services for a specialist' })
  @ApiOkResponse({
    description: 'Return list of services for the given specialist.',
    type: [BookingServiceResponseDto],
  })
  @ApiNotFoundResponse({ description: 'Specialist not found.' })
  findServices(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<BookingServiceResponseDto[]> {
    return this.employeesService.findServicesBySpecialist(id);
  }
}
