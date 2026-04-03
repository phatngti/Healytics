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
import {
  ApiOperation,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiNoContentResponse,
  ApiNotFoundResponse,
  ApiForbiddenResponse,
  ApiConflictResponse,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { PartnerApi } from '@/common/decorators/api/partner-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { ServiceTagsService } from './service-tags.service';
import { CreateServiceTagDto } from './dto/create-service-tag.dto';
import { UpdateServiceTagDto } from './dto/update-service-tag.dto';
import { ServiceTagResponseDto } from './dto/service-tag-response.dto';
import { AttachTagResponseDto } from './dto/attach-tag-response.dto';

/**
 * Controller for service tag management endpoints.
 * Uses @PartnerApi composite decorator → HEALTH_PARTNER role, /v1/partner/service-tags.
 */
@PartnerApi('service-tags')
export class ServiceTagsController {
  constructor(private readonly serviceTagsService: ServiceTagsService) {}

  /**
   * Creates a new service tag for the current user.
   */
  @Post()
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Create a new service tag' })
  @ApiCreatedResponse({
    description: 'The service tag has been successfully created.',
    type: ServiceTagResponseDto,
  })
  create(
    @Body() createServiceTagDto: CreateServiceTagDto,
    @CurrentUser('id') userId: string,
  ): Promise<ServiceTagResponseDto> {
    return this.serviceTagsService.create(createServiceTagDto, userId);
  }

  /**
   * Retrieves all service tags for the current user.
   */
  @Get()
  @ApiOperation({ summary: 'Get all service tags for current user' })
  @ApiOkResponse({
    description: 'Return all service tags for the current user.',
    type: [ServiceTagResponseDto],
  })
  findAll(@CurrentUser('id') userId: string): Promise<ServiceTagResponseDto[]> {
    return this.serviceTagsService.findAllByUser(userId);
  }

  /**
   * Retrieves active service tags for the current user.
   */
  @Get('active')
  @ApiOperation({ summary: 'Get active service tags for current user' })
  @ApiOkResponse({
    description: 'Return active service tags for the current user.',
    type: [ServiceTagResponseDto],
  })
  findActive(
    @CurrentUser('id') userId: string,
  ): Promise<ServiceTagResponseDto[]> {
    return this.serviceTagsService.findActiveByUser(userId);
  }

  /**
   * Retrieves a service tag by ID.
   */
  @Get(':id')
  @ApiOperation({ summary: 'Get a service tag by ID' })
  @ApiOkResponse({
    description: 'Return the service tag.',
    type: ServiceTagResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Service tag not found.' })
  findOne(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<ServiceTagResponseDto> {
    return this.serviceTagsService.findOne(id);
  }

  /**
   * Updates a service tag.
   */
  @Patch(':id')
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Update a service tag' })
  @ApiOkResponse({
    description: 'The service tag has been successfully updated.',
    type: ServiceTagResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Service tag not found.' })
  @ApiForbiddenResponse({ description: 'Not authorized to update this tag.' })
  update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updateServiceTagDto: UpdateServiceTagDto,
    @CurrentUser('id') userId: string,
  ): Promise<ServiceTagResponseDto> {
    return this.serviceTagsService.update(id, updateServiceTagDto, userId);
  }

  /**
   * Deletes a service tag (soft delete).
   */
  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Delete a service tag' })
  @ApiNoContentResponse({
    description: 'The service tag has been successfully deleted.',
  })
  @ApiNotFoundResponse({ description: 'Service tag not found.' })
  @ApiForbiddenResponse({ description: 'Not authorized to delete this tag.' })
  remove(
    @Param('id', ParseUUIDPipe) id: string,
    @CurrentUser('id') userId: string,
  ): Promise<void> {
    return this.serviceTagsService.remove(id, userId);
  }

  /**
   * Attaches a tag to a product.
   */
  @Post(':id/products/:productId')
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Attach a tag to a product' })
  @ApiCreatedResponse({
    description: 'Tag attached to product successfully.',
    type: AttachTagResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Tag or product not found.' })
  @ApiForbiddenResponse({ description: 'Not authorized to use this tag.' })
  @ApiConflictResponse({
    description: 'Tag is already attached to this product.',
  })
  attachToProduct(
    @Param('id', ParseUUIDPipe) tagId: string,
    @Param('productId', ParseUUIDPipe) productId: string,
    @CurrentUser('id') userId: string,
  ): Promise<AttachTagResponseDto> {
    return this.serviceTagsService.attachToProduct(tagId, productId, userId);
  }

  /**
   * Detaches a tag from a product.
   */
  @Delete(':id/products/:productId')
  @HttpCode(HttpStatus.NO_CONTENT)
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Detach a tag from a product' })
  @ApiNoContentResponse({
    description: 'Tag detached from product successfully.',
  })
  @ApiNotFoundResponse({
    description: 'Tag or product-tag relationship not found.',
  })
  @ApiForbiddenResponse({ description: 'Not authorized to modify this tag.' })
  detachFromProduct(
    @Param('id', ParseUUIDPipe) tagId: string,
    @Param('productId', ParseUUIDPipe) productId: string,
    @CurrentUser('id') userId: string,
  ): Promise<void> {
    return this.serviceTagsService.detachFromProduct(tagId, productId, userId);
  }

  /**
   * Gets all tags attached to a product.
   */
  @Get('products/:productId')
  @ApiOperation({ summary: 'Get all tags attached to a product' })
  @ApiOkResponse({
    description: 'Return all tags for the product.',
    type: [ServiceTagResponseDto],
  })
  getTagsForProduct(
    @Param('productId', ParseUUIDPipe) productId: string,
  ): Promise<ServiceTagResponseDto[]> {
    return this.serviceTagsService.getTagsForProduct(productId);
  }
}
