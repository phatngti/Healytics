import { Module } from '@nestjs/common';
import { AccountService } from './account.service';
import { EntitiesModule } from './entities.module';

@Module({
  imports: [EntitiesModule],
  providers: [AccountService],
  exports: [AccountService],
})
export class AccountModule {}
