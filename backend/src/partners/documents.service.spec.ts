import { Test, TestingModule } from '@nestjs/testing';
import { DocumentsService } from './documents.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { PartnerDocument } from './entities/partner-document.entity';
import { DocumentRequirement } from './entities/document-requirement.entity';
import { Partner } from './entities/partner.entity';
import { S3Service } from '@/s3/s3.service';
import { PartnersService } from './partners.service';
import { NotFoundException, BadRequestException } from '@nestjs/common';
import { DocumentType } from './enum/document-type.enum';
import { DocumentStatus } from './enum/document-status.enum';
import { BusinessType } from './enum/business-type.enum';

describe('DocumentsService', () => {
    let service: DocumentsService;
    let documentRepo: Record<string, jest.Mock>;
    let requirementRepo: Record<string, jest.Mock>;
    let partnerRepo: Record<string, jest.Mock>;
    let s3Service: Record<string, jest.Mock>;
    let partnersService: Record<string, jest.Mock>;

    const mockDocumentRepo = {
        findOne: jest.fn(),
        find: jest.fn(),
        create: jest.fn(),
        save: jest.fn(),
    };

    const mockRequirementRepo = {
        find: jest.fn(),
    };

    const mockPartnerRepo = {
        findOne: jest.fn(),
        save: jest.fn(),
    };

    const mockS3Service = {
        getPresignedUploadUrl: jest.fn(),
        getFileUrl: jest.fn(),
        deleteFile: jest.fn(),
    };

    const mockPartnersService = {
        getPartnerByAccountId: jest.fn(),
    };

    // Mock data
    const mockPartner = {
        id: 'partner-uuid',
        accountId: 'account-uuid',
        businessType: BusinessType.MASSAGE_THERAPY,
        isVerified: false,
        verificationCompletedAt: null,
    };

    const mockDocument = {
        id: 'doc-uuid',
        partnerId: 'partner-uuid',
        documentType: DocumentType.BUSINESS_LICENSE,
        documentUrl: 'https://example.com/doc.pdf',
        documentKey: 'documents/partner-uuid/123-doc.pdf',
        status: DocumentStatus.PENDING,
        adminFeedback: null,
        verificationNotes: null,
        verifiedBy: null,
        uploadedAt: new Date(),
        partner: mockPartner,
    };

    const mockRequirements = [
        {
            documentType: DocumentType.BUSINESS_LICENSE,
            description: 'Giấy phép kinh doanh',
            isRequired: true,
            displayOrder: 1,
            businessType: BusinessType.MASSAGE_THERAPY,
        },
        {
            documentType: DocumentType.ANTT,
            description: 'Giấy ANTT',
            isRequired: true,
            displayOrder: 2,
            businessType: BusinessType.MASSAGE_THERAPY,
        },
    ];

    beforeEach(async () => {
        jest.clearAllMocks();

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                DocumentsService,
                {
                    provide: getRepositoryToken(PartnerDocument),
                    useValue: mockDocumentRepo,
                },
                {
                    provide: getRepositoryToken(DocumentRequirement),
                    useValue: mockRequirementRepo,
                },
                {
                    provide: getRepositoryToken(Partner),
                    useValue: mockPartnerRepo,
                },
                {
                    provide: S3Service,
                    useValue: mockS3Service,
                },
                {
                    provide: PartnersService,
                    useValue: mockPartnersService,
                },
            ],
        }).compile();

        service = module.get<DocumentsService>(DocumentsService);
        documentRepo = module.get(getRepositoryToken(PartnerDocument));
        requirementRepo = module.get(getRepositoryToken(DocumentRequirement));
        partnerRepo = module.get(getRepositoryToken(Partner));
        s3Service = module.get(S3Service);
        partnersService = module.get(PartnersService);
    });

    afterEach(() => {
        jest.clearAllMocks();
    });

    describe('getUploadUrl', () => {
        it('should return presigned upload URL', async () => {
            // Arrange
            mockPartnersService.getPartnerByAccountId.mockResolvedValue(mockPartner);
            mockS3Service.getPresignedUploadUrl.mockResolvedValue({
                uploadUrl: 'https://s3.example.com/upload',
                key: 'documents/partner-uuid/123-test.pdf',
            });

            // Act
            const result = await service.getUploadUrl(
                'account-uuid',
                'test.pdf',
                'application/pdf',
            );

            // Assert
            expect(result.uploadUrl).toBe('https://s3.example.com/upload');
            expect(result.documentKey).toBe('documents/partner-uuid/123-test.pdf');
        });

        it('should throw NotFoundException when partner not found', async () => {
            // Arrange
            mockPartnersService.getPartnerByAccountId.mockResolvedValue(null);

            // Act & Assert
            await expect(
                service.getUploadUrl('invalid-account', 'test.pdf', 'application/pdf'),
            ).rejects.toThrow(NotFoundException);
            await expect(
                service.getUploadUrl('invalid-account', 'test.pdf', 'application/pdf'),
            ).rejects.toThrow('Partner not found');
        });
    });

    describe('getDocumentUrl', () => {
        it('should return S3 URL for document with key', async () => {
            // Arrange
            mockDocumentRepo.findOne.mockResolvedValue(mockDocument);
            mockS3Service.getFileUrl.mockResolvedValue(
                'https://s3.example.com/signed-url',
            );

            // Act
            const result = await service.getDocumentUrl('doc-uuid');

            // Assert
            expect(result.url).toBe('https://s3.example.com/signed-url');
            expect(result.documentType).toBe(DocumentType.BUSINESS_LICENSE);
            expect(mockS3Service.getFileUrl).toHaveBeenCalledWith(
                mockDocument.documentKey,
            );
        });

        it('should return direct URL for document without key', async () => {
            // Arrange
            const docWithoutKey = { ...mockDocument, documentKey: null };
            mockDocumentRepo.findOne.mockResolvedValue(docWithoutKey);

            // Act
            const result = await service.getDocumentUrl('doc-uuid');

            // Assert
            expect(result.url).toBe(mockDocument.documentUrl);
            expect(mockS3Service.getFileUrl).not.toHaveBeenCalled();
        });

        it('should throw NotFoundException when document not found', async () => {
            // Arrange
            mockDocumentRepo.findOne.mockResolvedValue(null);

            // Act & Assert
            await expect(service.getDocumentUrl('invalid-doc')).rejects.toThrow(
                NotFoundException,
            );
        });

        it('should verify ownership when accountId is provided', async () => {
            // Arrange
            mockDocumentRepo.findOne.mockResolvedValue(mockDocument);
            mockPartnersService.getPartnerByAccountId.mockResolvedValue(mockPartner);
            mockS3Service.getFileUrl.mockResolvedValue('https://s3.example.com/url');

            // Act
            const result = await service.getDocumentUrl('doc-uuid', 'account-uuid');

            // Assert
            expect(result).toBeDefined();
            expect(mockPartnersService.getPartnerByAccountId).toHaveBeenCalledWith(
                'account-uuid',
            );
        });

        it('should throw BadRequestException for unauthorized access', async () => {
            // Arrange
            mockDocumentRepo.findOne.mockResolvedValue(mockDocument);
            mockPartnersService.getPartnerByAccountId.mockResolvedValue({
                id: 'different-partner',
            });

            // Act & Assert
            await expect(
                service.getDocumentUrl('doc-uuid', 'different-account'),
            ).rejects.toThrow(BadRequestException);
            await expect(
                service.getDocumentUrl('doc-uuid', 'different-account'),
            ).rejects.toThrow('Access denied');
        });
    });

    describe('submitDocument', () => {
        const submitDto = {
            documentType: DocumentType.BUSINESS_LICENSE,
            documentUrl: 'https://example.com/new-doc.pdf',
        };

        it('should create new document when not exists', async () => {
            // Arrange
            mockPartnersService.getPartnerByAccountId.mockResolvedValue(mockPartner);
            mockDocumentRepo.findOne.mockResolvedValue(null);
            mockDocumentRepo.create.mockReturnValue({
                ...submitDto,
                partnerId: mockPartner.id,
                status: DocumentStatus.PENDING,
            });
            mockDocumentRepo.save.mockImplementation((doc) => ({ id: 'new-doc', ...doc }));

            // Act
            const result = await service.submitDocument('account-uuid', submitDto);

            // Assert
            expect(result.id).toBe('new-doc');
            expect(mockDocumentRepo.create).toHaveBeenCalled();
            expect(mockDocumentRepo.save).toHaveBeenCalled();
        });

        it('should update existing document (UPSERT)', async () => {
            // Arrange
            mockPartnersService.getPartnerByAccountId.mockResolvedValue(mockPartner);
            mockDocumentRepo.findOne.mockResolvedValue({ ...mockDocument });
            mockDocumentRepo.save.mockImplementation((doc) => doc);

            // Act
            const result = await service.submitDocument('account-uuid', submitDto);

            // Assert
            expect(result.documentUrl).toBe(submitDto.documentUrl);
            expect(result.status).toBe(DocumentStatus.PENDING);
            expect(mockDocumentRepo.create).not.toHaveBeenCalled();
        });

        it('should delete old S3 file when updating document with new URL', async () => {
            // Arrange
            mockPartnersService.getPartnerByAccountId.mockResolvedValue(mockPartner);
            mockDocumentRepo.findOne.mockResolvedValue({ ...mockDocument });
            mockDocumentRepo.save.mockImplementation((doc) => doc);
            mockS3Service.deleteFile.mockResolvedValue(undefined);

            // Act
            await service.submitDocument('account-uuid', submitDto);

            // Assert
            expect(mockS3Service.deleteFile).toHaveBeenCalledWith(
                mockDocument.documentKey,
            );
        });

        it('should throw NotFoundException when partner not found', async () => {
            // Arrange
            mockPartnersService.getPartnerByAccountId.mockResolvedValue(null);

            // Act & Assert
            await expect(
                service.submitDocument('invalid-account', submitDto),
            ).rejects.toThrow(NotFoundException);
        });
    });

    describe('getPartnerDocumentStatus', () => {
        it('should return document status mapping requirements to submissions', async () => {
            // Arrange
            mockPartnersService.getPartnerByAccountId.mockResolvedValue(mockPartner);
            mockRequirementRepo.find.mockResolvedValue(mockRequirements);
            mockDocumentRepo.find.mockResolvedValue([
                {
                    ...mockDocument,
                    documentType: DocumentType.BUSINESS_LICENSE,
                    status: DocumentStatus.APPROVED,
                },
            ]);

            // Act
            const result = await service.getPartnerDocumentStatus('account-uuid');

            // Assert
            expect(result.documents).toHaveLength(2);
            expect(result.documents[0].status).toBe(DocumentStatus.APPROVED);
            expect(result.documents[1].status).toBe('MISSING');
            expect(result.totalRequired).toBe(2);
            expect(result.totalApproved).toBe(1);
        });

        it('should throw NotFoundException when partner not found', async () => {
            // Arrange
            mockPartnersService.getPartnerByAccountId.mockResolvedValue(null);

            // Act & Assert
            await expect(
                service.getPartnerDocumentStatus('invalid-account'),
            ).rejects.toThrow(NotFoundException);
        });
    });

    describe('reviewDocument', () => {
        const approveDto = {
            status: DocumentStatus.APPROVED,
            verificationNotes: 'Looks good',
        };

        const rejectDto = {
            status: DocumentStatus.REJECTED,
            adminFeedback: 'Document is blurry, please re-upload',
        };

        beforeEach(() => {
            mockDocumentRepo.findOne.mockResolvedValue({ ...mockDocument });
            mockDocumentRepo.save.mockImplementation((doc) => doc);
            mockPartnerRepo.findOne.mockResolvedValue({ ...mockPartner });
            mockRequirementRepo.find.mockResolvedValue(mockRequirements);
            mockDocumentRepo.find.mockResolvedValue([]);
        });

        it('should approve document', async () => {
            // Arrange & Act
            const result = await service.reviewDocument(
                'doc-uuid',
                approveDto,
                'admin-uuid',
            );

            // Assert
            expect(result.status).toBe(DocumentStatus.APPROVED);
            expect(result.verifiedBy).toBe('admin-uuid');
            expect(mockDocumentRepo.save).toHaveBeenCalled();
        });

        it('should reject document with feedback', async () => {
            // Arrange & Act
            const result = await service.reviewDocument(
                'doc-uuid',
                rejectDto,
                'admin-uuid',
            );

            // Assert
            expect(result.status).toBe(DocumentStatus.REJECTED);
            expect(result.adminFeedback).toBe(rejectDto.adminFeedback);
        });

        it('should throw BadRequestException when rejecting without feedback', async () => {
            // Arrange
            const rejectWithoutFeedback = {
                status: DocumentStatus.REJECTED,
                adminFeedback: '',
            };

            // Act & Assert
            await expect(
                service.reviewDocument('doc-uuid', rejectWithoutFeedback, 'admin-uuid'),
            ).rejects.toThrow(BadRequestException);
            await expect(
                service.reviewDocument('doc-uuid', rejectWithoutFeedback, 'admin-uuid'),
            ).rejects.toThrow('Admin feedback is required when rejecting a document');
        });

        it('should throw NotFoundException when document not found', async () => {
            // Arrange
            mockDocumentRepo.findOne.mockResolvedValue(null);

            // Act & Assert
            await expect(
                service.reviewDocument('invalid-doc', approveDto, 'admin-uuid'),
            ).rejects.toThrow(NotFoundException);
        });

        it('should auto-activate partner when all required documents approved', async () => {
            // Arrange
            mockDocumentRepo.find.mockResolvedValue([
                { documentType: DocumentType.BUSINESS_LICENSE, status: DocumentStatus.APPROVED },
                { documentType: DocumentType.ANTT, status: DocumentStatus.APPROVED },
            ]);

            // Act
            await service.reviewDocument('doc-uuid', approveDto, 'admin-uuid');

            // Assert
            expect(mockPartnerRepo.save).toHaveBeenCalledWith(
                expect.objectContaining({
                    isVerified: true,
                    verificationCompletedAt: expect.any(Date),
                }),
            );
        });
    });

    describe('getPartnerDocuments', () => {
        it('should return all documents for partner', async () => {
            // Arrange
            const documents = [mockDocument, { ...mockDocument, id: 'doc-2' }];
            mockDocumentRepo.find.mockResolvedValue(documents);

            // Act
            const result = await service.getPartnerDocuments('partner-uuid');

            // Assert
            expect(result).toHaveLength(2);
            expect(mockDocumentRepo.find).toHaveBeenCalledWith({
                where: { partnerId: 'partner-uuid' },
                order: { uploadedAt: 'DESC' },
            });
        });
    });
});
