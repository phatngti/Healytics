import { Test, TestingModule } from '@nestjs/testing';
import { ProductsController } from './products.controller';
import { ProductsService } from './products.service';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { MockType } from '../../test/mocks/mock-types';

describe('ProductsController', () => {
  let controller: ProductsController;
  let productsService: MockType<ProductsService>;

  beforeEach(async () => {
    // Arrange - Create typed mock for ProductsService
    const mockProductsService: MockType<ProductsService> = {
      create: jest.fn(),
      findAll: jest.fn(),
      findOne: jest.fn(),
      findBySlug: jest.fn(),
      update: jest.fn(),
      remove: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [ProductsController],
      providers: [
        {
          provide: ProductsService,
          useValue: mockProductsService,
        },
      ],
    }).compile();

    controller = module.get<ProductsController>(ProductsController);
    productsService = module.get(ProductsService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('create', () => {
    it('should call service.create with the DTO and return created product', async () => {
      // Arrange
      const dto: CreateProductDto = { name: 'New Product' } as CreateProductDto;
      const expectedProduct = { id: 'uuid-1', name: 'New Product' };
      productsService.create!.mockResolvedValue(expectedProduct);

      // Act
      const result = await controller.create(dto);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(productsService.create).toHaveBeenCalledWith(dto);
      expect(productsService.create).toHaveBeenCalledTimes(1);
    });
  });

  describe('findAll', () => {
    it('should call service.findAll and return all products', async () => {
      // Arrange
      const expectedProducts = [{ id: '1' }, { id: '2' }];
      productsService.findAll!.mockResolvedValue(expectedProducts);

      // Act
      const result = await controller.findAll();

      // Assert
      expect(result).toEqual(expectedProducts);
      expect(productsService.findAll).toHaveBeenCalledTimes(1);
    });
  });

  describe('findOne', () => {
    it('should call service.findOne with ID and return the product', async () => {
      // Arrange
      const id = 'uuid-1';
      const expectedProduct = { id, name: 'Product' };
      productsService.findOne!.mockResolvedValue(expectedProduct);

      // Act
      const result = await controller.findOne(id);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(productsService.findOne).toHaveBeenCalledWith(id);
    });
  });

  describe('findBySlug', () => {
    it('should call service.findBySlug with slug and return the product', async () => {
      // Arrange
      const slug = 'test-product';
      const expectedProduct = { id: 'uuid-1', slug };
      productsService.findBySlug!.mockResolvedValue(expectedProduct);

      // Act
      const result = await controller.findBySlug(slug);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(productsService.findBySlug).toHaveBeenCalledWith(slug);
    });
  });

  describe('update', () => {
    it('should call service.update with ID and DTO and return updated product', async () => {
      // Arrange
      const id = 'uuid-1';
      const dto: UpdateProductDto = { name: 'Updated' } as UpdateProductDto;
      const expectedProduct = { id, name: 'Updated' };
      productsService.update!.mockResolvedValue(expectedProduct);

      // Act
      const result = await controller.update(id, dto);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(productsService.update).toHaveBeenCalledWith(id, dto);
    });
  });

  describe('remove', () => {
    it('should call service.remove with ID', async () => {
      // Arrange
      const id = 'uuid-1';
      productsService.remove!.mockResolvedValue(undefined);

      // Act
      await controller.remove(id);

      // Assert
      expect(productsService.remove).toHaveBeenCalledWith(id);
      expect(productsService.remove).toHaveBeenCalledTimes(1);
    });
  });
});

