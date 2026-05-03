import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Partner } from '@/common/entities/partner.entity';
import { Product } from '@/common/entities/product.entity';
import { Employee } from '@/common/entities/employee.entity';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';

// ─── Nested DTOs ─────────────────────────────────────────────

class PublicClinicCertificationDto {
  @ApiProperty({ type: String, example: 'Medical License #124' })
  title: string;

  @ApiProperty({ type: String, example: 'Ministry of Health' })
  subtitle: string;

  @ApiProperty({ type: String, example: 'workspace_premium' })
  iconName: string;
}

class PublicClinicSpecialistPreviewDto {
  @ApiProperty({ type: String, example: 'a1b2c3d4-...' })
  id: string;

  @ApiProperty({ type: String, example: 'Dr. Sarah Lin' })
  name: string;

  @ApiProperty({ type: String, example: 'Dermatologist' })
  role: string;

  @ApiPropertyOptional({ type: String, nullable: true, example: 'https://example.com/avatar.jpg' })
  imageUrl: string | null;

  @ApiPropertyOptional({ type: String, nullable: true, example: '10 Yrs Exp' })
  experienceLabel: string | null;
}

class PublicClinicFacilityImageDto {
  @ApiProperty({ type: String, example: 'https://example.com/facility.jpg' })
  imageUrl: string;

  @ApiProperty({ type: String, example: 'Main Hall' })
  label: string;
}

class PublicClinicFeaturedServiceDto {
  @ApiProperty({ type: String, example: 'a1b2c3d4-...' })
  id: string;

  @ApiProperty({ type: String, example: 'Relaxation Massage' })
  title: string;

  @ApiPropertyOptional({ type: String, nullable: true, example: 'https://example.com/service.jpg' })
  imageUrl: string | null;

  @ApiProperty({ type: String, example: '890,000₫' })
  price: string;

  @ApiProperty({ type: Number, example: 4.9 })
  rating: number;

  @ApiProperty({ type: String, example: '1.2k booked' })
  bookedLabel: string;
}

export class PublicClinicTrustMetricsDto {
  @ApiProperty({ type: String, example: '10+ Yrs' })
  experienceLabel: string;

  @ApiProperty({ type: Number, example: 15 })
  specialistsCount: number;

  @ApiProperty({ type: String, example: '100%' })
  certifiedLabel: string;

  @ApiProperty({ type: String, example: '30k+' })
  clientsLabel: string;
}

// ─── Main DTO ────────────────────────────────────────────────

export class PublicClinicInfoResponseDto {
  @ApiProperty({ type: String, example: 'a1b2c3d4-...' })
  id: string;

  @ApiProperty({ type: String, example: 'An Mien Spa & Clinic' })
  name: string;

  @ApiProperty({ type: String, example: '42 West St., District 1, HCM' })
  address: string;

  @ApiProperty({ type: Boolean, example: true })
  isVerified: boolean;

  @ApiPropertyOptional({ type: String, nullable: true, example: 'https://example.com/cover.jpg' })
  coverImageUrl: string | null;

  @ApiPropertyOptional({ type: String, nullable: true, example: 'https://example.com/logo.jpg' })
  logoImageUrl: string | null;

  @ApiProperty({ type: [String] })
  gallery: string[];

  @ApiProperty({ type: Number, example: 4.9 })
  rating: number;

  @ApiProperty({ type: Number, example: 2500 })
  reviewCount: number;

  @ApiProperty({ type: String, example: '15k' })
  followersLabel: string;

  @ApiPropertyOptional({ type: String, nullable: true, example: '+84 28 1234 5678' })
  phone: string | null;

  @ApiPropertyOptional({ type: String, nullable: true, example: '10.7769,106.7009' })
  coordinates: string | null;

  @ApiPropertyOptional({ type: String, nullable: true, example: 'a1b2c3d4-...' })
  chatPartnerId: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  description: string | null;

  @ApiProperty({ type: PublicClinicTrustMetricsDto })
  trustMetrics: PublicClinicTrustMetricsDto;

  @ApiProperty({ type: [PublicClinicCertificationDto] })
  certifications: PublicClinicCertificationDto[];

  @ApiProperty({ type: [PublicClinicSpecialistPreviewDto] })
  specialists: PublicClinicSpecialistPreviewDto[];

  @ApiProperty({ type: [PublicClinicFacilityImageDto] })
  facilityImages: PublicClinicFacilityImageDto[];

  @ApiProperty({ type: [PublicClinicFeaturedServiceDto] })
  featuredServices: PublicClinicFeaturedServiceDto[];

  static fromPartner(
    partner: Partner,
    employees: Employee[],
    products: Product[],
    ratingsMap: Map<string, { rating: number; count: number }>,
  ): PublicClinicInfoResponseDto {
    const dto = new PublicClinicInfoResponseDto();

    dto.id = partner.id;
    dto.name = partner.brandName;

    const addressParts = [
      partner.streetAddress,
      partner.ward?.fullName,
      partner.district?.fullName,
      partner.province?.fullName,
    ].filter(Boolean);
    dto.address = addressParts.join(', ');

    dto.isVerified = partner.verificationStatus === PartnerVerificationStatus.APPROVED;
    dto.coverImageUrl = partner.coverImageUrl ?? null;
    dto.logoImageUrl = partner.logoImageUrl ?? null;
    dto.gallery = partner.gallery ?? [];
    dto.phone = partner.phoneNumber;
    dto.coordinates = partner.coordinates;
    dto.chatPartnerId = partner.accountId;

    // Aggregate rating across all partner products
    let totalRating = 0;
    let totalCount = 0;
    for (const [, data] of ratingsMap) {
      totalRating += data.rating * data.count;
      totalCount += data.count;
    }
    dto.rating = totalCount > 0
      ? Math.round((totalRating / totalCount) * 10) / 10
      : 0;
    dto.reviewCount = totalCount;
    dto.followersLabel = String(partner.followerCount ?? 0);
    dto.description = partner.description ?? null;

    // Trust metrics — derived from partner data
    dto.trustMetrics = {
      experienceLabel: '1+ Yrs',
      specialistsCount: employees.length,
      certifiedLabel: '100%',
      clientsLabel: `${totalCount}+`,
    };

    // Certifications — placeholder until a
    // dedicated table exists
    dto.certifications = [];

    // Specialists preview
    dto.specialists = employees.slice(0, 5).map((e) => ({
      id: e.id,
      name: `${e.firstName} ${e.lastName}`,
      role: e.role,
      imageUrl: e.avatarUrl ?? null,
      experienceLabel: null,
    }));

    // Facility images from first product that
    // has them
    dto.facilityImages = [];
    for (const product of products) {
      const images = product.facilityImages ?? [];
      if (images.length > 0) {
        dto.facilityImages = images
          .sort((a, b) => a.sortOrder - b.sortOrder)
          .map((fi) => ({
            imageUrl: fi.imageUrl,
            label: fi.label,
          }));
        break;
      }
    }

    // Featured services
    dto.featuredServices = products.slice(0, 4).map((p) => {
      const rd = ratingsMap.get(p.id);
      const price = p.salePrice ?? p.basePrice;
      return {
        id: p.id,
        title: p.name,
        imageUrl:
          p.media?.find((m) => m.isThumbnail)?.url ??
          p.media?.[0]?.url ??
          null,
        price:
          new Intl.NumberFormat('vi-VN').format(
            Number(price),
          ) + '₫',
        rating: rd?.rating ?? 0,
        bookedLabel: `${rd?.count ?? 0} booked`,
      };
    });

    return dto;
  }
}
