import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Product } from '@/common/entities/product.entity';
import { PartnersModule } from '@/partners/partners.module';
import { AiServiceController } from './ai-service.controller';
import { AiServiceService } from './ai-service.service';
import { AiTokenAuthGuard } from './guards/ai-token-auth.guard';

@Module({
  imports: [TypeOrmModule.forFeature([Product]), PartnersModule],
  controllers: [AiServiceController],
  providers: [AiServiceService, AiTokenAuthGuard],
  exports: [AiServiceService],
})
export class AiServiceModule {}
