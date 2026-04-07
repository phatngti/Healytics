import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Product } from '@/common/entities/product.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Booking } from '@/common/entities/booking.entity';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
import { PartnerCertification } from './entities/partner-certification.entity';
import { ClinicReviewResponse } from './entities/clinic-review-response.entity';
import { PartnersService } from '@/partners/partners.service';
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import {
  ClinicInfoResponseDto,
  ClinicCertificationDto,
  ClinicSpecialistPreviewDto,
  ClinicTrustMetricsDto,
} from './dto/clinic-info-response.dto';
import {
  ClinicProductsResponseDto,
  ClinicProductDto,
} from './dto/clinic-products-response.dto';
import {
  ClinicReviewsResponseDto,
  ClinicReviewSummaryDto,
  ClinicReviewFilterDto,
  ClinicReviewDto,
} from './dto/clinic-reviews-response.dto';
import { GetClinicProductsQueryDto } from './dto/get-clinic-products-query.dto';
import { GetClinicReviewsQueryDto } from './dto/get-clinic-reviews-query.dto';

@Injectable()
export class ClinicService {
  private readonly logger = new Logger(ClinicService.name);

  constructor(
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,
    @InjectRepository(Employee)
    private readonly employeeRepo: Repository<Employee>,
    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,
    @InjectRepository(TreatmentReview)
    private readonly treatmentReviewRepo: Repository<TreatmentReview>,
    @InjectRepository(PartnerCertification)
    private readonly certificationRepo: Repository<PartnerCertification>,
    @InjectRepository(ClinicReviewResponse)
    private readonly clinicReviewResponseRepo: Repository<ClinicReviewResponse>,
    private readonly partnersService: PartnersService,
  ) {}

  // ═══════════════════════════════════════════════════════════════
  //  Endpoint 1: GET /v1/user/clinics/:id/info
  // ═══════════════════════════════════════════════════════════════

  async getClinicInfo(partnerId: string): Promise<ClinicInfoResponseDto> {
    const partner = await this.partnersService.findOneById(partnerId);
    if (!partner) {
      throw new NotFoundException(`Clinic with ID ${partnerId} not found`);
    }

    const [employees, products, certifications] = await Promise.all([
      this.employeeRepo.find({
        where: { partnerId, status: EmployeeStatus.ACTIVE },
        relations: ['doctorProfile'],
        take: 5,
      }),
      this.productRepo.find({
        where: {
          partnerId,
          status: HealthServiceStatus.ACTIVE,
        },
        select: ['id'],
      }),
      this.certificationRepo.find({
        where: { partnerId },
        order: { sortOrder: 'ASC' },
      }),
    ]);

    const productIds = products.map((p) => p.id);

    const [ratingsMap, uniqueBookingUsers] = await Promise.all([
      this.buildRatingsMap(productIds),
      this.countUniqueBookingUsers(productIds),
    ]);

    let totalRating = 0;
    let totalReviewCount = 0;
    for (const [, data] of ratingsMap) {
      totalRating += data.rating * data.count;
      totalReviewCount += data.count;
    }
    const avgRating =
      totalReviewCount > 0
        ? Math.round((totalRating / totalReviewCount) * 10) / 10
        : 0;

    const yearsActive = Math.floor(
      (Date.now() - partner.createdAt.getTime()) / (365.25 * 86400000),
    );

    const specialists: ClinicSpecialistPreviewDto[] = employees.map((e) => {
      let expLabel: string | null = null;
      if (e.doctorProfile?.experienceYears) {
        expLabel = `${e.doctorProfile.experienceYears} Yrs Exp`;
      } else if (e.startDate) {
        const years = Math.floor(
          (Date.now() - new Date(e.startDate).getTime()) / (365.25 * 86400000),
        );
        if (years > 0) expLabel = `${years} Yrs Exp`;
      }
      return {
        id: e.id,
        name: e.fullName,
        role: e.jobTitle ?? e.role,
        imageUrl: e.avatarUrl ?? null,
        experienceLabel: expLabel,
      };
    });

    const trustMetrics: ClinicTrustMetricsDto = {
      rating: avgRating,
      reviewCount: totalReviewCount,
      experienceLabel: `${Math.max(yearsActive, 1)}+ Yrs`,
      clientsLabel: formatCount(uniqueBookingUsers),
    };

    const certDtos: ClinicCertificationDto[] = certifications.map((c) => ({
      title: c.title,
      subtitle: c.subtitle,
      iconName: c.iconName,
    }));

    const addressParts = [
      partner.streetAddress,
      partner.ward?.fullName,
      partner.district?.fullName,
      partner.province?.fullName,
    ].filter(Boolean);

    return {
      id: partner.id,
      name: partner.brandName,
      coverImageUrl: partner.coverImageUrl ?? null,
      logoImageUrl: partner.logoImageUrl ?? null,
      gallery: partner.gallery ?? [],
      followersLabel: formatCount(partner.followerCount ?? 0),
      reviewsLabel: formatCount(totalReviewCount),
      description: partner.description ?? null,
      trustMetrics,
      certifications: certDtos,
      specialists,
      businessTypes: partner.businessType as unknown as string[],
      address: addressParts.join(', ') || null,
      phoneNumber: partner.phoneNumber,
    };
  }

