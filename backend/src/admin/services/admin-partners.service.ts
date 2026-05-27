import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, SelectQueryBuilder } from 'typeorm';
import { Partner } from '@/common/entities/partner.entity';
import { PartnerReviewLog } from '@/common/entities/partner-review-log.entity';
import { AdminPartnerDetailResponseDto } from '../dto/admin-partner-detail-response.dto';
import { PartnerPriority } from '../dto/admin-partner-detail-response.dto';
import { ReviewPartnerProfileDto } from '../dto/review-partner-profile.dto';
import { ReviewPartnerResponseDto } from '../dto/review-partner-response.dto';
import { TotalPartnersResponseDto } from '../dto/total-partners-response.dto';
import {
  AdminPartnersQueryDto,
  AdminPartnerScope,
  AdminPartnerSortBy,
  AdminPartnerSortDirection,
} from '../dto/admin-partners-query.dto';
import { AdminPartnersResponseDto } from '../dto/admin-partner-list-response.dto';
import { AdminPartnerStatsResponseDto } from '../dto/admin-partner-stats-response.dto';
import { ReviewPartnerHandler } from '../application/handlers/review-partner.handler';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';

// Helper type for field review data
export interface FieldFeedback {
  isVerified: boolean;
  feedback?: string;
}

export type FieldFeedbackMap = Record<string, FieldFeedback>;

/** Statuses considered part of the review queue */
const REVIEW_QUEUE_STATUSES: PartnerVerificationStatus[] = [
  PartnerVerificationStatus.PENDING,
  PartnerVerificationStatus.REQUIRED_RESUBMIT,
];

/** Priority age thresholds in hours */
const URGENT_THRESHOLD_HOURS = 72;
const HIGH_THRESHOLD_HOURS = 24;

/**
 * Service facade for admin partner management.
 * Delegates mutation operations to dedicated handlers.
 * Handles read operations directly via repositories.
 */
@Injectable()
export class AdminPartnersService {
  private readonly logger = new Logger(AdminPartnersService.name);

  constructor(
    @InjectRepository(Partner)
    private readonly partnerRepo: Repository<Partner>,
    @InjectRepository(PartnerReviewLog)
    private readonly reviewLogRepo: Repository<PartnerReviewLog>,
    private readonly reviewPartnerHandler: ReviewPartnerHandler,
  ) {}

  // ==========================================================================
  // READ OPERATIONS
  // ==========================================================================

  /**
   * List partners with scope, search, status,
   * and sort filters.
   */
  async getPartners(
    query: AdminPartnersQueryDto,
  ): Promise<AdminPartnersResponseDto> {
    this.logger.log('Listing partners with filters');
    const { page = 1, limit = 10 } = query;
    const skip = (page - 1) * limit;

    const qb = this.buildBaseQuery();
    this.applyScope(qb, query.scope);
    this.applySearch(qb, query.search);
    this.applyStatus(qb, query.verificationStatus);
    this.applySort(qb, query.sortBy, query.sortDirection);

    const [data, total] = await qb.skip(skip).take(limit).getManyAndCount();

    const now = new Date();

    return {
      data: data.map((p) => ({
        id: p.id,
        taxCode: p.taxCode,
        legalName: p.legalName,
        brandName: p.brandName,
        email: p.account?.email ?? '',
        businessType: p.businessType ?? [],
        verificationStatus:
          p.verificationStatus ?? PartnerVerificationStatus.PENDING,
        priority: this.computePriority(p, now),
        createdAt: p.createdAt,
        verificationCompletedAt: p.verificationCompletedAt ?? null,
        isAccountActive: p.account?.isActive ?? false,
      })),
      total,
      page,
      limit,
    };
  }

  /**
   * Get filtered total partner count.
   */
  async getTotalPartners(
    query?: AdminPartnersQueryDto,
  ): Promise<TotalPartnersResponseDto> {
    const qb = this.buildBaseQuery();
    if (query) {
      this.applyScope(qb, query.scope);
      this.applySearch(qb, query.search);
      this.applyStatus(qb, query.verificationStatus);
    }
    const total = await qb.getCount();
    const response = new TotalPartnersResponseDto();
    response.total = total;
    return response;
  }

