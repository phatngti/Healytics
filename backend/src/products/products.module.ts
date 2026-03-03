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
import { ProductDefinition } from '@/common/entities/product-definition.entity';
import { ResourceType } from '@/common/entities/resource-type.entity';
import { ProductResourceRequirement } from '@/common/entities/product-resource-requirement.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { Employee } from '@/common/entities/employee.entity';
import { PartnersModule } from '@/partners/partners.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Product,
      ProductMedia,
      ProductReview,
      ProductFacilityImage,
      ProductDefinition,
      ResourceType,
      ProductResourceRequirement,
      ProductEmployeeEligibility,
      Employee,
    ]),
    PartnersModule,
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
