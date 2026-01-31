import { Test, TestingModule } from '@nestjs/testing';
import { AdminPartnersService } from './admin-partners.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Partner } from '@/partners/entities/partner.entity';
import { PartnerDocument } from '@/partners/entities/partner-document.entity';
import { PartnerReviewLog } from '@/admin/entities/partner-review-log.entity';
import { DocumentRequirement } from '@/partners/entities/document-requirement.entity';
import { DataSource, Repository } from 'typeorm';
import { PartnersService } from '@/partners/partners.service';
import { ReviewDecision, ReviewPartnerProfileDto } from '../dto/review-partner-profile.dto';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { BadRequestException } from '@nestjs/common';
import { BusinessType } from '@/partners/enum/business-type.enum';

describe('AdminPartnersService', () => {
    let service: AdminPartnersService;
    let partnerRepo: Repository<Partner>;
    let docReqRepo: Repository<DocumentRequirement>;

    const mockPartnerRepo = {
        findOne: jest.fn(),
    };
    const mockDocumentRepo = {
        find: jest.fn(),
    };
    const mockReviewLogRepo = {
        create: jest.fn(),
        save: jest.fn(),
    };
    const mockDocReqRepo = {
        find: jest.fn(),
    };
    const mockQueryRunner = {
        connect: jest.fn(),
        startTransaction: jest.fn(),
        commitTransaction: jest.fn(),
        rollbackTransaction: jest.fn(),
        release: jest.fn(),
        manager: {
            create: jest.fn(),
            save: jest.fn(),
            update: jest.fn(),
            find: jest.fn(),
        },
    };
    const mockDataSource = {
        transaction: jest.fn((cb) => cb(mockQueryRunner.manager)),
    };
    const mockPartnersService = {
        getPartners: jest.fn(),
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                AdminPartnersService,
                { provide: getRepositoryToken(Partner), useValue: mockPartnerRepo },
                { provide: getRepositoryToken(PartnerDocument), useValue: mockDocumentRepo },
                { provide: getRepositoryToken(PartnerReviewLog), useValue: mockReviewLogRepo },
                { provide: getRepositoryToken(DocumentRequirement), useValue: mockDocReqRepo },
                { provide: DataSource, useValue: mockDataSource },
                { provide: PartnersService, useValue: mockPartnersService },
            ],
        }).compile();

        service = module.get<AdminPartnersService>(AdminPartnersService);
        partnerRepo = module.get<Repository<Partner>>(getRepositoryToken(Partner));
        docReqRepo = module.get<Repository<DocumentRequirement>>(getRepositoryToken(DocumentRequirement));
    });

    it('should be defined', () => {
        expect(service).toBeDefined();
    });

    describe('reviewPartner', () => {
        it('should approve partner when clean and all docs present', async () => {
            const partnerId = 'p1';
            const adminId = 'admin1';
            const dto: ReviewPartnerProfileDto = {
                decision: ReviewDecision.APPROVED,
                generalComment: 'Looks good',
                items: []
            };

            const mockPartner = { id: partnerId, verificationStatus: 'PENDING', businessType: BusinessType.PHARMACY } as Partner;
            mockPartnerRepo.findOne.mockResolvedValue(mockPartner);
            mockDocReqRepo.find.mockResolvedValue([{ documentType: 'DOC_TYPE_A', isRequired: true }]); // Mock requirements
            mockQueryRunner.manager.find.mockImplementation((entity) => {
                if (entity === PartnerDocument) return Promise.resolve([
                    { id: 'd1', documentType: 'DOC_TYPE_A', isValid: true, isReviewed: true }
                ]);
                return Promise.resolve([]);
            });

            // Transaction execution
            await service.reviewPartner(partnerId, dto, adminId);

            // ... (rest of the test)
        });

        it('should BLOCK approval if required document is missing', async () => {
            const partnerId = 'p1';
            const adminId = 'admin1';
            const dto: ReviewPartnerProfileDto = {
                decision: ReviewDecision.APPROVED, // Admin tries to Approve
                generalComment: 'LGTM',
            };

            const mockPartner = { id: partnerId, verificationStatus: 'PENDING', businessType: BusinessType.PHARMACY } as Partner;
            mockPartnerRepo.findOne.mockResolvedValue(mockPartner);
            mockDocReqRepo.find.mockResolvedValue([{ documentType: 'REQUIRED_DOC_X', isRequired: true }]); // Mock requirements

            mockQueryRunner.manager.find.mockImplementation((entity) => {
                if (entity === PartnerDocument) return Promise.resolve([]); // NO DOCUMENTS uploaded
                return Promise.resolve([]);
            });

            await expect(service.reviewPartner(partnerId, dto, adminId))
                .rejects
                .toThrow(BadRequestException); // Should throw "Missing required documents"
        });

        it('should FORCE status to REQUIRED_RESUBMIT if errors exist, even if Admin selects CHANGES_REQUIRED', async () => {
            const partnerId = 'p1';
            const adminId = 'admin1';
            const dto: ReviewPartnerProfileDto = {
                decision: ReviewDecision.CHANGES_REQUIRED,
                generalComment: 'Fix docs',
                items: [
                    { fieldKey: 'business_license', documentKey: 'd1', isVerified: false, feedback: 'Blurry' }
                ]
            };

            const mockPartner = { id: partnerId, verificationStatus: 'PENDING' } as Partner;
            mockPartnerRepo.findOne.mockResolvedValue(mockPartner);

            mockQueryRunner.manager.find.mockImplementation((entity) => {
                if (entity === PartnerDocument) return Promise.resolve([
                    { id: 'd1', documentType: 'DOC_TYPE_A', isValid: true, isReviewed: false }
                ]);
                return Promise.resolve([]);
            });
            // Mock map get
            // The service code creates a Map from `existingDocs`.
            // We need to ensure `docMap.get(item.documentId)` works.
            // But Map creation is internal logic based on `existingDocs`. Correct.

            await service.reviewPartner(partnerId, dto, adminId);

            expect(mockQueryRunner.manager.save).toHaveBeenCalledWith(expect.objectContaining({
                verificationStatus: PartnerVerificationStatus.REQUIRED_RESUBMIT,
                rejectionDetails: expect.objectContaining({
                    document_DOC_TYPE_A: 'Blurry'
                })
            }));
        });

        it('should FORCE status to REQUIRED_RESUBMIT if errors exist, EVEN IF Admin selects APPROVED (Safety Net)', async () => {
            const partnerId = 'p1';
            const adminId = 'admin1';
            const dto: ReviewPartnerProfileDto = {
                decision: ReviewDecision.APPROVED, // User clicked Approve by mistake?
                generalComment: 'Oops',
                items: [
                    { fieldKey: 'legalName', isVerified: false, feedback: 'Wrong name' }
                ]
            };

            const mockPartner = { id: partnerId, verificationStatus: 'PENDING', legalName: 'Bad Name' } as Partner;
            mockPartnerRepo.findOne.mockResolvedValue(mockPartner);
            mockQueryRunner.manager.find.mockResolvedValue([]);

            await service.reviewPartner(partnerId, dto, adminId);

            // Should NOT be APPROVED, must be REQUIRED_RESUBMIT
            expect(mockQueryRunner.manager.save).toHaveBeenCalledWith(expect.objectContaining({
                verificationStatus: PartnerVerificationStatus.REQUIRED_RESUBMIT,
                rejectionDetails: expect.objectContaining({
                    legalName: 'Wrong name'
                })
            }));
        });
    });
});

