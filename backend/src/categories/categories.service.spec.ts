import { Test, TestingModule } from '@nestjs/testing';
import { CategoriesService } from './categories.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Category } from '@/common/entities/category.entity';
import { Product } from '@/common/entities/product.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { NotFoundException } from '@nestjs/common';
import { PartnersService } from '@/partners/partners.service';
import { CreateCategoryHandler } from './application/handlers/create-category.handler';
import { UpdateCategoryHandler } from './application/handlers/update-category.handler';
import { RemoveCategoryHandler } from './application/handlers/remove-category.handler';
import { ElasticsearchBookingService } from '@/search/services/elasticsearch-booking.service';

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

  const mockEligibilityRepository = {
    find: jest.fn(),
    createQueryBuilder: jest.fn().mockReturnValue({
      innerJoinAndSelect: jest.fn().mockReturnThis(),
      innerJoin: jest.fn().mockReturnThis(),
      where: jest.fn().mockReturnThis(),
      andWhere: jest.fn().mockReturnThis(),
      getMany: jest.fn().mockResolvedValue([]),
    }),
  };

  const mockProductRepository = {
    find: jest.fn(),
    findOne: jest.fn(),
  };

  const mockPartnersService = {
    getFirstHealthPartner: jest.fn().mockResolvedValue(null),
  };

  // Full mock entity for realistic DTO mapping
  const mockCategoryEntity: Partial<Category> = {
    id: 'uuid-1',
    name: 'Test Category',
    slug: 'test-category',
    description: 'A description',
    imageUrl: null,
    isActive: true,
    createdAt: new Date('2026-01-01'),
    updatedAt: new Date('2026-01-01'),
    parent: null,
    children: [],
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
          provide: getRepositoryToken(Product),
          useValue: mockProductRepository,
        },
        {
          provide: getRepositoryToken(ProductEmployeeEligibility),
          useValue: mockEligibilityRepository,
        },
        {
          provide: PartnersService,
          useValue: mockPartnersService,
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
        {
          provide: ElasticsearchBookingService,
          useValue: {
            isAvailable: false,
            searchServiceIds: jest.fn(),
          },
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
    it('should delegate to CreateCategoryHandler and return DTO', async () => {
      // Arrange
      const inputDto = { name: 'Test Category', slug: 'test-category' };
      mockCreateCategoryHandler.execute.mockResolvedValue(mockCategoryEntity);

      // Act
      const result = await service.create(inputDto as any);

      // Assert
      expect(result.id).toBe('uuid-1');
      expect(result.name).toBe('Test Category');
      expect(result.slug).toBe('test-category');
      expect(mockCreateCategoryHandler.execute).toHaveBeenCalledWith(inputDto);
    });
  });

  describe('findAll', () => {
    it('should return an array of CategoryResponseDto', async () => {
      // Arrange
      const entities = [mockCategoryEntity];
      mockCategoryRepository.find.mockResolvedValue(entities);

      // Act
      const result = await service.findAll();

      // Assert
      expect(result).toHaveLength(1);
      expect(result[0].id).toBe('uuid-1');
      expect(result[0].name).toBe('Test Category');
      expect(mockCategoryRepository.find).toHaveBeenCalledWith(
        expect.objectContaining({
          relations: ['parent', 'children'],
        }),
      );
    });
  });

  describe('findOne', () => {
    it('should return a CategoryResponseDto when found', async () => {
      // Arrange
      mockCategoryRepository.findOne.mockResolvedValue(mockCategoryEntity);

      // Act
      const result = await service.findOne('uuid-1');

      // Assert
      expect(result.id).toBe('uuid-1');
      expect(result.name).toBe('Test Category');
    });

    it('should throw NotFoundException when not found', async () => {
      // Arrange
      mockCategoryRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(service.findOne('missing-id')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('findBySlug', () => {
    it('should return a CategoryResponseDto when found', async () => {
      // Arrange
      mockCategoryRepository.findOne.mockResolvedValue(mockCategoryEntity);

      // Act
      const result = await service.findBySlug('test-category');

      // Assert
      expect(result.id).toBe('uuid-1');
      expect(result.slug).toBe('test-category');
    });

    it('should throw NotFoundException when not found', async () => {
      // Arrange
      mockCategoryRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(service.findBySlug('missing-slug')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('update', () => {
    it('should delegate to UpdateCategoryHandler and return DTO', async () => {
      // Arrange
      const updateDto = { name: 'New Name' };
      const updatedEntity = { ...mockCategoryEntity, name: 'New Name' };
      mockUpdateCategoryHandler.execute.mockResolvedValue(updatedEntity);

      // Act
      const result = await service.update('uuid-1', updateDto as any);

      // Assert
      expect(result.id).toBe('uuid-1');
      expect(result.name).toBe('New Name');
      expect(mockUpdateCategoryHandler.execute).toHaveBeenCalledWith(
        'uuid-1',
        updateDto,
      );
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