  /**
   * Get KPI stats for the partner manager dashboard.
   */
  async getPartnerStats(
    query?: AdminPartnersQueryDto,
  ): Promise<AdminPartnerStatsResponseDto> {
    const dto = new AdminPartnerStatsResponseDto();

    // Count by status
    const statusCounts = await this.partnerRepo
      .createQueryBuilder('partner')
      .select('partner.verificationStatus', 'status')
      .addSelect('COUNT(*)', 'count')
      .groupBy('partner.verificationStatus')
      .getRawMany<{
        status: PartnerVerificationStatus;
        count: string;
      }>();

    const countMap = new Map<string, number>();
    for (const row of statusCounts) {
      countMap.set(row.status, parseInt(row.count, 10));
    }

    dto.pendingReview =
      (countMap.get(PartnerVerificationStatus.PENDING) ?? 0) +
      (countMap.get(PartnerVerificationStatus.REQUIRED_RESUBMIT) ?? 0);
    dto.requiredResubmit =
      countMap.get(PartnerVerificationStatus.REQUIRED_RESUBMIT) ?? 0;
    dto.approved = countMap.get(PartnerVerificationStatus.APPROVED) ?? 0;
    dto.rejected = countMap.get(PartnerVerificationStatus.REJECTED) ?? 0;
    dto.activeToday = dto.approved;
    dto.totalProviders = Array.from(countMap.values()).reduce(
      (a, b) => a + b,
      0,
    );

    // High priority count
    const now = new Date();
    const highThreshold = new Date(
      now.getTime() - HIGH_THRESHOLD_HOURS * 3600_000,
    );

    const highPriorityCount = await this.partnerRepo
      .createQueryBuilder('partner')
      .where('partner.verificationStatus IN (:...statuses)', {
        statuses: REVIEW_QUEUE_STATUSES,
      })
      .andWhere('partner.createdAt <= :threshold', {
        threshold: highThreshold,
      })
      .getCount();

    dto.highPriority = highPriorityCount;

    // Average wait time
    const avgResult = await this.partnerRepo
      .createQueryBuilder('partner')
      .select(
        'AVG(EXTRACT(EPOCH FROM (NOW() - partner.createdAt)))',
        'avgSeconds',
      )
      .where('partner.verificationStatus IN (:...statuses)', {
        statuses: REVIEW_QUEUE_STATUSES,
      })
      .getRawOne<{ avgSeconds: string | null }>();

    const avgSeconds = avgResult?.avgSeconds
      ? Math.round(parseFloat(avgResult.avgSeconds))
      : 0;

    dto.avgWaitSeconds = avgSeconds;
    dto.avgWaitTime = this.formatWaitTime(avgSeconds);

    return dto;
  }

  /**
   * Get detailed partner information with
   * verification feedback.
   */
  async getPartnerDetail(id: string): Promise<AdminPartnerDetailResponseDto> {
    const partner = await this.partnerRepo.findOne({
      where: { id },
      relations: [
        'account',
        'province',
        'district',
        'ward',
        'legalRepresentative',
        'documents',
      ],
    });

    if (!partner) {
      throw new NotFoundException('Partner not found');
    }

    // Fetch the latest review log for feedback data
    const latestReviewLog = await this.reviewLogRepo.findOne({
      where: { partnerId: id },
      order: { createdAt: 'DESC' },
    });

    // Build feedback maps from review log
    const fieldFeedbackMap = this.buildFieldFeedbackMap(latestReviewLog);
    const documentFeedbackMap = this.buildDocumentFeedbackMap(latestReviewLog);

    return AdminPartnerDetailResponseDto.fromPartner(
      partner,
      fieldFeedbackMap,
      documentFeedbackMap,
    );
  }

  // ==========================================================================
  // MUTATION OPERATIONS
  // ==========================================================================

  /**
   * Facade: Delegates to ReviewPartnerHandler.
   * Returns ReviewPartnerResponseDto for controller.
   */
  async reviewPartner(
    id: string,
    dto: ReviewPartnerProfileDto,
    adminId: string,
  ): Promise<ReviewPartnerResponseDto> {
    await this.reviewPartnerHandler.execute(id, dto, adminId);
    const response = new ReviewPartnerResponseDto();
    response.message = 'Review submitted successfully';
    return response;
  }

  // ==========================================================================
  // QUERY BUILDER HELPERS
  // ==========================================================================

  /** Creates the base query with account join. */
  private buildBaseQuery(): SelectQueryBuilder<Partner> {
    return this.partnerRepo
      .createQueryBuilder('partner')
      .leftJoinAndSelect('partner.account', 'account')
      .select([
        'partner.id',
        'partner.taxCode',
        'partner.legalName',
        'partner.brandName',
        'partner.businessType',
        'partner.verificationStatus',
        'partner.verificationCompletedAt',
        'partner.createdAt',
        'account.email',
        'account.isActive',
      ]);
  }

