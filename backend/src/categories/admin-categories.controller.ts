import {
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  ParseUUIDPipe,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import {
  ApiOperation,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiNotFoundResponse,
  ApiNoContentResponse,
} from '@nestjs/swagger';
import { AdminApi } from '@/common/decorators/api/admin-api.decorator';
import { CategoriesService } from './categories.service';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
import { AdminCategoryResponseDto } from './dto/admin-category-response.dto';

/**
 * Admin controller for category management.
 * Uses @AdminApi() composite decorator → ADMIN_ROLES, /v1/admin/categories.
 *
 * Security: JwtAuthGuard → RolesGuard → ADMIN_ROLES
 */
@AdminApi('categories')
export class AdminCategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  /**
   * Lists all categories with admin-level detail (iconName, colorValue, sortOrder, serviceCount).
   */
  @Get()
  @ApiOperation({ summary: 'List all categories (admin view)' })
  @ApiOkResponse({
    description: 'Return all categories with admin fields.',
    type: [AdminCategoryResponseDto],
  })
  findAll(): Promise<AdminCategoryResponseDto[]> {
    return this.categoriesService.findAllForAdmin();
  }

  /**
   * Gets a single category by ID with admin-level detail.
   */
  @Get(':id')
  @ApiOperation({ summary: 'Get a category by id (admin view)' })
  @ApiOkResponse({
    description: 'Return the category with admin fields.',
    type: AdminCategoryResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Category not found.' })
  findOne(@Param('id', ParseUUIDPipe) id: string): Promise<AdminCategoryResponseDto> {
    return this.categoriesService.findOneForAdmin(id);
  }

  /**
   * Creates a new category.
   */
  @Post()
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @ApiOperation({ summary: 'Create a new category' })
  @ApiCreatedResponse({
    description: 'The category has been successfully created.',
    type: AdminCategoryResponseDto,
  })
  create(@Body() createCategoryDto: CreateCategoryDto): Promise<AdminCategoryResponseDto> {
    return this.categoriesService.createForAdmin(createCategoryDto);
  }

  /**
   * Updates a category.
   */
  @Patch(':id')
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @ApiOperation({ summary: 'Update a category' })
  @ApiOkResponse({
    description: 'The category has been successfully updated.',
    type: AdminCategoryResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Category not found.' })
  update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updateCategoryDto: UpdateCategoryDto,
  ): Promise<AdminCategoryResponseDto> {
    return this.categoriesService.updateForAdmin(id, updateCategoryDto);
  }

  /**
   * Deletes a category (soft delete).
   */
  @Delete(':id')
  @Throttle({ default: { limit: 10, ttl: 60000 } })
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
