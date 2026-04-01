import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException } from '@nestjs/common';
import { ServiceTagsService } from './service-tags.service';
import { ProductFeatureTag } from '@/common/entities/product-feature-tag.entity';
import { ProductTag } from '@/common/entities/product-tag.entity';
import { CreateServiceTagHandler } from './application/handlers/create-service-tag.handler';
import { UpdateServiceTagHandler } from './application/handlers/update-service-tag.handler';
import { RemoveServiceTagHandler } from './application/handlers/remove-service-tag.handler';
import { AttachProductTagHandler } from './application/handlers/attach-product-tag.handler';
import { DetachProductTagHandler } from './application/handlers/detach-product-tag.handler';
import { DataSource } from 'typeorm';
import {
  MockRepository,
  MockHandler,
  createMockRepository,
  createMockHandler,
} from '../../test/mocks/mock-types';

describe('ServiceTagsService', () => {
  let service: ServiceTagsService;
  let serviceTagRepository: MockRepository<ProductFeatureTag>;
  let productTagRepository: MockRepository<ProductTag>;
  let createServiceTagHandler: MockHandler;
  let updateServiceTagHandler: MockHandler;
  let removeServiceTagHandler: MockHandler;
  let attachProductTagHandler: MockHandler;
  let detachProductTagHandler: MockHandler;

  // Helper to create a mock entity for testing
  const createMockTagEntity = (
    overrides: Partial<ProductFeatureTag> = {},
  ): ProductFeatureTag =>
    ({
      id: 'tag-uuid-1',
      userId: 'user-uuid-1',
      name: 'Test Tag',
      description: 'A test tag',
      colorValue: '#FF6366F1',
      usage: 0,
      isActive: true,
      sortOrder: 0,
      createdAt: new Date('2026-01-14T22:45:00.000Z'),
      updatedAt: new Date('2026-01-14T22:45:00.000Z'),
      ...overrides,
    }) as ProductFeatureTag;

  beforeEach(async () => {
    // Arrange - Create fresh mocks for each test
    serviceTagRepository = createMockRepository<ProductFeatureTag>();
    productTagRepository = createMockRepository<ProductTag>();
    createServiceTagHandler = createMockHandler();
    updateServiceTagHandler = createMockHandler();
    removeServiceTagHandler = createMockHandler();
    attachProductTagHandler = createMockHandler();
    detachProductTagHandler = createMockHandler();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ServiceTagsService,
        {
          provide: getRepositoryToken(ProductFeatureTag),
          useValue: serviceTagRepository,
        },
        {
          provide: getRepositoryToken(ProductTag),
          useValue: productTagRepository,
        },
        {
          provide: DataSource,
          useValue: {},
        },
        {
          provide: CreateServiceTagHandler,
          useValue: createServiceTagHandler,
        },
        {
          provide: UpdateServiceTagHandler,
          useValue: updateServiceTagHandler,
        },
        {
          provide: RemoveServiceTagHandler,
          useValue: removeServiceTagHandler,
        },
        {
          provide: AttachProductTagHandler,
          useValue: attachProductTagHandler,
        },
        {
          provide: DetachProductTagHandler,
          useValue: detachProductTagHandler,
        },
      ],
    }).compile();

    service = module.get<ServiceTagsService>(ServiceTagsService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('create', () => {
    it('should delegate to CreateServiceTagHandler and return response DTO', async () => {
      // Arrange
      const dto = { name: 'Test Tag' };
      const userId = 'user-uuid-1';
      const mockEntity = createMockTagEntity({ name: 'Test Tag', userId });
      createServiceTagHandler.execute.mockResolvedValue(mockEntity);

      // Act
      const result = await service.create(dto as any, userId);

      // Assert
      expect(result.id).toBe(mockEntity.id);
      expect(result.name).toBe('Test Tag');
      expect(result.userId).toBe(userId);
      expect(createServiceTagHandler.execute).toHaveBeenCalledWith(dto, userId);
      expect(createServiceTagHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('findAllByUser', () => {
    it('should return response DTOs for all service tags', async () => {
      // Arrange
      const userId = 'user-uuid-1';
      const entities = [
        createMockTagEntity({ id: 'tag-1', name: 'Tag 1', userId }),
        createMockTagEntity({ id: 'tag-2', name: 'Tag 2', userId }),
      ];
      serviceTagRepository.find.mockResolvedValue(entities);

      // Act
      const result = await service.findAllByUser(userId);

      // Assert
      expect(result).toHaveLength(2);
      expect(result[0].id).toBe('tag-1');
      expect(result[1].id).toBe('tag-2');
      expect(serviceTagRepository.find).toHaveBeenCalledWith({
        where: { userId },
        order: { sortOrder: 'ASC', createdAt: 'DESC' },
      });
    });

    it('should return empty array when user has no tags', async () => {
      // Arrange
      const userId = 'user-with-no-tags';
      serviceTagRepository.find.mockResolvedValue([]);

      // Act
      const result = await service.findAllByUser(userId);

      // Assert
      expect(result).toEqual([]);
    });
  });

  describe('findActiveByUser', () => {
    it('should return only active service tags as response DTOs', async () => {
      // Arrange
      const userId = 'user-uuid-1';
      const entities = [
        createMockTagEntity({
          id: 'tag-1',
          name: 'Active Tag',
          isActive: true,
        }),
      ];
      serviceTagRepository.find.mockResolvedValue(entities);

      // Act
      const result = await service.findActiveByUser(userId);

      // Assert
      expect(result).toHaveLength(1);
      expect(result[0].isActive).toBe(true);
      expect(serviceTagRepository.find).toHaveBeenCalledWith({
        where: { userId, isActive: true },
        order: { sortOrder: 'ASC', createdAt: 'DESC' },
      });
    });
  });

  describe('findOne', () => {
    it('should return a response DTO when tag found', async () => {
      // Arrange
      const tagId = 'tag-uuid-1';
      const entity = createMockTagEntity({ id: tagId });
      serviceTagRepository.findOne.mockResolvedValue(entity);

      // Act
      const result = await service.findOne(tagId);

      // Assert
      expect(result.id).toBe(tagId);
      expect(result.name).toBe('Test Tag');
      expect(serviceTagRepository.findOne).toHaveBeenCalledWith({
        where: { id: tagId },
        relations: ['productTags'],
      });
    });

    it('should throw NotFoundException when tag not found', async () => {
      // Arrange
      const tagId = 'non-existent-id';
      serviceTagRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(service.findOne(tagId)).rejects.toThrow(NotFoundException);
      await expect(service.findOne(tagId)).rejects.toThrow(
        `Service tag with ID ${tagId} not found`,
      );
    });
  });

  describe('update', () => {
    it('should delegate to UpdateServiceTagHandler and return response DTO', async () => {
      // Arrange
      const tagId = 'tag-uuid-1';
      const userId = 'user-uuid-1';
      const dto = { name: 'Updated Name' };
      const mockEntity = createMockTagEntity({
        id: tagId,
        name: 'Updated Name',
      });
      updateServiceTagHandler.execute.mockResolvedValue(mockEntity);

      // Act
      const result = await service.update(tagId, dto as any, userId);

      // Assert
      expect(result.id).toBe(tagId);
      expect(result.name).toBe('Updated Name');
      expect(updateServiceTagHandler.execute).toHaveBeenCalledWith(
        tagId,
        dto,
        userId,
      );
    });
  });

  describe('remove', () => {
    it('should delegate to RemoveServiceTagHandler', async () => {
      // Arrange
      const tagId = 'tag-uuid-1';
      const userId = 'user-uuid-1';
      removeServiceTagHandler.execute.mockResolvedValue(undefined);

      // Act
      await service.remove(tagId, userId);

      // Assert
      expect(removeServiceTagHandler.execute).toHaveBeenCalledWith(
        tagId,
        userId,
      );
    });
  });

  describe('attachToProduct', () => {
    it('should delegate to handler and return AttachTagResponseDto', async () => {
      // Arrange
      const tagId = 'tag-uuid-1';
      const productId = 'product-uuid-1';
      const userId = 'user-uuid-1';
      const mockCreatedAt = new Date('2026-01-14T22:45:00.000Z');
      const mockProductTag = {
        id: 'pt-1',
        tagId,
        productId,
        createdAt: mockCreatedAt,
      };
      attachProductTagHandler.execute.mockResolvedValue(mockProductTag);

      // Act
      const result = await service.attachToProduct(tagId, productId, userId);

      // Assert
      expect(result.tagId).toBe(tagId);
      expect(result.productId).toBe(productId);
      expect(result.createdAt).toEqual(mockCreatedAt);
      expect(attachProductTagHandler.execute).toHaveBeenCalledWith(
        tagId,
        productId,
        userId,
      );
    });
  });

  describe('detachFromProduct', () => {
    it('should delegate to DetachProductTagHandler', async () => {
      // Arrange
      const tagId = 'tag-uuid-1';
      const productId = 'product-uuid-1';
      const userId = 'user-uuid-1';
      detachProductTagHandler.execute.mockResolvedValue(undefined);

      // Act
      await service.detachFromProduct(tagId, productId, userId);

      // Assert
      expect(detachProductTagHandler.execute).toHaveBeenCalledWith(
        tagId,
        productId,
        userId,
      );
    });
  });

  describe('getTagsForProduct', () => {
    it('should return response DTOs for all tags on a product', async () => {
      // Arrange
      const productId = 'product-uuid-1';
      const tag1 = createMockTagEntity({ id: 'tag-1', name: 'Tag 1' });
      const tag2 = createMockTagEntity({ id: 'tag-2', name: 'Tag 2' });
      const productTags = [
        { id: 'pt-1', productId, tag: tag1 },
        { id: 'pt-2', productId, tag: tag2 },
      ];
      productTagRepository.find.mockResolvedValue(productTags);

      // Act
      const result = await service.getTagsForProduct(productId);

      // Assert
      expect(result).toHaveLength(2);
      expect(result[0].id).toBe('tag-1');
      expect(result[1].id).toBe('tag-2');
      expect(productTagRepository.find).toHaveBeenCalledWith({
        where: { productId },
        relations: ['tag'],
      });
    });

    it('should return empty array when product has no tags', async () => {
      // Arrange
      const productId = 'product-with-no-tags';
      productTagRepository.find.mockResolvedValue([]);

      // Act
      const result = await service.getTagsForProduct(productId);

      // Assert
      expect(result).toEqual([]);
    });
  });
});
