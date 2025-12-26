import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductsService } from './products.service';
import { ProductsController } from './products.controller';
import { Product } from './entities/product.entity';
import { ProductMedia } from './entities/product-media.entity';
import { ProductPhysicalDetails } from './entities/product-physical-details.entity';
import { ServiceDefinition } from './entities/service-definition.entity';
import { ResourceType } from './entities/resource-type.entity';
import { ServiceResourceRequirement } from './entities/service-resource-requirement.entity';
import { ServiceEmployeeEligibility } from './entities/service-employee-eligibility.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Product,
      ProductMedia,
      ProductPhysicalDetails,
      ServiceDefinition,
      ResourceType,
      ServiceResourceRequirement,
      ServiceEmployeeEligibility,
    ]),
  ],
  controllers: [ProductsController],
  providers: [ProductsService],
  exports: [ProductsService],
})
export class ProductsModule {}
