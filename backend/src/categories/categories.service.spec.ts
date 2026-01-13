import { Test, TestingModule } from '@nestjs/testing';
import { CategoriesService } from './categories.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Category } from './entities/category.entity';
import { NotFoundException } from '@nestjs/common';
import { CreateCategoryHandler } from './application/handlers/create-category.handler';
import { UpdateCategoryHandler } from './application/handlers/update-category.handler';
import { RemoveCategoryHandler } from './application/handlers/remove-category.handler';

describe('CategoriesService', () => {
  let service: CategoriesService;
  let repository: Record<string, jest.Mock>;
  let createCategoryHandler: Record<string, jest.Mock>;
  let updateCategoryHandler: Record<string, jest.Mock>;
  let removeCategoryHandler: Record<string, jest.Mock>;

  const mockCategoryRepository = {
    find: jest.fn(),
    findOne: jest.fn(),
    count: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
  };

  const mockCreateCategoryHandler = {
    execute: jest.fn(),
  };

  const mockUpdateCategoryHandler = {
    execute: jest.fn(),
  };

  const mockRemoveCategoryHandler = {
    execute: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CategoriesService,
        {
          provide: getRepositoryToken(Category),
          useValue: mockCategoryRepository,
        },
        {
          provide: CreateCategoryHandler,
          useValue: mockCreateCategoryHandler,
        },
        {
          provide: UpdateCategoryHandler,
          useValue: mockUpdateCategoryHandler,
        },
        {
          provide: RemoveCategoryHandler,
          useValue: mockRemoveCategoryHandler,
        },
      ],
    }).compile();

    service = module.get<CategoriesService>(CategoriesService);
    repository = module.get(getRepositoryToken(Category));
    createCategoryHandler = module.get(CreateCategoryHandler);
    updateCategoryHandler = module.get(UpdateCategoryHandler);
    removeCategoryHandler = module.get(RemoveCategoryHandler);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('create', () => {
    it('should delegate to CreateCategoryHandler', async () => {
      // Arrange
      const inputDto = { name: 'Test Category', slug: 'test-category' };
      const expectedCategory = { id: 'uuid-1', ...inputDto };
      mockCreateCategoryHandler.execute.mockResolvedValue(expectedCategory);

      // Act
      const result = await service.create(inputDto as any);

      // Assert
      expect(result).toEqual(expectedCategory);
      expect(mockCreateCategoryHandler.execute).toHaveBeenCalledWith(inputDto);
    });
  });

  describe('findAll', () => {
    it('should return an array of categories', async () => {
      // Arrange
      const expectedCategories = [{ id: '1', name: 'Category 1' }];
      mockCategoryRepository.find.mockResolvedValue(expectedCategories);

      // Act
      const result = await service.findAll();

      // Assert
      expect(result).toEqual(expectedCategories);
      expect(mockCategoryRepository.find).toHaveBeenCalledWith(
        expect.objectContaining({
          relations: ['parent', 'children'],
        }),
      );
    });
  });

  describe('findOne', () => {
    it('should return a category when found', async () => {
      // Arrange
      const expectedCategory = { id: 'uuid-1', name: 'Test' };
      mockCategoryRepository.findOne.mockResolvedValue(expectedCategory);

      // Act
      const result = await service.findOne('uuid-1');

      // Assert
      expect(result).toEqual(expectedCategory);
    });

    it('should throw NotFoundException when not found', async () => {
      // Arrange
      mockCategoryRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(service.findOne('missing-id')).rejects.toThrow(NotFoundException);
    });
  });

  describe('findBySlug', () => {
    it('should return a category when found', async () => {
      // Arrange
      const expectedCategory = { id: 'uuid-1', slug: 'test-slug' };
      mockCategoryRepository.findOne.mockResolvedValue(expectedCategory);

      // Act
      const result = await service.findBySlug('test-slug');

      // Assert
      expect(result).toEqual(expectedCategory);
    });

    it('should throw NotFoundException when not found', async () => {
      // Arrange
      mockCategoryRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(service.findBySlug('missing-slug')).rejects.toThrow(NotFoundException);
    });
  });

  describe('update', () => {
    it('should delegate to UpdateCategoryHandler', async () => {
      // Arrange
      const updateDto = { name: 'New Name' };
      const expectedCategory = { id: 'uuid-1', name: 'New Name' };
      mockUpdateCategoryHandler.execute.mockResolvedValue(expectedCategory);

      // Act
      const result = await service.update('uuid-1', updateDto as any);

      // Assert
      expect(result).toEqual(expectedCategory);
      expect(mockUpdateCategoryHandler.execute).toHaveBeenCalledWith('uuid-1', updateDto);
    });
  });

  describe('remove', () => {
    it('should delegate to RemoveCategoryHandler', async () => {
      // Arrange
      mockRemoveCategoryHandler.execute.mockResolvedValue(undefined);

      // Act
      await service.remove('uuid-1');

      // Assert
      expect(mockRemoveCategoryHandler.execute).toHaveBeenCalledWith('uuid-1');
    });
  });
});
