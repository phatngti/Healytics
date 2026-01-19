import {
    Injectable,
    NotFoundException,
    BadRequestException,
    Logger,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PartnerDocument } from './entities/partner-document.entity';
import { DocumentRequirement } from './entities/document-requirement.entity';
import { Partner } from './entities/partner.entity';
import { S3Service } from '@/s3/s3.service';
import { PartnersService } from './partners.service';
import { SubmitDocumentDto } from './dto/request/submit-document.dto';
import { ReviewDocumentDto } from './dto/request/review-document.dto';
import {
    GetDocumentStatusResponseDto,
    DocumentStatusDto,
} from './dto/response/get-document-status-response.dto';
import { DocumentStatus } from './enum/document-status.enum';
import { GetUploadUrlResponseDto } from './dto/response/get-upload-url-response.dto';
import { GetDocumentUrlResponseDto } from './dto/response/get-document-url-response.dto';

@Injectable()
export class DocumentsService {
    private readonly logger = new Logger(DocumentsService.name);

    constructor(
        @InjectRepository(PartnerDocument)
        private readonly documentRepo: Repository<PartnerDocument>,
        @InjectRepository(DocumentRequirement)
        private readonly requirementRepo: Repository<DocumentRequirement>,
        @InjectRepository(Partner)
        private readonly partnerRepo: Repository<Partner>,
        private readonly s3Service: S3Service,
        private readonly partnersService: PartnersService,
    ) { }

    /**
     * PARTNER: Get presigned URL for document upload
     */
    async getUploadUrl(
        accountId: string,
        fileName: string,
        contentType: string,
    ): Promise<GetUploadUrlResponseDto> {
        const partner = await this.partnersService.getPartnerByAccountId(
            accountId,
        );
        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

        // Generate presigned URL via S3Service
        const result = await this.s3Service.getPresignedUploadUrl(
            `documents/${partner.id}/${Date.now()}-${fileName}`,
            contentType,
        );

        return {
            uploadUrl: result.uploadUrl,
            documentKey: result.key,
        };
    }

    /**
     * Get signed URL for viewing/downloading a document
     */
    async getDocumentUrl(documentId: string, accountId?: string): Promise<GetDocumentUrlResponseDto> {
        const document = await this.documentRepo.findOne({
            where: { id: documentId },
            relations: ['partner'],
        });

        if (!document) {
            throw new NotFoundException('Document not found');
        }

        // If accountId provided (partner role), verify ownership
        if (accountId) {
            const partner = await this.partnersService.getPartnerByAccountId(
                accountId,
            );
            if (!partner || partner.id !== document.partnerId) {
                throw new BadRequestException('Access denied');
            }
        }

        const url = await this.s3Service.getFileUrl(document.documentKey);
        return {
            url,
            documentType: document.documentType,
            status: document.status,
        };
    }

    /**
     * PARTNER: Submit/Update a document (UPSERT logic)
     */
    async submitDocument(accountId: string, dto: SubmitDocumentDto): Promise<PartnerDocument> {
        const partner = await this.partnersService.getPartnerByAccountId(
            accountId,
        );
        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

        // Check if document already exists
        let document = await this.documentRepo.findOne({
            where: {
                partnerId: partner.id,
                documentType: dto.documentType,
            },
        });

        if (document) {
            // CLEANUP: If the document key is different, delete the old file from R2/S3
            if (document.documentKey && document.documentKey !== dto.documentUrl) {
                try {
                    // Fire and forget - don't block user if deletion fails
                    await this.s3Service.deleteFile(document.documentKey);
                    this.logger.log(
                        `Deleted old document file: ${document.documentKey}`,
                    );
                } catch (error) {
                    this.logger.error(
                        `Failed to delete old document ${document.documentKey}`,
                        error,
                    );
                    // Continue anyway - the new document upload should succeed regardless
                }
            }

            // Update existing document
            document.documentKey = dto.documentUrl;
            document.status = DocumentStatus.PENDING;
            document.adminFeedback = null; // Clear old feedback
            document.verificationNotes = null;
            document.verifiedBy = null;
            this.logger.log(
                `Document ${dto.documentType} re-submitted for partner ${partner.id}`,
            );
        } else {
            // Create new document
            document = this.documentRepo.create({
                partnerId: partner.id,
                documentType: dto.documentType,
                documentKey: dto.documentUrl,
                status: DocumentStatus.PENDING,
            });
            this.logger.log(
                `New document ${dto.documentType} submitted for partner ${partner.id}`,
            );
        }

        return this.documentRepo.save(document);
    }

