import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { Partner } from '@/partners/entities/partner.entity';
import { PartnerDocument, PartnerDocumentStatuses } from '@/partners/entities/partner-document.entity';
import { PartnerReviewLog } from '@/admin/entities/partner-review-log.entity';
import { DocumentRequirement } from '@/partners/entities/document-requirement.entity';
import { AdminPartnerDetailResponseDto } from '../dto/admin-partner-detail-response.dto';
import { ReviewPartnerProfileDto, ReviewDecision } from '../dto/review-partner-profile.dto';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { PartnersService } from '@/partners/partners.service';
import { GetPartnersQueryDto } from '@/partners/dto/request/get-partners-query.dto';

// ============================================================================
// Field Keys for Review (centralized for easy maintenance)
// ============================================================================
export const PartnerFieldKeys = {
    // Business Info Fields
    brandName: 'brandName',
    taxCode: 'taxCode',
    legalName: 'legalName',
    businessType: 'businessType',
    serviceTags: 'serviceTags',
    phoneNumber: 'phoneNumber',
    email: 'email',
    username: 'username',
    
    // Address Fields (matching /partners/me API keys)
    streetAddress: 'streetAddress',
    // Legacy keys for backward compatibility
    ward: 'ward',
    district: 'district',
    city: 'city',
    
    // Legal Representative Fields (prefixed with 'legalRep.')
    fullName: 'fullName',
    position: 'position',
    idType: 'idType',
    idNumber: 'idNumber',
    idIssueDate: 'idIssueDate',
} as const;

export type PartnerFieldKey = typeof PartnerFieldKeys[keyof typeof PartnerFieldKeys];

// Helper type for field review data
export interface FieldFeedback {
    isVerified: boolean;
    feedback?: string;
}

export type FieldFeedbackMap = Record<string, FieldFeedback>;

@Injectable()
export class AdminPartnersService {
    constructor(
        @InjectRepository(Partner)
        private readonly partnerRepo: Repository<Partner>,
        @InjectRepository(PartnerDocument)
        private readonly documentRepo: Repository<PartnerDocument>,
        @InjectRepository(PartnerReviewLog)
        private readonly reviewLogRepo: Repository<PartnerReviewLog>,
        @InjectRepository(DocumentRequirement)
        private readonly docRequirementRepo: Repository<DocumentRequirement>,
        private readonly dataSource: DataSource,
        private readonly partnersService: PartnersService,
    ) { }

    async getPartnerDetail(id: string): Promise<AdminPartnerDetailResponseDto> {
        const partner = await this.partnerRepo.findOne({
            where: { id },
            relations: ['account', 'province', 'district', 'ward', 'legalRepresentative'],
        });

        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

        // Fetch documents with simplified schema
        const documents = await this.documentRepo.find({
            where: { partnerId: id },
            order: { createdAt: 'DESC' },
        });

        // Assign documents to partner for DTO mapping
        partner.documents = documents;

        // Fetch the latest review log for feedback data
        const latestReviewLog = await this.reviewLogRepo.findOne({
            where: { partnerId: id },
            order: { createdAt: 'DESC' },
        });

        // Build field feedback map from review log
        const fieldFeedbackMap = this.buildFieldFeedbackMap(latestReviewLog);

        // Build document feedback map from review log
        const documentFeedbackMap = this.buildDocumentFeedbackMap(latestReviewLog);

        return AdminPartnerDetailResponseDto.fromPartner(partner, fieldFeedbackMap, documentFeedbackMap);
    }

    /**
     * Build field feedback map from the latest review log
     */
    private buildFieldFeedbackMap(reviewLog: PartnerReviewLog | null): FieldFeedbackMap {
        const feedbackMap: FieldFeedbackMap = {};

        if (!reviewLog?.fieldReviews) {
            return feedbackMap;
        }

        for (const [fieldName, review] of Object.entries(reviewLog.fieldReviews)) {
            feedbackMap[fieldName] = {
                isVerified: review.isValid,
                feedback: review.reason,
            };
        }

        return feedbackMap;
    }

    /**
     * Build document feedback map from the latest review log
     */
    private buildDocumentFeedbackMap(reviewLog: PartnerReviewLog | null): FieldFeedbackMap {
        const feedbackMap: FieldFeedbackMap = {};

        if (!reviewLog?.documentReviews) {
            return feedbackMap;
        }

        for (const [docId, review] of Object.entries(reviewLog.documentReviews)) {
            feedbackMap[docId] = {
                isVerified: review.isValid,
                feedback: review.feedback,
            };
        }

        return feedbackMap;
    }

