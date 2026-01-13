import { Test, TestingModule } from '@nestjs/testing';
import { ProductsService } from './products.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Product } from './entities/product.entity';
import { NotFoundException } from '@nestjs/common';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { CreateProductHandler } from './application/handlers/create-product.handler';
import { UpdateProductHandler } from './application/handlers/update-product.handler';
import { RemoveProductHandler } from './application/handlers/remove-product.handler';

describe('ProductsService', () => {
  let service: ProductsService;
  let createHandler: CreateProductHandler;
  let updateHandler: UpdateProductHandler;
  let removeHandler: RemoveProductHandler;
  let productRepository;

  const mockProductRepository = {
    find: jest.fn(),
    findOne: jest.fn(),
  };

  const mockCreateProductHandler = {
    execute: jest.fn(),
  };

  const mockUpdateProductHandler = {
    execute: jest.fn(),
  };

  const mockRemoveProductHandler = {
    execute: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProductsService,
        {
          provide: getRepositoryToken(Product),
          useValue: mockProductRepository,
        },
        {
          provide: CreateProductHandler,
          useValue: mockCreateProductHandler,
        },
        {
          provide: UpdateProductHandler,
          useValue: mockUpdateProductHandler,
        },
        {
          provide: RemoveProductHandler,
          useValue: mockRemoveProductHandler,
        },
      ],
    }).compile();

    service = module.get<ProductsService>(ProductsService);
    createHandler = module.get<CreateProductHandler>(CreateProductHandler);
    updateHandler = module.get<UpdateProductHandler>(UpdateProductHandler);
    removeHandler = module.get<RemoveProductHandler>(RemoveProductHandler);
    productRepository = module.get(getRepositoryToken(Product));
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('create', () => {
    it('should delegate to CreateProductHandler', async () => {
      const dto = { name: 'Test' } as CreateProductDto;
      const expectedProduct = { id: '1', name: 'Test' };
      
      mockCreateProductHandler.execute.mockResolvedValue(expectedProduct);

      const result = await service.create(dto);

      expect(result).toEqual(expectedProduct);
      expect(createHandler.execute).toHaveBeenCalledWith(dto);
    });
  });

  describe('update', () => {
    it('should delegate to UpdateProductHandler', async () => {
      const dto = { name: 'Updated' } as UpdateProductDto;
      const expectedProduct = { id: '1', name: 'Updated' };
      
      mockUpdateProductHandler.execute.mockResolvedValue(expectedProduct);

      const result = await service.update('1', dto);

      expect(result).toEqual(expectedProduct);
      expect(updateHandler.execute).toHaveBeenCalledWith('1', dto);
    });
  });

  describe('remove', () => {
    it('should delegate to RemoveProductHandler', async () => {
      mockRemoveProductHandler.execute.mockResolvedValue(undefined);

      await service.remove('1');

      expect(removeHandler.execute).toHaveBeenCalledWith('1');
    });
  });

  describe('findAll', () => {
    it('should return an array of products', async () => {
      const result = [{ id: '1', name: 'P1' }];
      mockProductRepository.find.mockResolvedValue(result);

      expect(await service.findAll()).toEqual(result);
      expect(mockProductRepository.find).toHaveBeenCalledWith(
        expect.objectContaining({
            relations: expect.any(Array),
            order: { createdAt: 'DESC' }
        })
      );
    });
  });

  describe('findOne', () => {
    it('should return a product if found', async () => {
      const product = { id: '1', name: 'P1' };
      mockProductRepository.findOne.mockResolvedValue(product);

      expect(await service.findOne('1')).toEqual(product);
      expect(mockProductRepository.findOne).toHaveBeenCalledWith(
        expect.objectContaining({ where: { id: '1' } })
      );
    });

    it('should throw NotFoundException if not found', async () => {
      mockProductRepository.findOne.mockResolvedValue(null);
      await expect(service.findOne('999')).rejects.toThrow(NotFoundException);
    });
  });

  describe('findBySlug', () => {
    it('should return a product if found', async () => {
      const product = { id: '1', slug: 'slug-1' };
      mockProductRepository.findOne.mockResolvedValue(product);

      expect(await service.findBySlug('slug-1')).toEqual(product);
      expect(mockProductRepository.findOne).toHaveBeenCalledWith(
        expect.objectContaining({ where: { slug: 'slug-1' } })
      );
    });

    it('should throw NotFoundException if not found', async () => {
      mockProductRepository.findOne.mockResolvedValue(null);
      await expect(service.findBySlug('missing-slug')).rejects.toThrow(NotFoundException);
    });
  });
});
