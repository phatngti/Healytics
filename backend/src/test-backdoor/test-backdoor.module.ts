import { Module } from '@nestjs/common';
import { TestBackdoorController } from './test-backdoor.controller';
import { TestBackdoorService } from './test-backdoor.service';

@Module({
  controllers: [TestBackdoorController],
  providers: [TestBackdoorService],
})
export class TestBackdoorModule {}
