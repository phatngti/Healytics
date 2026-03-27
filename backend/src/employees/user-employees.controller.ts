import {
  Get,
  Param,
  Query,
  ParseUUIDPipe,
} from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { EmployeesService } from './employees.service';
import { GetEmployeesQueryDto } from './dto/get-employees-query.dto';
import { EmployeeResponseDto } from './dto/employee-response.dto';
import { UserApi } from '@/common/decorators/api/user-api.decorator';

/**
 * User controller for employee browsing.
 * All endpoints require USER authentication.
 * Route prefix: /v1/user/employees
 */
@UserApi('employees')
export class UserEmployeesController {
  constructor(private readonly employeesService: EmployeesService) {}

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
}
