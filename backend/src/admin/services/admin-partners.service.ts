import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Partner } from '@/common/entities/partner.entity';
import { PartnerReviewLog } from '@/common/entities/partner-review-log.entity';
import { AdminPartnerDetailResponseDto } from '../dto/admin-partner-detail-response.dto';
import { ReviewPartnerProfileDto } from '../dto/review-partner-profile.dto';
import { ReviewPartnerResponseDto } from '../dto/review-partner-response.dto';
import { TotalPartnersResponseDto } from '../dto/total-partners-response.dto';
import { PartnersResponseDto } from '@/partners/dto/response/partners-response.dto';
import { GetPartnersQueryDto } from '@/partners/dto/request/get-partners-query.dto';
import { ReviewPartnerHandler } from '../application/handlers/review-partner.handler';

// Helper type for field review data
export interface FieldFeedback {
  isVerified: boolean;
  feedback?: string;
}

export type FieldFeedbackMap = Record<string, FieldFeedback>;

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

  /**
   * Get detailed partner information with verification feedback.
   */
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

    // Build feedback maps from review log
    const fieldFeedbackMap = this.buildFieldFeedbackMap(latestReviewLog);
    const documentFeedbackMap = this.buildDocumentFeedbackMap(latestReviewLog);

    return AdminPartnerDetailResponseDto.fromPartner(partner, fieldFeedbackMap, documentFeedbackMap);
  }

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

  /**
   * List partners with query filters.
   */
  async getPartners(query: GetPartnersQueryDto): Promise<PartnersResponseDto> {
    this.logger.log('Listing partners with filters');
    const { page = 1, limit = 10, verificationStatus, search } = query;
    const skip = (page - 1) * limit;

    const queryBuilder = this.partnerRepo
      .createQueryBuilder('partner')
      .leftJoinAndSelect('partner.account', 'account')
      .select([
        'partner.id',
        'partner.taxCode',
        'partner.legalName',
        'partner.brandName',
        'partner.businessType',
        'partner.verificationStatus',
        'partner.createdAt',
        'account.email',
      ]);

    if (verificationStatus) {
      queryBuilder.andWhere(
        'partner.verificationStatus = :verificationStatus',
        { verificationStatus },
      );
    }

    if (search) {
      queryBuilder.andWhere(
        '(partner.taxCode ILIKE :search OR partner.brandName ILIKE :search OR partner.legalName ILIKE :search OR account.email ILIKE :search)',
        { search: `%${search}%` },
      );
    }

    const [data, total] = await queryBuilder
      .orderBy('partner.createdAt', 'DESC')
      .skip(skip)
      .take(limit)
      .getManyAndCount();

    return {
      data: data.map((b) => ({
        id: b.id,
        taxCode: b.taxCode,
        legalName: b.legalName,
        brandName: b.brandName,
        email: b.account.email,
        businessType: b.businessType,
        verificationStatus: b.verificationStatus,
        createdAt: b.createdAt,
      })),
      total,
      page,
      limit,
    };
  }

  /**
   * Get total partner count.
   */
  async getTotalPartners(): Promise<TotalPartnersResponseDto> {
    const total = await this.partnerRepo.count();
    const response = new TotalPartnersResponseDto();
    response.total = total;
    return response;
  }

  // ============================================================================
  // Private Helper Methods
  // ============================================================================

  private buildFieldFeedbackMap(reviewLog: PartnerReviewLog | null): FieldFeedbackMap {
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

  private buildDocumentFeedbackMap(reviewLog: PartnerReviewLog | null): FieldFeedbackMap {
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
