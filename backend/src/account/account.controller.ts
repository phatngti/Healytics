import {
  Controller,
  Get,
  Post,
  Body,
  ConflictException,
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
import {
  ApiTags,
  ApiBearerAuth,
  ApiBody,
  ApiResponse,
  ApiOkResponse,
  ApiConflictResponse,
  ApiOperation,
} from '@nestjs/swagger';

/**
 * Controller for account management endpoints.
 * API Version 1.
 */
@ApiTags('Account')
@ApiBearerAuth()
@Controller({ path: 'account', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
@UseInterceptors(ClassSerializerInterceptor)
@Roles(...ALL_ROLES)
export class AccountController {
  constructor(private readonly accountService: AccountService) {}

  /**
   * Gets the current user's survey data.
   */
  @Get('survey')
  @ApiOperation({ summary: 'Get current user survey' })
  @ApiOkResponse({ description: 'User survey', type: SurveyResponseDto })
  async getSurvey(@CurrentUser('id') userId: string): Promise<SurveyResponseDto> {
    const survey = await this.accountService.getSurvey(userId);
    if (survey === null) return { survey: null } as SurveyResponseDto;
    return { survey };
  }

  /**
   * Creates a one-shot survey for the current user.
   */
  @Post('survey')
  @ApiOperation({ summary: 'Create one-shot survey for current user' })
  @ApiBody({ type: SurveyDto })
  @ApiResponse({
    status: 201,
    description: 'Survey created',
    type: SurveyResponseDto,
  })
  @ApiConflictResponse({ description: 'Survey already exists' })
  async postSurvey(
    @CurrentUser('id') userId: string,
    @Body() dto: SurveyDto,
  ): Promise<SurveyResponseDto> {
    const existing = await this.accountService.getSurvey(userId);
    if (existing !== null) throw new ConflictException('Survey already exists');
    const created = await this.accountService.setSurvey(userId, dto.survey);
    return { survey: created['survey'] };
  }
}
