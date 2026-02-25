import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductsService } from './products.service';
import { CreateProductHandler } from './application/handlers/create-product.handler';
import { UpdateProductHandler } from './application/handlers/update-product.handler';
import { RemoveProductHandler } from './application/handlers/remove-product.handler';
import { ProductsController } from './products.controller';
import { PartnerProductsController } from './partner-products.controller';
import { Product } from '@/common/entities/product.entity';
import { ProductMedia } from '@/common/entities/product-media.entity';
import { ProductReview } from '@/common/entities/product-review.entity';
import { ProductFacilityImage } from '@/common/entities/product-facility-image.entity';
import { ServiceDefinition } from '@/common/entities/service-definition.entity';
import { ResourceType } from '@/common/entities/resource-type.entity';
import { ServiceResourceRequirement } from '@/common/entities/service-resource-requirement.entity';
import { ServiceEmployeeEligibility } from '@/common/entities/service-employee-eligibility.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Product,
      ProductMedia,
      ProductReview,
      ProductFacilityImage,
      ServiceDefinition,
      ResourceType,
      ServiceResourceRequirement,
      ServiceEmployeeEligibility,
    ]),
  ],
  controllers: [ProductsController, PartnerProductsController],
  providers: [
    ProductsService,
    CreateProductHandler,
    UpdateProductHandler,
    RemoveProductHandler,
  ],
  exports: [ProductsService],
})
export class ProductsModule {}