    async reviewPartner(id: string, dto: ReviewPartnerProfileDto, adminId: string): Promise<void> {
        const partner = await this.partnerRepo.findOne({
            where: { id },
            relations: ['legalRepresentative']
        });

        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

        // [CONSTRAINT 1] Gatekeeper: Admin can ONLY review if status is PENDING
        if (partner.verificationStatus !== PartnerVerificationStatus.PENDING) {
            throw new BadRequestException(`Partner is not in PENDING state (Current: ${partner.verificationStatus}). Cannot review.`);
        }

        await this.dataSource.transaction(async (manager) => {
            // 1. Prepare Log Data Snapshots
            const fieldReviews: Record<string, any> = {};
            const documentReviews: Record<string, any> = {};

            // Fetch all current documents for snapshotting
            const existingDocs = await manager.find(PartnerDocument, {
                where: { partnerId: id }
            });
            const docMap = new Map(existingDocs.map(d => [d.id, d]));

            // Track accepted document types (for completeness check)
            const acceptedDocuments = new Set<string>();

            // Helper to record field review
            const recordFieldReview = (fieldKey: string, isVerified: boolean, feedback?: string, value?: any) => {
                fieldReviews[fieldKey] = {
                    value: value ?? null,
                    isValid: isVerified,
                    reason: isVerified ? null : feedback
                };
            };

            // Helper to get field value from partner or legal representative
            const getFieldValue = (fieldKey: string): any => {
                if (fieldKey.startsWith('legalRep.')) {
                    const actualFieldName = fieldKey.substring('legalRep.'.length);
                    return partner.legalRepresentative ? (partner.legalRepresentative as any)[actualFieldName] : null;
                }
                return (partner as any)[fieldKey];
            };

            // 2. Process Items (Validation & Status Update) - Update documents and record for logging
            const finalRejections: Record<string, string> = {};

            if (dto.items && dto.items.length > 0) {
                for (const item of dto.items) {
                    // --- DOCUMENT (identified by presence of documentKey) ---
                    if (item.documentKey) {
                        const doc = docMap.get(item.documentKey);
                        if (doc) {
                            // Update Document Status using new simplified schema
                            const newStatus = item.isVerified 
                                ? PartnerDocumentStatuses.ACCEPTED 
                                : PartnerDocumentStatuses.REJECTED;
                            
                            await manager.update(PartnerDocument, { id: item.documentKey }, {
                                status: newStatus,
                            });

                            // Log Snapshot
                            documentReviews[item.documentKey] = {
                                documentType: doc.type,
                                url: doc.fileUrl,
                                isValid: item.isVerified,
                                feedback: item.feedback
                            };

                            if (!item.isVerified) {
                                // Add to rejection list
                                finalRejections[`document_${doc.id}`] = item.feedback || 'Document rejected';
                            } else {
                                // Add to accepted set
                                acceptedDocuments.add(doc.id);
                            }
                        }
                    }
                    // --- FIELD (partner or legalRep, determined by fieldKey prefix) ---
                    else {
                        const value = getFieldValue(item.fieldKey);
                        recordFieldReview(item.fieldKey, item.isVerified, item.feedback, value);
                        if (!item.isVerified) {
                            finalRejections[item.fieldKey] = item.feedback || 'Field rejected';
                        }
                    }
                }
            }

            // 3. CHECK EXISTING DOCUMENTS (Catch missed rejected docs)
            existingDocs.forEach(doc => {
                const isProcessed = dto.items?.some(i => i.documentKey === doc.id);
                if (!isProcessed) {
                    if (doc.status === PartnerDocumentStatuses.ACCEPTED) {
                        acceptedDocuments.add(doc.id);
                    } else if (doc.status === PartnerDocumentStatuses.REJECTED) {
                        // Previous rejection still stands -> Add to rejections
                        finalRejections[`document_${doc.id}`] = 'Previous rejection';
                    }
                }
            });

            // 4. DETERMINE VERDICT
            const hasErrors = Object.keys(finalRejections).length > 0;
            let verdict: PartnerVerificationStatus;

            if (dto.decision === ReviewDecision.REJECTED) {
                // Explicit REJECT (Terminal) overrides everything
                verdict = PartnerVerificationStatus.REJECTED;
                partner.verificationStatus = PartnerVerificationStatus.REJECTED;
                partner.rejectionDetails = null;
            } else if (hasErrors) {
                // If there are errors, we MUST Require Resubmit regardless of decision
                verdict = PartnerVerificationStatus.REQUIRED_RESUBMIT;
                partner.verificationStatus = PartnerVerificationStatus.REQUIRED_RESUBMIT;
                partner.rejectionDetails = finalRejections;
            } else {
                // Clean slate -> Check for APPROVED criteria
                if (dto.decision === ReviewDecision.APPROVED) {
                    // Check if missing required documents
                    const requirements = await this.docRequirementRepo.find({
                        where: { businessType: partner.businessType, isRequired: true }
                    });

                    // With simplified schema, we just check if we have any documents
                    if (existingDocs.length === 0 && requirements.length > 0) {
                        throw new BadRequestException(`Cannot approve: Missing required documents`);
                    }

                    verdict = PartnerVerificationStatus.APPROVED;
                    partner.verificationStatus = PartnerVerificationStatus.APPROVED;
                    partner.verificationCompletedAt = new Date();
                    partner.rejectionDetails = null;

                    // Auto-accept remaining pending documents
                    await manager.update(PartnerDocument,
                        { partnerId: id, status: PartnerDocumentStatuses.PENDING },
                        { status: PartnerDocumentStatuses.ACCEPTED }
                    );
                } else {
                    // CHANGES_REQUIRED but no specific errors found?
                    // Still set to REQUIRED_RESUBMIT but maybe empty rejections?
                    if (!dto.generalComment) {
                        throw new BadRequestException('Must specify rejection items or comment when requesting changes.');
                    }
                    verdict = PartnerVerificationStatus.REQUIRED_RESUBMIT;
                    partner.verificationStatus = PartnerVerificationStatus.REQUIRED_RESUBMIT;
                    partner.rejectionDetails = null;
                }
            }

            await manager.save(partner);

            // 5. Create Review Log
            const reviewLog = manager.create(PartnerReviewLog, {
                partnerId: id,
                reviewerId: adminId,
                verdict,
                generalComment: dto.generalComment,
                fieldReviews: Object.keys(fieldReviews).length > 0 ? fieldReviews : null,
                documentReviews: Object.keys(documentReviews).length > 0 ? documentReviews : null,
            });
            await manager.save(reviewLog);
        });
    }

    async getPartners(query: GetPartnersQueryDto): Promise<any> {
        return this.partnersService.getPartners(query);
    }

    async getTotalPartners(): Promise<{ total: number }> {
        const total = await this.partnerRepo.count();
        return { total };
    }
}
