import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException } from '@nestjs/common';
import { HealthServiceService } from './health-service.service';
import { Product } from '@/common/entities/product.entity';
import { CreatePartnerHealthServiceDto } from './dto/partner/create-partner-health-service.dto';
import { UpdatePartnerHealthServiceDto } from './dto/partner/update-partner-health-service.dto';
import { CreateHealthServiceHandler } from './application/handlers/create-health-service.handler';
import { UpdateHealthServiceHandler } from './application/handlers/update-health-service.handler';
import { RemoveHealthServiceHandler } from './application/handlers/remove-health-service.handler';
import { PartnersService } from '@/partners/partners.service';
import {
  MockRepository,
  MockHandler,
  createMockRepository,
  createMockHandler,
} from '../../test/mocks/mock-types';

describe('HealthServiceService', () => {
  let service: HealthServiceService;
  let productRepository: MockRepository<Product>;
  let createHandler: MockHandler;
  let updateHandler: MockHandler;
  let removeHandler: MockHandler;

  beforeEach(async () => {
    // Arrange - Create fresh mocks for each test
    productRepository = createMockRepository<Product>();
    createHandler = createMockHandler();
    updateHandler = createMockHandler();
    removeHandler = createMockHandler();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        HealthServiceService,
        {
          provide: getRepositoryToken(Product),
          useValue: productRepository,
        },
        {
          provide: CreateHealthServiceHandler,
          useValue: createHandler,
        },
        {
          provide: UpdateHealthServiceHandler,
          useValue: updateHandler,
        },
        {
          provide: RemoveHealthServiceHandler,
          useValue: removeHandler,
        },
        {
          provide: PartnersService,
          useValue: { getFirstHealthPartner: jest.fn().mockResolvedValue(null) },
        },
      ],
    }).compile();

    service = module.get<HealthServiceService>(HealthServiceService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('create', () => {
    it('should delegate to CreateHealthServiceHandler and return created product', async () => {
      // Arrange
      const dto: CreatePartnerHealthServiceDto = { name: 'Test Product' } as CreatePartnerHealthServiceDto;
      const expectedProduct = { id: 'uuid-1', name: 'Test Product' };
      createHandler.execute.mockResolvedValue(expectedProduct);

      // Act
      const result = await service.create(dto);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(createHandler.execute).toHaveBeenCalledWith(dto);
      expect(createHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('update', () => {
    it('should delegate to UpdateHealthServiceHandler and return updated product', async () => {
      // Arrange
      const id = 'uuid-1';
      const dto: UpdatePartnerHealthServiceDto = { name: 'Updated Product' } as UpdatePartnerHealthServiceDto;
      const expectedProduct = { id, name: 'Updated Product' };
      updateHandler.execute.mockResolvedValue(expectedProduct);

      // Act
      const result = await service.update(id, dto);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(updateHandler.execute).toHaveBeenCalledWith(id, dto);
      expect(updateHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('remove', () => {
    it('should delegate to RemoveHealthServiceHandler', async () => {
      // Arrange
      const id = 'uuid-1';
      removeHandler.execute.mockResolvedValue(undefined);

      // Act
      await service.remove(id);

      // Assert
      expect(removeHandler.execute).toHaveBeenCalledWith(id);
      expect(removeHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('findAll', () => {
    it('should return all products with relations ordered by createdAt DESC', async () => {
      // Arrange
      const expectedProducts = [
        { id: 'uuid-1', name: 'Product 1' },
        { id: 'uuid-2', name: 'Product 2' },
      ];
      productRepository.find.mockResolvedValue(expectedProducts);

      // Act
      const result = await service.findAll();

      // Assert
      expect(result).toEqual(expectedProducts);
      expect(productRepository.find).toHaveBeenCalledWith(
        expect.objectContaining({
          relations: expect.any(Array),
          order: { createdAt: 'DESC' },
        }),
      );
    });

    it('should return empty array when no products exist', async () => {
      // Arrange
      productRepository.find.mockResolvedValue([]);

      // Act
      const result = await service.findAll();

      // Assert
      expect(result).toEqual([]);
    });
  });

  describe('findOne', () => {
    it('should return a product when found by ID', async () => {
      // Arrange
      const id = 'uuid-1';
      const expectedProduct = { id, name: 'Test Product' };
      productRepository.findOne.mockResolvedValue(expectedProduct);

      // Act
      const result = await service.findOne(id);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(productRepository.findOne).toHaveBeenCalledWith(
        expect.objectContaining({ where: { id } }),
      );
    });

    it('should throw NotFoundException when product not found', async () => {
      // Arrange
      const id = 'non-existent-id';
      productRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(service.findOne(id)).rejects.toThrow(NotFoundException);
      await expect(service.findOne(id)).rejects.toThrow(`Product with ID ${id} not found`);
    });
  });

  describe('findBySlug', () => {
    it('should return a product when found by slug', async () => {
      // Arrange
      const slug = 'test-product';
      const expectedProduct = { id: 'uuid-1', slug };
      productRepository.findOne.mockResolvedValue(expectedProduct);

      // Act
      const result = await service.findBySlug(slug);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(productRepository.findOne).toHaveBeenCalledWith(
        expect.objectContaining({ where: { slug } }),
      );
    });

    it('should throw NotFoundException when product slug not found', async () => {
      // Arrange
      const slug = 'non-existent-slug';
      productRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(service.findBySlug(slug)).rejects.toThrow(NotFoundException);
      await expect(service.findBySlug(slug)).rejects.toThrow(`Product with slug "${slug}" not found`);
    });
  });

  describe('getPremiumTreatments', () => {
    it('should query active visible products and return card DTOs', async () => {
      // Arrange
      const mockProducts = [
        { id: 'uuid-1', name: 'Product 1', type: 'service', basePrice: 500000, media: [], reviews: [], productEmployeeEligibilities: [] },
      ];
      productRepository.find.mockResolvedValue(mockProducts);

      // Act
      const result = await service.getPremiumTreatments();

      // Assert
      expect(result).toBeDefined();
      expect(Array.isArray(result)).toBe(true);
      expect(productRepository.find).toHaveBeenCalledWith(
        expect.objectContaining({
          where: { status: 'active', isVisibleOnline: true },
          take: 10,
        }),
      );
    });

    it('should return empty array when no products exist', async () => {
      // Arrange
      productRepository.find.mockResolvedValue([]);

      // Act
      const result = await service.getPremiumTreatments();

      // Assert
      expect(result).toEqual([]);
    });
  });

  describe('getHomeRecommend', () => {
    it('should query active visible products and return card DTOs', async () => {
      // Arrange
      const mockProducts = [
        { id: 'uuid-2', name: 'Product 2', type: 'package', basePrice: 750000, media: [], reviews: [], productEmployeeEligibilities: [] },
      ];
      productRepository.find.mockResolvedValue(mockProducts);

      // Act
      const result = await service.getHomeRecommend();

      // Assert
      expect(result).toBeDefined();
      expect(Array.isArray(result)).toBe(true);
      expect(productRepository.find).toHaveBeenCalledWith(
        expect.objectContaining({
          where: { status: 'active', isVisibleOnline: true },
          take: 10,
        }),
      );
    });

    it('should return empty array when no products exist', async () => {
      // Arrange
      productRepository.find.mockResolvedValue([]);

      // Act
      const result = await service.getHomeRecommend();

      // Assert
      expect(result).toEqual([]);
    });
  });
});
