import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { Partner } from '@/common/entities/partner.entity';
import { LegalRepresentative } from '@/common/entities/legal-representative.entity';
import { PartnerDocument } from '@/common/entities/partner-document.entity';
import { PartnerFieldKeys } from '@/common/constants/partner-form-keys';
import { BusinessType } from '@/partners/enum/business-type.enum';

// ============================================================================
// Field Feedback Types
// ============================================================================

export interface FieldFeedback {
  feedback?: string;
}

export type FieldFeedbackMap = Record<string, FieldFeedback>;

// ============================================================================
// Verified Field Generic Type (for field-level verification audit)
// ============================================================================

export class VerifiedField<T> {
  @ApiProperty({ type: String })
  fieldKey: string;

  @ApiProperty()
  value: T;

  @ApiProperty({ type: Boolean, example: false })
  isVerified: boolean;

  @ApiPropertyOptional({ type: String })
  feedback?: string;

  constructor(
    fieldKey: string,
    value: T,
    isVerified = false,
    feedback?: string,
  ) {
    this.fieldKey = fieldKey;
    this.value = value;
    this.isVerified = isVerified;
    this.feedback = feedback;
  }

  static of<T>(
    fieldKey: string,
    value: T,
    isVerified = false,
    feedback?: string,
  ): VerifiedField<T> {
    return new VerifiedField(fieldKey, value, isVerified, feedback);
  }
}

// ============================================================================
// KYC Document DTO
// ============================================================================

export class KycDocumentDto {
  @ApiProperty({ type: String, example: 'uuid-123' })
  id: string;

  @ApiProperty({ type: String, example: 'documents/business-license.pdf' })
  documentKey: string;

  @ApiPropertyOptional({
    type: String,
    example: 'https://example.com/doc.pdf',
    nullable: true,
  })
  fileUrl?: string | null;

  @ApiProperty({ type: String, example: 'BUSINESS_LICENSE' })
  type: string;

  @ApiProperty({ type: String, example: 'pdf' })
  fileType: string;

  @ApiProperty({ type: String, example: 'pending' })
  status: string;

  @ApiPropertyOptional({ type: String, example: '2024-01-20T10:00:00Z' })
  uploadedAt?: string;

  static fromEntity(doc: PartnerDocument): KycDocumentDto {
    const dto = new KycDocumentDto();
    dto.id = doc.id;
    dto.documentKey = doc.documentKey;
    dto.fileUrl = doc.fileUrl;
    dto.type = doc.type;
    dto.fileType = doc.fileType;
    dto.status = doc.status;
    dto.uploadedAt = doc.createdAt.toISOString();
    return dto;
  }
}

// ============================================================================
// Legal Representative DTO
// ============================================================================

export class LegalRepresentativeDto {
  @ApiProperty({ type: VerifiedField })
  fullName: VerifiedField<string>;

  @ApiPropertyOptional({ type: VerifiedField })
  position?: VerifiedField<string>;

  @ApiPropertyOptional({ type: VerifiedField })
  phoneNumber?: VerifiedField<string>;

  @ApiPropertyOptional({ type: VerifiedField })
  idType?: VerifiedField<string>;

  @ApiPropertyOptional({ type: VerifiedField })
  idNumber?: VerifiedField<string>;

  @ApiPropertyOptional({ type: VerifiedField })
  idIssueDate?: VerifiedField<string>;

