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
import { PublicProductResponseDto } from './dto/public/public-product-response.dto';
import { PublicProductInfoResponseDto } from './dto/public/public-product-info-response.dto';
import { PublicProductEmployeeResponseDto } from './dto/public/public-product-employee-response.dto';
import { PublicProductReviewResponseDto } from './dto/public/public-product-review-response.dto';
import { PublicProductRecommendedResponseDto } from './dto/public/public-product-recommended-response.dto';
import { PublicProductCardResponseDto } from './dto/public/public-product-card-response.dto';
import { Public } from '@/common/decorators/auth/public.decorator';
import { LogResponse } from '@/common/interceptors/response.interceptor';

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

  // ─── Public Listing Endpoints ───────────────────────────────

  /**
   * Returns a list of premium treatment products.
   */
  @Get('premium-treatments')
  @Public()
  @ApiOperation({ summary: 'Get premium treatments' })
  @ApiOkResponse({
    description: 'Return list of premium treatments.',
    type: [PublicProductCardResponseDto],
  })
  getPremiumTreatments(): Promise<PublicProductCardResponseDto[]> {
    return this.productsService.getPremiumTreatments();
  }

  /**
   * Returns a list of home-recommended products.
   */
  @Get('home-recommend')
  @Public()
  @ApiOperation({ summary: 'Get home recommendations' })
  @ApiOkResponse({
    description: 'Return list of home recommended products.',
    type: [PublicProductCardResponseDto],
  })
  getHomeRecommend(): Promise<PublicProductCardResponseDto[]> {
    return this.productsService.getHomeRecommend();
  }

  // ─── User-facing Product Detail Endpoints ───────────────────

  /**
   * Retrieves product info (service info) by ID.
   */
  @Get(':id/info')
  @Public()
  @LogResponse()
  @ApiOperation({ summary: 'Get product info by ID' })
  @ApiOkResponse({
    description: 'Return product info for the detail screen.',
    type: PublicProductInfoResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Product not found.' })
  getProductInfo(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<PublicProductInfoResponseDto> {
    return this.productsService.getProductInfo(id);
  }

  /**
   * Retrieves eligible employees for a product/service.
   */
  
  @Get(':id/employees')
  @Public()
  @LogResponse()
  @ApiOperation({ summary: 'Get employees for a product' })
  @ApiOkResponse({
    description: 'Return list of eligible employees.',
    type: [PublicProductEmployeeResponseDto],
  })
  @ApiNotFoundResponse({ description: 'Product not found.' })
  getProductEmployees(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<PublicProductEmployeeResponseDto[]> {
    return this.productsService.getProductEmployees(id);
  }

  /**
   * Retrieves reviews for a product.
   */
  @Get(':id/reviews')
  @Public()
  @ApiOperation({ summary: 'Get reviews for a product' })
  @ApiOkResponse({
    description: 'Return list of reviews.',
    type: [PublicProductReviewResponseDto],
  })
  @ApiNotFoundResponse({ description: 'Product not found.' })
  getProductReviews(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<PublicProductReviewResponseDto[]> {
    return this.productsService.getProductReviews(id);
  }

  /**
   * Retrieves recommended products from the same category.
   */
  @Get(':id/recommended')
  @Public()
  @ApiOperation({ summary: 'Get recommended products' })
  @ApiOkResponse({
    description: 'Return list of recommended products.',
    type: [PublicProductRecommendedResponseDto],
  })
  @ApiNotFoundResponse({ description: 'Product not found.' })
  getRecommendedProducts(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<PublicProductRecommendedResponseDto[]> {
    return this.productsService.getRecommendedProducts(id);
  }

  /**
   * Retrieves a product by ID.
   */
  @Get(':id')
  @Public()
  @ApiOperation({ summary: 'Get a product by id' })
  @ApiOkResponse({
    description: 'Return the product.',
    type: PublicProductResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Product not found.' })
  findOne(@Param('id', ParseUUIDPipe) id: string): Promise<PublicProductResponseDto> {
    return this.productsService.findOne(id);
  }
}

