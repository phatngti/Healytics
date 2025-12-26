import {
  Controller,
  Get,
  Post,
  Body,
  Req,
  ConflictException,
  UseGuards,
} from '@nestjs/common';
import { AccountService } from './account.service';
import { SurveyDto } from './dto/request/survey.dto';
import { SurveyResponseDto } from './dto/response/survey-response.dto';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/auth/decorators/roles.decorator';
import { ALL_ROLES } from '@/auth/constants/role-groups';
import {
  ApiTags,
  ApiBearerAuth,
  ApiBody,
  ApiResponse,
  ApiOkResponse,
  ApiConflictResponse,
  ApiOperation,
} from '@nestjs/swagger';

@ApiTags('Account')
@ApiBearerAuth()
@Controller('account')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(...ALL_ROLES)
export class AccountController {
  constructor(private readonly accountService: AccountService) {}
  @Get('survey')
  @ApiOperation({ summary: 'Get current user survey' })
  @ApiOkResponse({ description: 'User survey', type: SurveyResponseDto })
  async getSurvey(@Req() req: any): Promise<SurveyResponseDto> {
    const id = req.user?.id;
    const survey = await this.accountService.getSurvey(id);
    if (survey === null) return { survey: null } as SurveyResponseDto;
    return { survey };
  }

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
    @Req() req: any,
    @Body() dto: SurveyDto,
  ): Promise<SurveyResponseDto> {
    const id = req.user?.id;
    const existing = await this.accountService.getSurvey(id);
    if (existing !== null) throw new ConflictException('Survey already exists');
    const created = await this.accountService.setSurvey(id, dto.survey);
    return { survey: created['survey'] };
  }
}
