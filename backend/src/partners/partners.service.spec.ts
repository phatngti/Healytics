import { Test, TestingModule } from '@nestjs/testing';
import { PartnersService } from './partners.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Account } from '@/account/entities/account.entity';
import { Partner } from './entities/partner.entity';
import { LegalRepresentative } from './entities/legal-representative.entity';
import { LocationsService } from '@/locations/locations.service';
import { AuthService } from '@/auth/auth.service';
import { DataSource } from 'typeorm';
import {
    ConflictException,
    BadRequestException,
    NotFoundException,
} from '@nestjs/common';
import { BusinessType } from './enum/business-type.enum';
import { DocumentType } from './enum/document-type.enum';
import { PartnerDocument } from './entities/partner-document.entity';
import { PartnerVerificationStatus } from './enum/partner-verification-status.enum';
import { Role } from '@/account/enum/role.enum';

describe('PartnersService', () => {
    let service: PartnersService;
    let accountRepository: Record<string, jest.Mock>;
    let partnerRepository: Record<string, jest.Mock>;
    let legalRepRepository: Record<string, jest.Mock>;
    let locationsService: Record<string, jest.Mock>;
    let authService: Record<string, jest.Mock>;
    let dataSource: Record<string, jest.Mock>;

    // Mock repositories
    const mockAccountRepository = {
        findOne: jest.fn(),
        create: jest.fn(),
        save: jest.fn(),
    };

    const mockPartnerRepository = {
        findOne: jest.fn(),
        create: jest.fn(),
        save: jest.fn(),
        createQueryBuilder: jest.fn(),
    };

    const mockLegalRepRepository = {
        findOne: jest.fn(),
        create: jest.fn(),
        save: jest.fn(),
    };

    const mockLocationsService = {
        validateAddress: jest.fn(),
    };

    const mockAuthService = {
        createTokensForUser: jest.fn(),
    };

    // Mock query runner for transactions
    const mockQueryRunner = {
        connect: jest.fn(),
        startTransaction: jest.fn(),
        commitTransaction: jest.fn(),
        rollbackTransaction: jest.fn(),
        release: jest.fn(),
        manager: {
            create: jest.fn(),
            save: jest.fn(),
            findOne: jest.fn(),
        },
    };

    const mockDataSource = {
        createQueryRunner: jest.fn().mockReturnValue(mockQueryRunner),
    };

    // Mock data
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
        businessType: BusinessType.MASSAGE_THERAPY,
        provinceId: 'province-1',
        districtId: 'district-1',
        wardId: 'ward-1',
        streetAddress: '123 Test Street',
        accountId: 'account-uuid',
        verificationStatus: PartnerVerificationStatus.PENDING,
        verificationCompletedAt: null,
        createdAt: new Date(),
        province: { name: 'Hà Nội' },
        district: { name: 'Quận 1' },
        ward: { name: 'Phường 1' },
        legalRepresentative: {
            fullName: 'John Doe',
            position: 'Director',
            phoneNumber: '0901234567',
            idType: 'CCCD',
            idNumber: '012345678901',
        },
        account: mockAccount,
    };

    const mockRegisterDto = {
        account: {
            email: 'partner@test.com',
            password: 'securePassword123',
        },
        partner: {
            taxCode: '1234567890',
            legalName: 'Test Business',
            brandName: 'Test Brand',
            businessType: BusinessType.MASSAGE_THERAPY,
            provinceId: 'province-1',
            districtId: 'district-1',
            wardId: 'ward-1',
            streetAddress: '123 Test Street',
        },
        legalRepresentative: {
            fullName: 'John Doe',
            position: 'Director',
            phoneNumber: '0901234567',
            idType: 'CCCD',
            idNumber: '012345678901',
            idIssueDate: '2020-01-15',
            images: {
                frontImgUrl: 'https://example.com/front.jpg',
                backImgUrl: 'https://example.com/back.jpg',
            },
            authorization: {
                isAuthorizedUser: false,
                authLetterDocUrl: null,
            },
        },
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
                    provide: getRepositoryToken(LegalRepresentative),
                    useValue: mockLegalRepRepository,
                },
                {
                    provide: DataSource,
                    useValue: mockDataSource,
                },
                {
                    provide: LocationsService,
                    useValue: mockLocationsService,
                },
                {
                    provide: AuthService,
                    useValue: mockAuthService,
                },
            ],
        }).compile();

        service = module.get<PartnersService>(PartnersService);
        accountRepository = module.get(getRepositoryToken(Account));
        partnerRepository = module.get(getRepositoryToken(Partner));
        legalRepRepository = module.get(getRepositoryToken(LegalRepresentative));
        locationsService = module.get(LocationsService);
        authService = module.get(AuthService);
        dataSource = module.get(DataSource);
    });

    afterEach(() => {
        jest.clearAllMocks();
    });

    describe('getBusinessTypes', () => {
        it('should return all business types with Vietnamese labels', () => {
            // Act
            const result = service.getBusinessTypes();

            // Assert
            expect(result.data).toHaveLength(11);
            expect(result.data[0]).toEqual({
                value: BusinessType.MASSAGE_THERAPY,
                label: 'Massage Thư giãn',
            });
            expect(result.data).toContainEqual({
                value: BusinessType.PHARMACY,
                label: 'Dược phẩm',
            });
        });
    });

    describe('registerPartner', () => {
        beforeEach(() => {
            mockAccountRepository.findOne.mockResolvedValue(null);
            mockPartnerRepository.findOne.mockResolvedValue(null);
            mockLocationsService.validateAddress.mockResolvedValue(true);
            mockQueryRunner.manager.create.mockImplementation((entity, data) => data);
            mockQueryRunner.manager.save.mockImplementation((entity, data) => {
                if (data) return { id: `${entity.name}-uuid`, ...data };
                return { id: 'saved-uuid', ...entity };
            });
            mockAuthService.createTokensForUser.mockResolvedValue({
                access_token: 'test-access-token',
                refresh_token: 'test-refresh-token',
            });
        });

        it('should successfully register a new partner', async () => {
            // Arrange
            const createCalls: any[] = [];
            mockQueryRunner.manager.create.mockImplementation((entity, data) => {
                createCalls.push({ entity, data });
                return data;
            });
            mockQueryRunner.manager.save.mockImplementation((entity, data) => {
                if (Array.isArray(data)) return data; // For PartnerDocument array
                if (data) return { id: 'new-uuid', ...data };
                return { id: 'new-uuid', ...entity };
            });

            // Act
            const result = await service.registerPartner(mockRegisterDto as any);

            // Assert - Basic response validation
            expect(result.status).toBe('success');
            expect(result.access_token).toBe('test-access-token');
            expect(result.refresh_token).toBe('test-refresh-token');
            expect(mockQueryRunner.commitTransaction).toHaveBeenCalled();
            expect(mockQueryRunner.release).toHaveBeenCalled();

            // Assert - Verify PartnerDocument records were created (without TAX_CODE)
            // The service creates documents for IDENTITY_FRONT, IDENTITY_BACK only
            const documentCreates = createCalls.filter(
                (call) => call.entity === PartnerDocument,
            );
            expect(documentCreates.length).toBeGreaterThanOrEqual(2);

            // Verify IDENTITY_FRONT document with new isReviewed/isValid flags
            expect(
                documentCreates.some(
                    (call) =>
                        call.data.documentType === DocumentType.IDENTITY_FRONT &&
                        call.data.documentUrl ===
                        mockRegisterDto.legalRepresentative.images.frontImgUrl &&
                        call.data.isReviewed === false &&
                        call.data.isValid === true, // Optimistic validation
                ),
            ).toBe(true);

            // Verify IDENTITY_BACK document with new isReviewed/isValid flags
            expect(
                documentCreates.some(
                    (call) =>
                        call.data.documentType === DocumentType.IDENTITY_BACK &&
                        call.data.documentUrl ===
                        mockRegisterDto.legalRepresentative.images.backImgUrl &&
                        call.data.isReviewed === false &&
                        call.data.isValid === true, // Optimistic validation
                ),
            ).toBe(true);

            // Note: TAX_CODE is now a data field on Partner, not a document type
        });

        it('should create AUTHORIZATION_LETTER document when provided', async () => {
            // Arrange
            const dtoWithAuthLetter = {
                ...mockRegisterDto,
                legalRepresentative: {
                    ...mockRegisterDto.legalRepresentative,
                    authorization: {
                        isAuthorizedUser: true,
                        authLetterDocUrl: 'https://example.com/auth-letter.pdf',
                    },
                },
            };

            const createCalls: any[] = [];
            mockQueryRunner.manager.create.mockImplementation((entity, data) => {
                createCalls.push({ entity, data });
                return data;
            });
            mockQueryRunner.manager.save.mockImplementation((entity, data) => {
                if (Array.isArray(data)) return data;
                if (data) return { id: 'new-uuid', ...data };
                return { id: 'new-uuid', ...entity };
            });

            // Act
            await service.registerPartner(dtoWithAuthLetter as any);

            // Assert - Verify AUTHORIZATION_LETTER document was created with new flags
            const documentCreates = createCalls.filter(
                (call) => call.entity === PartnerDocument,
            );
            expect(
                documentCreates.some(
                    (call) =>
                        call.data.documentType === DocumentType.AUTHORIZATION_LETTER &&
                        call.data.documentUrl ===
                        dtoWithAuthLetter.legalRepresentative.authorization.authLetterDocUrl &&
                        call.data.isReviewed === false &&
                        call.data.isValid === true, // Optimistic validation
                ),
            ).toBe(true);
        });

        it('should throw ConflictException for duplicate email', async () => {
            // Arrange
            mockAccountRepository.findOne.mockResolvedValue(mockAccount);

            // Act & Assert
            await expect(
                service.registerPartner(mockRegisterDto as any),
            ).rejects.toThrow(ConflictException);
            await expect(
                service.registerPartner(mockRegisterDto as any),
            ).rejects.toThrow('An account with this email already exists');
        });

        it('should throw ConflictException for duplicate tax code', async () => {
            // Arrange
            mockAccountRepository.findOne.mockResolvedValue(null);
            mockPartnerRepository.findOne.mockResolvedValue(mockPartner);

            // Act & Assert
            await expect(
                service.registerPartner(mockRegisterDto as any),
            ).rejects.toThrow(ConflictException);
            await expect(
                service.registerPartner(mockRegisterDto as any),
            ).rejects.toThrow('A business with this tax code is already registered');
        });

        it('should throw BadRequestException for invalid address', async () => {
            // Arrange
            mockLocationsService.validateAddress.mockRejectedValue(
                new NotFoundException('Invalid address hierarchy'),
            );

            // Act & Assert
            await expect(
                service.registerPartner(mockRegisterDto as any),
            ).rejects.toThrow(BadRequestException);
        });

        it('should rollback transaction on error', async () => {
            // Arrange
            mockQueryRunner.manager.save.mockRejectedValue(new Error('DB Error'));

            // Act & Assert
            await expect(
                service.registerPartner(mockRegisterDto as any),
            ).rejects.toThrow('DB Error');
            expect(mockQueryRunner.rollbackTransaction).toHaveBeenCalled();
            expect(mockQueryRunner.release).toHaveBeenCalled();
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
                relations: ['province', 'district', 'ward', 'legalRepresentative', 'documents'],
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

    describe('getMyProfile', () => {
        it('should return formatted profile with verificationStatus', async () => {
            // Arrange
            mockPartnerRepository.findOne.mockResolvedValue(mockPartner);

            // Act
            const result = await service.getMyProfile('account-uuid');

            // Assert
            expect(result.id).toBe(mockPartner.id);
            expect(result.taxCode).toBe(mockPartner.taxCode);
            expect(result.address.province).toBe('Hà Nội');
            expect(result.address.district).toBe('Quận 1');
            expect(result.legalRepresentative.fullName).toBe('John Doe');
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

    describe('updateMyProfile', () => {
        const updateDto = {
            brandName: 'Updated Brand',
            streetAddress: 'Updated Address',
        };

        it('should update partner profile successfully', async () => {
            // Arrange
            mockPartnerRepository.findOne.mockResolvedValue({ ...mockPartner });
            mockQueryRunner.manager.save.mockResolvedValue({
                ...mockPartner,
                ...updateDto,
            });
            mockQueryRunner.manager.findOne.mockResolvedValue(
                mockPartner.legalRepresentative,
            );

            // Act
            const result = await service.updateMyProfile(
                'account-uuid',
                updateDto as any,
            );

            // Assert
            expect(mockQueryRunner.commitTransaction).toHaveBeenCalled();
            expect(result).toBeDefined();
        });

        it('should throw NotFoundException when partner not found', async () => {
            // Arrange
            mockPartnerRepository.findOne.mockResolvedValue(null);

            // Act & Assert
            await expect(
                service.updateMyProfile('invalid-account', updateDto as any),
            ).rejects.toThrow(NotFoundException);
        });

        it('should validate address when address fields are provided', async () => {
            // Arrange
            const updateWithAddress = {
                ...updateDto,
                provinceId: 'new-province',
                districtId: 'new-district',
                wardId: 'new-ward',
            };
            mockPartnerRepository.findOne.mockResolvedValue({ ...mockPartner });
            mockLocationsService.validateAddress.mockResolvedValue(true);
            mockQueryRunner.manager.save.mockResolvedValue(mockPartner);

            // Act
            await service.updateMyProfile('account-uuid', updateWithAddress as any);

            // Assert
            expect(mockLocationsService.validateAddress).toHaveBeenCalledWith(
                'new-province',
                'new-district',
                'new-ward',
            );
        });

        it('should rollback transaction on error', async () => {
            // Arrange
            mockPartnerRepository.findOne.mockResolvedValue({ ...mockPartner });
            mockQueryRunner.manager.save.mockRejectedValue(new Error('Update error'));

            // Act & Assert
            await expect(
                service.updateMyProfile('account-uuid', updateDto as any),
            ).rejects.toThrow('Update error');
            expect(mockQueryRunner.rollbackTransaction).toHaveBeenCalled();
        });
    });

    describe('getPartners', () => {
        const mockQueryBuilder = {
            leftJoinAndSelect: jest.fn().mockReturnThis(),
            select: jest.fn().mockReturnThis(),
            andWhere: jest.fn().mockReturnThis(),
            orderBy: jest.fn().mockReturnThis(),
            skip: jest.fn().mockReturnThis(),
            take: jest.fn().mockReturnThis(),
            getManyAndCount: jest.fn(),
        };

        beforeEach(() => {
            mockPartnerRepository.createQueryBuilder.mockReturnValue(mockQueryBuilder);
        });

        it('should return paginated partners list', async () => {
            // Arrange
            const partnerWithNewFields = {
                ...mockPartner,
                verificationStatus: PartnerVerificationStatus.PENDING,
            };
            const partnersData = [partnerWithNewFields];
            mockQueryBuilder.getManyAndCount.mockResolvedValue([partnersData, 1]);

            // Act
            const result = await service.getPartners({ page: 1, limit: 10 });

            // Assert
            expect(result.data).toHaveLength(1);
            expect(result.total).toBe(1);
            expect(result.page).toBe(1);
            expect(result.limit).toBe(10);
            expect(result.data[0].verificationStatus).toBe(PartnerVerificationStatus.PENDING);
        });

        it('should filter by verificationStatus', async () => {
            // Arrange
            mockQueryBuilder.getManyAndCount.mockResolvedValue([[], 0]);

            // Act
            await service.getPartners({
                page: 1,
                limit: 10,
                verificationStatus: PartnerVerificationStatus.APPROVED,
            });

            // Assert
            expect(mockQueryBuilder.andWhere).toHaveBeenCalledWith(
                'partner.verificationStatus = :verificationStatus',
                { verificationStatus: PartnerVerificationStatus.APPROVED },
            );
        });

        it('should filter by search term', async () => {
            // Arrange
            mockQueryBuilder.getManyAndCount.mockResolvedValue([[], 0]);

            // Act
            await service.getPartners({ page: 1, limit: 10, search: 'test' });

            // Assert
            expect(mockQueryBuilder.andWhere).toHaveBeenCalledWith(
                '(partner.taxCode ILIKE :search OR partner.brandName ILIKE :search OR partner.legalName ILIKE :search OR account.email ILIKE :search)',
                { search: '%test%' },
            );
        });
    });

    describe('getPartnerDetail', () => {
        it('should return partner detail with verificationStatus', async () => {
            // Arrange
            mockPartnerRepository.findOne.mockResolvedValue(mockPartner);

            // Act
            const result = await service.getPartnerDetail('partner-uuid');

            // Assert
            expect(result.id).toBe(mockPartner.id);
            expect(result.account.email).toBe(mockAccount.email);
            expect(result.address.province).toBe('Hà Nội');
            expect(result.verificationStatus).toBe(PartnerVerificationStatus.PENDING);
        });

        it('should throw NotFoundException when partner not found', async () => {
            // Arrange
            mockPartnerRepository.findOne.mockResolvedValue(null);

            // Act & Assert
            await expect(
                service.getPartnerDetail('invalid-partner'),
            ).rejects.toThrow(NotFoundException);
            await expect(
                service.getPartnerDetail('invalid-partner'),
            ).rejects.toThrow('Partner not found');
        });
    });
});