  // ═══════════════════════════════════════════════════════════════
  //  Endpoint 2: GET /v1/user/clinics/:id/products
  // ═══════════════════════════════════════════════════════════════

  async getClinicProducts(
    partnerId: string,
    options: GetClinicProductsQueryDto,
  ): Promise<ClinicProductsResponseDto> {
    const partner = await this.partnersService.findOneById(partnerId);
    if (!partner) {
      throw new NotFoundException(`Clinic with ID ${partnerId} not found`);
    }

    const { sort = 'popular', search } = options;
    const page = options.page ?? 1;
    const limit = Math.min(options.limit ?? 20, 50);

    // Build filtered query
    let qb = this.productRepo
      .createQueryBuilder('p')
      .leftJoinAndSelect('p.category', 'c')
      .leftJoinAndSelect('p.media', 'm')
      .leftJoinAndSelect('p.productDefinition', 'pd')
      .where('p.partner_id = :partnerId', { partnerId })
      .andWhere('p.status = :status', { status: HealthServiceStatus.ACTIVE })
      .andWhere('p.is_visible_online = true');

    if (search) {
      qb = qb.andWhere('p.name ILIKE :search', { search: `%${search}%` });
    }

    const totalCount = await qb.getCount();

    // For popular/top_sales, join sold count subquery for DB-level sorting
    if (sort === 'popular' || sort === 'top_sales') {
      qb = qb
        .addSelect((subQuery) => {
          return subQuery
            .select('COUNT(b.id)', 'sold_count')
            .from(Booking, 'b')
            .where('b.product_id = p.id')
            .andWhere('b.status = :completedStatus');
        }, 'sold_count')
        .setParameter('completedStatus', BookingStatus.COMPLETED)
        .orderBy('sold_count', 'DESC');
    } else {
      switch (sort) {
        case 'latest':
          qb = qb.orderBy('p.createdAt', 'DESC');
          break;
        case 'price_asc':
          qb = qb
            .addSelect('COALESCE(p.sale_price, p.base_price)', 'price')
            .orderBy('price', 'ASC');
          break;
        case 'price_desc':
          qb = qb
            .addSelect('COALESCE(p.sale_price, p.base_price)', 'price')
            .orderBy('price', 'DESC');
          break;
        default:
          qb = qb.orderBy('p.createdAt', 'DESC');
      }
    }

    qb = qb.skip((page - 1) * limit).take(limit);
    const products = await qb.getMany();

    const productIds = products.map((p) => p.id);
    const soldMap = await this.buildSoldCountMap(productIds);

    const productDtos: ClinicProductDto[] = products.map((p) => {
      const currentPrice = p.salePrice ?? p.basePrice;
      const hasDiscount =
        p.salePrice != null && Number(p.basePrice) !== Number(p.salePrice);
      const pct = hasDiscount
        ? Math.round((1 - Number(p.salePrice) / Number(p.basePrice)) * 100)
        : null;

      return {
        id: p.id,
        title: p.name,
        imageUrl:
          p.media?.find((media) => media.isThumbnail)?.url ??
          p.media?.[0]?.url ??
          null,
        price: formatVND(currentPrice) + 'đ',
        priceAmount: Number(currentPrice),
        originalPrice: hasDiscount ? formatVND(p.basePrice) + 'đ' : null,
        discountLabel: pct ? `-${pct}%` : null,
        badgeLabel: null,
        durationLabel: p.productDefinition?.durationMinutes
          ? `${p.productDefinition.durationMinutes} min`
          : null,
        specialistLabel: null,
        categoryId: p.categoryId ?? 'all',
        soldCount: soldMap.get(p.id) ?? 0,
        createdAtMs: p.createdAt.getTime(),
      };
    });

    return {
      products: productDtos,
      totalCount,
      hasMore: page * limit < totalCount,
    };
  }

  // ═══════════════════════════════════════════════════════════════
  //  Endpoint 3: GET /v1/user/clinics/:id/reviews
  // ═══════════════════════════════════════════════════════════════

