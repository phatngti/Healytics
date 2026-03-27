import {
  Controller,
  Get,
  Post,
  Body,
  UseGuards,
  UseInterceptors,
  ClassSerializerInterceptor,
} from '@nestjs/common';
import { AccountService } from './account.service';
import { SurveyDto } from './dto/request/survey.dto';
import { SurveyResponseDto } from './dto/response/survey-response.dto';
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
   * Gets the current user's survey data.
   */
  @Get('survey')
  @ApiOperation({ summary: 'Get current user survey' })
  @ApiOkResponse({ description: 'User survey data.', type: SurveyResponseDto })
  async getSurvey(@CurrentUser('id') userId: string): Promise<SurveyResponseDto> {
    return this.accountService.getSurveyResponse(userId);
  }

  /**
   * Creates a one-shot survey for the current user.
   * Throws ConflictException if survey already exists (handled by service).
   */
  @Post('survey')
  @Throttle({ default: { limit: 5, ttl: 60000 } })
  @ApiOperation({ summary: 'Create one-shot survey for current user' })
  @ApiCreatedResponse({ description: 'Survey created.', type: SurveyResponseDto })
  @ApiConflictResponse({ description: 'Survey already exists.' })
  async postSurvey(
    @CurrentUser('id') userId: string,
    @Body() dto: SurveyDto,
  ): Promise<SurveyResponseDto> {
    return this.accountService.createSurvey(userId, dto.survey);
  }
}
