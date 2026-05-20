import {
  Controller,
  Get,
  Post,
  Patch,
  Body,
  UseGuards,
  UseInterceptors,
  ClassSerializerInterceptor,
} from '@nestjs/common';
import { AccountService } from './account.service';
import { SurveyDto } from './dto/request/survey.dto';
import { UpdateAvatarDto } from './dto/request/update-avatar.dto';
import { UpdateAccountAddressDto } from './dto/request/update-account-address.dto';
import { UpdateAccountProfileDto } from './dto/request/update-account-profile.dto';
import { SurveyResponseDto } from './dto/response/survey-response.dto';
import { AccountMeResponseDto } from './dto/response/account-me-response.dto';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/common/decorators/auth/roles.decorator';
import { ALL_ROLES } from '@/auth/constants/role-groups';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { Throttle } from '@nestjs/throttler';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOkResponse,
  ApiCreatedResponse,
  ApiConflictResponse,
  ApiOperation,
} from '@nestjs/swagger';

/**
 * Controller for account management endpoints.
 * Uses ALL_ROLES — all authenticated users can access these endpoints.
 *
 * Security: JwtAuthGuard → RolesGuard → ALL_ROLES
 * Route prefix: /v1/account
 */
@ApiTags('Account')
@ApiBearerAuth()
@Controller({ path: 'account', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(...ALL_ROLES)
@UseInterceptors(ClassSerializerInterceptor)
export class AccountController {
  constructor(private readonly accountService: AccountService) {}

  /**
   * Returns the current authenticated user's full account data including role.
   */
  @Get('me')
  @ApiOperation({ summary: 'Get current user account details' })
  @ApiOkResponse({
    description: 'Current user account data with role.',
    type: AccountMeResponseDto,
  })
  async getMe(
    @CurrentUser('id') userId: string,
  ): Promise<AccountMeResponseDto> {
    return this.accountService.getMe(userId);
  }

  /**
   * Updates the current user's avatar URL (S3 key).
   */
  @Patch('me/avatar')
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @ApiOperation({ summary: 'Update current user avatar' })
  @ApiOkResponse({
    description: 'Avatar updated, returns refreshed account data.',
    type: AccountMeResponseDto,
  })
  async updateAvatar(
    @CurrentUser('id') userId: string,
    @Body() dto: UpdateAvatarDto,
  ): Promise<AccountMeResponseDto> {
    return this.accountService.updateAvatar(userId, dto.avatarUrl);
  }

  /**
   * Updates the current user's personal identity fields.
   */
  @Patch('me/profile')
  @Throttle({ default: { limit: 20, ttl: 60000 } })
  @ApiOperation({ summary: 'Update current user profile identity' })
  @ApiOkResponse({
    description: 'Profile updated, returns refreshed account data.',
    type: AccountMeResponseDto,
  })
  async updateProfile(
    @CurrentUser('id') userId: string,
    @Body() dto: UpdateAccountProfileDto,
  ): Promise<AccountMeResponseDto> {
    return this.accountService.updateProfile(userId, dto);
  }

  /**
   * Updates the current user's saved address.
   */
  @Patch('me/address')
  @Throttle({ default: { limit: 20, ttl: 60000 } })
  @ApiOperation({ summary: 'Update current user address' })
  @ApiOkResponse({
    description: 'Address updated, returns refreshed account data.',
    type: AccountMeResponseDto,
  })
  async updateAddress(
    @CurrentUser('id') userId: string,
    @Body() dto: UpdateAccountAddressDto,
  ): Promise<AccountMeResponseDto> {
    return this.accountService.updateAddress(userId, dto);
  }

  /**
   * Gets the current user's survey data.
   */
  @Get('survey')
  @ApiOperation({ summary: 'Get current user survey' })
  @ApiOkResponse({ description: 'User survey data.', type: SurveyResponseDto })
  async getSurvey(
    @CurrentUser('id') userId: string,
  ): Promise<SurveyResponseDto> {
    return this.accountService.getSurveyResponse(userId);
  }

  /**
   * Creates a one-shot survey for the current user.
   * Throws ConflictException if survey already exists (handled by service).
   */
  @Post('survey')
  @Throttle({ default: { limit: 5, ttl: 60000 } })
  @ApiOperation({ summary: 'Create one-shot survey for current user' })
  @ApiCreatedResponse({
    description: 'Survey created.',
    type: SurveyResponseDto,
  })
  @ApiConflictResponse({ description: 'Survey already exists.' })
  async postSurvey(
    @CurrentUser('id') userId: string,
    @Body() dto: SurveyDto,
  ): Promise<SurveyResponseDto> {
    return this.accountService.createSurvey(userId, dto.survey);
  }
}
