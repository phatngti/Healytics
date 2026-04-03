import {
  Injectable,
  Logger,
  NotFoundException,
  Inject,
  forwardRef,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { Partner } from '@/common/entities/partner.entity';
import { PartnerReviewLog } from '@/common/entities/partner-review-log.entity';
import { RegisterPartnerDto } from './dto/request/register-partner.dto';
import { UpdatePartnerDto } from './dto/request/update-partner.dto';
import { RegisterPartnerResponseDto } from './dto/response/register-partner-response.dto';
import {
  MyProfileResponseDto,
  FieldFeedbackMap,
} from './dto/response/my-profile-response.dto';
import { Role } from '@/account/enum/role.enum';
import { BusinessServicesResponseDto } from './dto/response/business-types-response.dto';
import { bussinessServices } from './enum/business-type.enum';
import { RegisterPartnerHandler } from './application/handlers/register-partner.handler';
import { UpdatePartnerProfileHandler } from './application/handlers/update-partner-profile.handler';

@Injectable()
export class PartnersService {
  private readonly logger = new Logger(PartnersService.name);

  constructor(
    @InjectRepository(Account)
    private readonly accountRepository: Repository<Account>,
    @InjectRepository(Partner)
    private readonly partnerRepository: Repository<Partner>,
    @InjectRepository(PartnerReviewLog)
    private readonly reviewLogRepository: Repository<PartnerReviewLog>,
    private readonly registerPartnerHandler: RegisterPartnerHandler,
    private readonly updatePartnerProfileHandler: UpdatePartnerProfileHandler,
  ) {}

  // ============================================================================
  // Public Queries
  // ============================================================================

  /**
   * Get all available business types with Vietnamese labels
   */
  getBusinessServices(): BusinessServicesResponseDto {
    this.logger.log('Getting business services');
    return {
      data: Array.from(bussinessServices.values()),
    };
  }

  // ============================================================================
  // Mutations — delegated to handlers
  // ============================================================================

  /**
   * Registers a new partner (account + partner + legal rep + documents).
   * Delegates to RegisterPartnerHandler for transaction management.
   */
  async registerPartner(
    dto: RegisterPartnerDto,
  ): Promise<RegisterPartnerResponseDto> {
    this.logger.log(`Registering partner: ${dto.account.email}`);
    return this.registerPartnerHandler.execute(dto);
  }

  /**
   * Updates partner's own profile with "Smart Update" logic.
   * Delegates to UpdatePartnerProfileHandler for transaction management.
   */
  async updateMyProfile(
    accountId: string,
    dto: UpdatePartnerDto,
  ): Promise<MyProfileResponseDto> {
    this.logger.log(`Updating profile for account: ${accountId}`);
    const partner = await this.getPartnerByAccountId(accountId);
    if (!partner) throw new NotFoundException('Partner not found');

    await this.updatePartnerProfileHandler.execute(partner, dto);
    return this.getMyProfile(accountId); // Return latest data
  }

  // ============================================================================
  // Queries
  // ============================================================================

  /**
   * Get partner's own profile with verification fields
   */
  async getMyProfile(accountId: string): Promise<MyProfileResponseDto> {
    this.logger.log(`Getting profile for account: ${accountId}`);
    const partner = await this.partnerRepository.findOne({
      where: { accountId },
      relations: [
        'province',
        'district',
        'ward',
        'legalRepresentative',
        'documents',
        'account',
      ],
    });
    if (!partner) {
      this.logger.warn(`Partner not found for account: ${accountId}`);
      throw new NotFoundException('Partner not found');
    }

    const latestReviewLog = await this.reviewLogRepository.findOne({
      where: { partnerId: partner.id },
      order: { createdAt: 'DESC' },
    });

    const fieldFeedbackMap = this.buildFieldFeedbackMap(latestReviewLog);
    const documentFeedbackMap = this.buildDocumentFeedbackMap(latestReviewLog);

    return MyProfileResponseDto.fromPartner(
      partner,
      fieldFeedbackMap,
      documentFeedbackMap,
    );
  }

  async getPartnerProfile(userId: string): Promise<Partner> {
    this.logger.log(`Getting partner profile for user: ${userId}`);
    const partner = await this.partnerRepository.findOne({
      where: { accountId: userId },
    });
    if (!partner) {
      this.logger.warn(`Partner profile not found for user: ${userId}`);
      throw new NotFoundException('Partner profile not found');
    }
    return partner;
  }

  async getPartnerByAccountId(accountId: string): Promise<Partner | null> {
    return this.partnerRepository.findOne({
      where: { accountId },
      relations: [
        'province',
        'district',
        'ward',
        'legalRepresentative',
        'documents',
      ],
    });
  }

  /**
   * Returns a partner profile by its primary key,
   * with location relations loaded.
   */
  async findOneById(id: string): Promise<Partner | null> {
    return this.partnerRepository.findOne({
      where: { id },
      relations: ['province', 'district', 'ward'],
    });
  }

  /**
   * Returns the first health partner profile with location relations.
   * Used to populate clinic/location info on public product detail screens.
   */
  async getFirstHealthPartner(): Promise<Partner | null> {
    const account = await this.accountRepository.findOne({
      where: { role: Role.HEALTH_PARTNER },
    });
    if (!account) return null;

    return this.partnerRepository.findOne({
      where: { accountId: account.id },
      relations: ['province', 'district', 'ward'],
    });
  }

  // ============================================================================
  // Helper Methods for Review Log Feedback
  // ============================================================================

  private buildFieldFeedbackMap(
    reviewLog: PartnerReviewLog | null,
  ): FieldFeedbackMap {
    const feedbackMap: FieldFeedbackMap = {};
    if (!reviewLog?.fieldReviews) return feedbackMap;

    for (const [fieldName, review] of Object.entries(reviewLog.fieldReviews)) {
      feedbackMap[fieldName] = { feedback: review.feedback };
    }
    return feedbackMap;
  }

  private buildDocumentFeedbackMap(
    reviewLog: PartnerReviewLog | null,
  ): FieldFeedbackMap {
    const feedbackMap: FieldFeedbackMap = {};
    if (!reviewLog?.documentReviews) return feedbackMap;

    for (const [docId, review] of Object.entries(reviewLog.documentReviews)) {
      feedbackMap[docId] = { feedback: review.feedback };
    }
    return feedbackMap;
  }
}
