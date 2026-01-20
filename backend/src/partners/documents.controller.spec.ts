import { Test, TestingModule } from '@nestjs/testing';
import { DocumentsController } from './documents.controller';
import { DocumentsService } from './documents.service';
import { NotFoundException, BadRequestException } from '@nestjs/common';
import { DocumentType } from './enum/document-type.enum';

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
        isReviewed: false,
        isValid: true,
    };

    const mockDocument = {
        id: 'doc-uuid',
        partnerId: 'partner-uuid',
        documentType: DocumentType.BUSINESS_LICENSE,
        documentUrl: 'https://example.com/doc.pdf',
        documentKey: 'documents/partner-uuid/123-doc.pdf',
        isReviewed: false,
        isValid: true,
        uploadedAt: new Date(),
    };

    const mockDocumentStatus = {
        documents: [
            {
                documentType: DocumentType.BUSINESS_LICENSE,
                description: 'Giấy phép kinh doanh',
                isRequired: true,
                status: 'VALID', // computed status
                isReviewed: true,
                isValid: true,
                documentUrl: 'https://example.com/doc.pdf',
                documentKey: null,
                adminFeedback: null,
                uploadedAt: new Date(),
                documentId: 'doc-uuid',
            },
        ],
        totalRequired: 3,
        totalValid: 1,
        verificationStatus: 'PENDING',
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
            expect(result.isReviewed).toBe(mockDocument.isReviewed);
            expect(result.isValid).toBe(mockDocument.isValid);
            expect(mockDocumentsService.submitDocument).toHaveBeenCalledWith(
                mockReq.user.id,
                submitDto,
            );
        });
    });
});
