import { Test, TestingModule } from '@nestjs/testing';
import { ProductsController } from './products.controller';
import { ProductsService } from './products.service';
import { MockType } from '../../test/mocks/mock-types';

describe('ProductsController', () => {
  let controller: ProductsController;
  let productsService: MockType<ProductsService>;

  beforeEach(async () => {
    // Arrange - Create typed mock for ProductsService
    const mockProductsService: MockType<ProductsService> = {
      findAll: jest.fn(),
      findOne: jest.fn(),
      findBySlug: jest.fn(),
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
});
