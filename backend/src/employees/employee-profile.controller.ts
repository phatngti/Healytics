import { Get, Patch, Body } from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { EmployeeApi } from '@/common/decorators/api/employee-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { EmployeeResponseDto } from './dto/employee-response.dto';
import { UpdateEmployeeProfileDto } from './dto/employee/update-employee-profile.dto';
import { GetEmployeeProfileHandler } from './application/handlers/get-employee-profile.handler';
import { UpdateEmployeeProfileHandler } from './application/handlers/update-employee-profile.handler';

/**
 * Employee self-service profile controller.
 * All endpoints require EMPLOYEE authentication.
 * Route prefix: /v1/employee/profile
 */
@EmployeeApi('profile')
export class EmployeeProfileController {
  constructor(
    private readonly getProfileHandler: GetEmployeeProfileHandler,
    private readonly updateProfileHandler: UpdateEmployeeProfileHandler,
  ) {}

  /**
   * Retrieves the authenticated employee's own profile.
   */
  @Get()
  @ApiOperation({ summary: 'Get my employee profile' })
  @ApiOkResponse({
    description: 'Return the authenticated employee profile.',
    type: EmployeeResponseDto,
  })
  @ApiNotFoundResponse({
    description: 'No employee profile linked to this account.',
  })
  async getMyProfile(
    @CurrentUser('id') accountId: string,
  ): Promise<EmployeeResponseDto> {
    return this.getProfileHandler.execute(accountId);
  }

  /**
   * Updates the authenticated employee's own profile.
   * Only allowed fields (phone, avatar, description, schedule, emergency contacts).
   */
  @Patch()
  @ApiOperation({ summary: 'Update my employee profile' })
  @ApiOkResponse({
    description: 'The profile has been successfully updated.',
    type: EmployeeResponseDto,
  })
  @ApiNotFoundResponse({
    description: 'No employee profile linked to this account.',
  })
  async updateMyProfile(
    @CurrentUser('id') accountId: string,
    @Body() dto: UpdateEmployeeProfileDto,
  ): Promise<EmployeeResponseDto> {
    return this.updateProfileHandler.execute(accountId, dto);
  }
}
