import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CategoriesService } from './categories.service';
import { CategoriesController } from './categories.controller';
import { AdminCategoriesController } from './admin-categories.controller';
import { Category } from '@/common/entities/category.entity';
import { CreateCategoryHandler } from './application/handlers/create-category.handler';
import { UpdateCategoryHandler } from './application/handlers/update-category.handler';
import { RemoveCategoryHandler } from './application/handlers/remove-category.handler';

@Module({
  imports: [TypeOrmModule.forFeature([Category])],
  controllers: [CategoriesController, AdminCategoriesController],
  providers: [
    CategoriesService,
    CreateCategoryHandler,
    UpdateCategoryHandler,
    RemoveCategoryHandler,
  ],
  exports: [CategoriesService],
})
export class CategoriesModule {}
