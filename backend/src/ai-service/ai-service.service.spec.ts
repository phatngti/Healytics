import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { AiServiceService } from './ai-service.service';
import { Product } from '@/common/entities/product.entity';
import { PartnersService } from '@/partners/partners.service';
import {
  MockType,
  createMockRepository,
  MockRepository,
} from '../../test/mocks/mock-types';

describe('AiServiceService', () => {
  let service: AiServiceService;
  let productRepo: MockRepository<Product>;
  let partnersService: MockType<PartnersService>;

  beforeEach(async () => {
    productRepo = createMockRepository<Product>();

    const mockPartnersService: MockType<PartnersService> = {
      getFirstHealthPartner: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AiServiceService,
        {
          provide: getRepositoryToken(Product),
          useValue: productRepo,
        },
        {
          provide: PartnersService,
          useValue: mockPartnersService,
        },
      ],
    }).compile();

    service = module.get<AiServiceService>(AiServiceService);
    partnersService = module.get(PartnersService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getRecommendations', () => {
    it('should return recommendations for valid service IDs', async () => {
      // Arrange
      const mockProducts = [
        {
          id: 'uuid-1',
          name: 'Service A',
          basePrice: 500000,
          currency: 'VND',
          media: [{ url: 'https://example.com/img.jpg', isThumbnail: true }],
          productEmployeeEligibilities: [
            { employee: { fullName: 'Dr. Test' } },
          ],
          reviews: [{ rating: 5 }, { rating: 4 }],
        },
        {
          id: 'uuid-2',
          name: 'Service B',
          basePrice: 300000,
          salePrice: 250000,
          currency: 'VND',
          media: [],
          productEmployeeEligibilities: [],
          reviews: [],
        },
      ];
      const mockPartner = {
        streetAddress: '123 Test St',
        district: { fullName: 'Quận 1' },
        province: { fullName: 'Hồ Chí Minh' },
      };

      productRepo.find.mockResolvedValue(mockProducts);
      partnersService.getFirstHealthPartner!.mockResolvedValue(mockPartner);

      // Act
      const result = await service.getRecommendations(['uuid-1', 'uuid-2']);

      // Assert
      expect(result.total).toBe(2);
      expect(result.recommendations).toHaveLength(2);

      // First recommendation
      expect(result.recommendations[0].service_id).toBe('uuid-1');
      expect(result.recommendations[0].name).toBe('Service A');
      expect(result.recommendations[0].image_url).toBe(
        'https://example.com/img.jpg',
      );
      expect(result.recommendations[0].price).toEqual({
        amount: 500000,
        currency: 'VND',
      });
      expect(result.recommendations[0].staff_name).toBe('Dr. Test');
      expect(result.recommendations[0].rating).toEqual({
        average: 4.5,
        total_reviews: 2,
      });
      expect(result.recommendations[0].location).toEqual({
        address: '123 Test St',
        district: 'Quận 1',
        city: 'Hồ Chí Minh',
      });

      // Second recommendation — uses salePrice
      expect(result.recommendations[1].price.amount).toBe(250000);
      expect(result.recommendations[1].staff_name).toBeNull();
      expect(result.recommendations[1].image_url).toBeNull();
    });

    it('should return empty when no products match', async () => {
      // Arrange
      productRepo.find.mockResolvedValue([]);
      partnersService.getFirstHealthPartner!.mockResolvedValue(null);

      // Act
      const result = await service.getRecommendations(['non-existent']);

      // Assert
      expect(result.total).toBe(0);
      expect(result.recommendations).toEqual([]);
    });

    it('should handle missing partner gracefully', async () => {
      // Arrange
      const mockProducts = [
        {
          id: 'uuid-1',
          name: 'Service A',
          basePrice: 100000,
          currency: 'VND',
          media: [],
          productEmployeeEligibilities: [],
          reviews: [],
        },
      ];
      productRepo.find.mockResolvedValue(mockProducts);
      partnersService.getFirstHealthPartner!.mockResolvedValue(null);

      // Act
      const result = await service.getRecommendations(['uuid-1']);

      // Assert
      expect(result.total).toBe(1);
      expect(result.recommendations[0].location).toEqual({
        address: '',
        district: '',
        city: '',
      });
    });
  });
});
