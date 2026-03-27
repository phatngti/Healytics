import { Test, TestingModule } from '@nestjs/testing';
import { CategoriesController } from './categories.controller';
import { CategoriesService } from './categories.service';
import { FindCategoriesQueryDto } from './dto/find-categories-query.dto';
import { MockType } from '../../test/mocks/mock-types';

describe('CategoriesController', () => {
  let controller: CategoriesController;
  let categoriesService: MockType<CategoriesService>;

  beforeEach(async () => {
    // Arrange - Create typed mock for CategoriesService
    const mockCategoriesService: MockType<CategoriesService> = {
      findAll: jest.fn(),
      findOne: jest.fn(),
      findBySlug: jest.fn(),
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
});
