import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { BusinessType } from '@/partners/enum/business-type.enum';
import { Partner } from '@/common/entities/partner.entity';
import { LegalRepresentative } from '@/common/entities/legal-representative.entity';
import { PartnerCertification } from '@/clinic/entities/partner-certification.entity';

// ============================================================================
// Read-Only Business Info DTO
// ============================================================================

export class PublicProfileBusinessInfoDto {
  @ApiProperty({ example: 'Healytics Wellness Center' })
  brandName: string;

  @ApiProperty({ example: 'Healytics Wellness Joint Stock Company' })
  legalName: string;

  @ApiProperty({ example: '0123456789' })
  taxCode: string;

  @ApiProperty({
    type: [String],
    example: [BusinessType.SPA_BEAUTY],
  })
  businessType: string[];

  @ApiPropertyOptional({ example: '0901234567', nullable: true })
  phoneNumber: string | null;

  @ApiPropertyOptional({ example: 'clinic@example.com', nullable: true })
  email: string | null;

  @ApiPropertyOptional({ example: 'healytics_clinic', nullable: true })
  username: string | null;

  static fromPartner(partner: Partner): PublicProfileBusinessInfoDto {
    const dto = new PublicProfileBusinessInfoDto();
    dto.brandName = partner.brandName;
    dto.legalName = partner.legalName;
    dto.taxCode = partner.taxCode;
    dto.businessType = partner.businessType;
    dto.phoneNumber = partner.phoneNumber;
    dto.email = partner.account?.email ?? null;
    dto.username = partner.account?.username ?? null;
    return dto;
  }
}

// ============================================================================
// Read-Only Address DTO
// ============================================================================

export class PublicProfileAddressDto {
  @ApiProperty({ example: '123 Nguyen Hue, Ward 1' })
  streetAddress: string;

  @ApiPropertyOptional({
    example: { id: 'uuid', name: 'Phường 1' },
    nullable: true,
  })
  ward: { id: string; name: string } | null;

  @ApiPropertyOptional({
    example: { id: 'uuid', name: 'Quận 1' },
    nullable: true,
  })
  district: { id: string; name: string } | null;

  @ApiPropertyOptional({
    example: { id: 'uuid', name: 'TP. Hồ Chí Minh' },
    nullable: true,
  })
  province: { id: string; name: string } | null;

  @ApiPropertyOptional({ example: 21.0285, nullable: true, type: Number })
  latitude: number | null;

  @ApiPropertyOptional({ example: 105.8542, nullable: true, type: Number })
  longitude: number | null;

  @ApiPropertyOptional({
    example: '123 Nguyen Hue, Phường 1, Quận 1, TP. Hồ Chí Minh',
    nullable: true,
  })
  formattedAddress: string | null;

  static fromPartner(partner: Partner): PublicProfileAddressDto {
    const dto = new PublicProfileAddressDto();
    dto.streetAddress = partner.streetAddress;
    dto.ward = partner.ward
      ? { id: partner.ward.id, name: partner.ward.name }
      : null;
    dto.district = partner.district
      ? { id: partner.district.id, name: partner.district.name }
      : null;
    dto.province = partner.province
      ? { id: partner.province.id, name: partner.province.name }
      : null;
    dto.latitude = partner.latitude;
    dto.longitude = partner.longitude;

    const addressParts = [
      partner.streetAddress,
      partner.ward?.fullName ?? partner.ward?.name,
      partner.district?.fullName ?? partner.district?.name,
      partner.province?.fullName ?? partner.province?.name,
    ].filter(Boolean);
    dto.formattedAddress =
      addressParts.length === 0 ? null : addressParts.join(', ');

    return dto;
  }
}

// ============================================================================
// Read-Only Legal Summary DTO
// ============================================================================

export class PublicProfileLegalSummaryDto {
  @ApiProperty({ example: 'Nguyễn Văn A' })
  fullName: string;

  @ApiProperty({ example: 'Giám đốc' })
  position: string;

  @ApiProperty({ example: 'cccd' })
  idType: string;

  @ApiProperty({ example: '012345678901' })
  idNumber: string;

  static fromEntity(
    legalRep: LegalRepresentative,
  ): PublicProfileLegalSummaryDto {
    const dto = new PublicProfileLegalSummaryDto();
    dto.fullName = legalRep.fullName;
    dto.position = legalRep.position;
    dto.idType = String(legalRep.idType);
    dto.idNumber = legalRep.idNumber;
    return dto;
  }
}

// ============================================================================
// Certification DTO (for storefront)
// ============================================================================

export class PublicProfileCertificationDto {
  @ApiProperty({ example: '8d2ee5c7-4f58-46a5-8f8d-4a14a8fd9e2b' })
  id: string;

  @ApiProperty({ example: 'ISO 9001:2015' })
  title: string;

  @ApiPropertyOptional({ example: 'Quality Management', nullable: true })
  subtitle: string | null;

  @ApiProperty({ example: 'workspace_premium' })
  iconName: string;

  @ApiProperty({ example: 1 })
  sortOrder: number;

  static fromEntity(
    cert: PartnerCertification,
  ): PublicProfileCertificationDto {
    const dto = new PublicProfileCertificationDto();
    dto.id = cert.id;
    dto.title = cert.title;
    dto.subtitle = cert.subtitle ?? null;
    dto.iconName = cert.iconName;
    dto.sortOrder = cert.sortOrder;
    return dto;
  }
}

