import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

/**
 * Trust metrics bar displayed on the clinic info screen.
 *
 * Field-mapping contract (Partner -> ClinicService -> DTO -> user_app):
 * | DTO field        | Source                                          | user_app entity field    |
 * |------------------|-------------------------------------------------|--------------------------|
 * | rating           | avg treatment-review rating across products      | ClinicTrustMetrics.rating          |
 * | reviewCount      | total treatment-review count across products     | ClinicTrustMetrics.reviewCount     |
 * | experienceLabel  | derived from Partner.createdAt (years active)    | ClinicTrustMetrics.experienceLabel |
 * | clientsLabel     | unique booking users across products             | ClinicTrustMetrics.clientsLabel    |
 */
export class ClinicTrustMetricsDto {
  @ApiProperty({ type: Number, example: 4.9 })
  rating: number;

  @ApiProperty({ type: Number, example: 2500 })
  reviewCount: number;

  @ApiProperty({ type: String, example: '5+ Yrs' })
  experienceLabel: string;

  @ApiProperty({ type: String, example: '15k' })
  clientsLabel: string;
}

export class ClinicCertificationDto {
  @ApiProperty({ type: String, example: 'ISO 9001:2015' })
  title: string;

  @ApiPropertyOptional({ type: String, nullable: true, example: 'Quality Management' })
  subtitle: string | null;

  @ApiProperty({ type: String, example: 'workspace_premium' })
  iconName: string;
}

export class ClinicSpecialistPreviewDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String, example: 'Dr. Sarah' })
  name: string;

  @ApiProperty({ type: String, example: 'Senior Therapist' })
  role: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  imageUrl: string | null;

  @ApiPropertyOptional({ type: String, nullable: true, example: '5 Yrs Exp' })
  experienceLabel: string | null;
}

/**
 * Clinic profile returned by `GET /user/clinics/:id/info`.
 *
 * Field-mapping contract (admin_panel sign-up -> Partner entity -> this DTO):
 * | DTO field      | Partner column / derivation            | Admin sign-up form key         |
 * |----------------|----------------------------------------|--------------------------------|
 * | id             | Partner.id (auto UUID)                 | —                              |
 * | name           | Partner.brandName                      | brand_name                     |
 * | coverImageUrl  | Partner.coverImageUrl (post-signup)     | —                              |
 * | logoImageUrl   | Partner.logoImageUrl (post-signup)      | —                              |
 * | gallery        | Partner.gallery (post-signup)           | —                              |
 * | followersLabel | formatCount(Partner.followerCount)      | — (derived)                   |
 * | reviewsLabel   | formatCount(totalReviewCount)           | — (derived)                   |
 * | description    | Partner.description (post-signup)       | —                              |
 * | trustMetrics   | see ClinicTrustMetricsDto              | — (derived)                   |
 * | certifications | PartnerCertification rows              | — (post-signup)               |
 * | specialists    | Employee rows (active, limit 5)        | — (post-signup)               |
 * | businessTypes  | Partner.businessType (BusinessType[])   | business_types (enum codes)   |
 * | address        | Partner.streetAddress                   | street_address                |
 * | phoneNumber    | Partner.phoneNumber                     | clinic_phone (dedicated field)|
 */
export class ClinicInfoResponseDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String, example: 'Healytics Wellness Center' })
  name: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  coverImageUrl: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  logoImageUrl: string | null;

  @ApiProperty({ type: [String] })
  gallery: string[];

  @ApiProperty({ type: String, example: '15k' })
  followersLabel: string;

  @ApiProperty({ type: String, example: '2.5k' })
  reviewsLabel: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  description: string | null;

  @ApiProperty({ type: ClinicTrustMetricsDto })
  trustMetrics: ClinicTrustMetricsDto;

  @ApiProperty({ type: [ClinicCertificationDto] })
  certifications: ClinicCertificationDto[];

  @ApiProperty({ type: [ClinicSpecialistPreviewDto] })
  specialists: ClinicSpecialistPreviewDto[];

  @ApiProperty({ type: [String] })
  businessTypes: string[];

  @ApiPropertyOptional({ type: String, nullable: true })
  address: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  phoneNumber: string | null;
}