  async getClinicReviews(
    partnerId: string,
    query: GetClinicReviewsQueryDto,
  ): Promise<ClinicReviewsResponseDto> {
    const { page = 1, limit = 10, starCount, hasMedia } = query;

    const partner = await this.partnersService.findOneById(partnerId);
    if (!partner) {
      throw new NotFoundException(`Clinic with ID ${partnerId} not found`);
    }

    const productIds = await this.productRepo
      .find({ where: { partnerId }, select: ['id'] })
      .then((ps) => ps.map((p) => p.id));

    if (productIds.length === 0) {
      return this.emptyReviewsResponse();
    }

    // Filtered query
    let qb = this.treatmentReviewRepo
      .createQueryBuilder('tr')
      .innerJoinAndSelect('tr.booking', 'b')
      .leftJoinAndSelect('b.product', 'p')
      .innerJoinAndSelect('tr.user', 'u')
      .leftJoinAndSelect('u.userProfile', 'up')
      .where('b.product_id IN (:...productIds)', { productIds });

    if (starCount != null) {
      qb = qb.andWhere('tr.rating = :starCount', { starCount });
    }
    if (hasMedia === true) {
      qb = qb.andWhere('jsonb_array_length(tr.photo_urls) > 0');
    }

    const totalCount = await qb.getCount();
    const reviews = await qb
      .orderBy('tr.createdAt', 'DESC')
      .skip((page - 1) * limit)
      .take(limit)
      .getMany();

    // Load clinic responses for these reviews
    const reviewIds = reviews.map((r) => r.id);
    const clinicResponses =
      reviewIds.length > 0
        ? await this.clinicReviewResponseRepo.find({
            where: { reviewId: In(reviewIds) },
          })
        : [];
    const responseMap = new Map(clinicResponses.map((cr) => [cr.reviewId, cr]));

    // Summary (always unfiltered)
    const summary = await this.buildReviewSummary(productIds);
    const filters = await this.buildReviewFilters(productIds);

    const reviewDtos: ClinicReviewDto[] = reviews.map((tr) => {
      const userName =
        tr.user?.userProfile?.name || tr.user?.email || 'Anonymous';
      const response = responseMap.get(tr.id);

      return {
        id: tr.id,
        reviewerName: maskName(userName),
        reviewerInitial: userName[0]?.toUpperCase() ?? '?',
        starCount: tr.rating,
        memberBadge: null,
        dateLabel: formatDate(tr.createdAt),
        serviceName: tr.booking?.product?.name ?? null,
        serviceIcon: null,
        reviewText: tr.comment ?? '',
        mediaUrls: tr.photoUrls ?? [],
        clinicResponse: response
          ? { responseText: response.responseText }
          : null,
      };
    });

    return {
      summary,
      filters,
      reviews: reviewDtos,
      totalCount,
      hasMore: page * limit < totalCount,
    };
  }

  // ═══════════════════════════════════════════════════════════════
  //  Private Helpers
  // ═══════════════════════════════════════════════════════════════

  private async buildRatingsMap(
    productIds: string[],
  ): Promise<Map<string, { rating: number; count: number }>> {
    if (!productIds.length) return new Map();

    const rows = await this.treatmentReviewRepo
      .createQueryBuilder('tr')
      .innerJoin('tr.booking', 'b')
      .where('b.product_id IN (:...productIds)', { productIds })
      .select('b.product_id', 'productId')
      .addSelect('AVG(tr.rating)', 'avg')
      .addSelect('COUNT(tr.id)', 'count')
      .groupBy('b.product_id')
      .getRawMany<{ productId: string; avg: string; count: string }>();

    const map = new Map<string, { rating: number; count: number }>();
    for (const row of rows) {
      const count = parseInt(row.count, 10);
      const rating = count > 0 ? Math.round(parseFloat(row.avg) * 10) / 10 : 0;
      map.set(row.productId, { rating, count });
    }
    return map;
  }

  private async buildSoldCountMap(
    productIds: string[],
  ): Promise<Map<string, number>> {
    if (!productIds.length) return new Map();

    const rows = await this.bookingRepo
      .createQueryBuilder('b')
      .where('b.product_id IN (:...productIds)', { productIds })
      .andWhere('b.status = :status', { status: BookingStatus.COMPLETED })
      .select('b.product_id', 'productId')
      .addSelect('COUNT(b.id)', 'count')
      .groupBy('b.product_id')
      .getRawMany<{ productId: string; count: string }>();

    const map = new Map<string, number>();
    for (const row of rows) {
      map.set(row.productId, parseInt(row.count, 10));
    }
    return map;
  }

  private async countUniqueBookingUsers(productIds: string[]): Promise<number> {
    if (!productIds.length) return 0;

    const result = await this.bookingRepo
      .createQueryBuilder('b')
      .where('b.product_id IN (:...productIds)', { productIds })
      .andWhere('b.status = :status', { status: BookingStatus.COMPLETED })
      .select('COUNT(DISTINCT b.user_id)', 'count')
      .getRawOne<{ count: string }>();

    return parseInt(result?.count ?? '0', 10);
  }

