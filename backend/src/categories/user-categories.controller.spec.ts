import { Test, TestingModule } from '@nestjs/testing';
import { UserCategoriesController } from './user-categories.controller';
import { CategoriesService } from './categories.service';
import { MockType } from '../../test/mocks/mock-types';

describe('UserCategoriesController', () => {
  let controller: UserCategoriesController;
  let categoriesService: MockType<CategoriesService>;

  beforeEach(async () => {
    const mockCategoriesService: MockType<CategoriesService> = {
      findSpecialistsByCategory: jest.fn(),
      findServicesByCategory: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [UserCategoriesController],
      providers: [
        {
          provide: CategoriesService,
          useValue: mockCategoriesService,
        },
      ],
    }).compile();

    controller = module.get<UserCategoriesController>(UserCategoriesController);
    categoriesService = module.get(CategoriesService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('findServicesByCategory', () => {
    it('should call service.findServicesByCategory with categoryId and query', async () => {
      // Arrange
      const categoryId = 'cat-uuid-1';
      const expected = [
        {
          id: 'svc-1',
          title: 'Deep Tissue',
          duration: '60 min',
          price: '850,000 VND',
        },
      ];
      categoriesService.findServicesByCategory!.mockResolvedValue(expected);

      // Act
      const query = { lat: 10.8, lng: 106.7 };
      const result = await controller.findServicesByCategory(categoryId, query);

      // Assert
      expect(result).toEqual(expected);
      expect(categoriesService.findServicesByCategory).toHaveBeenCalledWith(
        categoryId,
        query,
      );
    });

    it('should pass an empty query when not provided', async () => {
      // Arrange
      categoriesService.findServicesByCategory!.mockResolvedValue([]);

      // Act
      const result = await controller.findServicesByCategory('cat-uuid-2', {});

      // Assert
      expect(result).toEqual([]);
      expect(categoriesService.findServicesByCategory).toHaveBeenCalledWith(
        'cat-uuid-2',
        {},
      );
    });
  });

  describe('findSpecialistsByCategory', () => {
    it('should call service.findSpecialistsByCategory with categoryId', async () => {
      // Arrange
      const categoryId = 'cat-uuid-1';
      const expected = [
        {
          id: 'spec-1',
          name: 'Dr. Anna',
          specialty: 'Therapist',
          avatarUrl: null,
        },
      ];
      categoriesService.findSpecialistsByCategory!.mockResolvedValue(expected);

      // Act
      const result = await controller.findSpecialistsByCategory(categoryId);

      // Assert
      expect(result).toEqual(expected);
      expect(categoriesService.findSpecialistsByCategory).toHaveBeenCalledWith(
        categoryId,
      );
    });

    it('should return empty array when no specialists found', async () => {
      // Arrange
      categoriesService.findSpecialistsByCategory!.mockResolvedValue([]);

      // Act
      const result = await controller.findSpecialistsByCategory('cat-uuid-2');

      // Assert
      expect(result).toEqual([]);
    });
  });
});
