import { Module } from '@nestjs/common';
import { AccountService } from './account.service';
import { EntitiesModule } from './entities.module';
import { AccountController } from './account.controller';
import { CreateAccountHandler } from './application/handlers/create-account.handler';
import { SetSurveyHandler } from './application/handlers/set-survey.handler';
import { SetRefreshTokenHandler } from './application/handlers/set-refresh-token.handler';

@Module({
  imports: [EntitiesModule],
  controllers: [AccountController],
  providers: [
    AccountService,
    CreateAccountHandler,
    SetSurveyHandler,
    SetRefreshTokenHandler,
  ],
  exports: [AccountService],
})
export class AccountModule {}