  private async buildReviewSummary(
    productIds: string[],
  ): Promise<ClinicReviewSummaryDto> {
    const rows = await this.treatmentReviewRepo
      .createQueryBuilder('tr')
      .innerJoin('tr.booking', 'b')
      .where('b.product_id IN (:...productIds)', { productIds })
      .select('tr.rating', 'star')
      .addSelect('COUNT(tr.id)', 'count')
      .groupBy('tr.rating')
      .getRawMany<{ star: number; count: string }>();

    let total = 0;
    let sum = 0;
    const dist: Record<number, number> = { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 };
    for (const r of rows) {
      const c = parseInt(r.count, 10);
      dist[r.star] = c;
      total += c;
      sum += r.star * c;
    }

    const avg = total > 0 ? Math.round((sum / total) * 10) / 10 : 0;

    const starDistribution: Record<number, number> = {};
    for (const s of [5, 4, 3, 2, 1]) {
      starDistribution[s] =
        total > 0 ? Math.round((dist[s] / total) * 1000) / 1000 : 0;
    }

    return {
      averageRating: avg,
      totalReviewCount: total,
      ratingLabel: ratingLabel(avg),
      starDistribution,
    };
  }

  private async buildReviewFilters(
    productIds: string[],
  ): Promise<ClinicReviewFilterDto[]> {
    const rows = await this.treatmentReviewRepo
      .createQueryBuilder('tr')
      .innerJoin('tr.booking', 'b')
      .where('b.product_id IN (:...productIds)', { productIds })
      .select('tr.rating', 'star')
      .addSelect('COUNT(tr.id)', 'count')
      .groupBy('tr.rating')
      .getRawMany<{ star: number; count: string }>();

    const total = rows.reduce((s, r) => s + parseInt(r.count, 10), 0);
    const starMap = new Map(rows.map((r) => [r.star, parseInt(r.count, 10)]));

    const mediaCount = await this.treatmentReviewRepo
      .createQueryBuilder('tr')
      .innerJoin('tr.booking', 'b')
      .where('b.product_id IN (:...productIds)', { productIds })
      .andWhere('jsonb_array_length(tr.photo_urls) > 0')
      .getCount();

    const filters: ClinicReviewFilterDto[] = [
      {
        id: 'all',
        label: `All (${formatCount(total)})`,
        starCount: null,
        requiresMedia: false,
      },
    ];

    for (const s of [5, 4, 3, 2, 1]) {
      const c = starMap.get(s) ?? 0;
      if (c > 0) {
        filters.push({
          id: `${s}star`,
          label: `${s} Star (${formatCount(c)})`,
          starCount: s,
          requiresMedia: false,
        });
      }
    }

    if (mediaCount > 0) {
      filters.push({
        id: 'media',
        label: `With Photos (${formatCount(mediaCount)})`,
        starCount: null,
        requiresMedia: true,
      });
    }

    return filters;
  }

  private emptyReviewsResponse(): ClinicReviewsResponseDto {
    return {
      summary: {
        averageRating: 0,
        totalReviewCount: 0,
        ratingLabel: 'No Reviews',
        starDistribution: { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 },
      },
      filters: [
        {
          id: 'all',
          label: 'All (0)',
          starCount: null,
          requiresMedia: false,
        },
      ],
      reviews: [],
      totalCount: 0,
      hasMore: false,
    };
  }
}

// ═══════════════════════════════════════════════════════════════
//  Pure Helper Functions
// ═══════════════════════════════════════════════════════════════

function maskName(name: string): string {
  if (!name || name.length < 2) return '***';
  const f = name[0].toLowerCase();
  const l = name[name.length - 1].toLowerCase();
  return `${f}***${l}`;
}

function ratingLabel(avg: number): string {
  if (avg >= 4.5) return 'Excellent';
  if (avg >= 4.0) return 'Very Good';
  if (avg >= 3.5) return 'Good';
  if (avg >= 3.0) return 'Average';
  if (avg === 0) return 'No Reviews';
  return 'Below Average';
}

function formatDate(date: Date): string {
  const d = String(date.getDate()).padStart(2, '0');
  const m = String(date.getMonth() + 1).padStart(2, '0');
  return `${d}-${m}-${date.getFullYear()}`;
}

function formatVND(amount: number | string): string {
  return new Intl.NumberFormat('vi-VN').format(Number(amount));
}

function formatCount(n: number): string {
  if (n >= 1000) {
    const k = n / 1000;
    return k % 1 === 0 ? `${k}k` : `${k.toFixed(1)}k`;
  }
  return String(n);
}
