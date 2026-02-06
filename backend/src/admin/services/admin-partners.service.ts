import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource, In } from 'typeorm';
import { Partner } from '@/partners/entities/partner.entity';
import { PartnerDocument, PartnerDocumentStatuses } from '@/partners/entities/partner-document.entity';
import { PartnerReviewLog } from '@/admin/entities/partner-review-log.entity';
import { DocumentRequirement } from '@/partners/entities/document-requirement.entity';
import { AdminPartnerDetailResponseDto } from '../dto/admin-partner-detail-response.dto';
import { ReviewPartnerProfileDto, ReviewDecision } from '../dto/review-partner-profile.dto';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { PartnersService } from '@/partners/partners.service';
import { GetPartnersQueryDto } from '@/partners/dto/request/get-partners-query.dto';
import { PartnerFieldKeys, PartnerFieldKey } from '@/common/constants/partner-form-keys';

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
            relations: ['account', 'province', 'district', 'ward', 'legalRepresentative', 'documents'],
        });

        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

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
                feedback: review.feedback,
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

    // ============================================================================
    // Private Helper Methods for Review Processing
    // ============================================================================

    /**
     * Check if a value is a known partner field key (not a document key)
     * Document keys are values NOT in PartnerFieldKeys
     */
    private isPartnerFieldKey(value: string): boolean {
        const fieldKeyValues = Object.values(PartnerFieldKeys) as string[];
        return fieldKeyValues.includes(value);
    }

    /**
     * Sanitize entity records - removes timestamp fields (created_at, updated_at, deleted_at)
     */
    private sanitizeRecordValue(value: any): any {
        if (value === null || value === undefined) return null;
        if (typeof value !== 'object' || value instanceof Date) return value;
        if (Array.isArray(value)) return value.map(item => this.sanitizeRecordValue(item));
        
        // Remove timestamp fields from object
        const { createdAt, created_at, deletedAt, deleted_at, updatedAt, updated_at, ...rest } = value;
        return rest;
    }

    /**
     * Get field value from partner entity using field key
     */
    private getFieldValue(partner: Partner, fieldKey: string): any {
        // Field resolver map for cleaner value resolution
        const fieldResolvers: Record<string, () => any> = {
            [PartnerFieldKeys.ward]: () => partner.ward,
            [PartnerFieldKeys.district]: () => partner.district,
            [PartnerFieldKeys.city]: () => partner.province,
            [PartnerFieldKeys.brandName]: () => partner.brandName,
            [PartnerFieldKeys.taxCode]: () => partner.taxCode,
            [PartnerFieldKeys.legalName]: () => partner.legalName,
            [PartnerFieldKeys.businessType]: () => partner.businessType,
            [PartnerFieldKeys.streetAddress]: () => partner.streetAddress,
            [PartnerFieldKeys.phoneNumber]: () => partner.phoneNumber,
            [PartnerFieldKeys.email]: () => partner.account?.email ?? null,
            [PartnerFieldKeys.username]: () => partner.account?.username ?? null,
            [PartnerFieldKeys.idType]: () => partner.legalRepresentative?.idType ?? null,
            [PartnerFieldKeys.idNumber]: () => partner.legalRepresentative?.idNumber ?? null,
            [PartnerFieldKeys.idIssueDate]: () => partner.legalRepresentative?.idIssueDate ?? null,
            [PartnerFieldKeys.fullName]: () => partner.legalRepresentative?.fullName ?? null,
            [PartnerFieldKeys.position]: () => partner.legalRepresentative?.position ?? null,
        };

        const resolver = fieldResolvers[fieldKey];
        return resolver ? resolver() : (partner as any)[fieldKey] ?? null;
    }

    /**
     * Process a document review item - updates document status and records review data
     * Note: fieldKey contains the documentKey (storage path) from PartnerDocument entity
     */
    private async processDocumentReviewItem(
        manager: any,
        item: { fieldKey: string; feedback: string },
        docMap: Map<string, PartnerDocument>,
        documentReviews: Record<string, any>,
        finalRejections: Record<string, string>,
    ): Promise<void> {
        const documentKey = item.fieldKey;
        const doc = docMap.get(documentKey);
        if (!doc) return;


        await manager.update(PartnerDocument, { id: doc.id }, { status: PartnerDocumentStatuses.REJECTED });

        // Record document review snapshot (keyed by documentKey for consistency)
        documentReviews[documentKey] = {
            documentType: doc.type,
            url: doc.fileUrl,
            feedback: item.feedback,
        };

        finalRejections[`document_${doc.documentKey}`] = item.feedback;
    }

    /**
     * Process a field review item - records field value and review status
     */
    private processFieldReviewItem(
        partner: Partner,
        item: { fieldKey: string; feedback: string },
        fieldReviews: Record<string, any>,
        finalRejections: Record<string, string>,
    ): void {
        const fieldKey = item.fieldKey;
        const value = this.getFieldValue(partner, fieldKey);

        fieldReviews[fieldKey] = {
            value: this.sanitizeRecordValue(value),
            feedback: item.feedback,
        };

        finalRejections[fieldKey] = item.feedback || 'Field rejected';
    }


    async reviewPartner(id: string, dto: ReviewPartnerProfileDto, adminId: string): Promise<void> {
        const partner = await this.partnerRepo.findOne({
            where: { id },
            relations: ['legalRepresentative', 'province', 'district', 'ward', 'account', 'documents']
        });

        if (!partner) {
            throw new NotFoundException('Partner not found');
        }

        // [CONSTRAINT 1] Gatekeeper: Admin can ONLY review if status is PENDING
        if (partner.verificationStatus !== PartnerVerificationStatus.PENDING) {
            throw new BadRequestException(`Partner is not in PENDING state (Current: ${partner.verificationStatus}). Cannot review.`);
        }

        await this.dataSource.transaction(async (manager) => {
            // 1. Fetch all current documents for snapshotting
            const existingDocs = await manager.find(PartnerDocument, {
                where: { partnerId: id }
            });
            // Map documents by documentKey (storage path) for lookup
            const docMap = new Map(existingDocs.map(d => [d.documentKey, d]));

            // 2. Initialize review tracking data
            const fieldReviews: Record<string, any> = {};
            const documentReviews: Record<string, any> = {};
            const finalRejections: Record<string, string> = {};

            // 3. Process review items
            // fieldKey values in PartnerFieldKeys are field reviews
            // fieldKey values NOT in PartnerFieldKeys are document reviews (documentKey storage paths)
            for (const item of dto.items ?? []) {
                if (item.fieldKey && this.isPartnerFieldKey(item.fieldKey)) {
                    // Known field key - process as field review
                    this.processFieldReviewItem(
                        partner, item, fieldReviews, finalRejections
                    );
                } else if (item.fieldKey) {
                    // Not a known field key - process as document review (documentKey)
                    await this.processDocumentReviewItem(
                        manager, item, docMap, documentReviews, finalRejections
                    );
                }
            }

            // 5. Determine verdict based on rejections
            const hasErrors = Object.keys(finalRejections).length > 0;
            let verdict: PartnerVerificationStatus;

            if (dto.decision === ReviewDecision.REJECTED) {
                // Explicit REJECT (Terminal) overrides everything
                verdict = PartnerVerificationStatus.REJECTED;
                partner.verificationStatus = PartnerVerificationStatus.REJECTED;
            } else if (hasErrors) {
                // If there are errors, we MUST Require Resubmit regardless of decision
                verdict = PartnerVerificationStatus.REQUIRED_RESUBMIT;
                partner.verificationStatus = PartnerVerificationStatus.REQUIRED_RESUBMIT;
            } else {
                // Clean slate -> Check for APPROVED criteria
                if (dto.decision === ReviewDecision.APPROVED) {
                    // Check if missing required documents
                    const requirements = await this.docRequirementRepo.find({
                        where: { businessType: In(partner.businessType), isRequired: true }
                    });

                    // With simplified schema, we just check if we have any documents
                    if (existingDocs.length === 0 && requirements.length > 0) {
                        throw new BadRequestException(`Cannot approve: Missing required documents`);
                    }

                    verdict = PartnerVerificationStatus.APPROVED;
                    partner.verificationStatus = PartnerVerificationStatus.APPROVED;
                    partner.verificationCompletedAt = new Date();
                } else {
                    // CHANGES_REQUIRED but no specific errors found?
                    // Still set to REQUIRED_RESUBMIT but maybe empty rejections?
                    if (!dto.generalComment) {
                        throw new BadRequestException('Must specify rejection items or comment when requesting changes.');
                    }
                    verdict = PartnerVerificationStatus.REQUIRED_RESUBMIT;
                    partner.verificationStatus = PartnerVerificationStatus.REQUIRED_RESUBMIT;
                }
            }

            await manager.save(partner);

            // 6. Create Review Log
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
