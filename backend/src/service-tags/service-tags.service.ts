import {
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { ProductFeatureTag } from '@/common/entities/product-feature-tag.entity';
import { ProductTag } from '@/common/entities/product-tag.entity';
import { CreateServiceTagDto } from './dto/create-service-tag.dto';
import { UpdateServiceTagDto } from './dto/update-service-tag.dto';
import { ServiceTagResponseDto } from './dto/service-tag-response.dto';
import { AttachTagResponseDto } from './dto/attach-tag-response.dto';
import { CreateServiceTagHandler } from './application/handlers/create-service-tag.handler';
import { UpdateServiceTagHandler } from './application/handlers/update-service-tag.handler';
import { RemoveServiceTagHandler } from './application/handlers/remove-service-tag.handler';
import { AttachProductTagHandler } from './application/handlers/attach-product-tag.handler';
import { DetachProductTagHandler } from './application/handlers/detach-product-tag.handler';

/**
 * Service facade for service tag operations.
 * Delegates mutations to handlers and provides read operations.
 * Always returns Response DTOs — never raw entities.
 */
@Injectable()
export class ServiceTagsService {
  private readonly logger = new Logger(ServiceTagsService.name);

  constructor(
    @InjectRepository(ProductFeatureTag)
    private readonly serviceTagRepository: Repository<ProductFeatureTag>,
    @InjectRepository(ProductTag)
    private readonly productTagRepository: Repository<ProductTag>,
    private readonly dataSource: DataSource,
    private readonly createServiceTagHandler: CreateServiceTagHandler,
    private readonly updateServiceTagHandler: UpdateServiceTagHandler,
    private readonly removeServiceTagHandler: RemoveServiceTagHandler,
    private readonly attachProductTagHandler: AttachProductTagHandler,
    private readonly detachProductTagHandler: DetachProductTagHandler,
  ) {}

  // ============================================================================
  // Mutations — delegated to handlers
  // ============================================================================

  /**
   * Creates a new service tag for a user.
   */
  async create(dto: CreateServiceTagDto, userId: string): Promise<ServiceTagResponseDto> {
    const entity = await this.createServiceTagHandler.execute(dto, userId);
    return ServiceTagResponseDto.fromEntity(entity);
  }

  /**
   * Updates a service tag.
   */
  async update(
    id: string,
    dto: UpdateServiceTagDto,
    userId: string,
  ): Promise<ServiceTagResponseDto> {
    const entity = await this.updateServiceTagHandler.execute(id, dto, userId);
    return ServiceTagResponseDto.fromEntity(entity);
  }

  /**
   * Removes a service tag (soft delete).
   */
  async remove(id: string, userId: string): Promise<void> {
    return this.removeServiceTagHandler.execute(id, userId);
  }

  /**
   * Attaches a tag to a product. Returns the response DTO directly.
   */
  async attachToProduct(
    tagId: string,
    productId: string,
    userId: string,
  ): Promise<AttachTagResponseDto> {
    const productTag = await this.attachProductTagHandler.execute(tagId, productId, userId);
    const dto = new AttachTagResponseDto();
    dto.tagId = productTag.tagId;
    dto.productId = productTag.productId;
    dto.createdAt = productTag.createdAt;
    return dto;
  }

  /**
   * Detaches a tag from a product.
   */
  async detachFromProduct(
    tagId: string,
    productId: string,
    userId: string,
  ): Promise<void> {
    return this.detachProductTagHandler.execute(tagId, productId, userId);
  }

  // ============================================================================
  // Queries — return Response DTOs
  // ============================================================================

  /**
   * Finds all service tags for a user.
   */
  async findAllByUser(userId: string): Promise<ServiceTagResponseDto[]> {
    this.logger.log(`Finding all service tags for user: ${userId}`);
    const entities = await this.serviceTagRepository.find({
      where: { userId },
      order: { sortOrder: 'ASC', createdAt: 'DESC' },
    });
    return ServiceTagResponseDto.fromEntities(entities);
  }

  /**
   * Finds active service tags for a user.
   */
  async findActiveByUser(userId: string): Promise<ServiceTagResponseDto[]> {
    this.logger.log(`Finding active service tags for user: ${userId}`);
    const entities = await this.serviceTagRepository.find({
      where: { userId, isActive: true },
      order: { sortOrder: 'ASC', createdAt: 'DESC' },
    });
    return ServiceTagResponseDto.fromEntities(entities);
  }

  /**
   * Finds a service tag by ID.
   */
  async findOne(id: string): Promise<ServiceTagResponseDto> {
    const tag = await this.serviceTagRepository.findOne({
      where: { id },
      relations: ['productTags'],
    });

    if (!tag) {
      this.logger.warn(`Service tag not found: ${id}`);
      throw new NotFoundException(`Service tag with ID ${id} not found`);
    }

    return ServiceTagResponseDto.fromEntity(tag);
  }

  /**
   * Gets all tags attached to a product.
   */
  async getTagsForProduct(productId: string): Promise<ServiceTagResponseDto[]> {
    const productTags = await this.productTagRepository.find({
      where: { productId },
      relations: ['tag'],
    });

    const entities = productTags.map((pt) => pt.tag);
    return ServiceTagResponseDto.fromEntities(entities);
  }
}
