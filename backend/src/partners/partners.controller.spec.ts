import { Test, TestingModule } from '@nestjs/testing';
import { PartnersController } from './partners.controller';
import { PartnersService } from './partners.service';
import { NotFoundException } from '@nestjs/common';
import { BusinessType } from './enum/business-type.enum';

describe('PartnersController', () => {
    let controller: PartnersController;
    let partnersService: Record<string, jest.Mock>;

    const mockPartnersService = {
        getBusinessTypes: jest.fn(),
        getMyProfile: jest.fn(),
        updateMyProfile: jest.fn(),
        getPartners: jest.fn(),
        getPartnerDetail: jest.fn(),
    };

    // Mock data
    const mockBusinessTypes = {
        data: [
            { value: BusinessType.MASSAGE_THERAPY, label: 'Massage Thư giãn' },
            { value: BusinessType.SPA_BEAUTY, label: 'Spa & Làm đẹp' },
        ],
    };

    const mockProfile = {
        id: 'partner-uuid',
        taxCode: '1234567890',
        legalName: 'Test Business',
        brandName: 'Test Brand',
        businessType: BusinessType.MASSAGE_THERAPY,
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
        isVerified: false,
        createdAt: new Date(),
    };

    const mockPartnersList = {
        data: [
            {
                id: 'partner-1',
                taxCode: '1234567890',
                brandName: 'Brand 1',
                email: 'partner1@test.com',
                businessType: BusinessType.MASSAGE_THERAPY,
                isVerified: true,
                createdAt: new Date(),
            },
        ],
        total: 1,
        page: 1,
        limit: 10,
    };

    const mockReq = {
        user: {
            id: 'account-uuid',
            email: 'partner@test.com',
        },
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

    describe('getBusinessTypes', () => {
        it('should return all business types', () => {
            // Arrange
            mockPartnersService.getBusinessTypes.mockReturnValue(mockBusinessTypes);

            // Act
            const result = controller.getBusinessTypes();

            // Assert
            expect(result).toEqual(mockBusinessTypes);
            expect(mockPartnersService.getBusinessTypes).toHaveBeenCalled();
        });
    });

    describe('getMyProfile', () => {
        it('should return partner profile for authenticated user', async () => {
            // Arrange
            mockPartnersService.getMyProfile.mockResolvedValue(mockProfile);

            // Act
            const result = await controller.getMyProfile(mockReq);

            // Assert
            expect(result).toEqual(mockProfile);
            expect(mockPartnersService.getMyProfile).toHaveBeenCalledWith(mockReq.user.id);
        });

        it('should propagate NotFoundException from service', async () => {
            // Arrange
            mockPartnersService.getMyProfile.mockRejectedValue(
                new NotFoundException('Partner not found'),
            );

            // Act & Assert
            await expect(controller.getMyProfile(mockReq)).rejects.toThrow(NotFoundException);
        });
    });

    describe('updateMyProfile', () => {
        const updateDto = {
            brandName: 'Updated Brand',
            streetAddress: 'Updated Address',
        };

        it('should update partner profile', async () => {
            // Arrange
            const updatedProfile = { ...mockProfile, ...updateDto };
            mockPartnersService.updateMyProfile.mockResolvedValue(updatedProfile);

            // Act
            const result = await controller.updateMyProfile(mockReq, updateDto as any);

            // Assert
            expect(result).toEqual(updatedProfile);
            expect(mockPartnersService.updateMyProfile).toHaveBeenCalledWith(
                mockReq.user.id,
                updateDto,
            );
        });
    });

    describe('getPartners', () => {
        it('should return paginated partners list', async () => {
            // Arrange
            const query = { page: 1, limit: 10 };
            mockPartnersService.getPartners.mockResolvedValue(mockPartnersList);

            // Act
            const result = await controller.getPartners(query);

            // Assert
            expect(result).toEqual(mockPartnersList);
            expect(mockPartnersService.getPartners).toHaveBeenCalledWith(query);
        });

        it('should pass filters to service', async () => {
            // Arrange
            const query = { page: 1, limit: 10, isVerified: true, search: 'test' };
            mockPartnersService.getPartners.mockResolvedValue({ ...mockPartnersList, data: [] });

            // Act
            await controller.getPartners(query);

            // Assert
            expect(mockPartnersService.getPartners).toHaveBeenCalledWith(query);
        });
    });

    describe('getPartnerDetail', () => {
        it('should return partner detail by ID', async () => {
            // Arrange
            const partnerId = 'partner-uuid';
            const mockDetail = {
                ...mockProfile,
                account: { id: 'account-uuid', email: 'partner@test.com', isActive: true },
            };
            mockPartnersService.getPartnerDetail.mockResolvedValue(mockDetail);

            // Act
            const result = await controller.getPartnerDetail(partnerId);

            // Assert
            expect(result).toEqual(mockDetail);
            expect(mockPartnersService.getPartnerDetail).toHaveBeenCalledWith(partnerId);
        });

        it('should propagate NotFoundException from service', async () => {
            // Arrange
            const partnerId = 'invalid-partner';
            mockPartnersService.getPartnerDetail.mockRejectedValue(
                new NotFoundException('Partner not found'),
            );

            // Act & Assert
            await expect(controller.getPartnerDetail(partnerId)).rejects.toThrow(NotFoundException);
        });
    });
});
