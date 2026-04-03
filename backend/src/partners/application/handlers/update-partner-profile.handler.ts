import {
  Injectable,
  Logger,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Partner } from '@/common/entities/partner.entity';
import { LegalRepresentative } from '@/common/entities/legal-representative.entity';
import {
  PartnerDocument,
  PartnerDocumentStatuses,
  DocumentFileTypes,
  DocumentTypes,
} from '@/common/entities/partner-document.entity';
import { UpdatePartnerDto } from '../../dto/request/update-partner.dto';
import { PartnerVerificationStatus } from '../../enum/partner-verification-status.enum';
import { LocationsService } from '@/locations/locations.service';

/**
 * Handler for updating partner's own profile (resubmission flow).
 * Follows the domain handler pattern with transactional boundaries.
 *
 * Flow:
 * 1. Invariant check: status must be REQUIRED_RESUBMIT
 * 2. Process business info, legal representative, KYC documents
 * 3. Recalculate status → set to PENDING
 * 4. Commit
 */
@Injectable()
export class UpdatePartnerProfileHandler {
  private readonly logger = new Logger(UpdatePartnerProfileHandler.name);

  constructor(
    private readonly dataSource: DataSource,
    private readonly locationsService: LocationsService,
  ) {}

  async execute(partner: Partner, dto: UpdatePartnerDto): Promise<void> {
    this.logger.log(`Updating partner profile: ${partner.id}`);

    // 1. Invariant Check
    if (
      partner.verificationStatus !== PartnerVerificationStatus.REQUIRED_RESUBMIT
    ) {
      throw new BadRequestException(
        'Profile can only be updated when verification status is REQUIRED_RESUBMIT',
      );
    }

    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      let isModified = false;
      let hasCriticalChange = false;

      // Helper function to extract value from UpdatedField wrapper OR direct value.
      const getValue = <T>(
        field: { fieldKey: string; value: T } | T | null | undefined,
      ): T | undefined => {
        if (field === null || field === undefined) return undefined;
        if (
          typeof field === 'object' &&
          'value' in (field as object) &&
          'fieldKey' in (field as object)
        ) {
          const extracted = (field as { fieldKey: string; value: T }).value;
          return extracted === null ? undefined : extracted;
        }
        return field as T;
      };

      // --- A. PROCESS BUSINESS INFO ---
      if (dto.bussinessInfo) {
        const bizInfo = dto.bussinessInfo;

        // A.1 Check for duplicate TaxCode
        const newTaxCode = getValue(bizInfo.taxRegistrationCode);
        if (newTaxCode && newTaxCode !== partner.taxCode) {
          const existing = await queryRunner.manager.findOne(Partner, {
            where: { taxCode: newTaxCode },
          });
          if (existing)
            throw new BadRequestException('Tax code already exists');
          partner.taxCode = newTaxCode;
          isModified = true;
          hasCriticalChange = true;
        }

        // A.2 Update brand name
        const newBrandName = getValue(bizInfo.brandName);
        if (newBrandName !== undefined && newBrandName !== partner.brandName) {
          partner.brandName = newBrandName;
          isModified = true;
        }

        // A.3 Update phone number
        const newPhoneNumber = getValue(bizInfo.phoneNumber);
        if (
          newPhoneNumber !== undefined &&
          newPhoneNumber !== partner.phoneNumber
        ) {
          partner.phoneNumber = newPhoneNumber;
          isModified = true;
        }

        // A.4 Update address
        if (bizInfo.address) {
          const addressDto = bizInfo.address;

          const newStreetAddress = getValue(addressDto.streetAddress);
          const newCity = getValue(addressDto.city);
          const newDistrict = getValue(addressDto.district);
          const newWard = getValue(addressDto.ward);

          if (
            newStreetAddress !== undefined &&
            newStreetAddress !== partner.streetAddress
          ) {
            partner.streetAddress = newStreetAddress;
            isModified = true;
            hasCriticalChange = true;
          }

          const newProvinceId = newCity?.id || partner.provinceId;
          const newDistrictId = newDistrict?.id || partner.districtId;
          const newWardId = newWard?.id || partner.wardId;

          if (newProvinceId && newDistrictId && newWardId) {
            const isAddressChanged =
              newProvinceId !== partner.provinceId ||
              newDistrictId !== partner.districtId ||
              newWardId !== partner.wardId;

            if (isAddressChanged) {
              await this.locationsService.validateAddress(
                newProvinceId,
                newDistrictId,
                newWardId,
              );
              partner.provinceId = newProvinceId;
              partner.districtId = newDistrictId;
              partner.wardId = newWardId;
              isModified = true;
              hasCriticalChange = true;
            }
          }
        }
      }

      // --- B. UPDATE LEGAL REPRESENTATIVE ---
      if (dto.legalRepresentative) {
        const legalRep = await queryRunner.manager.findOne(
          LegalRepresentative,
          {
            where: { partnerId: partner.id },
          },
        );
        if (legalRep) {
          let repModified = false;
          const repDto = dto.legalRepresentative;

          const updateRepField = <T>(
            field: keyof LegalRepresentative,
            updatedField: { fieldKey: string; value: T } | T | null | undefined,
            isCritical: boolean,
          ) => {
            const newValue = getValue(updatedField);
            if (newValue !== undefined && newValue !== legalRep[field]) {
              (legalRep as any)[field] = newValue;
              repModified = true;
              if (isCritical) hasCriticalChange = true;
            }
          };

          updateRepField('fullName', repDto.fullName, true);
          updateRepField('idNumber', repDto.idNumber, true);
          updateRepField('idType', repDto.idType, true);
          updateRepField('phoneNumber', repDto.phoneNumber, false);
          updateRepField('position', repDto.position, false);

          const newIdIssueDate = getValue(repDto.idIssueDate);
          if (newIdIssueDate) {
            const newDate = new Date(newIdIssueDate);
            const currentIssueDate = new Date(legalRep.idIssueDate);
            if (newDate.getTime() !== currentIssueDate.getTime()) {
              legalRep.idIssueDate = newDate;
              repModified = true;
              hasCriticalChange = true;
            }
          }

          if (repModified) {
            await queryRunner.manager.save(legalRep);
            isModified = true;
          }
        }
      }

      // --- C. UPDATE KYC DOCUMENTS ---
      if (dto.kycDocuments && dto.kycDocuments.length > 0) {
        for (const docUpdate of dto.kycDocuments) {
          if (docUpdate?.fileUrl) {
            const documentKey = docUpdate.fileType || 'OTHER_DOCUMENTS';

            const existingDoc = await queryRunner.manager.findOne(
              PartnerDocument,
              {
                where: { partnerId: partner.id, documentKey },
              },
            );

            if (existingDoc) {
              existingDoc.fileUrl = docUpdate.fileUrl;
              existingDoc.status = PartnerDocumentStatuses.ACCEPTED;
              await queryRunner.manager.save(existingDoc);
              isModified = true;
            } else {
              const newDoc = queryRunner.manager.create(PartnerDocument, {
                partnerId: partner.id,
                fileUrl: docUpdate.fileUrl,
                fileType: DocumentFileTypes.IMAGE,
                documentKey,
                type: DocumentTypes.OTHER_DOCUMENTS,
                status: PartnerDocumentStatuses.ACCEPTED,
              });
              await queryRunner.manager.save(newDoc);
              isModified = true;
            }
          }
        }
      }

      // --- D. RECALCULATE STATUS ---
      if (isModified) {
        partner.verificationStatus = PartnerVerificationStatus.PENDING;
        partner.verificationCompletedAt = null;

        const { documents, legalRepresentative, ...updateData } = partner;
        await queryRunner.manager.update(Partner, partner.id, updateData);
      }

      await queryRunner.commitTransaction();
      this.logger.log(`Partner profile updated: ${partner.id}`);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Partner profile update failed: ${error.message}`,
        error.stack,
      );
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
