import {
  Injectable,
  Logger,
  NotFoundException,
  ForbiddenException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { ServiceTag } from './entities/service-tag.entity';
import { ProductTag } from './entities/product-tag.entity';
import { CreateServiceTagDto } from './dto/create-service-tag.dto';
import { UpdateServiceTagDto } from './dto/update-service-tag.dto';
import { CreateServiceTagHandler } from './application/handlers/create-service-tag.handler';
import { UpdateServiceTagHandler } from './application/handlers/update-service-tag.handler';
import { RemoveServiceTagHandler } from './application/handlers/remove-service-tag.handler';

/**
 * Service facade for service tag operations.
 * Delegates mutations to handlers and provides read operations.
 */
@Injectable()
export class ServiceTagsService {
  private readonly logger = new Logger(ServiceTagsService.name);

  constructor(
    @InjectRepository(ServiceTag)
    private readonly serviceTagRepository: Repository<ServiceTag>,
    @InjectRepository(ProductTag)
    private readonly productTagRepository: Repository<ProductTag>,
    private readonly dataSource: DataSource,
    private readonly createServiceTagHandler: CreateServiceTagHandler,
    private readonly updateServiceTagHandler: UpdateServiceTagHandler,
    private readonly removeServiceTagHandler: RemoveServiceTagHandler,
  ) {}

  /**
   * Creates a new service tag for a user.
   */
  async create(dto: CreateServiceTagDto, userId: string): Promise<ServiceTag> {
    return this.createServiceTagHandler.execute(dto, userId);
  }

  /**
   * Finds all service tags for a user.
   */
  async findAllByUser(userId: string): Promise<ServiceTag[]> {
    this.logger.log(`Finding all service tags for user: ${userId}`);
    return this.serviceTagRepository.find({
      where: { userId },
      order: { sortOrder: 'ASC', createdAt: 'DESC' },
    });
  }

  /**
   * Finds active service tags for a user.
   */
  async findActiveByUser(userId: string): Promise<ServiceTag[]> {
    this.logger.log(`Finding active service tags for user: ${userId}`);
    return this.serviceTagRepository.find({
      where: { userId, isActive: true },
      order: { sortOrder: 'ASC', createdAt: 'DESC' },
    });
  }

  /**
   * Finds a service tag by ID.
   */
  async findOne(id: string): Promise<ServiceTag> {
    const tag = await this.serviceTagRepository.findOne({
      where: { id },
      relations: ['productTags'],
    });

    if (!tag) {
      this.logger.warn(`Service tag not found: ${id}`);
      throw new NotFoundException(`Service tag with ID ${id} not found`);
    }

    return tag;
  }

  /**
   * Updates a service tag.
   */
  async update(
    id: string,
    dto: UpdateServiceTagDto,
    userId: string,
  ): Promise<ServiceTag> {
    return this.updateServiceTagHandler.execute(id, dto, userId);
  }

  /**
   * Removes a service tag (soft delete).
   */
  async remove(id: string, userId: string): Promise<void> {
    return this.removeServiceTagHandler.execute(id, userId);
  }

  /**
   * Attaches a tag to a product.
   */
  async attachToProduct(
    tagId: string,
    productId: string,
    userId: string,
  ): Promise<ProductTag> {
    this.logger.log(`Attaching tag ${tagId} to product ${productId}`);

    // Verify tag exists and belongs to user
    const tag = await this.serviceTagRepository.findOne({
      where: { id: tagId },
    });

    if (!tag) {
      throw new NotFoundException(`Service tag with ID ${tagId} not found`);
    }

    if (tag.userId !== userId) {
      throw new ForbiddenException('You do not have permission to use this tag');
    }

    // Check if already attached
    const existing = await this.productTagRepository.findOne({
      where: { productId, tagId },
    });

    if (existing) {
      throw new ConflictException('Tag is already attached to this product');
    }

    // Create attachment
    const productTag = this.productTagRepository.create({
      productId,
      tagId,
    });

    const savedProductTag = await this.productTagRepository.save(productTag);

    // Increment usage counter
    await this.serviceTagRepository.increment({ id: tagId }, 'usage', 1);

    this.logger.log(`Tag ${tagId} attached to product ${productId}`);
    return savedProductTag;
  }

  /**
   * Detaches a tag from a product.
   */
  async detachFromProduct(
    tagId: string,
    productId: string,
    userId: string,
  ): Promise<void> {
    this.logger.log(`Detaching tag ${tagId} from product ${productId}`);

    // Verify tag exists and belongs to user
    const tag = await this.serviceTagRepository.findOne({
      where: { id: tagId },
    });

    if (!tag) {
      throw new NotFoundException(`Service tag with ID ${tagId} not found`);
    }

    if (tag.userId !== userId) {
      throw new ForbiddenException('You do not have permission to modify this tag');
    }

    // Find and remove attachment
    const productTag = await this.productTagRepository.findOne({
      where: { productId, tagId },
    });

    if (!productTag) {
      throw new NotFoundException('Tag is not attached to this product');
    }

    await this.productTagRepository.remove(productTag);

    // Decrement usage counter
    if (tag.usage > 0) {
      await this.serviceTagRepository.decrement({ id: tagId }, 'usage', 1);
    }

    this.logger.log(`Tag ${tagId} detached from product ${productId}`);
  }

  /**
   * Gets all tags attached to a product.
   */
  async getTagsForProduct(productId: string): Promise<ServiceTag[]> {
    const productTags = await this.productTagRepository.find({
      where: { productId },
      relations: ['tag'],
    });

    return productTags.map((pt) => pt.tag);
  }
}
