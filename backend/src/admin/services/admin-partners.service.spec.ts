import { Test, TestingModule } from '@nestjs/testing';
import { AdminPartnersService } from './admin-partners.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Partner } from '@/common/entities/partner.entity';
import { PartnerReviewLog } from '@/common/entities/partner-review-log.entity';
import {
  ReviewDecision,
  ReviewPartnerProfileDto,
} from '../dto/review-partner-profile.dto';
import { ReviewPartnerHandler } from '../application/handlers/review-partner.handler';
import { MockType } from '../../../test/mocks/mock-types';

describe('AdminPartnersService', () => {
  let service: AdminPartnersService;
  let reviewPartnerHandler: MockType<ReviewPartnerHandler>;

  const mockQueryBuilder = {
    leftJoinAndSelect: jest.fn().mockReturnThis(),
    select: jest.fn().mockReturnThis(),
    andWhere: jest.fn().mockReturnThis(),
    orderBy: jest.fn().mockReturnThis(),
    skip: jest.fn().mockReturnThis(),
    take: jest.fn().mockReturnThis(),
    getManyAndCount: jest.fn(),
  };

  const mockPartnerRepo = {
    findOne: jest.fn(),
    count: jest.fn(),
    createQueryBuilder: jest.fn().mockReturnValue(mockQueryBuilder),
  };
  const mockReviewLogRepo = {
    findOne: jest.fn(),
  };
  const mockReviewPartnerHandler = {
    execute: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AdminPartnersService,
        { provide: getRepositoryToken(Partner), useValue: mockPartnerRepo },
        {
          provide: getRepositoryToken(PartnerReviewLog),
          useValue: mockReviewLogRepo,
        },
        { provide: ReviewPartnerHandler, useValue: mockReviewPartnerHandler },
      ],
    }).compile();

    service = module.get<AdminPartnersService>(AdminPartnersService);
    reviewPartnerHandler = module.get(ReviewPartnerHandler);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('reviewPartner', () => {
    it('should delegate to ReviewPartnerHandler and return success response', async () => {
      // Arrange
      const partnerId = 'p1';
      const adminId = 'admin1';
      const dto: ReviewPartnerProfileDto = {
        decision: ReviewDecision.APPROVED,
        generalComment: 'Looks good',
        items: [],
      };
      mockReviewPartnerHandler.execute.mockResolvedValue(undefined);

      // Act
      const result = await service.reviewPartner(partnerId, dto, adminId);

      // Assert
      expect(reviewPartnerHandler.execute).toHaveBeenCalledWith(
        partnerId,
        dto,
        adminId,
      );
      expect(result.message).toBe('Review submitted successfully');
    });

    it('should propagate exceptions from handler', async () => {
      // Arrange
      const dto: ReviewPartnerProfileDto = {
        decision: ReviewDecision.APPROVED,
        generalComment: 'LGTM',
      };
      mockReviewPartnerHandler.execute.mockRejectedValue(
        new Error('Partner not found'),
      );

      // Act & Assert
      await expect(
        service.reviewPartner('p1', dto, 'admin1'),
      ).rejects.toThrow();
    });
  });

  describe('getTotalPartners', () => {
    it('should return total partner count', async () => {
      // Arrange
      mockPartnerRepo.count.mockResolvedValue(42);

      // Act
      const result = await service.getTotalPartners();

      // Assert
      expect(result.total).toBe(42);
    });
  });

  describe('getPartners', () => {
    it('should return paginated partners list', async () => {
      // Arrange
      const query = { page: 1, limit: 10 };
      const mockPartners = [
        {
          id: 'p1',
          taxCode: '123',
          legalName: 'Legal',
          brandName: 'Brand',
          businessType: ['SPA'],
          verificationStatus: 'PENDING',
          createdAt: new Date(),
          account: { email: 'test@test.com' },
        },
      ];
      mockQueryBuilder.getManyAndCount.mockResolvedValue([mockPartners, 1]);

      // Act
      const result = await service.getPartners(query as any);

      // Assert
      expect(result.data).toHaveLength(1);
      expect(result.total).toBe(1);
      expect(result.page).toBe(1);
      expect(result.data[0].email).toBe('test@test.com');
    });
  });
});
