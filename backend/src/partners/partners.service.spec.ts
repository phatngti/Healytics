import { Test, TestingModule } from '@nestjs/testing';
import { PartnersService } from './partners.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Account } from '@/common/entities/account.entity';
import { Partner } from '@/common/entities/partner.entity';
import { PartnerReviewLog } from '@/common/entities/partner-review-log.entity';
import { PartnerCertification } from '@/clinic/entities/partner-certification.entity';
import { NotFoundException } from '@nestjs/common';
import { BusinessType } from './enum/business-type.enum';
import { PartnerVerificationStatus } from './enum/partner-verification-status.enum';
import { RegisterPartnerHandler } from './application/handlers/register-partner.handler';
import { UpdatePartnerProfileHandler } from './application/handlers/update-partner-profile.handler';
import { Role } from '@/account/enum/role.enum';
import { BadRequestException } from '@nestjs/common';

describe('PartnersService', () => {
  const completedDescription =
    'A modern wellness clinic focused on preventive care, personalized treatment planning, and a calm patient experience across consultation, therapy, and follow-up visits.';

  let service: PartnersService;
  let accountRepository: Record<string, jest.Mock>;
  let partnerRepository: Record<string, jest.Mock>;
  let registerPartnerHandler: Record<string, jest.Mock>;
  let updatePartnerProfileHandler: Record<string, jest.Mock>;

  const mockAccountRepository = {
    findOne: jest.fn(),
  };

  const mockPartnerRepository = {
    findOne: jest.fn(),
    save: jest.fn(),
  };

  const mockReviewLogRepository = {
    findOne: jest.fn(),
  };

  const mockRegisterPartnerHandler = {
    execute: jest.fn(),
  };

  const mockUpdatePartnerProfileHandler = {
    execute: jest.fn(),
  };

  const mockAccount = {
    id: 'account-uuid',
    email: 'partner@test.com',
    role: Role.HEALTH_PARTNER,
    isActive: true,
  };

  const mockPartner = {
    id: 'partner-uuid',
    taxCode: '1234567890',
    legalName: 'Test Business',
    brandName: 'Test Brand',
    businessType: [BusinessType.MASSAGE_THERAPY],
    provinceId: 'province-1',
    districtId: 'district-1',
    wardId: 'ward-1',
    streetAddress: '123 Test Street',
    accountId: 'account-uuid',
    verificationStatus: PartnerVerificationStatus.PENDING,
    verificationCompletedAt: null,
    createdAt: new Date(),
    province: { id: 'province-1', name: 'Hà Nội' },
    district: { id: 'district-1', name: 'Quận 1' },
    ward: { id: 'ward-1', name: 'Phường 1' },
    legalRepresentative: {
      fullName: 'John Doe',
      position: 'Director',
      phoneNumber: '0901234567',
      idType: 'CCCD',
      idNumber: '012345678901',
      idIssueDate: new Date('2020-01-15'),
    },
    account: mockAccount,
    documents: [],
    coverImageUrl: null,
    logoImageUrl: null,
    gallery: [],
    description: null,
  };

  const mockCertificationRepository = {
    find: jest.fn(),
    save: jest.fn(),
    create: jest.fn((value) => value),
    delete: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PartnersService,
        {
          provide: getRepositoryToken(Account),
          useValue: mockAccountRepository,
        },
        {
          provide: getRepositoryToken(Partner),
          useValue: mockPartnerRepository,
        },
        {
          provide: getRepositoryToken(PartnerReviewLog),
          useValue: mockReviewLogRepository,
        },
        {
          provide: getRepositoryToken(PartnerCertification),
          useValue: mockCertificationRepository,
        },
        {
          provide: RegisterPartnerHandler,
          useValue: mockRegisterPartnerHandler,
        },
        {
          provide: UpdatePartnerProfileHandler,
          useValue: mockUpdatePartnerProfileHandler,
        },
      ],
    }).compile();

    service = module.get<PartnersService>(PartnersService);
    accountRepository = module.get(getRepositoryToken(Account));
    partnerRepository = module.get(getRepositoryToken(Partner));
    registerPartnerHandler = module.get(RegisterPartnerHandler);
    updatePartnerProfileHandler = module.get(UpdatePartnerProfileHandler);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getBusinessServices', () => {
    it('should return all business services with Vietnamese labels', () => {
      // Act
      const result = service.getBusinessServices();

      // Assert
      expect(result.data).toHaveLength(11);
      expect(result.data[0]).toEqual({
        value: BusinessType.MASSAGE_THERAPY,
        label: 'Massage Therapy',
        description: 'Massage Thư giãn',
      });
      expect(result.data).toContainEqual({
        value: BusinessType.PHARMACY,
        label: 'Pharmacy',
        description: 'Dược phẩm',
      });
    });
  });

  describe('registerPartner', () => {
    it('should delegate to RegisterPartnerHandler', async () => {
      // Arrange
      const dto = { account: { email: 'test@test.com' } } as any;
      const expectedResult = {
        accountId: 'acc-1',
        businessEntityId: 'biz-1',
        status: 'success',
        message: 'Partner registration successful',
        access_token: 'token',
        refresh_token: 'refresh',
      };
      mockRegisterPartnerHandler.execute.mockResolvedValue(expectedResult);

      // Act
      const result = await service.registerPartner(dto);

      // Assert
      expect(result).toEqual(expectedResult);
      expect(mockRegisterPartnerHandler.execute).toHaveBeenCalledWith(dto);
      expect(mockRegisterPartnerHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('updateMyProfile', () => {
    it('should delegate to UpdatePartnerProfileHandler', async () => {
      // Arrange
      const updateDto = { brandName: 'Updated Brand' } as any;
      mockPartnerRepository.findOne.mockResolvedValue({ ...mockPartner });
      mockUpdatePartnerProfileHandler.execute.mockResolvedValue(undefined);

      // Re-mock findOne for getMyProfile call after update
      mockPartnerRepository.findOne
        .mockResolvedValueOnce({ ...mockPartner }) // getPartnerByAccountId
        .mockResolvedValueOnce({ ...mockPartner }); // getMyProfile
      mockReviewLogRepository.findOne.mockResolvedValue(null);

      // Act
      const result = await service.updateMyProfile('account-uuid', updateDto);

      // Assert
      expect(result).toBeDefined();
      expect(mockUpdatePartnerProfileHandler.execute).toHaveBeenCalledWith(
        expect.objectContaining({ id: 'partner-uuid' }),
        updateDto,
      );
    });

    it('should throw NotFoundException when partner not found', async () => {
      // Arrange
      mockPartnerRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(
        service.updateMyProfile('invalid-account', {} as any),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('getMyProfile', () => {
    it('should return formatted profile with verification fields', async () => {
      // Arrange
      mockPartnerRepository.findOne.mockResolvedValue({
        ...mockPartner,
      });
      mockReviewLogRepository.findOne.mockResolvedValue(null);

      // Act
      const result = await service.getMyProfile('account-uuid');

      // Assert
      expect(result.id).toBe(mockPartner.id);
      expect(result.businessInfo.brandName.value).toBe(mockPartner.brandName);
      expect(result.businessInfo.address?.streetAddress.value).toBe(
        mockPartner.streetAddress,
      );
      expect(result.legalRepresentative?.fullName.value).toBe('John Doe');
      expect(result.verificationStatus).toBe(PartnerVerificationStatus.PENDING);
    });

    it('should throw NotFoundException when partner not found', async () => {
      // Arrange
      mockPartnerRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(service.getMyProfile('invalid-account')).rejects.toThrow(
        NotFoundException,
      );
      await expect(service.getMyProfile('invalid-account')).rejects.toThrow(
        'Partner not found',
      );
    });
  });

  describe('profile completion', () => {
    it('should compute partner profile completion status', () => {
      expect(
        service.isPartnerProfileCompleted({
          coverImageUrl: 'https://cdn.example.com/cover.jpg',
          logoImageUrl: 'https://cdn.example.com/logo.jpg',
          description: completedDescription,
          gallery: ['1', '2', '3'],
        }),
      ).toBe(true);

      expect(
        service.isPartnerProfileCompleted({
          coverImageUrl: 'https://cdn.example.com/cover.jpg',
          logoImageUrl: null,
          description: 'Incomplete clinic profile',
          gallery: ['1', '2', '3'],
        }),
      ).toBe(false);
    });

    it('should return profile completion data for approved partners', async () => {
      mockPartnerRepository.findOne.mockResolvedValue({
        ...mockPartner,
        verificationStatus: PartnerVerificationStatus.APPROVED,
        brandName: 'Approved Clinic',
      });
      mockCertificationRepository.find.mockResolvedValue([
        {
          id: 'cert-1',
          partnerId: 'partner-uuid',
          title: 'ISO 9001:2015',
          subtitle: 'Quality',
          iconName: 'workspace_premium',
          sortOrder: 0,
        },
      ]);

      const result = await service.getMyProfileCompletion('account-uuid');

      expect(result.clinicIdentity.brandName).toBe('Approved Clinic');
      expect(result.certifications).toHaveLength(1);
      expect(result.isCompleted).toBe(false);
    });

    it('should reject completion access for non-approved partners', async () => {
      mockPartnerRepository.findOne.mockResolvedValue({
        ...mockPartner,
        verificationStatus: PartnerVerificationStatus.PENDING,
      });

      await expect(
        service.getMyProfileCompletion('account-uuid'),
      ).rejects.toThrow(BadRequestException);
    });

    it('should update completion data and certifications', async () => {
      mockPartnerRepository.findOne
        .mockResolvedValueOnce({
          ...mockPartner,
          verificationStatus: PartnerVerificationStatus.APPROVED,
        })
        .mockResolvedValueOnce({
          ...mockPartner,
          verificationStatus: PartnerVerificationStatus.APPROVED,
          coverImageUrl: 'https://cdn.example.com/cover.jpg',
          logoImageUrl: 'https://cdn.example.com/logo.jpg',
          description: completedDescription,
          gallery: ['a', 'b', 'c'],
        });
      mockPartnerRepository.save.mockResolvedValue(undefined);
      mockCertificationRepository.find
        .mockResolvedValueOnce([
          {
            id: 'cert-old',
            partnerId: 'partner-uuid',
            title: 'Old',
            subtitle: null,
            iconName: 'verified',
            sortOrder: 0,
          },
        ])
        .mockResolvedValueOnce([
          {
            id: 'cert-new',
            partnerId: 'partner-uuid',
            title: 'ISO 9001:2015',
            subtitle: 'Quality',
            iconName: 'workspace_premium',
            sortOrder: 0,
          },
        ]);
      mockCertificationRepository.save.mockResolvedValue([
        {
          id: 'cert-new',
          partnerId: 'partner-uuid',
          title: 'ISO 9001:2015',
          subtitle: 'Quality',
          iconName: 'workspace_premium',
          sortOrder: 0,
        },
      ]);
      mockCertificationRepository.delete.mockResolvedValue(undefined);

      const result = await service.updateMyProfileCompletion('account-uuid', {
        coverImageUrl: 'https://cdn.example.com/cover.jpg',
        logoImageUrl: 'https://cdn.example.com/logo.jpg',
        description: completedDescription,
        gallery: ['a', 'b', 'c'],
        certifications: [
          {
            title: 'ISO 9001:2015',
            subtitle: 'Quality',
            iconName: 'workspace_premium',
            sortOrder: 0,
          },
        ],
      });

      expect(mockPartnerRepository.save).toHaveBeenCalled();
      expect(result.isCompleted).toBe(true);
      expect(result.certifications).toHaveLength(1);
    });
  });

  describe('getPartnerByAccountId', () => {
    it('should return partner when found', async () => {
      // Arrange
      mockPartnerRepository.findOne.mockResolvedValue(mockPartner);

      // Act
      const result = await service.getPartnerByAccountId('account-uuid');

      // Assert
      expect(result).toEqual(mockPartner);
      expect(mockPartnerRepository.findOne).toHaveBeenCalledWith({
        where: { accountId: 'account-uuid' },
        relations: [
          'province',
          'district',
          'ward',
          'legalRepresentative',
          'documents',
        ],
      });
    });

    it('should return null when partner not found', async () => {
      // Arrange
      mockPartnerRepository.findOne.mockResolvedValue(null);

      // Act
      const result = await service.getPartnerByAccountId('invalid-account');

      // Assert
      expect(result).toBeNull();
    });
  });

  describe('getFirstHealthPartner', () => {
    it('should return first health partner', async () => {
      // Arrange
      mockAccountRepository.findOne.mockResolvedValue(mockAccount);
      mockPartnerRepository.findOne.mockResolvedValue(mockPartner);

      // Act
      const result = await service.getFirstHealthPartner();

      // Assert
      expect(result).toEqual(mockPartner);
    });

    it('should return null when no health partner account exists', async () => {
      // Arrange
      mockAccountRepository.findOne.mockResolvedValue(null);

      // Act
      const result = await service.getFirstHealthPartner();

      // Assert
      expect(result).toBeNull();
    });
  });
});
