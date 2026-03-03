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
      getPremiumTreatments: jest.fn(),
      getHomeRecommend: jest.fn(),
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

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  describe('getPremiumTreatments', () => {
    it('should delegate to productsService.getPremiumTreatments', async () => {
      // Arrange
      const expected = [{ id: 'uuid-1', name: 'Test' }];
      productsService.getPremiumTreatments!.mockResolvedValue(expected);

      // Act
      const result = await controller.getPremiumTreatments();

      // Assert
      expect(result).toEqual(expected);
      expect(productsService.getPremiumTreatments!).toHaveBeenCalledTimes(1);
    });
  });

  describe('getHomeRecommend', () => {
    it('should delegate to productsService.getHomeRecommend', async () => {
      // Arrange
      const expected = [{ id: 'uuid-2', name: 'Recommend' }];
      productsService.getHomeRecommend!.mockResolvedValue(expected);

      // Act
      const result = await controller.getHomeRecommend();

      // Assert
      expect(result).toEqual(expected);
      expect(productsService.getHomeRecommend!).toHaveBeenCalledTimes(1);
    });
  });
});
