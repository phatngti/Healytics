import { Controller, Get, Post, Body, Req, ConflictException, UseGuards } from '@nestjs/common';
import { AccountService } from './account.service';
import { SurveyDto } from './dto/survey.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('account')
@UseGuards(JwtAuthGuard)
export class AccountController {
  constructor(private readonly accountService: AccountService) {}
  @Get('survey')
  async getSurvey(@Req() req: any) {
    const id = req.user?.id;
    const survey = await this.accountService.getSurvey(id);
    if (survey === null) return { survey: null };
    return { survey };
  }

  @Post('survey')
  async postSurvey(@Req() req: any, @Body() dto: SurveyDto) {
    const id = req.user?.id;
    const existing = await this.accountService.getSurvey(id);
    if (existing !== null) throw new ConflictException('Survey already exists');
    const created = await this.accountService.setSurvey(id, dto.survey);
    return { survey: created['survey'] };
  }
}
