import {
  Injectable,
  Logger,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
  Inject,
  forwardRef,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { Partner } from '@/common/entities/partner.entity';
import { PartnerReviewLog } from '@/common/entities/partner-review-log.entity';
import { PartnerCertification } from '@/clinic/entities/partner-certification.entity';
import { RegisterPartnerDto } from './dto/request/register-partner.dto';
import { UpdatePartnerDto } from './dto/request/update-partner.dto';
import {
  UpdatePartnerProfileCompletionDto,
  UpdatePartnerCertificationDto,
} from './dto/request/update-partner-profile-completion.dto';
import { RegisterPartnerResponseDto } from './dto/response/register-partner-response.dto';
import {
  MyProfileResponseDto,
  FieldFeedbackMap,
} from './dto/response/my-profile-response.dto';
import { MyProfileCompletionResponseDto } from './dto/response/my-profile-completion-response.dto';
import { Role } from '@/account/enum/role.enum';
import { BusinessServicesResponseDto } from './dto/response/business-types-response.dto';
import { bussinessServices } from './enum/business-type.enum';
import { RegisterPartnerHandler } from './application/handlers/register-partner.handler';
import { UpdatePartnerProfileHandler } from './application/handlers/update-partner-profile.handler';
import { UpdatePartnerPublicProfileHandler } from './application/handlers/update-partner-public-profile.handler';
import { PartnerVerificationStatus } from './enum/partner-verification-status.enum';
import { PartnerPublicProfileResponseDto } from './dto/response/partner-public-profile-response.dto';
import { UpdatePartnerPublicProfileDto } from './dto/request/update-partner-public-profile.dto';

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
    @InjectRepository(PartnerCertification)
    private readonly certificationRepository: Repository<PartnerCertification>,
    private readonly registerPartnerHandler: RegisterPartnerHandler,
    private readonly updatePartnerProfileHandler: UpdatePartnerProfileHandler,
    private readonly updatePartnerPublicProfileHandler: UpdatePartnerPublicProfileHandler,
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

  async getMyProfileCompletion(
    accountId: string,
  ): Promise<MyProfileCompletionResponseDto> {
    this.logger.log(
      `Getting profile completion data for account: ${accountId}`,
    );
    const partner = await this.partnerRepository.findOne({
      where: { accountId },
      relations: ['province', 'district', 'ward'],
    });
    if (!partner) {
      this.logger.warn(`Partner not found for account: ${accountId}`);
      throw new NotFoundException('Partner not found');
    }

    this.ensureProfileCompletionAccess(partner);

    const certifications = await this.certificationRepository.find({
      where: { partnerId: partner.id },
      order: { sortOrder: 'ASC', createdAt: 'ASC' },
    });

    return MyProfileCompletionResponseDto.fromPartner(partner, certifications);
  }

  async updateMyProfileCompletion(
    accountId: string,
    dto: UpdatePartnerProfileCompletionDto,
  ): Promise<MyProfileCompletionResponseDto> {
    this.logger.log(`Updating profile completion for account: ${accountId}`);
    const partner = await this.partnerRepository.findOne({
      where: { accountId },
      relations: ['province', 'district', 'ward'],
    });
    if (!partner) {
      throw new NotFoundException('Partner not found');
    }

    this.ensureProfileCompletionAccess(partner);

    let partnerChanged = false;

    if (dto.coverImageUrl !== undefined) {
      partner.coverImageUrl = dto.coverImageUrl?.trim() || null;
      partnerChanged = true;
    }

    if (dto.logoImageUrl !== undefined) {
      partner.logoImageUrl = dto.logoImageUrl?.trim() || null;
      partnerChanged = true;
    }

    if (dto.description !== undefined) {
      partner.description = dto.description.trim() || null;
      partnerChanged = true;
    }

    if (dto.gallery !== undefined) {
      partner.gallery = dto.gallery.map((item) => item.trim()).filter(Boolean);
      partnerChanged = true;
    }

    if (partnerChanged) {
      await this.partnerRepository.save(partner);
    }

    if (dto.certifications !== undefined) {
      await this.syncPartnerCertifications(partner.id, dto.certifications);
    }

    return this.getMyProfileCompletion(accountId);
  }

  // ============================================================================
  // Public Profile — Post-Completion Edits
  // ============================================================================

  /**
   * Get the aggregate public profile for the edit page.
   * Loads partner with full relations and certifications.
   * Access gate: APPROVED + profile completed.
   */
  async getPartnerPublicProfile(
    accountId: string,
  ): Promise<PartnerPublicProfileResponseDto> {
    this.logger.log(`Getting public profile for account: ${accountId}`);

    const partner = await this.partnerRepository.findOne({
      where: { accountId },
      relations: [
        'province',
        'district',
        'ward',
        'legalRepresentative',
        'account',
      ],
    });
    if (!partner) {
      this.logger.warn(`Partner not found for account: ${accountId}`);
      throw new NotFoundException('Partner not found');
    }

    this.ensurePublicProfileAccess(partner);

    const certifications = await this.certificationRepository.find({
      where: { partnerId: partner.id },
      order: { sortOrder: 'ASC', createdAt: 'ASC' },
    });

    return PartnerPublicProfileResponseDto.fromPartner(partner, certifications);
  }

  /**
   * Update the partner's public-facing clinic profile (storefront only).
   * Delegates to UpdatePartnerPublicProfileHandler for transaction management.
   */
  async updatePartnerPublicProfile(
    accountId: string,
    dto: UpdatePartnerPublicProfileDto,
  ): Promise<PartnerPublicProfileResponseDto> {
    this.logger.log(`Updating public profile for account: ${accountId}`);
    await this.updatePartnerPublicProfileHandler.execute(accountId, dto);
    return this.getPartnerPublicProfile(accountId);
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

  isPartnerProfileCompleted(
    partner: Pick<
      Partner,
      'coverImageUrl' | 'logoImageUrl' | 'description' | 'gallery'
    >,
  ): boolean {
    const descriptionLength = partner.description?.trim().length ?? 0;
    return (
      Boolean(partner.coverImageUrl) &&
      Boolean(partner.logoImageUrl) &&
      descriptionLength >= 120 &&
      descriptionLength <= 1000_000_000 &&
      (partner.gallery?.length ?? 0) >= 3
    );
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

  private ensureProfileCompletionAccess(partner: Partner): void {
    if (partner.verificationStatus !== PartnerVerificationStatus.APPROVED) {
      throw new BadRequestException(
        'Profile completion is only available after partner verification is approved',
      );
    }
  }

  /**
   * Access gate for public profile endpoints.
   * Requires APPROVED status AND completed profile.
   */
  private ensurePublicProfileAccess(partner: Partner): void {
    if (partner.verificationStatus !== PartnerVerificationStatus.APPROVED) {
      throw new ForbiddenException(
        'Public profile editing is only available for approved partners',
      );
    }
    if (!this.isPartnerProfileCompleted(partner)) {
      throw new ForbiddenException(
        'Public profile editing is only available after profile completion',
      );
    }
  }

  private async syncPartnerCertifications(
    partnerId: string,
    certifications: UpdatePartnerCertificationDto[],
  ): Promise<void> {
    const existing = await this.certificationRepository.find({
      where: { partnerId },
    });
    const existingById = new Map(existing.map((item) => [item.id, item]));
    const retainedIds = new Set<string>();
    const entitiesToSave: PartnerCertification[] = [];

    for (const [index, certification] of certifications.entries()) {
      const hasContent =
        Boolean(certification.title?.trim()) ||
        Boolean(certification.subtitle?.trim());
      if (!hasContent) {
        continue;
      }

      const entity =
        (certification.id ? existingById.get(certification.id) : undefined) ??
        this.certificationRepository.create({ partnerId });

      entity.partnerId = partnerId;
      entity.title = certification.title?.trim() ?? entity.title;
      entity.subtitle = certification.subtitle?.trim() || null;
      entity.iconName = certification.iconName?.trim() || 'workspace_premium';
      entity.sortOrder = certification.sortOrder ?? index;
      entitiesToSave.push(entity);
      if (entity.id) {
        retainedIds.add(entity.id);
      }
    }

    if (entitiesToSave.length > 0) {
      const saved = await this.certificationRepository.save(entitiesToSave);
      saved.forEach((entity) => retainedIds.add(entity.id));
    }

    const toDelete = existing
      .filter((entity) => !retainedIds.has(entity.id))
      .map((entity) => entity.id);

    if (toDelete.length > 0) {
      await this.certificationRepository.delete(toDelete);
    }
  }
}
