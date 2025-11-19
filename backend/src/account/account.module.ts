import { Module } from '@nestjs/common';
import { AccountService } from './account.service';
import { EntitiesModule } from './entities.module';
import { AccountController } from './account.controller';

@Module({
  imports: [EntitiesModule],
  controllers: [AccountController],
  providers: [AccountService],
  exports: [AccountService],
})
export class AccountModule {}
