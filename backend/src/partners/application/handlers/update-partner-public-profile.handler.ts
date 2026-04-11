import {
  Injectable,
  Logger,
  NotFoundException,
  ForbiddenException,
  Inject,
  forwardRef,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Partner } from '@/common/entities/partner.entity';
import { PartnerCertification } from '@/clinic/entities/partner-certification.entity';
import { UpdatePartnerPublicProfileDto } from '../../dto/request/update-partner-public-profile.dto';
import { UpdatePartnerCertificationDto } from '../../dto/request/update-partner-profile-completion.dto';
import { PartnerVerificationStatus } from '../../enum/partner-verification-status.enum';
import { PartnersService } from '../../partners.service';

/**
 * Handler for updating the partner's public-facing clinic profile.
 *
 * Only storefront fields (coverImage, logo, description, gallery,
 * certifications) are editable. Admin-verified business data is
 * never mutated here.
 *
 * Flow:
 * 1. Transaction Start
 * 2. Invariant Check — APPROVED + profile completed
 * 3. Apply Storefront Updates
 * 4. Sync Certifications
 * 5. Persist & Commit (no verification status change)
 */
@Injectable()
export class UpdatePartnerPublicProfileHandler {
  private readonly logger = new Logger(UpdatePartnerPublicProfileHandler.name);

  constructor(
    private readonly dataSource: DataSource,
    @Inject(forwardRef(() => PartnersService))
    private readonly partnersService: PartnersService,
  ) {}

  async execute(
    accountId: string,
    dto: UpdatePartnerPublicProfileDto,
  ): Promise<void> {
    this.logger.log(
      `Updating public profile for account: ${accountId}`,
    );

    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Load partner
      const partner = await queryRunner.manager.findOne(Partner, {
        where: { accountId },
        relations: ['province', 'district', 'ward'],
      });

      if (!partner) {
        throw new NotFoundException('Partner not found');
      }

      // 2. Invariant Check — must be APPROVED + profile completed
      if (partner.verificationStatus !== PartnerVerificationStatus.APPROVED) {
        throw new ForbiddenException(
          'Public profile editing is only available for approved partners',
        );
      }

      if (!this.partnersService.isPartnerProfileCompleted(partner)) {
        throw new ForbiddenException(
          'Public profile editing is only available after profile completion',
        );
      }

      // 3. Apply Storefront Updates
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
        partner.gallery = dto.gallery
          .map((item) => item.trim())
          .filter(Boolean);
        partnerChanged = true;
      }

      if (partnerChanged) {
        await queryRunner.manager.save(Partner, partner);
      }

      // 4. Sync Certifications (within same transaction)
      if (dto.certifications !== undefined) {
        await this.syncCertifications(
          queryRunner.manager,
          partner.id,
          dto.certifications,
        );
      }

      // 5. Commit — no verification status change
      await queryRunner.commitTransaction();
      this.logger.log(
        `Public profile updated for account: ${accountId}`,
      );
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Public profile update failed: ${error.message}`,
        error.stack,
      );
      // Re-throw domain exceptions as-is
      if (
        error instanceof NotFoundException ||
        error instanceof ForbiddenException
      ) {
        throw error;
      }
      throw error;
    } finally {
      await queryRunner.release();
    }
  }

  /**
   * Sync certifications: create, update, and delete within the transaction.
   * Mirrors the logic from PartnersService.syncPartnerCertifications
   * but uses the transactional EntityManager.
   */
  private async syncCertifications(
    manager: import('typeorm').EntityManager,
    partnerId: string,
    certifications: UpdatePartnerCertificationDto[],
  ): Promise<void> {
    const existing = await manager.find(PartnerCertification, {
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
        (certification.id
          ? existingById.get(certification.id)
          : undefined) ??
        manager.create(PartnerCertification, { partnerId });

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
      const saved = await manager.save(PartnerCertification, entitiesToSave);
      saved.forEach((entity) => retainedIds.add(entity.id));
    }

    const toDelete = existing
      .filter((entity) => !retainedIds.has(entity.id))
      .map((entity) => entity.id);

    if (toDelete.length > 0) {
      await manager.delete(PartnerCertification, toDelete);
    }
  }
}
