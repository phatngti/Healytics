import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Account } from './entities/account.entity';
import { UserProfile } from './entities/user-profile.entity';
// UserPreference moved to its own preferences module

@Module({
  imports: [TypeOrmModule.forFeature([Account, UserProfile])],
  exports: [TypeOrmModule],
})
export class EntitiesModule {}
