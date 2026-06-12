import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AccountService } from './account.service';
import { Account, Address, UserProfile } from '@/common/entities';
import { AccountController } from './account.controller';
import { CreateAccountHandler } from './application/handlers/create-account.handler';
import { SetSurveyHandler } from './application/handlers/set-survey.handler';
import { SetRefreshTokenHandler } from './application/handlers/set-refresh-token.handler';
import { LocationsModule } from '@/locations/locations.module';
import { MapboxModule } from '@/mapbox/mapbox.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Account, UserProfile, Address]),
    LocationsModule,
    MapboxModule,
  ],
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
