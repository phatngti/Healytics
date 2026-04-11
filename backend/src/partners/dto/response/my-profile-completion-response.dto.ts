import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { BusinessType } from '@/partners/enum/business-type.enum';
import { Partner } from '@/common/entities/partner.entity';
import { PartnerCertification } from '@/clinic/entities/partner-certification.entity';

export class CompletionChecklistItemDto {
  @ApiProperty({ example: 'coverImageUrl' })
  key: string;

  @ApiProperty({ example: 'Clinic cover image' })
  label: string;

  @ApiProperty({ example: true })
  required: boolean;

  @ApiProperty({ example: false })
  completed: boolean;
}

export class PartnerProfileCompletionCertificationDto {
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
    certification: PartnerCertification,
  ): PartnerProfileCompletionCertificationDto {
    const dto = new PartnerProfileCompletionCertificationDto();
    dto.id = certification.id;
    dto.title = certification.title;
    dto.subtitle = certification.subtitle ?? null;
    dto.iconName = certification.iconName;
    dto.sortOrder = certification.sortOrder;
    return dto;
  }
}

export class PartnerProfileCompletionIdentityDto {
  @ApiProperty({ example: 'Healytics Wellness Center' })
  brandName: string;

  @ApiProperty({ example: 'Healytics Wellness Joint Stock Company' })
  legalName: string;

  @ApiProperty({
    type: [String],
    example: [BusinessType.SPA_BEAUTY],
  })
  businessType: string[];

  @ApiPropertyOptional({ example: '0901234567', nullable: true })
  phoneNumber: string | null;

  @ApiPropertyOptional({
    example: '123 Main Street, Ward 1, District 1, Ho Chi Minh City',
    nullable: true,
  })
  address: string | null;
}

export class MyProfileCompletionResponseDto {
  @ApiProperty({ example: '7ec0e7fb-9e19-4f64-bcee-beaf3c12fd5d' })
  id: string;

  @ApiProperty({ type: PartnerProfileCompletionIdentityDto })
  clinicIdentity: PartnerProfileCompletionIdentityDto;

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

  @ApiProperty({
    type: [PartnerProfileCompletionCertificationDto],
  })
  certifications: PartnerProfileCompletionCertificationDto[];

  @ApiProperty({
    type: [CompletionChecklistItemDto],
  })
  checklist: CompletionChecklistItemDto[];

  @ApiProperty({ example: 50 })
  completionPercent: number;

  @ApiProperty({ example: false })
  isCompleted: boolean;

  static fromPartner(
    partner: Partner,
    certifications: PartnerCertification[],
  ): MyProfileCompletionResponseDto {
    const dto = new MyProfileCompletionResponseDto();
    const identity = new PartnerProfileCompletionIdentityDto();
    const addressParts = [
      partner.streetAddress,
      partner.ward?.fullName ?? partner.ward?.name,
      partner.district?.fullName ?? partner.district?.name,
      partner.province?.fullName ?? partner.province?.name,
    ].filter(Boolean);

    const checklist: CompletionChecklistItemDto[] = [
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

    dto.id = partner.id;
    identity.brandName = partner.brandName;
    identity.legalName = partner.legalName;
    identity.businessType = partner.businessType;
    identity.phoneNumber = partner.phoneNumber;
    identity.address = addressParts.length === 0 ? null : addressParts.join(', ');
    dto.clinicIdentity = identity;
    dto.coverImageUrl = partner.coverImageUrl;
    dto.logoImageUrl = partner.logoImageUrl;
    dto.description = partner.description;
    dto.gallery = Array.isArray(partner.gallery) ? [...partner.gallery] : [];
    dto.certifications = certifications
      .map(PartnerProfileCompletionCertificationDto.fromEntity)
      .sort((a, b) => a.sortOrder - b.sortOrder);
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