// ============================================================================
// Editable Storefront DTO
// ============================================================================

export class PublicProfileStorefrontDto {
  @ApiPropertyOptional({
    example: 'https://cdn.example.com/clinic-cover.jpg',
    nullable: true,
  })
  coverImageUrl: string | null;

  @ApiPropertyOptional({
    example: 'https://cdn.example.com/clinic-logo.jpg',
    nullable: true,
  })
  logoImageUrl: string | null;

  @ApiPropertyOptional({
    example: 'A modern wellness clinic focused on long-term care.',
    nullable: true,
  })
  description: string | null;

  @ApiProperty({ type: [String] })
  gallery: string[];

  @ApiProperty({ type: [PublicProfileCertificationDto] })
  certifications: PublicProfileCertificationDto[];

  static fromPartner(
    partner: Partner,
    certifications: PartnerCertification[],
  ): PublicProfileStorefrontDto {
    const dto = new PublicProfileStorefrontDto();
    dto.coverImageUrl = partner.coverImageUrl;
    dto.logoImageUrl = partner.logoImageUrl;
    dto.description = partner.description;
    dto.gallery = Array.isArray(partner.gallery) ? [...partner.gallery] : [];
    dto.certifications = certifications
      .map(PublicProfileCertificationDto.fromEntity)
      .sort((a, b) => a.sortOrder - b.sortOrder);
    return dto;
  }
}

// ============================================================================
// Completion Summary DTO (derived)
// ============================================================================

export class PublicProfileChecklistItemDto {
  @ApiProperty({ example: 'coverImageUrl' })
  key: string;

  @ApiProperty({ example: 'Clinic cover image' })
  label: string;

  @ApiProperty({ example: true })
  required: boolean;

  @ApiProperty({ example: false })
  completed: boolean;
}

export class PublicProfileCompletionSummaryDto {
  @ApiProperty({ type: [PublicProfileChecklistItemDto] })
  checklist: PublicProfileChecklistItemDto[];

  @ApiProperty({ example: 75 })
  completionPercent: number;

  @ApiProperty({ example: false })
  isCompleted: boolean;

  static fromPartner(
    partner: Partner,
    certifications: PartnerCertification[],
  ): PublicProfileCompletionSummaryDto {
    const dto = new PublicProfileCompletionSummaryDto();

    const checklist: PublicProfileChecklistItemDto[] = [
      {
        key: 'coverImageUrl',
        label: 'Clinic cover image',
        required: true,
        completed: Boolean(partner.coverImageUrl),
      },
      {
        key: 'logoImageUrl',
        label: 'Clinic logo image',
        required: true,
        completed: Boolean(partner.logoImageUrl),
      },
      {
        key: 'description',
        label: 'Clinic description',
        required: true,
        completed:
          (partner.description?.trim().length ?? 0) >= 120 &&
          (partner.description?.trim().length ?? 0) <= 1000,
      },
      {
        key: 'gallery',
        label: 'Clinic gallery',
        required: true,
        completed: (partner.gallery?.length ?? 0) >= 3,
      },
      {
        key: 'certifications',
        label: 'Trust badges and certifications',
        required: false,
        completed: certifications.length > 0,
      },
    ];

    dto.checklist = checklist;
    dto.completionPercent = Math.round(
      (checklist.filter((item) => item.completed).length / checklist.length) *
        100,
    );
    dto.isCompleted = checklist
      .filter((item) => item.required)
      .every((item) => item.completed);

    return dto;
  }
}

// ============================================================================
// Main Aggregate Response DTO
// ============================================================================

export class PartnerPublicProfileResponseDto {
  @ApiProperty({ example: '7ec0e7fb-9e19-4f64-bcee-beaf3c12fd5d' })
  id: string;

  @ApiProperty({ type: PublicProfileBusinessInfoDto })
  businessInfo: PublicProfileBusinessInfoDto;

  @ApiProperty({ type: PublicProfileAddressDto })
  address: PublicProfileAddressDto;

  @ApiPropertyOptional({ type: PublicProfileLegalSummaryDto })
  readOnlyLegalSummary: PublicProfileLegalSummaryDto | null;

  @ApiProperty({
    enum: PartnerVerificationStatus,
    example: PartnerVerificationStatus.APPROVED,
  })
  verificationStatus: PartnerVerificationStatus;

  @ApiProperty({ type: PublicProfileStorefrontDto })
  publicProfile: PublicProfileStorefrontDto;

  @ApiProperty({ type: PublicProfileCompletionSummaryDto })
  completionSummary: PublicProfileCompletionSummaryDto;

  static fromPartner(
    partner: Partner,
    certifications: PartnerCertification[],
  ): PartnerPublicProfileResponseDto {
    const dto = new PartnerPublicProfileResponseDto();
    dto.id = partner.id;
    dto.businessInfo = PublicProfileBusinessInfoDto.fromPartner(partner);
    dto.address = PublicProfileAddressDto.fromPartner(partner);
    dto.readOnlyLegalSummary = partner.legalRepresentative
      ? PublicProfileLegalSummaryDto.fromEntity(partner.legalRepresentative)
      : null;
    dto.verificationStatus =
      partner.verificationStatus ?? PartnerVerificationStatus.PENDING;
    dto.publicProfile = PublicProfileStorefrontDto.fromPartner(
      partner,
      certifications,
    );
    dto.completionSummary = PublicProfileCompletionSummaryDto.fromPartner(
      partner,
      certifications,
    );
    return dto;
  }
}
