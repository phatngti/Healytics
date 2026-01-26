import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { Partner } from '@/partners/entities/partner.entity';
import { PartnerDocument } from '@/partners/entities/partner-document.entity';
import { PartnerReviewLog } from '@/partners/entities/partner-review-log.entity';
import { DocumentRequirement } from '@/partners/entities/document-requirement.entity';
import { AdminPartnerDetailResponseDto } from '../dto/admin-partner-detail-response.dto';
import { ReviewPartnerProfileDto, ReviewDecision, ReviewItemType } from '../dto/review-partner-profile.dto';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { PartnersService } from '@/partners/partners.service';
import { GetPartnersQueryDto } from '@/partners/dto/request/get-partners-query.dto';
import { PartnerDocumentStatus } from '@/partners/enum/partner-document-status.enum';

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

        const documents = await this.documentRepo.find({
            where: { partnerId: id },
            order: { uploadedAt: 'DESC' },
        });

        // Fetch document requirements for this business type
        const requirements = await this.docRequirementRepo.find({
            where: { businessType: partner.businessType },
        });

        // Map uploaded documents by type for easy lookup
        const uploadedDocsMap = new Map<string, PartnerDocument>();
        documents.forEach((doc) => {
            uploadedDocsMap.set(doc.documentType, doc);
        });

        // Merge requirements with uploaded documents
        const mergedDocuments: any[] = requirements.map((req) => {
            const uploadedDoc = uploadedDocsMap.get(req.documentType);

            let status = PartnerDocumentStatus.MISSING;
            let documentUrl: string | null = null;
            let documentKey: string | null = null;
            let id: string | null = null;
            let isReviewed = false;
            let isValid = false;
            let adminFeedback: string | null = null;
            let verificationNotes: string | null = null;
            let uploadedAt: Date | null = null;

            if (uploadedDoc) {
                id = uploadedDoc.id;
                documentUrl = uploadedDoc.documentUrl;
                documentKey = uploadedDoc.documentKey;
                isReviewed = uploadedDoc.isReviewed;
                isValid = uploadedDoc.isValid;
                adminFeedback = uploadedDoc.adminFeedback;
                verificationNotes = uploadedDoc.verificationNotes;
                uploadedAt = uploadedDoc.uploadedAt;

                if (uploadedDoc.isReviewed) {
                    status = uploadedDoc.isValid
                        ? PartnerDocumentStatus.APPROVED
                        : PartnerDocumentStatus.REJECTED;
                } else {
                    status = PartnerDocumentStatus.PENDING;
                }
            }

            return {
                id,
                documentType: req.documentType,
                documentUrl,
                documentKey,
                status,
                isRequired: req.isRequired,
                description: req.description,
                isReviewed,
                isValid,
                adminFeedback,
                verificationNotes,
                uploadedAt,
            };
        });

        // Also include any uploaded documents that might not be in the current requirements
        documents.forEach((doc) => {
            const reqExists = requirements.find(r => r.documentType === doc.documentType);
            if (!reqExists) {
                let status = PartnerDocumentStatus.PENDING;
                if (doc.isReviewed) {
                    status = doc.isValid ? PartnerDocumentStatus.APPROVED : PartnerDocumentStatus.REJECTED;
                }

                mergedDocuments.push({
                    id: doc.id,
                    documentType: doc.documentType,
                    documentUrl: doc.documentUrl,
                    documentKey: doc.documentKey,
                    status,
                    isRequired: false, // Not in current requirements
                    description: null,
                    isReviewed: doc.isReviewed,
                    isValid: doc.isValid,
                    adminFeedback: doc.adminFeedback,
                    verificationNotes: doc.verificationNotes,
                    uploadedAt: doc.uploadedAt,
                });
            }
        });

        return AdminPartnerDetailResponseDto.fromEntity(partner, mergedDocuments);
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

            // Track valid document types (for completeness check)
            const validDocumentTypes = new Set<string>();

            // Helper to record field review
            const recordFieldReview = (fieldName: string, isValid: boolean, reason?: string, value?: any) => {
                fieldReviews[fieldName] = {
                    value: value ?? null,
                    isValid,
                    reason: isValid ? null : reason
                };
            };

            // 2. Process Items (Validation & Status Update) - Update documents and record for logging
            const finalRejections: Record<string, string> = {};

            if (dto.items && dto.items.length > 0) {
                for (const item of dto.items) {
                    // --- DOCUMENT ---
                    if (item.type === ReviewItemType.DOCUMENT && item.documentId) {
                        const doc = docMap.get(item.documentId);
                        if (doc) {
                            // Update Document Status
                            await manager.update(PartnerDocument, { id: item.documentId }, {
                                isReviewed: true,
                                isValid: item.isValid,
                                adminFeedback: item.isValid ? null : item.reason,
                                verifiedBy: adminId,
                                verificationNotes: dto.generalComment
                            });

                            // Log Snapshot
                            documentReviews[item.documentId] = {
                                documentType: doc.documentType,
                                url: doc.documentUrl,
                                isValid: item.isValid,
                                feedback: item.reason
                            };

                            if (!item.isValid) {
                                // Add to rejection list
                                finalRejections[`document_${doc.documentType}`] = item.reason || 'Document rejected';
                            } else {
                                // Add to valid set
                                validDocumentTypes.add(doc.documentType);
                            }
                        }
                    }
                    // --- PARTNER FIELDS ---
                    else if (item.type === ReviewItemType.FIELD && item.fieldName) {
                        const value = (partner as any)[item.fieldName];
                        recordFieldReview(item.fieldName, item.isValid, item.reason, value);
                        if (!item.isValid) {
                            finalRejections[item.fieldName] = item.reason || 'Field rejected';
                        }
                    }
                    // --- LEGAL REP FIELDS ---
                    else if (item.type === ReviewItemType.LEGAL_REP_FIELD && item.fieldName && partner.legalRepresentative) {
                        const value = (partner.legalRepresentative as any)[item.fieldName];
                        recordFieldReview(`legalRep.${item.fieldName}`, item.isValid, item.reason, value);
                        if (!item.isValid) {
                            finalRejections[`legalRep.${item.fieldName}`] = item.reason || 'Field rejected';
                        }
                    }
                }
            }

            // 3. CHECK LEGACY DOCUMENTS (Catch missed bad docs)
            existingDocs.forEach(doc => {
                const isProcessed = dto.items?.some(i => i.type === ReviewItemType.DOCUMENT && i.documentId === doc.id);
                if (!isProcessed) {
                    if (doc.isValid) {
                        validDocumentTypes.add(doc.documentType);
                    } else if (doc.isReviewed && !doc.isValid) {
                        // Previous rejection still stands -> Add to rejections
                        finalRejections[`document_${doc.documentType}`] = doc.adminFeedback || 'Previous rejection';
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

                    const missingDocs = requirements
                        .filter(req => !validDocumentTypes.has(req.documentType))
                        .map(req => req.documentType);

                    if (missingDocs.length > 0) {
                        throw new BadRequestException(`Cannot approve: Missing required documents: ${missingDocs.join(', ')}`);
                    }

                    verdict = PartnerVerificationStatus.APPROVED;
                    partner.verificationStatus = PartnerVerificationStatus.APPROVED;
                    partner.verificationCompletedAt = new Date();
                    partner.rejectionDetails = null;

                    // Auto-approve remaining unreviewed documents
                    await manager.update(PartnerDocument,
                        { partnerId: id, isReviewed: false },
                        { isReviewed: true, isValid: true, verifiedBy: adminId }
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
}
