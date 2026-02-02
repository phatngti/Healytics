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
import { DocumentRequirement } from './entities/document-requirement.entity';
import { PartnerDocument } from './entities/partner-document.entity';
import { PartnerVerificationStatus } from './enum/partner-verification-status.enum';
import { PartnerReviewLog } from '@/admin/entities/partner-review-log.entity';
import { Role } from '@/account/enum/role.enum';

describe('PartnersService', () => {
    let service: PartnersService;
    let accountRepository: Record<string, jest.Mock>;
    let partnerRepository: Record<string, jest.Mock>;
    let legalRepRepository: Record<string, jest.Mock>;
    let docRequirementRepository: Record<string, jest.Mock>;
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

    const mockDocRequirementRepository = {
        find: jest.fn(),
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
            find: jest.fn(),
            update: jest.fn(),
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
            documents: {
                businessLicenseUrl: null,
                authorizationLetterUrl: null,
                taxCertificateUrl: null,
                otherDocumentUrls: [],
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
                    provide: getRepositoryToken(DocumentRequirement),
                    useValue: mockDocRequirementRepository,
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
        docRequirementRepository = module.get(getRepositoryToken(DocumentRequirement));
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
            mockQueryRunner.manager.create.mockImplementation((entity, data) => data);
            mockQueryRunner.manager.save.mockImplementation((entity, data) => {
                if (Array.isArray(data)) return data;
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

            // Note: Identity documents (IDENTITY_FRONT, IDENTITY_BACK, AUTHORIZATION_LETTER)
            // are now stored only in LegalRepresentative entity, not as PartnerDocument records
        });

        it('should store document URLs in LegalRepresentative when provided', async () => {
            // Arrange
            const dtoWithDocuments = {
                ...mockRegisterDto,
                legalRepresentative: {
                    ...mockRegisterDto.legalRepresentative,
                    documents: {
                        businessLicenseUrl: 'https://example.com/business-license.pdf',
                        authorizationLetterUrl: 'https://example.com/auth-letter.pdf',
                        taxCertificateUrl: null,
                        otherDocumentUrls: [],
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
            await service.registerPartner(dtoWithDocuments as any);

            // Assert - Verify LegalRepresentative was created with document URLs
            const legalRepCreate = createCalls.find(
                (call) => call.entity === LegalRepresentative,
            );
            expect(legalRepCreate).toBeDefined();
            expect(legalRepCreate.data.businessLicenseUrl).toBe(
                'https://example.com/business-license.pdf',
            );
            expect(legalRepCreate.data.authorizationLetterUrl).toBe(
                'https://example.com/auth-letter.pdf',
            );
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
        let mockReviewLogRepository: Record<string, jest.Mock>;

        beforeEach(() => {
            // Create a mock for the reviewLogRepository
            mockReviewLogRepository = {
                findOne: jest.fn().mockResolvedValue(null),
            };
            // Inject it into the service (accessing private property for testing)
            (service as any).reviewLogRepository = mockReviewLogRepository;
        });

        it('should return formatted profile with verification fields', async () => {
            // Arrange
            const mockPartnerWithLegalRep = {
                ...mockPartner,
                legalRepresentative: {
                    ...mockPartner.legalRepresentative,
                    idIssueDate: new Date('2020-01-15'),
                },
                documents: [],
            };
            mockPartnerRepository.findOne.mockResolvedValue(mockPartnerWithLegalRep);

            // Act
            const result = await service.getMyProfile('account-uuid');

            // Assert
            expect(result.id).toBe(mockPartner.id);
            expect(result.businessInfo.brandName.value).toBe(mockPartner.brandName);
            expect(result.businessInfo.address?.streetAddress.value).toBe(mockPartner.streetAddress);
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

    describe('updateMyProfile', () => {
        const updateDto = {
            brandName: 'Updated Brand',
            streetAddress: 'Updated Address',
        };

        it('should update partner profile successfully', async () => {
            // Arrange
            mockPartnerRepository.findOne.mockImplementation(() => Promise.resolve({ ...mockPartner }));
            mockQueryRunner.manager.save.mockResolvedValue({
                ...mockPartner,
                ...updateDto,
            });
            mockQueryRunner.manager.findOne.mockImplementation((entity) => {
                if (entity && entity.name === 'LegalRepresentative') return Promise.resolve(mockPartner.legalRepresentative);
                if (entity && entity.name === 'Partner') return Promise.resolve(null);
                return Promise.resolve(null);
            });
            mockQueryRunner.manager.find.mockResolvedValue([]);

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
            mockPartnerRepository.findOne.mockImplementation(() => Promise.resolve({ ...mockPartner }));
            mockLocationsService.validateAddress.mockResolvedValue(true);
            mockQueryRunner.manager.save.mockResolvedValue(mockPartner);
            mockQueryRunner.manager.find.mockResolvedValue([]);

            // Act
            await service.updateMyProfile('account-uuid', updateWithAddress as any);

            // Assert
            expect(mockLocationsService.validateAddress).toHaveBeenCalledWith(
                'new-province',
                'new-district',
                'new-ward',
            );
        });


        it('should transition from ONBOARDING to PENDING when all documents are uploaded', async () => {
            // Arrange
            const partnerOnboarding = {
                ...mockPartner,
                verificationStatus: PartnerVerificationStatus.ONBOARDING,
                documents: [],
            };

            // Requirements: ID Card Front (implied by legalRep mock) + Business License (mocked below)
            mockDocRequirementRepository.find.mockResolvedValue([
                { documentType: DocumentType.BUSINESS_LICENSE, isRequired: true }
            ]);

            mockPartnerRepository.findOne.mockImplementation(() => Promise.resolve({ ...partnerOnboarding }));

            // Mock document upload
            const docDto = {
                documentType: DocumentType.BUSINESS_LICENSE,
                documentUrl: 'https://example.com/license.jpg',
            };
            const updateWithDoc = {
                documents: [docDto],
            };

            // Mock find existing doc (none)
            mockQueryRunner.manager.findOne.mockImplementation((entity) => {
                if (entity.name === 'PartnerDocument') return Promise.resolve(null); // New doc
                if (entity.name === 'LegalRepresentative') return Promise.resolve(mockPartner.legalRepresentative);
                return Promise.resolve(null);
            });
            mockQueryRunner.manager.find.mockImplementation((entity) => {
                // Return all current documents including the one just uploaded (simulated)
                // Note: The service fetches all docs again to check status
                if (entity.name === 'PartnerDocument') {
                    return Promise.resolve([{
                        partnerId: mockPartner.id,
                        documentType: DocumentType.BUSINESS_LICENSE,
                        documentUrl: 'https://example.com/license.jpg',
                        isReviewed: false,
                        isValid: true,
                    }]);
                }
                if (entity.name === 'DocumentRequirement') return Promise.resolve([{ documentType: DocumentType.BUSINESS_LICENSE, isRequired: true }]);
                return Promise.resolve([]);
            });

            // Mock update to verify status change
            let updateDataUsed: any;
            mockQueryRunner.manager.update.mockImplementation((entity, id, data) => {
                if (entity === Partner) {
                    updateDataUsed = data;
                }
                return Promise.resolve({ generatedMaps: [], raw: [], affected: 1 });
            });

            // Act
            await service.updateMyProfile('account-uuid', updateWithDoc as any);

            // Assert
            expect(updateDataUsed).toBeDefined();
            expect(updateDataUsed.verificationStatus).toBe(PartnerVerificationStatus.PENDING);
        });

        it('should rollback transaction on error', async () => {
            // Arrange
            mockPartnerRepository.findOne.mockResolvedValue({ ...mockPartner });
            mockQueryRunner.manager.update.mockRejectedValue(new Error('Update error'));

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
});
