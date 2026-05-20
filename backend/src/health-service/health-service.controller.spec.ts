import { Test, TestingModule } from '@nestjs/testing';
import { UserHealthServiceController } from './user-health-service.controller';
import { HealthServiceService } from './health-service.service';
import { MockType } from '../../test/mocks/mock-types';

describe('UserHealthServiceController', () => {
  let controller: UserHealthServiceController;
  let healthServiceService: MockType<HealthServiceService>;

  beforeEach(async () => {
    // Arrange - Create typed mock for HealthServiceService
    const mockHealthServiceService: MockType<HealthServiceService> = {
      findAll: jest.fn(),
      findOne: jest.fn(),
      findBySlug: jest.fn(),
      getPremiumTreatments: jest.fn(),
      getHomeRecommend: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [UserHealthServiceController],
      providers: [
        {
          provide: HealthServiceService,
          useValue: mockHealthServiceService,
        },
      ],
    }).compile();

    controller = module.get<UserHealthServiceController>(UserHealthServiceController);
    healthServiceService = module.get(HealthServiceService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  describe('getPremiumTreatments', () => {
    it('should delegate to healthServiceService.getPremiumTreatments', async () => {
      // Arrange
      const expected = [{ id: 'uuid-1', name: 'Test' }];
      healthServiceService.getPremiumTreatments!.mockResolvedValue(expected);

      // Act
      const result = await controller.getPremiumTreatments();

      // Assert
      expect(result).toEqual(expected);
      expect(healthServiceService.getPremiumTreatments!).toHaveBeenCalledTimes(
        1,
      );
    });
  });

  describe('getHomeRecommend', () => {
    it('should delegate to healthServiceService.getHomeRecommend', async () => {
      // Arrange
      const expected = [{ id: 'uuid-2', name: 'Recommend' }];
      healthServiceService.getHomeRecommend!.mockResolvedValue(expected);

      // Act
      const result = await controller.getHomeRecommend();

      // Assert
      expect(result).toEqual(expected);
      expect(healthServiceService.getHomeRecommend!).toHaveBeenCalledTimes(1);
    });
  });
});
