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
    DocumentStatusResponseDto,
    DocumentStatusDto,
} from './dto/response/document-status-response.dto';
import { DocumentStatus } from './enum/document-status.enum';
import { UploadUrlResponseDto } from './dto/response/upload-url-response.dto';
import { DocumentUrlResponseDto } from './dto/response/document-url-response.dto';

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
    ): Promise<UploadUrlResponseDto> {
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
    async getDocumentUrl(documentId: string, accountId?: string): Promise<DocumentUrlResponseDto> {
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

        // For documents with documentKey (uploaded files), get signed URL from R2/S3
        // For documents with only documentUrl (registration links), return the URL directly
        const url = document.documentKey
            ? await this.s3Service.getFileUrl(document.documentKey)
            : document.documentUrl;

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
            // Only delete if it's an R2 file (has documentKey), not a registration URL
            if (document.documentKey && document.documentUrl !== dto.documentUrl) {
                try {
                    await this.s3Service.deleteFile(document.documentKey);
                    this.logger.log(
                        `Deleted old document file: ${document.documentKey}`,
                    );
                } catch (error) {
                    this.logger.error(
                        `Failed to delete old document ${document.documentKey}`,
                        error,
                    );
                }
            }

            // Update existing document
            document.documentUrl = dto.documentUrl;
            document.documentKey = null; // Reset - will be set in controller if file uploaded
            document.status = DocumentStatus.PENDING;
            document.adminFeedback = null;
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
                documentUrl: dto.documentUrl,
                documentKey: null, // Will be set in controller if file uploaded
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
    ): Promise<DocumentStatusResponseDto> {
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
                documentUrl: doc?.documentUrl || null,
                documentKey: doc?.documentKey || null,
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
