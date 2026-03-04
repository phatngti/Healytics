import { Test, TestingModule } from '@nestjs/testing';
import { PartnerProductsController } from './partner-products.controller';
import { ProductsService } from './products.service';
import { MockType } from '../../test/mocks/mock-types';
import { CreatePartnerProductDto } from './dto/partner/create-partner-product.dto';
import { UpdatePartnerProductDto } from './dto/partner/update-partner-product.dto';
import { ProductType } from './enums/product-type.enum';

describe('PartnerProductsController', () => {
  let controller: PartnerProductsController;
  let productsService: MockType<ProductsService>;

  beforeEach(async () => {
    // Arrange - Create typed mock for ProductsService
    const mockProductsService: MockType<ProductsService> = {
      create: jest.fn(),
      update: jest.fn(),
      remove: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [PartnerProductsController],
      providers: [
        {
          provide: ProductsService,
          useValue: mockProductsService,
        },
      ],
    }).compile();

    controller = module.get<PartnerProductsController>(PartnerProductsController);
    productsService = module.get(ProductsService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('create', () => {
    it('should call service.create with DTO and return the created product', async () => {
      // Arrange
      const createDto: CreatePartnerProductDto = {
        name: 'Thai Massage',
        slug: 'thai-massage',
        type: ProductType.SERVICE,
      };
      const expectedProduct = { id: 'uuid-1', ...createDto };
      productsService.create!.mockResolvedValue(expectedProduct);

      // Act
      const result = await controller.create(createDto);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(productsService.create).toHaveBeenCalledWith(createDto);
      expect(productsService.create).toHaveBeenCalledTimes(1);
    });
  });

  describe('update', () => {
    it('should call service.update with ID and DTO and return the updated product', async () => {
      // Arrange
      const id = 'uuid-1';
      const updateDto: UpdatePartnerProductDto = { name: 'Updated Massage' };
      const expectedProduct = { id, name: 'Updated Massage' };
      productsService.update!.mockResolvedValue(expectedProduct);

      // Act
      const result = await controller.update(id, updateDto);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(productsService.update).toHaveBeenCalledWith(id, updateDto);
      expect(productsService.update).toHaveBeenCalledTimes(1);
    });
  });

  describe('remove', () => {
    it('should call service.remove with ID and return void', async () => {
      // Arrange
      const id = 'uuid-1';
      productsService.remove!.mockResolvedValue(undefined);

      // Act
      const result = await controller.remove(id);

      // Assert
      expect(result).toBeUndefined();
      expect(productsService.remove).toHaveBeenCalledWith(id);
      expect(productsService.remove).toHaveBeenCalledTimes(1);
    });
  });
});
