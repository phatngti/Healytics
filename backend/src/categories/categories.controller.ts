import { Get, Param, Query, ParseUUIDPipe } from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { PublicApi } from '@/common/decorators/api/public-api.decorator';
import { CategoriesService } from './categories.service';
import { CategoryResponseDto } from './dto/category-response.dto';
import { FindCategoriesQueryDto } from './dto/find-categories-query.dto';

/**
 * Public controller for category browsing endpoints.
 * All endpoints are publicly accessible (no auth required).
 * Route prefix: /v1/categories
 */
@PublicApi('categories')
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  /**
   * Retrieves all categories or only root categories.
   */
  @Get()
  @ApiOperation({ summary: 'Get all categories' })
  @ApiOkResponse({
    description: 'Return all categories.',
    type: [CategoryResponseDto],
  })
  findAll(
    @Query() query: FindCategoriesQueryDto,
  ): Promise<CategoryResponseDto[]> {
    return this.categoriesService.findAll(query.rootsOnly ?? false);
  }

  /**
   * Retrieves a category by ID.
   */
  @Get(':id')
  @ApiOperation({ summary: 'Get a category by id' })
  @ApiOkResponse({
    description: 'Return the category.',
    type: CategoryResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Category not found.' })
  findOne(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<CategoryResponseDto> {
    return this.categoriesService.findOne(id);
  }

  /**
   * Retrieves a category by slug.
   */
  @Get('slug/:slug')
  @ApiOperation({ summary: 'Get a category by slug' })
  @ApiOkResponse({
    description: 'Return the category.',
    type: CategoryResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Category not found.' })
  findBySlug(@Param('slug') slug: string): Promise<CategoryResponseDto> {
    return this.categoriesService.findBySlug(slug);
  }
}
