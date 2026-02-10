import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException } from '@nestjs/common';
import { ServiceTagsService } from './service-tags.service';
import { ServiceTag } from '@/common/entities/service-tag.entity';
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
  let serviceTagRepository: MockRepository<ServiceTag>;
  let productTagRepository: MockRepository<ProductTag>;
  let createServiceTagHandler: MockHandler;
  let updateServiceTagHandler: MockHandler;
  let removeServiceTagHandler: MockHandler;
  let attachProductTagHandler: MockHandler;
  let detachProductTagHandler: MockHandler;

  beforeEach(async () => {
    // Arrange - Create fresh mocks for each test
    serviceTagRepository = createMockRepository<ServiceTag>();
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
          provide: getRepositoryToken(ServiceTag),
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
    it('should delegate to CreateServiceTagHandler', async () => {
      // Arrange
      const dto = { name: 'Test Tag' };
      const userId = 'user-uuid-1';
      const expectedTag = { id: 'tag-uuid-1', name: 'Test Tag', userId };
      createServiceTagHandler.execute.mockResolvedValue(expectedTag);

      // Act
      const result = await service.create(dto as any, userId);

      // Assert
      expect(result).toEqual(expectedTag);
      expect(createServiceTagHandler.execute).toHaveBeenCalledWith(dto, userId);
      expect(createServiceTagHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('findAllByUser', () => {
    it('should return all service tags for the user', async () => {
      // Arrange
      const userId = 'user-uuid-1';
      const expectedTags = [
        { id: 'tag-1', name: 'Tag 1', userId },
        { id: 'tag-2', name: 'Tag 2', userId },
      ];
      serviceTagRepository.find.mockResolvedValue(expectedTags);

      // Act
      const result = await service.findAllByUser(userId);

      // Assert
      expect(result).toEqual(expectedTags);
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
    it('should return only active service tags for the user', async () => {
      // Arrange
      const userId = 'user-uuid-1';
      const expectedTags = [{ id: 'tag-1', name: 'Active Tag', isActive: true }];
      serviceTagRepository.find.mockResolvedValue(expectedTags);

      // Act
      const result = await service.findActiveByUser(userId);

      // Assert
      expect(result).toEqual(expectedTags);
      expect(serviceTagRepository.find).toHaveBeenCalledWith({
        where: { userId, isActive: true },
        order: { sortOrder: 'ASC', createdAt: 'DESC' },
      });
    });
  });

  describe('findOne', () => {
    it('should return a service tag when found', async () => {
      // Arrange
      const tagId = 'tag-uuid-1';
      const expectedTag = { id: tagId, name: 'Test Tag' };
      serviceTagRepository.findOne.mockResolvedValue(expectedTag);

      // Act
      const result = await service.findOne(tagId);

      // Assert
      expect(result).toEqual(expectedTag);
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
    it('should delegate to UpdateServiceTagHandler', async () => {
      // Arrange
      const tagId = 'tag-uuid-1';
      const userId = 'user-uuid-1';
      const dto = { name: 'Updated Name' };
      const expectedTag = { id: tagId, name: 'Updated Name' };
      updateServiceTagHandler.execute.mockResolvedValue(expectedTag);

      // Act
      const result = await service.update(tagId, dto as any, userId);

      // Assert
      expect(result).toEqual(expectedTag);
      expect(updateServiceTagHandler.execute).toHaveBeenCalledWith(tagId, dto, userId);
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
      expect(removeServiceTagHandler.execute).toHaveBeenCalledWith(tagId, userId);
    });
  });

  describe('attachToProduct', () => {
    it('should delegate to AttachProductTagHandler', async () => {
      // Arrange
      const tagId = 'tag-uuid-1';
      const productId = 'product-uuid-1';
      const userId = 'user-uuid-1';
      const expectedProductTag = { id: 'pt-1', tagId, productId };
      attachProductTagHandler.execute.mockResolvedValue(expectedProductTag);

      // Act
      const result = await service.attachToProduct(tagId, productId, userId);

      // Assert
      expect(result).toEqual(expectedProductTag);
      expect(attachProductTagHandler.execute).toHaveBeenCalledWith(tagId, productId, userId);
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
      expect(detachProductTagHandler.execute).toHaveBeenCalledWith(tagId, productId, userId);
    });
  });

  describe('getTagsForProduct', () => {
    it('should return all tags for a product', async () => {
      // Arrange
      const productId = 'product-uuid-1';
      const tag1 = { id: 'tag-1', name: 'Tag 1' };
      const tag2 = { id: 'tag-2', name: 'Tag 2' };
      const productTags = [
        { id: 'pt-1', productId, tag: tag1 },
        { id: 'pt-2', productId, tag: tag2 },
      ];
      productTagRepository.find.mockResolvedValue(productTags);

      // Act
      const result = await service.getTagsForProduct(productId);

      // Assert
      expect(result).toEqual([tag1, tag2]);
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