  static fromEntity(
    rep: LegalRepresentative,
    feedbackMap: FieldFeedbackMap = {},
  ): LegalRepresentativeDto {
    const dto = new LegalRepresentativeDto();

    const getFeedback = (fieldKey: string) => {
      const feedback = feedbackMap[fieldKey];
      return {
        isVerified: !feedback,
        reason: feedback?.feedback,
      };
    };

    const fullNameFb = getFeedback(PartnerFieldKeys.fullName);
    dto.fullName = VerifiedField.of(
      PartnerFieldKeys.fullName,
      rep.fullName,
      fullNameFb.isVerified,
      fullNameFb.reason,
    );

    const positionFb = getFeedback(PartnerFieldKeys.position);
    dto.position = VerifiedField.of(
      PartnerFieldKeys.position,
      rep.position,
      positionFb.isVerified,
      positionFb.reason,
    );

    if (rep.phoneNumber) {
      const phoneNumberFb = getFeedback(PartnerFieldKeys.phoneNumber);
      dto.phoneNumber = VerifiedField.of(
        PartnerFieldKeys.phoneNumber,
        rep.phoneNumber,
        phoneNumberFb.isVerified,
        phoneNumberFb.reason,
      );
    }

    const idTypeFb = getFeedback(PartnerFieldKeys.idType);
    dto.idType = VerifiedField.of(
      PartnerFieldKeys.idType,
      String(rep.idType),
      idTypeFb.isVerified,
      idTypeFb.reason,
    );

    const idNumberFb = getFeedback(PartnerFieldKeys.idNumber);
    dto.idNumber = VerifiedField.of(
      PartnerFieldKeys.idNumber,
      rep.idNumber,
      idNumberFb.isVerified,
      idNumberFb.reason,
    );

    const issueDateValue =
      rep.idIssueDate instanceof Date
        ? rep.idIssueDate.toISOString().split('T')[0]
        : String(rep.idIssueDate);
    const idIssueDateFb = getFeedback(PartnerFieldKeys.idIssueDate);
    dto.idIssueDate = VerifiedField.of(
      PartnerFieldKeys.idIssueDate,
      issueDateValue,
      idIssueDateFb.isVerified,
      idIssueDateFb.reason,
    );

    return dto;
  }
}

// ============================================================================
// Address Info DTO
// ============================================================================

type LocationRef = { id: string; name: string };

export class AddressInfoDto {
  @ApiProperty({ type: VerifiedField })
  streetAddress: VerifiedField<string>;

  @ApiPropertyOptional({ type: VerifiedField })
  ward?: VerifiedField<LocationRef>;

  @ApiPropertyOptional({ type: VerifiedField })
  district?: VerifiedField<LocationRef>;

  @ApiPropertyOptional({ type: VerifiedField })
  city?: VerifiedField<LocationRef>;

  @ApiPropertyOptional({ type: String, example: 'Vietnam' })
  country?: string;

  @ApiPropertyOptional({ example: 21.0285, nullable: true, type: Number })
  latitude?: number | null;

  @ApiPropertyOptional({ example: 105.8542, nullable: true, type: Number })
  longitude?: number | null;

  static fromPartner(
    partner: Partner,
    feedbackMap: FieldFeedbackMap = {},
  ): AddressInfoDto {
    const dto = new AddressInfoDto();

    const getFeedback = (fieldKey: string) => {
      const feedback = feedbackMap[fieldKey];
      return {
        isVerified: !feedback,
        reason: feedback?.feedback,
      };
    };

    const streetFb = getFeedback(PartnerFieldKeys.streetAddress);
    dto.streetAddress = VerifiedField.of(
      PartnerFieldKeys.streetAddress,
      partner.streetAddress ?? '',
      streetFb.isVerified,
      streetFb.reason,
    );

    if (partner.ward) {
      const wardFb = getFeedback(PartnerFieldKeys.ward);
      dto.ward = VerifiedField.of(
        PartnerFieldKeys.ward,
        { id: partner.ward.id, name: partner.ward.name },
        wardFb.isVerified,
        wardFb.reason,
      );
    }

    if (partner.district) {
      const districtFb = getFeedback(PartnerFieldKeys.district);
      dto.district = VerifiedField.of(
        PartnerFieldKeys.district,
        { id: partner.district.id, name: partner.district.name },
        districtFb.isVerified,
        districtFb.reason,
      );
    }

    if (partner.province) {
      const cityFb = getFeedback(PartnerFieldKeys.city);
      dto.city = VerifiedField.of(
        PartnerFieldKeys.city,
        { id: partner.province.id, name: partner.province.name },
        cityFb.isVerified,
        cityFb.reason,
      );
    }

    dto.country = 'Vietnam';
    dto.latitude = partner.latitude;
    dto.longitude = partner.longitude;

    return dto;
  }
}

// ============================================================================
// Business Info DTO
// ============================================================================

export class BusinessInfoDto {
  @ApiProperty({ type: VerifiedField })
  brandName: VerifiedField<string>;

  @ApiPropertyOptional({ type: VerifiedField })
  legalName?: VerifiedField<string>;

  @ApiPropertyOptional({ type: VerifiedField })
  taxRegistrationCode?: VerifiedField<string>;

  @ApiProperty({ type: VerifiedField })
  businessType: VerifiedField<BusinessType[]>;

  @ApiPropertyOptional({ type: AddressInfoDto })
  address?: AddressInfoDto;

  @ApiPropertyOptional({ type: VerifiedField })
  email?: VerifiedField<string>;

  @ApiPropertyOptional({ type: VerifiedField })
  phoneNumber?: VerifiedField<string>;