    /**
     * PARTNER: Get document status - the "difficult" method
     * Maps requirements vs actual submissions
     */
    async getPartnerDocumentStatus(
        accountId: string,
    ): Promise<GetDocumentStatusResponseDto> {
        const partner = await this.partnersService.getPartnerByAccountId(
            accountId,
        );
        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

        // Get required documents for this business type
        const requirements = await this.requirementRepo.find({
            where: { businessType: partner.businessType },
            order: { displayOrder: 'ASC' },
        });

        // Get submitted documents
        const submitted = await this.documentRepo.find({
            where: { partnerId: partner.id },
        });

        // Create map for quick lookup
        const submittedMap = new Map(
            submitted.map((doc) => [doc.documentType, doc]),
        );

        // Combine requirements with submissions
        const documents: DocumentStatusDto[] = requirements.map((req) => {
            const doc = submittedMap.get(req.documentType);

            // Calculate status dynamically: 'MISSING' if not uploaded, otherwise actual status
            const status: DocumentStatus | 'MISSING' = doc?.status || 'MISSING';

            return {
                documentType: req.documentType,
                description: req.description,
                isRequired: req.isRequired,
                status: status,
                documentUrl: doc?.documentKey || null,
                adminFeedback: doc?.adminFeedback || null,
                uploadedAt: doc?.uploadedAt || null,
                documentId: doc?.id || null,
            };
        });

        const totalRequired = requirements.filter((r) => r.isRequired).length;
        const totalApproved = submitted.filter(
            (d) => d.status === DocumentStatus.APPROVED,
        ).length;

        return {
            documents,
            totalRequired,
            totalApproved,
            isVerified: partner.isVerified,
        };
    }

    /**
     * ADMIN: Review a document
     */
    async reviewDocument(
        documentId: string,
        dto: ReviewDocumentDto,
        adminId: string,
    ): Promise<PartnerDocument> {
        const document = await this.documentRepo.findOne({
            where: { id: documentId },
            relations: ['partner'],
        });

        if (!document) {
            throw new NotFoundException('Document not found');
        }

        // Validation: Feedback required when rejecting
        if (
            dto.status === DocumentStatus.REJECTED &&
            !dto.adminFeedback?.trim()
        ) {
            throw new BadRequestException(
                'Admin feedback is required when rejecting a document',
            );
        }

        // Update document
        document.status = dto.status;
        document.adminFeedback = dto.adminFeedback || null;
        document.verificationNotes = dto.verificationNotes || null;
        document.verifiedBy = adminId;

        await this.documentRepo.save(document);

        // Trigger auto-activation check if approved
        if (dto.status === DocumentStatus.APPROVED) {
            await this.checkAndActivatePartner(document.partnerId);
        }

        this.logger.log(
            `Document ${documentId} reviewed by ${adminId}: ${dto.status}`,
        );

        return document;
    }

    /**
     * SYSTEM: Auto-activation logic
     * Checks if all required documents are approved, then activates business
     */
    private async checkAndActivatePartner(partnerId: string): Promise<void> {
        const partner = await this.partnerRepo.findOne({
            where: { id: partnerId },
        });

        if (!partner || partner.isVerified) {
            return; // Already verified or not found
        }

        // Get required documents for this partner type
        const requirements = await this.requirementRepo.find({
            where: {
                businessType: partner.businessType,
                isRequired: true,
            },
        });

        // Get approved documents
        const approvedDocs = await this.documentRepo.find({
            where: {
                partnerId: partner.id,
                status: DocumentStatus.APPROVED,
            },
        });

        const requiredTypes = new Set(requirements.map((r) => r.documentType));
        const approvedTypes = new Set(approvedDocs.map((d) => d.documentType));

        // Check if all required documents are approved
        const allApproved = [...requiredTypes].every((type) =>
            approvedTypes.has(type),
        );

        if (allApproved) {
            partner.isVerified = true;
            partner.verificationCompletedAt = new Date();
            await this.partnerRepo.save(partner);

            this.logger.log(
                `🎉 Partner ${partner.id} automatically activated!`,
            );
            // TODO: Send notification to partner
        }
    }

    /**
     * ADMIN: Get all documents for a specific partner
     */
    async getPartnerDocuments(partnerId: string): Promise<PartnerDocument[]> {
        return this.documentRepo.find({
            where: { partnerId },
            order: { uploadedAt: 'DESC' },
        });
    }
}
