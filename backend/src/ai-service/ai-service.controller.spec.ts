import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { AiServiceController } from './ai-service.controller';
import { AiServiceService } from './ai-service.service';
import { MockType } from '../../test/mocks/mock-types';

describe('AiServiceController', () => {
  let controller: AiServiceController;
  let aiServiceService: MockType<AiServiceService>;

  beforeEach(async () => {
    // Arrange — Create typed mocks
    const mockAiServiceService: MockType<AiServiceService> = {
      getRecommendations: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [AiServiceController],
      providers: [
        {
          provide: AiServiceService,
          useValue: mockAiServiceService,
        },
        {
          provide: ConfigService,
          useValue: { get: jest.fn().mockReturnValue('test-token') },
        },
      ],
    }).compile();

    controller = module.get<AiServiceController>(AiServiceController);
    aiServiceService = module.get(AiServiceService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  describe('getRecommendations', () => {
    it('should delegate to aiServiceService.getRecommendations', async () => {
      // Arrange
      const requestDto = { serviceIds: ['uuid-1', 'uuid-2'] };
      const expected = {
        total: 2,
        recommendations: [
          { id: 'uuid-1', name: 'Service A' },
          { id: 'uuid-2', name: 'Service B' },
        ],
      };
      aiServiceService.getRecommendations!.mockResolvedValue(expected);

      // Act
      const result = await controller.getRecommendations(requestDto);

      // Assert
      expect(result).toEqual(expected);
      expect(aiServiceService.getRecommendations!).toHaveBeenCalledTimes(1);
      expect(aiServiceService.getRecommendations!).toHaveBeenCalledWith([
        'uuid-1',
        'uuid-2',
      ]);
    });

    it('should return empty recommendations for non-matching IDs', async () => {
      // Arrange
      const requestDto = { serviceIds: ['non-existent'] };
      const expected = { total: 0, recommendations: [] };
      aiServiceService.getRecommendations!.mockResolvedValue(expected);

      // Act
      const result = await controller.getRecommendations(requestDto);

      // Assert
      expect(result).toEqual(expected);
      expect(aiServiceService.getRecommendations!).toHaveBeenCalledWith([
        'non-existent',
      ]);
    });
  });
});
