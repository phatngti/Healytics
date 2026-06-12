import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CategoriesService } from './categories.service';
import { CategoriesController } from './categories.controller';
import { UserCategoriesController } from './user-categories.controller';
import { AdminCategoriesController } from './admin-categories.controller';
import { Category } from '@/common/entities/category.entity';
import { Product } from '@/common/entities/product.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { Employee } from '@/common/entities/employee.entity';
import { PartnersModule } from '@/partners/partners.module';
import { SearchModule } from '@/search/search.module';
import { CreateCategoryHandler } from './application/handlers/create-category.handler';
import { UpdateCategoryHandler } from './application/handlers/update-category.handler';
import { RemoveCategoryHandler } from './application/handlers/remove-category.handler';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Category,
      Product,
      ProductEmployeeEligibility,
      Employee,
    ]),
    PartnersModule,
    SearchModule,
  ],
  controllers: [
    CategoriesController,
    UserCategoriesController,
    AdminCategoriesController,
  ],
  providers: [
    CategoriesService,
    CreateCategoryHandler,
    UpdateCategoryHandler,
    RemoveCategoryHandler,
  ],
  exports: [CategoriesService],
})
export class CategoriesModule {}
