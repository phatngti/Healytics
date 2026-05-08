import {
  Injectable,
  Logger,
  NotFoundException,
  BadRequestException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource, In } from 'typeorm';
import { Partner } from '@/common/entities/partner.entity';
import {
  PartnerDocument,
  PartnerDocumentStatuses,
} from '@/common/entities/partner-document.entity';
import { PartnerReviewLog } from '@/common/entities/partner-review-log.entity';
import { DocumentRequirement } from '@/common/entities/document-requirement.entity';
import {
  ReviewPartnerProfileDto,
  ReviewDecision,
} from '../../dto/review-partner-profile.dto';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { PartnerFieldKeys } from '@/common/constants/partner-form-keys';

/**
 * Handler for reviewing partner profiles with transactional boundaries.
 * Extracted from AdminPartnersService per enterprise handler pattern (§5).
 *
 * Follows the domain handler pattern:
 * 1. Invariant Check — partner must be PENDING or REQUIRED_RESUBMIT
 * 2. Domain Action — process field/document reviews
 * 3. Persistence — update statuses and create review log
 * 4. Commit/Rollback with proper finally { release }
 */
@Injectable()
export class ReviewPartnerHandler {
  private readonly logger = new Logger(ReviewPartnerHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    partnerId: string,
    dto: ReviewPartnerProfileDto,
    adminId: string,
  ): Promise<void> {
    this.logger.log(`Reviewing partner: ${partnerId} by admin: ${adminId}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const manager = queryRunner.manager;

      // 1. Hydration + Invariant Check
      const partner = await manager.findOne(Partner, {
        where: { id: partnerId },
        relations: [
          'legalRepresentative',
          'province',
          'district',
          'ward',
          'account',
          'documents',
        ],
      });

      if (!partner) {
        throw new NotFoundException('Partner not found');
      }

      const reviewableStatuses = [
        PartnerVerificationStatus.PENDING,
        PartnerVerificationStatus.REQUIRED_RESUBMIT,
      ];
      if (!reviewableStatuses.includes(partner.verificationStatus)) {
        throw new BadRequestException(
          `Partner is not in a reviewable state (Current: ${partner.verificationStatus}). Cannot review.`,
        );
      }

      // 2. Fetch documents for snapshotting
      const existingDocs = await manager.find(PartnerDocument, {
        where: { partnerId },
      });
      const docMap = new Map(existingDocs.map((d) => [d.documentKey, d]));

      // 3. Process review items
      const fieldReviews: Record<string, any> = {};
      const documentReviews: Record<string, any> = {};
      const finalRejections: Record<string, string> = {};

      for (const item of dto.items ?? []) {
        if (item.fieldKey && this.isPartnerFieldKey(item.fieldKey)) {
          this.processFieldReviewItem(
            partner,
            item,
            fieldReviews,
            finalRejections,
          );
        } else if (item.fieldKey) {
          await this.processDocumentReviewItem(
            manager,
            item,
            docMap,
            documentReviews,
            finalRejections,
          );
        }
      }

      // 4. Determine verdict
      const hasErrors = Object.keys(finalRejections).length > 0;
      let verdict: PartnerVerificationStatus;

      if (dto.decision === ReviewDecision.REJECTED) {
        verdict = PartnerVerificationStatus.REJECTED;
        partner.verificationStatus = PartnerVerificationStatus.REJECTED;
      } else if (hasErrors) {
        verdict = PartnerVerificationStatus.REQUIRED_RESUBMIT;
        partner.verificationStatus =
          PartnerVerificationStatus.REQUIRED_RESUBMIT;
      } else if (dto.decision === ReviewDecision.APPROVED) {
        const requirements = await manager.find(DocumentRequirement, {
          where: { businessType: In(partner.businessType), isRequired: true },
        });

        if (existingDocs.length === 0 && requirements.length > 0) {
          throw new BadRequestException(
            'Cannot approve: Missing required documents',
          );
        }

        verdict = PartnerVerificationStatus.APPROVED;
        partner.verificationStatus = PartnerVerificationStatus.APPROVED;
        partner.verificationCompletedAt = new Date();
      } else {
        if (!dto.generalComment) {
          throw new BadRequestException(
            'Must specify rejection items or comment when requesting changes.',
          );
        }
        verdict = PartnerVerificationStatus.REQUIRED_RESUBMIT;
        partner.verificationStatus =
          PartnerVerificationStatus.REQUIRED_RESUBMIT;
      }

      await manager.save(partner);

      // 5. Create Review Log
      const reviewLog = manager.create(PartnerReviewLog, {
        partnerId,
        reviewerId: adminId,
        verdict,
        generalComment: dto.generalComment,
        fieldReviews:
          Object.keys(fieldReviews).length > 0 ? fieldReviews : null,
        documentReviews:
          Object.keys(documentReviews).length > 0 ? documentReviews : null,
      });
      await manager.save(reviewLog);

      // 6. Commit
      await queryRunner.commitTransaction();
      this.logger.log(`Partner ${partnerId} reviewed: ${verdict}`);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      if (
        error instanceof NotFoundException ||
        error instanceof BadRequestException
      ) {
        throw error;
      }
      this.logger.error(`Review failed: ${error.message}`, error.stack);
      throw new InternalServerErrorException(
        'Transaction failed during partner review',
      );
    } finally {
      await queryRunner.release();
    }
  }

  // ============================================================================
  // Private Helper Methods
  // ============================================================================

  private isPartnerFieldKey(value: string): boolean {
    const fieldKeyValues = Object.values(PartnerFieldKeys) as string[];
    return fieldKeyValues.includes(value);
  }

  private sanitizeRecordValue(value: any): any {
    if (value === null || value === undefined) return null;
    if (typeof value !== 'object' || value instanceof Date) return value;
    if (Array.isArray(value))
      return value.map((item) => this.sanitizeRecordValue(item));

    const {
      createdAt,
      created_at,
      deletedAt,
      deleted_at,
      updatedAt,
      updated_at,
      ...rest
    } = value;
    return rest;
  }

  private getFieldValue(partner: Partner, fieldKey: string): any {
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
      [PartnerFieldKeys.idType]: () =>
        partner.legalRepresentative?.idType ?? null,
      [PartnerFieldKeys.idNumber]: () =>
        partner.legalRepresentative?.idNumber ?? null,
      [PartnerFieldKeys.idIssueDate]: () =>
        partner.legalRepresentative?.idIssueDate ?? null,
      [PartnerFieldKeys.fullName]: () =>
        partner.legalRepresentative?.fullName ?? null,
      [PartnerFieldKeys.position]: () =>
        partner.legalRepresentative?.position ?? null,
    };

    const resolver = fieldResolvers[fieldKey];
    return resolver ? resolver() : ((partner as any)[fieldKey] ?? null);
  }

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

    await manager.update(
      PartnerDocument,
      { id: doc.id },
      { status: PartnerDocumentStatuses.REJECTED },
    );

    documentReviews[documentKey] = {
      documentType: doc.type,
      url: doc.fileUrl,
      feedback: item.feedback,
    };

    finalRejections[`document_${doc.documentKey}`] = item.feedback;
  }

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
}
