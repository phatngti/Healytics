import { Test, TestingModule } from '@nestjs/testing';
import { DocumentsController } from './documents.controller';
import { DocumentsService } from './documents.service';
import { NotFoundException, BadRequestException } from '@nestjs/common';
import { DocumentType } from './enum/document-type.enum';
import { DocumentStatus } from './enum/document-status.enum';

describe('DocumentsController', () => {
    let controller: DocumentsController;
    let documentsService: Record<string, jest.Mock>;

    const mockDocumentsService = {
        getPartnerDocumentStatus: jest.fn(),
        getUploadUrl: jest.fn(),
        getDocumentUrl: jest.fn(),
        submitDocument: jest.fn(),
        reviewDocument: jest.fn(),
        getPartnerDocuments: jest.fn(),
    };

    // Mock data
    const mockReq = {
        user: {
            id: 'account-uuid',
            email: 'partner@test.com',
        },
    };

    const mockUploadUrlResponse = {
        uploadUrl: 'https://s3.example.com/presigned-upload-url',
        documentKey: 'documents/partner-uuid/123-test.pdf',
    };

    const mockDocumentUrlResponse = {
        url: 'https://s3.example.com/signed-url',
        documentType: DocumentType.BUSINESS_LICENSE,
        status: DocumentStatus.PENDING,
    };

    const mockDocument = {
        id: 'doc-uuid',
        partnerId: 'partner-uuid',
        documentType: DocumentType.BUSINESS_LICENSE,
        documentUrl: 'https://example.com/doc.pdf',
        documentKey: 'documents/partner-uuid/123-doc.pdf',
        status: DocumentStatus.PENDING,
        uploadedAt: new Date(),
    };

    const mockDocumentStatus = {
        documents: [
            {
                documentType: DocumentType.BUSINESS_LICENSE,
                description: 'Giấy phép kinh doanh',
                isRequired: true,
                status: DocumentStatus.APPROVED,
                documentUrl: 'https://example.com/doc.pdf',
                documentKey: null,
                adminFeedback: null,
                uploadedAt: new Date(),
                documentId: 'doc-uuid',
            },
        ],
        totalRequired: 3,
        totalApproved: 1,
        isVerified: false,
    };

    beforeEach(async () => {
        jest.clearAllMocks();

        const module: TestingModule = await Test.createTestingModule({
            controllers: [DocumentsController],
            providers: [
                {
                    provide: DocumentsService,
                    useValue: mockDocumentsService,
                },
            ],
        }).compile();

        controller = module.get<DocumentsController>(DocumentsController);
        documentsService = module.get(DocumentsService);
    });

    afterEach(() => {
        jest.clearAllMocks();
    });

    describe('getMyDocuments', () => {
        it('should return document status for authenticated partner', async () => {
            // Arrange
            mockDocumentsService.getPartnerDocumentStatus.mockResolvedValue(mockDocumentStatus);

            // Act
            const result = await controller.getMyDocuments(mockReq);

            // Assert
            expect(result).toEqual(mockDocumentStatus);
            expect(mockDocumentsService.getPartnerDocumentStatus).toHaveBeenCalledWith(mockReq.user.id);
        });

        it('should propagate NotFoundException from service', async () => {
            // Arrange
            mockDocumentsService.getPartnerDocumentStatus.mockRejectedValue(
                new NotFoundException('Partner not found'),
            );

            // Act & Assert
            await expect(controller.getMyDocuments(mockReq)).rejects.toThrow(NotFoundException);
        });
    });

    describe('getUploadUrl', () => {
        const uploadUrlDto = {
            fileName: 'test.pdf',
            contentType: 'application/pdf',
        };

        it('should return presigned upload URL', async () => {
            // Arrange
            mockDocumentsService.getUploadUrl.mockResolvedValue(mockUploadUrlResponse);

            // Act
            const result = await controller.getUploadUrl(mockReq, uploadUrlDto);

            // Assert
            expect(result).toEqual(mockUploadUrlResponse);
            expect(mockDocumentsService.getUploadUrl).toHaveBeenCalledWith(
                mockReq.user.id,
                uploadUrlDto.fileName,
                uploadUrlDto.contentType,
            );
        });

        it('should propagate NotFoundException from service', async () => {
            // Arrange
            mockDocumentsService.getUploadUrl.mockRejectedValue(
                new NotFoundException('Partner not found'),
            );

            // Act & Assert
            await expect(controller.getUploadUrl(mockReq, uploadUrlDto)).rejects.toThrow(
                NotFoundException,
            );
        });
    });

    describe('getDocumentUrl', () => {
        it('should return signed document URL for partner', async () => {
            // Arrange
            const documentId = 'doc-uuid';
            mockDocumentsService.getDocumentUrl.mockResolvedValue(mockDocumentUrlResponse);

            // Act
            const result = await controller.getDocumentUrl(mockReq, documentId);

            // Assert
            expect(result).toEqual(mockDocumentUrlResponse);
            expect(mockDocumentsService.getDocumentUrl).toHaveBeenCalledWith(
                documentId,
                mockReq.user.id,
            );
        });

        it('should propagate BadRequestException for unauthorized access', async () => {
            // Arrange
            const documentId = 'other-doc';
            mockDocumentsService.getDocumentUrl.mockRejectedValue(
                new BadRequestException('Access denied'),
            );

            // Act & Assert
            await expect(controller.getDocumentUrl(mockReq, documentId)).rejects.toThrow(
                BadRequestException,
            );
        });
    });

    describe('submitDocument', () => {
        const submitDto = {
            documentType: DocumentType.BUSINESS_LICENSE,
            documentUrl: 'https://example.com/new-doc.pdf',
        };

        it('should submit document and return response', async () => {
            // Arrange
            mockDocumentsService.submitDocument.mockResolvedValue(mockDocument);

            // Act
            const result = await controller.submitDocument(mockReq, submitDto);

            // Assert
            expect(result.id).toBe(mockDocument.id);
            expect(result.documentType).toBe(mockDocument.documentType);
            expect(result.status).toBe(mockDocument.status);
            expect(mockDocumentsService.submitDocument).toHaveBeenCalledWith(
                mockReq.user.id,
                submitDto,
            );
        });
    });

    describe('reviewDocument', () => {
        const adminReq = {
            user: {
                id: 'admin-uuid',
                email: 'admin@test.com',
            },
        };

        it('should approve document', async () => {
            // Arrange
            const documentId = 'doc-uuid';
            const reviewDto = {
                status: DocumentStatus.APPROVED,
                verificationNotes: 'Looks good',
            };
            const approvedDoc = { ...mockDocument, status: DocumentStatus.APPROVED };
            mockDocumentsService.reviewDocument.mockResolvedValue(approvedDoc);

            // Act
            const result = await controller.reviewDocument(documentId, reviewDto, adminReq);

            // Assert
            expect(result.status).toBe(DocumentStatus.APPROVED);
            expect(mockDocumentsService.reviewDocument).toHaveBeenCalledWith(
                documentId,
                reviewDto,
                adminReq.user.id,
            );
        });

        it('should reject document with feedback', async () => {
            // Arrange
            const documentId = 'doc-uuid';
            const reviewDto = {
                status: DocumentStatus.REJECTED,
                adminFeedback: 'Document is blurry',
            };
            const rejectedDoc = {
                ...mockDocument,
                status: DocumentStatus.REJECTED,
                adminFeedback: reviewDto.adminFeedback,
            };
            mockDocumentsService.reviewDocument.mockResolvedValue(rejectedDoc);

            // Act
            const result = await controller.reviewDocument(documentId, reviewDto, adminReq);

            // Assert
            expect(result.status).toBe(DocumentStatus.REJECTED);
            expect(result.adminFeedback).toBe(reviewDto.adminFeedback);
        });

        it('should propagate BadRequestException for missing feedback', async () => {
            // Arrange
            const documentId = 'doc-uuid';
            const reviewDto = {
                status: DocumentStatus.REJECTED,
                adminFeedback: '',
            };
            mockDocumentsService.reviewDocument.mockRejectedValue(
                new BadRequestException('Admin feedback is required when rejecting'),
            );

            // Act & Assert
            await expect(
                controller.reviewDocument(documentId, reviewDto, adminReq),
            ).rejects.toThrow(BadRequestException);
        });
    });

    describe('getPartnerDocumentStatusAdmin', () => {
        it('should return document status for specified account (admin)', async () => {
            // Arrange
            const accountId = 'partner-account-uuid';
            mockDocumentsService.getPartnerDocumentStatus.mockResolvedValue(mockDocumentStatus);

            // Act
            const result = await controller.getPartnerDocumentStatusAdmin(accountId);

            // Assert
            expect(result).toEqual(mockDocumentStatus);
            expect(mockDocumentsService.getPartnerDocumentStatus).toHaveBeenCalledWith(accountId);
        });
    });

    describe('getPartnerDocuments', () => {
        it('should return all documents for a partner (admin)', async () => {
            // Arrange
            const accountId = 'partner-account-uuid';
            const mockDocuments = [mockDocument, { ...mockDocument, id: 'doc-2' }];
            mockDocumentsService.getPartnerDocuments.mockResolvedValue(mockDocuments);

            // Act
            const result = await controller.getPartnerDocuments(accountId);

            // Assert
            expect(result.documents).toEqual(mockDocuments);
            expect(mockDocumentsService.getPartnerDocuments).toHaveBeenCalledWith(accountId);
        });
    });

    describe('getDocumentUrlAdmin', () => {
        it('should return document URL without ownership check (admin)', async () => {
            // Arrange
            const documentId = 'doc-uuid';
            mockDocumentsService.getDocumentUrl.mockResolvedValue(mockDocumentUrlResponse);

            // Act
            const result = await controller.getDocumentUrlAdmin(documentId);

            // Assert
            expect(result).toEqual(mockDocumentUrlResponse);
            // Admin call should NOT pass accountId (no ownership check)
            expect(mockDocumentsService.getDocumentUrl).toHaveBeenCalledWith(documentId);
        });
    });
});