  /** Applies tab scope filter. */
  private applyScope(
    qb: SelectQueryBuilder<Partner>,
    scope?: AdminPartnerScope,
  ): void {
    if (scope === AdminPartnerScope.VERIFICATION_QUEUE) {
      qb.andWhere('partner.verificationStatus IN (:...statuses)', {
        statuses: REVIEW_QUEUE_STATUSES,
      });
    }
    // ALL_PROVIDERS → no status filter from scope
  }

  /** Applies free-text search across key fields. */
  private applySearch(qb: SelectQueryBuilder<Partner>, search?: string): void {
    if (!search) return;
    qb.andWhere(
      '(partner.taxCode ILIKE :search ' +
        'OR partner.brandName ILIKE :search ' +
        'OR partner.legalName ILIKE :search ' +
        'OR account.email ILIKE :search)',
      { search: `%${search}%` },
    );
  }

  /** Applies explicit status filter. */
  private applyStatus(
    qb: SelectQueryBuilder<Partner>,
    status?: PartnerVerificationStatus,
  ): void {
    if (!status) return;
    qb.andWhere('partner.verificationStatus = :status', { status });
  }

  /** Applies sorting; defaults to createdAt DESC. */
  private applySort(
    qb: SelectQueryBuilder<Partner>,
    sortBy?: AdminPartnerSortBy,
    direction?: AdminPartnerSortDirection,
  ): void {
    const dir = direction === AdminPartnerSortDirection.ASC ? 'ASC' : 'DESC';

    switch (sortBy) {
      case AdminPartnerSortBy.BRAND_NAME:
        qb.orderBy('partner.brandName', dir);
        break;
      case AdminPartnerSortBy.LEGAL_NAME:
        qb.orderBy('partner.legalName', dir);
        break;
      case AdminPartnerSortBy.VERIFICATION_STATUS:
        qb.orderBy('partner.verificationStatus', dir);
        break;
      default:
        qb.orderBy('partner.createdAt', dir);
    }
  }

  // ==========================================================================
  // PRIORITY HELPERS
  // ==========================================================================

  /**
   * Computes priority based on age of the
   * verification request.
   */
  private computePriority(partner: Partner, now: Date): PartnerPriority {
    const status =
      partner.verificationStatus ?? PartnerVerificationStatus.PENDING;

    if (!REVIEW_QUEUE_STATUSES.includes(status)) {
      return PartnerPriority.NORMAL;
    }

    const ageHours = (now.getTime() - partner.createdAt.getTime()) / 3_600_000;

    if (ageHours >= URGENT_THRESHOLD_HOURS) {
      return PartnerPriority.URGENT;
    }
    if (ageHours >= HIGH_THRESHOLD_HOURS) {
      return PartnerPriority.HIGH;
    }
    return PartnerPriority.NORMAL;
  }

  /**
   * Formats seconds into a compact label like
   * "4h 12m" or "2d 5h".
   */
  private formatWaitTime(totalSeconds: number): string {
    if (totalSeconds <= 0) return '0m';

    const days = Math.floor(totalSeconds / 86400);
    const hours = Math.floor((totalSeconds % 86400) / 3600);
    const minutes = Math.floor((totalSeconds % 3600) / 60);

    if (days > 0) return `${days}d ${hours}h`;
    if (hours > 0) return `${hours}h ${minutes}m`;
    return `${minutes}m`;
  }

  // ==========================================================================
  // FEEDBACK MAP BUILDERS
  // ==========================================================================

  private buildFieldFeedbackMap(
    reviewLog: PartnerReviewLog | null,
  ): FieldFeedbackMap {
    const feedbackMap: FieldFeedbackMap = {};
    if (!reviewLog?.fieldReviews) return feedbackMap;

    for (const [fieldName, review] of Object.entries(reviewLog.fieldReviews)) {
      feedbackMap[fieldName] = {
        isVerified: review.isValid,
        feedback: review.feedback,
      };
    }
    return feedbackMap;
  }

  private buildDocumentFeedbackMap(
    reviewLog: PartnerReviewLog | null,
  ): FieldFeedbackMap {
    const feedbackMap: FieldFeedbackMap = {};
    if (!reviewLog?.documentReviews) return feedbackMap;

    for (const [docId, review] of Object.entries(reviewLog.documentReviews)) {
      feedbackMap[docId] = {
        isVerified: review.isValid,
        feedback: review.feedback,
      };
    }
    return feedbackMap;
  }
}
