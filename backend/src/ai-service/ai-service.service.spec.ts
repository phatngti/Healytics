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
          slug: 'service-a',
          basePrice: 500000,
          currency: 'VND',
          type: 'service',
          vendorName: null,
          media: [{ url: 'https://example.com/img.jpg', isThumbnail: true }],
          category: { name: 'Massage' },
          productDefinition: { durationMinutes: 60 },
          productEmployeeEligibilities: [
            { employee: { fullName: 'Dr. Test', avatarUrl: 'https://example.com/avatar.jpg' } },
          ],
        },
        {
          id: 'uuid-2',
          name: 'Service B',
          slug: 'service-b',
          basePrice: 300000,
          salePrice: 250000,
          currency: 'VND',
          type: 'service',
          vendorName: null,
          media: [],
          category: null,
          productDefinition: null,
          productEmployeeEligibilities: [],
        },
      ];
      const mockPartner = {
        brandName: 'Healytics Spa',
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

      // First recommendation — flat card-style fields
      const rec0 = result.recommendations[0];
      expect(rec0.service_id).toBe('uuid-1');
      expect(rec0.name).toBe('Service A');
      expect(rec0.slug).toBe('service-a');
      expect(rec0.imageUrl).toBe('https://example.com/img.jpg');
      expect(rec0.category).toBe('Massage');
      expect(rec0.duration).toBe('60 min');
      expect(rec0.price).toBe(new Intl.NumberFormat('vi-VN').format(500000));
      expect(rec0.rating).toBe('0');
      expect(rec0.vendorName).toBe('Healytics Spa');
      expect(rec0.location).toBe('Quận 1, Hồ Chí Minh');
      expect(rec0.staffAvatars).toEqual(['https://example.com/avatar.jpg']);
      expect(rec0.type).toBe('service');

      // Second recommendation — uses salePrice, no category/duration
      const rec1 = result.recommendations[1];
      expect(rec1.price).toBe(new Intl.NumberFormat('vi-VN').format(250000));
      expect(rec1.imageUrl).toBeNull();
      expect(rec1.category).toBe('Uncategorized');
      expect(rec1.duration).toBe('');
      expect(rec1.staffAvatars).toEqual([]);
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
          slug: 'service-a',
          basePrice: 100000,
          currency: 'VND',
          type: 'service',
          vendorName: null,
          media: [],
          category: null,
          productDefinition: null,
          productEmployeeEligibilities: [],
        },
      ];
      productRepo.find.mockResolvedValue(mockProducts);
      partnersService.getFirstHealthPartner!.mockResolvedValue(null);

      // Act
      const result = await service.getRecommendations(['uuid-1']);

      // Assert
      expect(result.total).toBe(1);
      expect(result.recommendations[0].location).toBe('');
      expect(result.recommendations[0].vendorName).toBe('');
    });
  });
});
