import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductsService } from './products.service';
import { CreateProductHandler } from './application/handlers/create-product.handler';
import { UpdateProductHandler } from './application/handlers/update-product.handler';
import { RemoveProductHandler } from './application/handlers/remove-product.handler';
import { ProductsController } from './products.controller';
import { Product } from './entities/product.entity';
import { ProductMedia } from './entities/product-media.entity';

import { ServiceDefinition } from './entities/service-definition.entity';
import { ResourceType } from './entities/resource-type.entity';
import { ServiceResourceRequirement } from './entities/service-resource-requirement.entity';
import { ServiceEmployeeEligibility } from './entities/service-employee-eligibility.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Product,
      ProductMedia,

      ServiceDefinition,
      ResourceType,
      ServiceResourceRequirement,
      ServiceEmployeeEligibility,
    ]),
  ],
  controllers: [ProductsController],
  providers: [
    ProductsService,
    CreateProductHandler,
    UpdateProductHandler,
    RemoveProductHandler,
  ],
  exports: [ProductsService],
})
export class ProductsModule {}
