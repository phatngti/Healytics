import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  UseGuards,
  UseInterceptors,
  ClassSerializerInterceptor,
  ParseUUIDPipe,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiNotFoundResponse,
  ApiNoContentResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { CategoriesService } from './categories.service';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
import { CategoryResponseDto } from './dto/category-response.dto';
import { FindCategoriesQueryDto } from './dto/find-categories-query.dto';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/common/decorators/auth/roles.decorator';
import { ADMIN_ROLES } from '@/auth/constants/role-groups';
import { Public } from '@/common/decorators/auth/public.decorator';

/**
 * Controller for category management endpoints.
 * API Version 1.
 */
@ApiTags('categories')
@ApiBearerAuth()
@Controller({ path: 'categories', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
@UseInterceptors(ClassSerializerInterceptor)
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  /**
   * Creates a new category.
   */
  @Post()
  @Roles(...ADMIN_ROLES)
  @ApiOperation({ summary: 'Create a new category' })
  @ApiCreatedResponse({
    description: 'The category has been successfully created.',
    type: CategoryResponseDto,
  })
  create(@Body() createCategoryDto: CreateCategoryDto): Promise<CategoryResponseDto> {
    return this.categoriesService.create(createCategoryDto);
  }

  /**
   * Retrieves all categories or only root categories.
   */
  @Get()
  @Public()
  @ApiOperation({ summary: 'Get all categories' })
  @ApiOkResponse({
    description: 'Return all categories.',
    type: [CategoryResponseDto],
  })
  findAll(@Query() query: FindCategoriesQueryDto): Promise<CategoryResponseDto[]> {
    return this.categoriesService.findAll(query.rootsOnly ?? false);
  }

  /**
   * Retrieves a category by ID.
   */
  @Get(':id')
  @Public()
  @ApiOperation({ summary: 'Get a category by id' })
  @ApiOkResponse({
    description: 'Return the category.',
    type: CategoryResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Category not found.' })
  findOne(@Param('id', ParseUUIDPipe) id: string): Promise<CategoryResponseDto> {
    return this.categoriesService.findOne(id);
  }

  /**
   * Retrieves a category by slug.
   */
  @Get('slug/:slug')
  @Public()
  @ApiOperation({ summary: 'Get a category by slug' })
  @ApiOkResponse({
    description: 'Return the category.',
    type: CategoryResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Category not found.' })
  findBySlug(@Param('slug') slug: string): Promise<CategoryResponseDto> {
    return this.categoriesService.findBySlug(slug);
  }

  /**
   * Updates a category.
   */
  @Patch(':id')
  @Roles(...ADMIN_ROLES)
  @ApiOperation({ summary: 'Update a category' })
  @ApiOkResponse({
    description: 'The category has been successfully updated.',
    type: CategoryResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Category not found.' })
  update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updateCategoryDto: UpdateCategoryDto,
  ): Promise<CategoryResponseDto> {
    return this.categoriesService.update(id, updateCategoryDto);
  }

  /**
   * Deletes a category (soft delete).
   */
  @Delete(':id')
  @Roles(...ADMIN_ROLES)
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a category' })
  @ApiNoContentResponse({
    description: 'The category has been successfully deleted.',
  })
  @ApiNotFoundResponse({ description: 'Category not found.' })
  remove(@Param('id', ParseUUIDPipe) id: string): Promise<void> {
    return this.categoriesService.remove(id);
  }
}
