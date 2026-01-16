import { Test, TestingModule } from '@nestjs/testing';
import { CategoriesController } from './categories.controller';
import { CategoriesService } from './categories.service';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
import { FindCategoriesQueryDto } from './dto/find-categories-query.dto';
import { MockType } from '../../test/mocks/mock-types';

describe('CategoriesController', () => {
  let controller: CategoriesController;
  let categoriesService: MockType<CategoriesService>;

  beforeEach(async () => {
    // Arrange - Create typed mock for CategoriesService
    const mockCategoriesService: MockType<CategoriesService> = {
      create: jest.fn(),
      findAll: jest.fn(),
      findOne: jest.fn(),
      findBySlug: jest.fn(),
      update: jest.fn(),
      remove: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [CategoriesController],
      providers: [
        {
          provide: CategoriesService,
          useValue: mockCategoriesService,
        },
      ],
    }).compile();

    controller = module.get<CategoriesController>(CategoriesController);
    categoriesService = module.get(CategoriesService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('create', () => {
    it('should call service.create with DTO and return created category', async () => {
      // Arrange
      const dto: CreateCategoryDto = { name: 'Test Category', slug: 'test-category' } as CreateCategoryDto;
      const expectedCategory = { id: 'uuid-1', name: 'Test Category', slug: 'test-category' };
      categoriesService.create!.mockResolvedValue(expectedCategory);

      // Act
      const result = await controller.create(dto);

      // Assert
      expect(result).toEqual(expectedCategory);
      expect(categoriesService.create).toHaveBeenCalledWith(dto);
      expect(categoriesService.create).toHaveBeenCalledTimes(1);
    });
  });

  describe('findAll', () => {
    it('should call service.findAll with rootsOnly=false when not specified', async () => {
      // Arrange
      const query: FindCategoriesQueryDto = {};
      const expectedCategories = [{ id: '1' }, { id: '2' }];
      categoriesService.findAll!.mockResolvedValue(expectedCategories);

      // Act
      const result = await controller.findAll(query);

      // Assert
      expect(result).toEqual(expectedCategories);
      expect(categoriesService.findAll).toHaveBeenCalledWith(false);
    });

    it('should call service.findAll with rootsOnly=true when specified', async () => {
      // Arrange
      const query: FindCategoriesQueryDto = { rootsOnly: true };
      const expectedCategories = [{ id: '1', parentId: null }];
      categoriesService.findAll!.mockResolvedValue(expectedCategories);

      // Act
      const result = await controller.findAll(query);

      // Assert
      expect(result).toEqual(expectedCategories);
      expect(categoriesService.findAll).toHaveBeenCalledWith(true);
    });
  });

  describe('findOne', () => {
    it('should call service.findOne with ID and return category', async () => {
      // Arrange
      const id = 'uuid-1';
      const expectedCategory = { id, name: 'Category' };
      categoriesService.findOne!.mockResolvedValue(expectedCategory);

      // Act
      const result = await controller.findOne(id);

      // Assert
      expect(result).toEqual(expectedCategory);
      expect(categoriesService.findOne).toHaveBeenCalledWith(id);
    });
  });

  describe('findBySlug', () => {
    it('should call service.findBySlug with slug and return category', async () => {
      // Arrange
      const slug = 'test-category';
      const expectedCategory = { id: 'uuid-1', slug };
      categoriesService.findBySlug!.mockResolvedValue(expectedCategory);

      // Act
      const result = await controller.findBySlug(slug);

      // Assert
      expect(result).toEqual(expectedCategory);
      expect(categoriesService.findBySlug).toHaveBeenCalledWith(slug);
    });
  });

  describe('update', () => {
    it('should call service.update with ID and DTO and return updated category', async () => {
      // Arrange
      const id = 'uuid-1';
      const dto: UpdateCategoryDto = { name: 'Updated' } as UpdateCategoryDto;
      const expectedCategory = { id, name: 'Updated' };
      categoriesService.update!.mockResolvedValue(expectedCategory);

      // Act
      const result = await controller.update(id, dto);

      // Assert
      expect(result).toEqual(expectedCategory);
      expect(categoriesService.update).toHaveBeenCalledWith(id, dto);
    });
  });

  describe('remove', () => {
    it('should call service.remove with ID', async () => {
      // Arrange
      const id = 'uuid-1';
      categoriesService.remove!.mockResolvedValue(undefined);

      // Act
      await controller.remove(id);

      // Assert
      expect(categoriesService.remove).toHaveBeenCalledWith(id);
      expect(categoriesService.remove).toHaveBeenCalledTimes(1);
    });
  });
});
