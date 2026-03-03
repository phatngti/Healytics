import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ServiceTagsService } from './service-tags.service';
import { ServiceTagsController } from './service-tags.controller';
import { ProductFeatureTag } from '@/common/entities/product-feature-tag.entity';
import { ProductTag } from '@/common/entities/product-tag.entity';
import { CreateServiceTagHandler } from './application/handlers/create-service-tag.handler';
import { UpdateServiceTagHandler } from './application/handlers/update-service-tag.handler';
import { RemoveServiceTagHandler } from './application/handlers/remove-service-tag.handler';
import { AttachProductTagHandler } from './application/handlers/attach-product-tag.handler';
import { DetachProductTagHandler } from './application/handlers/detach-product-tag.handler';

@Module({
  imports: [TypeOrmModule.forFeature([ProductFeatureTag, ProductTag])],
  controllers: [ServiceTagsController],
  providers: [
    ServiceTagsService,
    CreateServiceTagHandler,
    UpdateServiceTagHandler,
    RemoveServiceTagHandler,
    AttachProductTagHandler,
    DetachProductTagHandler,
  ],
  exports: [ServiceTagsService],
})
export class ServiceTagsModule {}

