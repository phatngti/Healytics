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
import { UploadUrlResponseDto } from './dto/response/upload-url-response.dto';
import { DocumentUrlResponseDto } from './dto/response/document-url-response.dto';
import { PartnerVerificationStatus } from './enum/partner-verification-status.enum';

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
        // S3Service adds timestamp prefix, so we pass the path without timestamp
        // Result key will be: {timestamp}-documents/{partnerId}/{fileName}
        const result = await this.s3Service.getPresignedUploadUrl(
            `documents/${partner.id}/${fileName}`,
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
            : document.documentUrl ?? null;

        return {
            url,
            documentType: document.documentType,
            isReviewed: document.isReviewed,
            isValid: document.isValid,
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

            // Update existing document - reset review status
            document.documentUrl = dto.documentUrl ?? null;
            document.documentKey = dto.documentKey ?? null; // Reset - will be set in controller if file uploaded
            document.isReviewed = false;
            document.isValid = true; // Optimistic validation
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
                documentKey: dto.documentKey || null, // Use key from DTO if provided
                isReviewed: false,
                isValid: true, // Optimistic validation
            });
            this.logger.log(
                `New document ${dto.documentType} submitted for partner ${partner.id}`,
            );
        }

        // Always update key if provided in DTO
        if (dto.documentKey) {
            document.documentKey = dto.documentKey;
        }

        return this.documentRepo.save(document);
    }

    /**
     * ADMIN: Get document status by Partner ID
     */
    async getPartnerDocumentStatusByPartnerId(
        partnerId: string,
    ): Promise<DocumentStatusResponseDto> {
        const partner = await this.partnerRepo.findOne({
            where: { id: partnerId },
        });

        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

        return this._generateDocumentStatusResponse(partner);
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

        return this._generateDocumentStatusResponse(partner);
    }

    /**
     * Helper to generate status response from partner entity
     */
    private async _generateDocumentStatusResponse(partner: Partner): Promise<DocumentStatusResponseDto> {
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

            // Calculate status dynamically based on new fields
            let status: 'MISSING' | 'PENDING' | 'VALID' | 'INVALID';
            if (!doc) {
                status = 'MISSING';
            } else if (!doc.isReviewed) {
                status = 'PENDING';
            } else {
                status = doc.isValid ? 'VALID' : 'INVALID';
            }

            return {
                documentType: req.documentType,
                description: req.description,
                isRequired: req.isRequired,
                status: status,
                isReviewed: doc?.isReviewed ?? false,
                isValid: doc?.isValid ?? false,
                documentUrl: doc?.documentUrl || null,
                documentKey: doc?.documentKey || null,
                adminFeedback: doc?.adminFeedback || null,
                uploadedAt: doc?.uploadedAt || null,
                documentId: doc?.id || null,
            };
        });

        const totalRequired = requirements.filter((r) => r.isRequired).length;
        const totalValid = submitted.filter(
            (d) => d.isReviewed && d.isValid,
        ).length;

        return {
            documents,
            totalRequired,
            totalValid,
            verificationStatus: partner.verificationStatus,
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

        // Validation: Feedback required when marking as invalid
        if (!dto.isValid && !dto.adminFeedback?.trim()) {
            throw new BadRequestException(
                'Admin feedback is required when marking a document as invalid',
            );
        }

        // Update document with new model
        document.isReviewed = true;
        document.isValid = dto.isValid;
        document.adminFeedback = dto.adminFeedback || null;
        document.verificationNotes = dto.verificationNotes || null;
        document.verifiedBy = adminId;

        await this.documentRepo.save(document);

        // Trigger auto-activation check if valid
        if (dto.isValid) {
            await this.checkAndActivatePartner(document.partnerId);
        }

        this.logger.log(
            `Document ${documentId} reviewed by ${adminId}: isValid=${dto.isValid}`,
        );

        return document;
    }

    /**
     * SYSTEM: Auto-activation logic
     * Checks if all required documents are valid, then activates business
     */
    private async checkAndActivatePartner(partnerId: string): Promise<void> {
        const partner = await this.partnerRepo.findOne({
            where: { id: partnerId },
        });

        if (!partner || partner.verificationStatus === PartnerVerificationStatus.APPROVED) {
            return; // Already verified or not found
        }

        // Get required documents for this partner type
        const requirements = await this.requirementRepo.find({
            where: {
                businessType: partner.businessType,
                isRequired: true,
            },
        });

        // Get valid documents (reviewed + valid)
        const validDocs = await this.documentRepo.find({
            where: {
                partnerId: partner.id,
                isReviewed: true,
                isValid: true,
            },
        });

        const requiredTypes = new Set(requirements.map((r) => r.documentType));
        const validTypes = new Set(validDocs.map((d) => d.documentType));

        // Check if all required documents are valid
        const allValid = [...requiredTypes].every((type) =>
            validTypes.has(type),
        );

        if (allValid) {
            partner.verificationStatus = PartnerVerificationStatus.APPROVED;
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
