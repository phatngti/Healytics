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
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiNotFoundResponse,
  ApiQuery,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { CategoriesService } from './categories.service';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
import { Category } from './entities/category.entity';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/auth/decorators/roles.decorator';
import { ADMIN_ROLES } from '@/auth/constants/role-groups';

@ApiTags('categories')
@ApiBearerAuth()
@Controller('categories')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(...ADMIN_ROLES)
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new category' })
  @ApiCreatedResponse({
    description: 'The category has been successfully created.',
    type: Category,
  })
  create(@Body() createCategoryDto: CreateCategoryDto) {
    return this.categoriesService.create(createCategoryDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all categories' })
  @ApiOkResponse({
    description: 'Return all categories.',
    type: [Category],
  })
  @ApiQuery({ name: 'rootsOnly', required: false, type: Boolean, description: 'Return only root categories' })
  findAll(@Query('rootsOnly') rootsOnly?: string) {
    if (rootsOnly === 'true') {
      return this.categoriesService.findRoots();
    }
    return this.categoriesService.findAll();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get a category by id' })
  @ApiOkResponse({
    description: 'Return the category.',
    type: Category,
  })
  @ApiNotFoundResponse({ description: 'Category not found.' })
  findOne(@Param('id') id: string) {
    return this.categoriesService.findOne(id);
  }

  @Get('slug/:slug')
  @ApiOperation({ summary: 'Get a category by slug' })
  @ApiOkResponse({
    description: 'Return the category.',
    type: Category,
  })
  @ApiNotFoundResponse({ description: 'Category not found.' })
  findBySlug(@Param('slug') slug: string) {
    return this.categoriesService.findBySlug(slug);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update a category' })
  @ApiOkResponse({
    description: 'The category has been successfully updated.',
    type: Category,
  })
  @ApiNotFoundResponse({ description: 'Category not found.' })
  update(
    @Param('id') id: string,
    @Body() updateCategoryDto: UpdateCategoryDto,
  ) {
    return this.categoriesService.update(id, updateCategoryDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete a category' })
  @ApiOkResponse({ description: 'The category has been successfully deleted.' })
  @ApiNotFoundResponse({ description: 'Category not found.' })
  remove(@Param('id') id: string) {
    return this.categoriesService.remove(id);
  }
}
