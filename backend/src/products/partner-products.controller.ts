import {
  Post,
  Body,
  Patch,
  Param,
  Delete,
  ParseUUIDPipe,
  HttpCode,
  HttpStatus,
  Get,
} from '@nestjs/common';
import {
  ApiOperation,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiNotFoundResponse,
  ApiNoContentResponse,
} from '@nestjs/swagger';
import { ProductsService } from './products.service';
import { CreatePartnerProductDto } from './dto/partner/create-partner-product.dto';
import { UpdatePartnerProductDto } from './dto/partner/update-partner-product.dto';
import { PartnerProductResponseDto } from './dto/partner/partner-product-response.dto';
import { PartnerApi } from '@/common/decorators/api/partner-api.decorator';
import { PartnerProductDetailResponseDto } from './dto/partner/partner-product-detail-response.dto';

/**
 * Partner controller for product management.
 * All endpoints require HEALTH_PARTNER authentication.
 * Route prefix: /v1/partner/products
 */
@PartnerApi('products')
export class PartnerProductsController {
  constructor(private readonly productsService: ProductsService) {}
   /**
     * Retrieves all products.
     */
    @Get()
    @ApiOperation({ summary: 'Get all products' })
    @ApiOkResponse({
      description: 'Return all products.',
      type: [PartnerProductResponseDto],
    })
    findAll(): Promise<PartnerProductResponseDto[]> {
      return this.productsService.findAll();
    }
  
    /**
     * Retrieves full product details by slug (enriched response).
     */
    @Get('slug/:slug/details')
    @ApiOperation({ summary: 'Get full product details by slug' })
    @ApiOkResponse({
      description: 'Return enriched product details.',
      type: PartnerProductDetailResponseDto,
    })
    @ApiNotFoundResponse({ description: 'Product not found.' })
    getDetails(@Param('slug') slug: string): Promise<PartnerProductDetailResponseDto> {
      return this.productsService.getProductDetails(slug);
    }
  
    /**
     * Retrieves a product by slug.
     */
    @Get('slug/:slug')
    @ApiOperation({ summary: 'Get a product by slug' })
    @ApiOkResponse({
      description: 'Return the product.',
      type: PartnerProductResponseDto,
    })
    @ApiNotFoundResponse({ description: 'Product not found.' })
    findBySlug(@Param('slug') slug: string): Promise<PartnerProductResponseDto> {
      return this.productsService.findBySlug(slug);
    }
  
  /**
   * Creates a new product.
   */
  @Post()
  @ApiOperation({ summary: 'Create a new product' })
  @ApiCreatedResponse({
    description: 'The product has been successfully created.',
    type: PartnerProductResponseDto,
  })
  create(@Body() createProductDto: CreatePartnerProductDto): Promise<PartnerProductResponseDto> {
    return this.productsService.create(createProductDto);
  }

  /**
   * Updates a product.
   */
  @Patch(':id')
  @ApiOperation({ summary: 'Update a product' })
  @ApiOkResponse({
    description: 'The product has been successfully updated.',
    type: PartnerProductResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Product not found.' })
  update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updateProductDto: UpdatePartnerProductDto,
  ): Promise<PartnerProductResponseDto> {
    return this.productsService.update(id, updateProductDto);
  }

  /**
   * Deletes a product (soft delete).
   */
  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a product' })
  @ApiNoContentResponse({
    description: 'The product has been successfully deleted.',
  })
  @ApiNotFoundResponse({ description: 'Product not found.' })
  remove(@Param('id', ParseUUIDPipe) id: string): Promise<void> {
    return this.productsService.remove(id);
  }
}
