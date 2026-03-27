import { Test, TestingModule } from '@nestjs/testing';
import { AdminCategoriesController } from './admin-categories.controller';
import { CategoriesService } from './categories.service';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
import { MockType } from '../../test/mocks/mock-types';

describe('AdminCategoriesController', () => {
  let controller: AdminCategoriesController;
  let categoriesService: MockType<CategoriesService>;

  beforeEach(async () => {
    const mockCategoriesService: MockType<CategoriesService> = {
      createForAdmin: jest.fn(),
      updateForAdmin: jest.fn(),
      remove: jest.fn(),
      findAllForAdmin: jest.fn(),
      findOneForAdmin: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [AdminCategoriesController],
      providers: [
        {
          provide: CategoriesService,
          useValue: mockCategoriesService,
        },
      ],
    }).compile();

    controller = module.get<AdminCategoriesController>(AdminCategoriesController);
    categoriesService = module.get(CategoriesService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('findAll', () => {
    it('should call service.findAllForAdmin and return admin categories', async () => {
      // Arrange
      const expectedCategories = [
        {
          id: 'uuid-1',
          name: 'Test',
          iconName: 'spa',
          colorValue: '#FF6B6B',
          sortOrder: 0,
          serviceCount: 5,
        },
      ];
      categoriesService.findAllForAdmin!.mockResolvedValue(expectedCategories);

      // Act
      const result = await controller.findAll();

      // Assert
      expect(result).toEqual(expectedCategories);
      expect(categoriesService.findAllForAdmin).toHaveBeenCalledTimes(1);
    });
  });

  describe('findOne', () => {
    it('should call service.findOneForAdmin with ID', async () => {
      // Arrange
      const id = 'uuid-1';
      const expectedCategory = {
        id,
        name: 'Category',
        iconName: 'dental',
        colorValue: '#4ECDC4',
        sortOrder: 1,
        serviceCount: 3,
      };
      categoriesService.findOneForAdmin!.mockResolvedValue(expectedCategory);

      // Act
      const result = await controller.findOne(id);

      // Assert
      expect(result).toEqual(expectedCategory);
      expect(categoriesService.findOneForAdmin).toHaveBeenCalledWith(id);
    });
  });

  describe('create', () => {
    it('should call service.createForAdmin with DTO and return admin category', async () => {
      // Arrange
      const dto: CreateCategoryDto = {
        name: 'Test Category',
        slug: 'test-category',
        iconName: 'spa',
        colorValue: '#FF6B6B',
        sortOrder: 0,
      } as CreateCategoryDto;
      const expectedCategory = { id: 'uuid-1', ...dto, serviceCount: 0 };
      categoriesService.createForAdmin!.mockResolvedValue(expectedCategory);

      // Act
      const result = await controller.create(dto);

      // Assert
      expect(result).toEqual(expectedCategory);
      expect(categoriesService.createForAdmin).toHaveBeenCalledWith(dto);
      expect(categoriesService.createForAdmin).toHaveBeenCalledTimes(1);
    });
  });

  describe('update', () => {
    it('should call service.updateForAdmin with ID and DTO', async () => {
      // Arrange
      const id = 'uuid-1';
      const dto: UpdateCategoryDto = { name: 'Updated', sortOrder: 2 } as UpdateCategoryDto;
      const expectedCategory = { id, name: 'Updated', sortOrder: 2, serviceCount: 5 };
      categoriesService.updateForAdmin!.mockResolvedValue(expectedCategory);

      // Act
      const result = await controller.update(id, dto);

      // Assert
      expect(result).toEqual(expectedCategory);
      expect(categoriesService.updateForAdmin).toHaveBeenCalledWith(id, dto);
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
