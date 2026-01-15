import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ServiceTagsService } from './service-tags.service';
import { ServiceTagsController } from './service-tags.controller';
import { ServiceTag } from './entities/service-tag.entity';
import { ProductTag } from './entities/product-tag.entity';
import { CreateServiceTagHandler } from './application/handlers/create-service-tag.handler';
import { UpdateServiceTagHandler } from './application/handlers/update-service-tag.handler';
import { RemoveServiceTagHandler } from './application/handlers/remove-service-tag.handler';

@Module({
  imports: [TypeOrmModule.forFeature([ServiceTag, ProductTag])],
  controllers: [ServiceTagsController],
  providers: [
    ServiceTagsService,
    CreateServiceTagHandler,
    UpdateServiceTagHandler,
    RemoveServiceTagHandler,
  ],
  exports: [ServiceTagsService],
})
export class ServiceTagsModule {}