  static fromPartner(
    partner: Partner,
    feedbackMap: FieldFeedbackMap = {},
  ): BusinessInfoDto {
    const dto = new BusinessInfoDto();

    const getFeedback = (fieldKey: string) => {
      const feedback = feedbackMap[fieldKey];
      return {
        isVerified: !feedback,
        reason: feedback?.feedback,
      };
    };

    const brandNameFb = getFeedback(PartnerFieldKeys.brandName);
    dto.brandName = VerifiedField.of(
      PartnerFieldKeys.brandName,
      partner.brandName ?? '',
      brandNameFb.isVerified,
      brandNameFb.reason,
    );

    if (partner.legalName) {
      const legalNameFb = getFeedback(PartnerFieldKeys.legalName);
      dto.legalName = VerifiedField.of(
        PartnerFieldKeys.legalName,
        partner.legalName,
        legalNameFb.isVerified,
        legalNameFb.reason,
      );
    }

    if (partner.taxCode) {
      const taxCodeFb = getFeedback(PartnerFieldKeys.taxCode);
      dto.taxRegistrationCode = VerifiedField.of(
        PartnerFieldKeys.taxCode,
        partner.taxCode,
        taxCodeFb.isVerified,
        taxCodeFb.reason,
      );
    }

    const businessTypeFb = getFeedback(PartnerFieldKeys.businessType);
    dto.businessType = VerifiedField.of(
      PartnerFieldKeys.businessType,
      partner.businessType,
      businessTypeFb.isVerified,
      businessTypeFb.reason,
    );

    dto.address = AddressInfoDto.fromPartner(partner, feedbackMap);

    if (partner.account?.email) {
      const emailFb = getFeedback(PartnerFieldKeys.email);
      dto.email = VerifiedField.of(
        PartnerFieldKeys.email,
        partner.account.email,
        emailFb.isVerified,
        emailFb.reason,
      );
    }

    if (partner.phoneNumber) {
      const phoneNumberFb = getFeedback(PartnerFieldKeys.phoneNumber);
      dto.phoneNumber = VerifiedField.of(
        PartnerFieldKeys.phoneNumber,
        partner.phoneNumber,
        phoneNumberFb.isVerified,
        phoneNumberFb.reason,
      );
    }

    return dto;
  }
}

// ============================================================================
// Main Response DTO
// ============================================================================

export class MyProfileResponseDto {
  @ApiProperty({ type: String, example: 'uuid' })
  id: string;

  @ApiProperty({ type: BusinessInfoDto })
  businessInfo: BusinessInfoDto;

  @ApiPropertyOptional({ type: LegalRepresentativeDto })
  legalRepresentative?: LegalRepresentativeDto;

  @ApiProperty({ type: [VerifiedField] })
  kycDocuments: VerifiedField<KycDocumentDto>[];

  @ApiProperty({
    enum: PartnerVerificationStatus,
    enumName: 'PartnerVerificationStatus',
    example: PartnerVerificationStatus.PENDING,
  })
  verificationStatus: PartnerVerificationStatus;

  @ApiPropertyOptional({ type: Date, nullable: true, example: null })
  verificationCompletedAt: Date | null;

  @ApiProperty({ type: Date, example: '2024-01-15T10:30:00Z' })
  createdAt: Date;

  static fromPartner(
    partner: Partner,
    fieldFeedbackMap: FieldFeedbackMap = {},
    documentFeedbackMap: FieldFeedbackMap = {},
  ): MyProfileResponseDto {
    const dto = new MyProfileResponseDto();
    dto.id = partner.id;
    dto.businessInfo = BusinessInfoDto.fromPartner(partner, fieldFeedbackMap);
    dto.legalRepresentative = partner.legalRepresentative
      ? LegalRepresentativeDto.fromEntity(
          partner.legalRepresentative,
          fieldFeedbackMap,
        )
      : undefined;
    dto.kycDocuments = (partner.documents ?? []).map((doc) => {
      const docFeedback = documentFeedbackMap[doc.documentKey];
      return VerifiedField.of(
        doc.documentKey,
        KycDocumentDto.fromEntity(doc),
        !docFeedback,
        docFeedback?.feedback,
      );
    });
    dto.verificationStatus =
      partner.verificationStatus ?? PartnerVerificationStatus.PENDING;
    dto.verificationCompletedAt = partner.verificationCompletedAt ?? null;
    dto.createdAt = partner.createdAt;
    return dto;
  }
}
