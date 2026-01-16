import { Test, TestingModule } from '@nestjs/testing';
import { ServiceTagsController } from './service-tags.controller';
import { ServiceTagsService } from './service-tags.service';
import { CreateServiceTagDto } from './dto/create-service-tag.dto';
import { UpdateServiceTagDto } from './dto/update-service-tag.dto';
import { MockType } from '../../test/mocks/mock-types';

describe('ServiceTagsController', () => {
  let controller: ServiceTagsController;
  let serviceTagsService: MockType<ServiceTagsService>;

  beforeEach(async () => {
    // Arrange - Create typed mock for ServiceTagsService
    const mockServiceTagsService: MockType<ServiceTagsService> = {
      create: jest.fn(),
      findAllByUser: jest.fn(),
      findActiveByUser: jest.fn(),
      findOne: jest.fn(),
      update: jest.fn(),
      remove: jest.fn(),
      attachToProduct: jest.fn(),
      detachFromProduct: jest.fn(),
      getTagsForProduct: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [ServiceTagsController],
      providers: [
        {
          provide: ServiceTagsService,
          useValue: mockServiceTagsService,
        },
      ],
    }).compile();

    controller = module.get<ServiceTagsController>(ServiceTagsController);
    serviceTagsService = module.get(ServiceTagsService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('create', () => {
    it('should call service.create with DTO and userId', async () => {
      // Arrange
      const dto: CreateServiceTagDto = { name: 'Test Tag' } as CreateServiceTagDto;
      const userId = 'user-uuid-1';
      const expectedTag = { id: 'tag-uuid-1', name: 'Test Tag', userId };
      serviceTagsService.create!.mockResolvedValue(expectedTag);

      // Act
      const result = await controller.create(dto, userId);

      // Assert
      expect(result).toEqual(expectedTag);
      expect(serviceTagsService.create).toHaveBeenCalledWith(dto, userId);
    });
  });

  describe('findAll', () => {
    it('should call service.findAllByUser with userId', async () => {
      // Arrange
      const userId = 'user-uuid-1';
      const expectedTags = [{ id: 'tag-1' }, { id: 'tag-2' }];
      serviceTagsService.findAllByUser!.mockResolvedValue(expectedTags);

      // Act
      const result = await controller.findAll(userId);

      // Assert
      expect(result).toEqual(expectedTags);
      expect(serviceTagsService.findAllByUser).toHaveBeenCalledWith(userId);
    });
  });

  describe('findActive', () => {
    it('should call service.findActiveByUser with userId', async () => {
      // Arrange
      const userId = 'user-uuid-1';
      const expectedTags = [{ id: 'tag-1', isActive: true }];
      serviceTagsService.findActiveByUser!.mockResolvedValue(expectedTags);

      // Act
      const result = await controller.findActive(userId);

      // Assert
      expect(result).toEqual(expectedTags);
      expect(serviceTagsService.findActiveByUser).toHaveBeenCalledWith(userId);
    });
  });

  describe('findOne', () => {
    it('should call service.findOne with ID', async () => {
      // Arrange
      const id = 'tag-uuid-1';
      const expectedTag = { id, name: 'Test Tag' };
      serviceTagsService.findOne!.mockResolvedValue(expectedTag);

      // Act
      const result = await controller.findOne(id);

      // Assert
      expect(result).toEqual(expectedTag);
      expect(serviceTagsService.findOne).toHaveBeenCalledWith(id);
    });
  });

  describe('update', () => {
    it('should call service.update with ID, DTO, and userId', async () => {
      // Arrange
      const id = 'tag-uuid-1';
      const dto: UpdateServiceTagDto = { name: 'Updated Tag' } as UpdateServiceTagDto;
      const userId = 'user-uuid-1';
      const expectedTag = { id, name: 'Updated Tag' };
      serviceTagsService.update!.mockResolvedValue(expectedTag);

      // Act
      const result = await controller.update(id, dto, userId);

      // Assert
      expect(result).toEqual(expectedTag);
      expect(serviceTagsService.update).toHaveBeenCalledWith(id, dto, userId);
    });
  });

  describe('remove', () => {
    it('should call service.remove with ID and userId', async () => {
      // Arrange
      const id = 'tag-uuid-1';
      const userId = 'user-uuid-1';
      serviceTagsService.remove!.mockResolvedValue(undefined);

      // Act
      await controller.remove(id, userId);

      // Assert
      expect(serviceTagsService.remove).toHaveBeenCalledWith(id, userId);
    });
  });

  describe('attachToProduct', () => {
    it('should call service.attachToProduct with tagId, productId, and userId', async () => {
      // Arrange
      const tagId = 'tag-uuid-1';
      const productId = 'product-uuid-1';
      const userId = 'user-uuid-1';
      const mockCreatedAt = new Date('2026-01-14T22:45:00.000Z');
      const serviceProductTag = { id: 'pt-1', tagId, productId, createdAt: mockCreatedAt };
      serviceTagsService.attachToProduct!.mockResolvedValue(serviceProductTag);

      // Act
      const result = await controller.attachToProduct(tagId, productId, userId);

      // Assert
      expect(result).toEqual({ tagId, productId, createdAt: mockCreatedAt });
      expect(serviceTagsService.attachToProduct).toHaveBeenCalledWith(tagId, productId, userId);
    });
  });

  describe('detachFromProduct', () => {
    it('should call service.detachFromProduct with tagId, productId, and userId', async () => {
      // Arrange
      const tagId = 'tag-uuid-1';
      const productId = 'product-uuid-1';
      const userId = 'user-uuid-1';
      serviceTagsService.detachFromProduct!.mockResolvedValue(undefined);

      // Act
      await controller.detachFromProduct(tagId, productId, userId);

      // Assert
      expect(serviceTagsService.detachFromProduct).toHaveBeenCalledWith(tagId, productId, userId);
    });
  });

  describe('getTagsForProduct', () => {
    it('should call service.getTagsForProduct with productId', async () => {
      // Arrange
      const productId = 'product-uuid-1';
      const expectedTags = [{ id: 'tag-1' }, { id: 'tag-2' }];
      serviceTagsService.getTagsForProduct!.mockResolvedValue(expectedTags);

      // Act
      const result = await controller.getTagsForProduct(productId);

      // Assert
      expect(result).toEqual(expectedTags);
      expect(serviceTagsService.getTagsForProduct).toHaveBeenCalledWith(productId);
    });
  });
});
