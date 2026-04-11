import { Test, TestingModule } from '@nestjs/testing';
import {
  PartnersController,
  PartnerSelfController,
} from './partners.controller';
import { PartnersService } from './partners.service';
import { NotFoundException } from '@nestjs/common';
import { BusinessType } from './enum/business-type.enum';
import { PartnerVerificationStatus } from './enum/partner-verification-status.enum';

describe('PartnersController', () => {
  let controller: PartnersController;
  let partnersService: Record<string, jest.Mock>;

  const mockPartnersService = {
    getBusinessServices: jest.fn(),
    getMyProfile: jest.fn(),
    updateMyProfile: jest.fn(),
    getMyProfileCompletion: jest.fn(),
    updateMyProfileCompletion: jest.fn(),
  };

  const mockBusinessServices = {
    data: [
      { value: BusinessType.MASSAGE_THERAPY, label: 'Massage Thư giãn' },
      { value: BusinessType.SPA_BEAUTY, label: 'Spa & Làm đẹp' },
    ],
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      controllers: [PartnersController],
      providers: [
        {
          provide: PartnersService,
          useValue: mockPartnersService,
        },
      ],
    }).compile();

    controller = module.get<PartnersController>(PartnersController);
    partnersService = module.get(PartnersService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getBusinessServices', () => {
    it('should return all business services', () => {
      // Arrange
      mockPartnersService.getBusinessServices.mockReturnValue(
        mockBusinessServices,
      );

      // Act
      const result = controller.getBusinessServices();

      // Assert
      expect(result).toEqual(mockBusinessServices);
      expect(mockPartnersService.getBusinessServices).toHaveBeenCalled();
    });
  });
});

describe('PartnerSelfController', () => {
  let controller: PartnerSelfController;
  let partnersService: Record<string, jest.Mock>;

  const mockPartnersService = {
    getBusinessServices: jest.fn(),
    getMyProfile: jest.fn(),
    updateMyProfile: jest.fn(),
    getMyProfileCompletion: jest.fn(),
    updateMyProfileCompletion: jest.fn(),
  };

  const mockProfile = {
    id: 'partner-uuid',
    taxCode: '1234567890',
    legalName: 'Test Business',
    brandName: 'Test Brand',
    businessType: [BusinessType.MASSAGE_THERAPY],
    address: {
      province: 'Hà Nội',
      district: 'Quận 1',
      ward: 'Phường 1',
      streetAddress: '123 Test Street',
    },
    legalRepresentative: {
      fullName: 'John Doe',
      position: 'Director',
      idType: 'CCCD',
      idNumber: '012345678901',
    },
    createdAt: new Date(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      controllers: [PartnerSelfController],
      providers: [
        {
          provide: PartnersService,
          useValue: mockPartnersService,
        },
      ],
    }).compile();

    controller = module.get<PartnerSelfController>(PartnerSelfController);
    partnersService = module.get(PartnersService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getMyProfile', () => {
    it('should return partner profile for authenticated user', async () => {
      // Arrange
      const userId = 'account-uuid';
      mockPartnersService.getMyProfile.mockResolvedValue(mockProfile);

      // Act
      const result = await controller.getMyProfile(userId);

      // Assert
      expect(result).toEqual(mockProfile);
      expect(mockPartnersService.getMyProfile).toHaveBeenCalledWith(userId);
    });

    it('should propagate NotFoundException from service', async () => {
      // Arrange
      const userId = 'invalid-uuid';
      mockPartnersService.getMyProfile.mockRejectedValue(
        new NotFoundException('Partner not found'),
      );

      // Act & Assert
      await expect(controller.getMyProfile(userId)).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('updateMyProfile', () => {
    const updateDto = {
      brandName: 'Updated Brand',
      streetAddress: 'Updated Address',
    };

    it('should update partner profile', async () => {
      // Arrange
      const userId = 'account-uuid';
      const updatedProfile = { ...mockProfile, ...updateDto };
      mockPartnersService.updateMyProfile.mockResolvedValue(updatedProfile);

      // Act
      const result = await controller.updateMyProfile(userId, updateDto as any);

      // Assert
      expect(result).toEqual(updatedProfile);
      expect(mockPartnersService.updateMyProfile).toHaveBeenCalledWith(
        userId,
        updateDto,
      );
    });
  });

  describe('profile completion', () => {
    it('should return profile completion data', async () => {
      const userId = 'account-uuid';
      const completion = {
        id: 'partner-uuid',
        isCompleted: false,
        completionPercent: 25,
      };
      mockPartnersService.getMyProfileCompletion.mockResolvedValue(completion);

      const result = await controller.getMyProfileCompletion(userId);

      expect(result).toEqual(completion);
      expect(mockPartnersService.getMyProfileCompletion).toHaveBeenCalledWith(
        userId,
      );
    });

    it('should update profile completion data', async () => {
      const userId = 'account-uuid';
      const dto = {
        coverImageUrl: 'https://cdn.example.com/cover.jpg',
        gallery: ['https://cdn.example.com/gallery-1.jpg'],
      };
      const updated = {
        id: 'partner-uuid',
        isCompleted: false,
        completionPercent: 50,
      };
      mockPartnersService.updateMyProfileCompletion.mockResolvedValue(updated);

      const result = await controller.updateMyProfileCompletion(
        userId,
        dto as any,
      );

      expect(result).toEqual(updated);
      expect(
        mockPartnersService.updateMyProfileCompletion,
      ).toHaveBeenCalledWith(userId, dto);
    });
  });
});
