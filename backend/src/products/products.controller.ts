import {
  Controller,
  Get,
  Param,
  UseInterceptors,
  ClassSerializerInterceptor,
  ParseUUIDPipe,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { ProductsService } from './products.service';
import { ProductResponseDto } from './dto/product-response.dto';
import { ProductDetailResponseDto } from './dto/product-detail-response.dto';
import { Public } from '@/common/decorators/auth/public.decorator';

/**
 * Public controller for product browsing endpoints.
 * All endpoints are publicly accessible (no auth required).
 * API Version 1.
 */
@ApiTags('Products')
@Controller({ path: 'products', version: '1' })
@UseInterceptors(ClassSerializerInterceptor)
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  /**
   * Retrieves all products.
   */
  @Get()
  @Public()
  @ApiOperation({ summary: 'Get all products' })
  @ApiOkResponse({
    description: 'Return all products.',
    type: [ProductResponseDto],
  })
  findAll(): Promise<ProductResponseDto[]> {
    return this.productsService.findAll();
  }

  /**
   * Retrieves a product by ID.
   */
  @Get(':id')
  @Public()
  @ApiOperation({ summary: 'Get a product by id' })
  @ApiOkResponse({
    description: 'Return the product.',
    type: ProductResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Product not found.' })
  findOne(@Param('id', ParseUUIDPipe) id: string): Promise<ProductResponseDto> {
    return this.productsService.findOne(id);
  }

  /**
   * Retrieves full product details by slug (enriched response).
   */
  @Get('slug/:slug/details')
  @Public()
  @ApiOperation({ summary: 'Get full product details by slug' })
  @ApiOkResponse({
    description: 'Return enriched product details.',
    type: ProductDetailResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Product not found.' })
  getDetails(@Param('slug') slug: string): Promise<ProductDetailResponseDto> {
    return this.productsService.getProductDetails(slug);
  }

  /**
   * Retrieves a product by slug.
   */
  @Get('slug/:slug')
  @Public()
  @ApiOperation({ summary: 'Get a product by slug' })
  @ApiOkResponse({
    description: 'Return the product.',
    type: ProductResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Product not found.' })
  findBySlug(@Param('slug') slug: string): Promise<ProductResponseDto> {
    return this.productsService.findBySlug(slug);
  }
}
