import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException } from '@nestjs/common';
import { ProductsService } from './products.service';
import { Product } from './entities/product.entity';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { CreateProductHandler } from './application/handlers/create-product.handler';
import { UpdateProductHandler } from './application/handlers/update-product.handler';
import { RemoveProductHandler } from './application/handlers/remove-product.handler';
import {
  MockRepository,
  MockHandler,
  createMockRepository,
  createMockHandler,
} from '../../test/mocks/mock-types';

describe('ProductsService', () => {
  let service: ProductsService;
  let productRepository: MockRepository<Product>;
  let createProductHandler: MockHandler;
  let updateProductHandler: MockHandler;
  let removeProductHandler: MockHandler;

  beforeEach(async () => {
    // Arrange - Create fresh mocks for each test
    productRepository = createMockRepository<Product>();
    createProductHandler = createMockHandler();
    updateProductHandler = createMockHandler();
    removeProductHandler = createMockHandler();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProductsService,
        {
          provide: getRepositoryToken(Product),
          useValue: productRepository,
        },
        {
          provide: CreateProductHandler,
          useValue: createProductHandler,
        },
        {
          provide: UpdateProductHandler,
          useValue: updateProductHandler,
        },
        {
          provide: RemoveProductHandler,
          useValue: removeProductHandler,
        },
      ],
    }).compile();

    service = module.get<ProductsService>(ProductsService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('create', () => {
    it('should delegate to CreateProductHandler and return created product', async () => {
      // Arrange
      const dto: CreateProductDto = { name: 'Test Product' } as CreateProductDto;
      const expectedProduct = { id: 'uuid-1', name: 'Test Product' };
      createProductHandler.execute.mockResolvedValue(expectedProduct);

      // Act
      const result = await service.create(dto);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(createProductHandler.execute).toHaveBeenCalledWith(dto);
      expect(createProductHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('update', () => {
    it('should delegate to UpdateProductHandler and return updated product', async () => {
      // Arrange
      const id = 'uuid-1';
      const dto: UpdateProductDto = { name: 'Updated Product' } as UpdateProductDto;
      const expectedProduct = { id, name: 'Updated Product' };
      updateProductHandler.execute.mockResolvedValue(expectedProduct);

      // Act
      const result = await service.update(id, dto);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(updateProductHandler.execute).toHaveBeenCalledWith(id, dto);
      expect(updateProductHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('remove', () => {
    it('should delegate to RemoveProductHandler', async () => {
      // Arrange
      const id = 'uuid-1';
      removeProductHandler.execute.mockResolvedValue(undefined);

      // Act
      await service.remove(id);

      // Assert
      expect(removeProductHandler.execute).toHaveBeenCalledWith(id);
      expect(removeProductHandler.execute).toHaveBeenCalledTimes(1);
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
});

