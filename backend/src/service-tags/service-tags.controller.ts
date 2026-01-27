import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
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
  ApiNoContentResponse,
  ApiNotFoundResponse,
  ApiForbiddenResponse,
  ApiConflictResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { ServiceTagsService } from './service-tags.service';
import { CreateServiceTagDto } from './dto/create-service-tag.dto';
import { UpdateServiceTagDto } from './dto/update-service-tag.dto';
import { ServiceTagResponseDto } from './dto/service-tag-response.dto';
import { AttachTagResponseDto } from './dto/attach-tag-response.dto';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/common/decorators/auth/roles.decorator';
import { Role } from '@/account/enum/role.enum';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';

/**
 * Controller for service tag management endpoints.
 * API Version 1.
 * Accessible by ADMIN and HEALTH_PARTNER roles.
 */
@ApiTags('service-tags')
@ApiBearerAuth()
@Controller({ path: 'service-tags', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
@UseInterceptors(ClassSerializerInterceptor)
@Roles(Role.ADMIN, Role.HEALTH_PARTNER)
export class ServiceTagsController {
  constructor(private readonly serviceTagsService: ServiceTagsService) {}

  /**
   * Creates a new service tag for the current user.
   */
  @Post()
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
  findActive(@CurrentUser('id') userId: string): Promise<ServiceTagResponseDto[]> {
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
  findOne(@Param('id', ParseUUIDPipe) id: string): Promise<ServiceTagResponseDto> {
    return this.serviceTagsService.findOne(id);
  }

  /**
   * Updates a service tag.
   */
  @Patch(':id')
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
  async attachToProduct(
    @Param('id', ParseUUIDPipe) tagId: string,
    @Param('productId', ParseUUIDPipe) productId: string,
    @CurrentUser('id') userId: string,
  ): Promise<AttachTagResponseDto> {
    const productTag = await this.serviceTagsService.attachToProduct(tagId, productId, userId);
    return {
      tagId: productTag.tagId,
      productId: productTag.productId,
      createdAt: productTag.createdAt,
    };
  }

  /**
   * Detaches a tag from a product.
   */
  @Delete(':id/products/:productId')
  @HttpCode(HttpStatus.NO_CONTENT)
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
