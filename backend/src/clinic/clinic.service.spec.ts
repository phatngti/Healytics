import { NotFoundException } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { In } from 'typeorm';
import { Product } from '@/common/entities/product.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Booking } from '@/common/entities/booking.entity';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
import { Partner } from '@/common/entities/partner.entity';
import { UserClinicFollow } from '@/common/entities/user-clinic-follow.entity';
import { PartnersService } from '@/partners/partners.service';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { ClinicService } from './clinic.service';
import { PartnerCertification } from './entities/partner-certification.entity';
import { ClinicReviewResponse } from './entities/clinic-review-response.entity';
import { ClinicProductSortOption } from './dto/get-clinic-products-query.dto';

function createQueryBuilderMock() {
  return {
    leftJoinAndSelect: jest.fn().mockReturnThis(),
    innerJoinAndSelect: jest.fn().mockReturnThis(),
    innerJoin: jest.fn().mockReturnThis(),
    where: jest.fn().mockReturnThis(),
    andWhere: jest.fn().mockReturnThis(),
    select: jest.fn().mockReturnThis(),
    addSelect: jest.fn().mockReturnThis(),
    groupBy: jest.fn().mockReturnThis(),
    addGroupBy: jest.fn().mockReturnThis(),
    orderBy: jest.fn().mockReturnThis(),
    addOrderBy: jest.fn().mockReturnThis(),
    setParameter: jest.fn().mockReturnThis(),
    skip: jest.fn().mockReturnThis(),
    take: jest.fn().mockReturnThis(),
    getCount: jest.fn().mockResolvedValue(0),
    getMany: jest.fn().mockResolvedValue([]),
    getRawMany: jest.fn().mockResolvedValue([]),
  };
}

describe('ClinicService', () => {
  let service: ClinicService;
  let productRepo: { createQueryBuilder: jest.Mock };
  let employeeRepo: { find: jest.Mock };
  let bookingRepo: { createQueryBuilder: jest.Mock };
  let reviewRepo: { createQueryBuilder: jest.Mock };
  let partnerRepo: { increment: jest.Mock; decrement: jest.Mock };
  let clinicFollowRepo: {
    exists: jest.Mock;
    findOne: jest.Mock;
    create: jest.Mock;
    save: jest.Mock;
    delete: jest.Mock;
  };
  let certificationRepo: { find: jest.Mock };
  let clinicReviewResponseRepo: { find: jest.Mock };
  let partnersService: { findOneById: jest.Mock };

  const partner = {
    id: '11111111-1111-4111-8111-111111111111',
    brandName: 'Healytics Wellness Center',
    createdAt: new Date('2021-04-12T00:00:00.000Z'),
    coverImageUrl: 'https://example.com/cover.jpg',
    logoImageUrl: 'https://example.com/logo.jpg',
    gallery: ['https://example.com/gallery.jpg'],
    followerCount: 2500,
    description: 'Clinic description',
    businessType: ['clinic'],
    streetAddress: '123 Health Street',
    ward: { fullName: 'Ward 1' },
    district: { fullName: 'District 1' },
    province: { fullName: 'Ho Chi Minh City' },
    phoneNumber: '0123456789',
  };

  beforeEach(async () => {
    productRepo = { createQueryBuilder: jest.fn() };
    employeeRepo = { find: jest.fn() };
    bookingRepo = { createQueryBuilder: jest.fn() };
    reviewRepo = { createQueryBuilder: jest.fn() };
    partnerRepo = {
      increment: jest.fn(),
      decrement: jest.fn(),
    };
    clinicFollowRepo = {
      exists: jest.fn().mockResolvedValue(false),
      findOne: jest.fn(),
      create: jest.fn((value) => value),
      save: jest.fn(async (value) => ({ id: 'follow-1', ...value })),
      delete: jest.fn(),
    };
    certificationRepo = { find: jest.fn() };
    clinicReviewResponseRepo = { find: jest.fn() };
    partnersService = { findOneById: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ClinicService,
        { provide: getRepositoryToken(Product), useValue: productRepo },
        { provide: getRepositoryToken(Employee), useValue: employeeRepo },
        { provide: getRepositoryToken(Booking), useValue: bookingRepo },
        { provide: getRepositoryToken(TreatmentReview), useValue: reviewRepo },
        { provide: getRepositoryToken(Partner), useValue: partnerRepo },
        {
          provide: getRepositoryToken(UserClinicFollow),
          useValue: clinicFollowRepo,
        },
        {
          provide: getRepositoryToken(PartnerCertification),
          useValue: certificationRepo,
        },
        {
          provide: getRepositoryToken(ClinicReviewResponse),
          useValue: clinicReviewResponseRepo,
        },
        { provide: PartnersService, useValue: partnersService },
      ],
    }).compile();

    service = module.get<ClinicService>(ClinicService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('throws 404 when the clinic does not exist', async () => {
    partnersService.findOneById.mockResolvedValue(null);

    await expect(service.getClinicInfo('missing-clinic')).rejects.toThrow(
      NotFoundException,
    );
  });

  it('aggregates clinic info from public products only', async () => {
    const publicProductsQb = createQueryBuilderMock();
    publicProductsQb.getMany.mockResolvedValue([
      { id: 'prod-1' },
      { id: 'prod-2' },
    ]);
    productRepo.createQueryBuilder.mockReturnValue(publicProductsQb);
    partnersService.findOneById.mockResolvedValue(partner);
    employeeRepo.find.mockResolvedValue([
      {
        id: 'emp-1',
        fullName: 'Dr. Sarah',
        jobTitle: 'Senior Therapist',
        role: 'doctor',
        avatarUrl: 'https://example.com/doctor.jpg',
        doctorProfile: { experienceYears: 8 },
        startDate: new Date('2022-01-01T00:00:00.000Z'),
      },
      {
        id: 'emp-2',
        fullName: 'Alex Tran',
        jobTitle: null,
        role: 'therapist',
        avatarUrl: null,
        doctorProfile: null,
        startDate: new Date('2023-04-12T00:00:00.000Z'),
      },
    ]);
    certificationRepo.find.mockResolvedValue([
      {
        title: 'ISO 9001:2015',
        subtitle: 'Quality Management',
        iconName: 'workspace_premium',
      },
    ]);

    jest.spyOn(service as any, 'buildRatingsMap').mockResolvedValue(
      new Map([
        ['prod-1', { rating: 4.8, count: 3 }],
        ['prod-2', { rating: 4.2, count: 2 }],
      ]),
    );
    jest
      .spyOn(service as any, 'countUniqueBookingUsers')
      .mockResolvedValue(1500);

    const result = await service.getClinicInfo(partner.id);

    expect(result).toEqual(
      expect.objectContaining({
        id: partner.id,
        name: partner.brandName,
        followersLabel: '2.5k',
        followerCount: 2500,
        isFollowing: false,
        chatPartnerId: null,
        reviewsLabel: '5',
        address: '123 Health Street, Ward 1, District 1, Ho Chi Minh City',
        phoneNumber: '0123456789',
        trustMetrics: expect.objectContaining({
          rating: 4.6,
          reviewCount: 5,
          clientsLabel: '1.5k',
        }),
        certifications: [
          {
            title: 'ISO 9001:2015',
            subtitle: 'Quality Management',
            iconName: 'workspace_premium',
          },
        ],
        specialists: [
          expect.objectContaining({
            id: 'emp-1',
            experienceLabel: '8 Yrs Exp',
          }),
          expect.objectContaining({
            id: 'emp-2',
            role: 'therapist',
            experienceLabel: '3 Yrs Exp',
          }),
        ],
      }),
    );
    expect(publicProductsQb.where).toHaveBeenCalledWith(
      'p.partner_id = :partnerId',
      { partnerId: partner.id },
    );
    expect(publicProductsQb.andWhere).toHaveBeenNthCalledWith(
      1,
      'p.status = :status',
      { status: 'active' },
    );
    expect(publicProductsQb.andWhere).toHaveBeenNthCalledWith(
      2,
      'p.is_visible_online = true',
    );
  });

  it('creates follow rows idempotently and increments once', async () => {
    const publicProductsQb = createQueryBuilderMock();
    publicProductsQb.getMany.mockResolvedValue([]);
    productRepo.createQueryBuilder.mockReturnValue(publicProductsQb);
    partnersService.findOneById.mockResolvedValue(partner);
    employeeRepo.find.mockResolvedValue([]);
    certificationRepo.find.mockResolvedValue([]);
    jest.spyOn(service as any, 'buildRatingsMap').mockResolvedValue(new Map());
    jest
      .spyOn(service as any, 'countUniqueBookingUsers')
      .mockResolvedValue(0);

    clinicFollowRepo.findOne.mockResolvedValueOnce(null);

    await service.followClinic(partner.id, 'user-1');

    expect(clinicFollowRepo.save).toHaveBeenCalledWith({
      userId: 'user-1',
      partnerId: partner.id,
    });
    expect(partnerRepo.increment).toHaveBeenCalledWith(
      { id: partner.id },
      'followerCount',
      1,
    );
  });

  it('unfollows idempotently and decrements only when a row exists', async () => {
    const publicProductsQb = createQueryBuilderMock();
    publicProductsQb.getMany.mockResolvedValue([]);
    productRepo.createQueryBuilder.mockReturnValue(publicProductsQb);
    partnersService.findOneById.mockResolvedValue(partner);
    employeeRepo.find.mockResolvedValue([]);
    certificationRepo.find.mockResolvedValue([]);
    jest.spyOn(service as any, 'buildRatingsMap').mockResolvedValue(new Map());
    jest
      .spyOn(service as any, 'countUniqueBookingUsers')
      .mockResolvedValue(0);

    clinicFollowRepo.findOne.mockResolvedValueOnce({ id: 'follow-1' });

    await service.unfollowClinic(partner.id, 'user-1');

    expect(clinicFollowRepo.delete).toHaveBeenCalledWith({ id: 'follow-1' });
    expect(partnerRepo.decrement).toHaveBeenCalledWith(
      { id: partner.id },
      'followerCount',
      1,
    );
  });

  it('returns product categories and paginated products with category filtering', async () => {
    const productsQb = createQueryBuilderMock();
    const categoriesQb = createQueryBuilderMock();
    categoriesQb.getRawMany.mockResolvedValue([
      { id: 'cat-1', label: 'Facial Treatments' },
      { id: 'cat-2', label: 'Laser' },
    ]);
    productsQb.getCount.mockResolvedValue(2);
    productsQb.getMany.mockResolvedValue([
      {
        id: 'prod-1',
        name: 'Premium CO2 Laser',
        salePrice: 990000,
        basePrice: 1250000,
        media: [{ isThumbnail: true, url: 'https://example.com/thumb.jpg' }],
        productDefinition: { durationMinutes: 60 },
        categoryId: 'cat-1',
        createdAt: new Date('2026-04-01T00:00:00.000Z'),
      },
    ]);
    productRepo.createQueryBuilder
      .mockReturnValueOnce(productsQb)
      .mockReturnValueOnce(categoriesQb);
    partnersService.findOneById.mockResolvedValue(partner);
    jest
      .spyOn(service as any, 'buildSoldCountMap')
      .mockResolvedValue(new Map([['prod-1', 12]]));

    const result = await service.getClinicProducts(partner.id, {
      categoryId: 'cat-1',
      search: 'laser',
      sort: ClinicProductSortOption.PRICE_ASC,
      page: 2,
      limit: 1,
    });

    expect(result).toEqual({
      categories: [
        { id: 'all', label: 'All Services' },
        { id: 'cat-1', label: 'Facial Treatments' },
        { id: 'cat-2', label: 'Laser' },
      ],
      products: [
        {
          id: 'prod-1',
          title: 'Premium CO2 Laser',
          imageUrl: 'https://example.com/thumb.jpg',
          price: '990.000đ',
          priceAmount: 990000,
          originalPrice: '1.250.000đ',
          discountLabel: '-21%',
          badgeLabel: null,
          durationLabel: '60 min',
          specialistLabel: null,
          categoryId: 'cat-1',
          soldCount: 12,
          createdAtMs: new Date('2026-04-01T00:00:00.000Z').getTime(),
        },
      ],
      totalCount: 2,
      hasMore: false,
    });
    expect(productsQb.andWhere).toHaveBeenCalledWith('p.name ILIKE :search', {
      search: '%laser%',
    });
    expect(productsQb.andWhere).toHaveBeenCalledWith(
      'p.category_id = :categoryId',
      { categoryId: 'cat-1' },
    );
    expect(productsQb.addSelect).toHaveBeenCalledWith(
      'COALESCE(p.sale_price, p.base_price)',
      'price',
    );
    expect(productsQb.orderBy).toHaveBeenCalledWith('price', 'ASC');
    expect(productsQb.skip).toHaveBeenCalledWith(1);
    expect(productsQb.take).toHaveBeenCalledWith(1);
  });

  it.each([
    ['popular', 'sold_count', 'DESC'],
    ['top_sales', 'sold_count', 'DESC'],
    ['latest', 'p.createdAt', 'DESC'],
    ['price_asc', 'price', 'ASC'],
    ['price_desc', 'price', 'DESC'],
  ])(
    'applies %s sort semantics for clinic products',
    async (sort, orderField, orderDirection) => {
      const productsQb = createQueryBuilderMock();
      const categoriesQb = createQueryBuilderMock();
      productRepo.createQueryBuilder
        .mockReturnValueOnce(productsQb)
        .mockReturnValueOnce(categoriesQb);
      partnersService.findOneById.mockResolvedValue(partner);
      jest
        .spyOn(service as any, 'buildSoldCountMap')
        .mockResolvedValue(new Map());

      await service.getClinicProducts(partner.id, {
        sort: sort as ClinicProductSortOption,
      });

      expect(productsQb.orderBy).toHaveBeenCalledWith(
        orderField,
        orderDirection,
      );
      if (sort === 'popular' || sort === 'top_sales') {
        expect(productsQb.setParameter).toHaveBeenCalledWith(
          'completedStatus',
          BookingStatus.COMPLETED,
        );
      }
      if (sort === 'price_asc' || sort === 'price_desc') {
        expect(productsQb.addSelect).toHaveBeenCalledWith(
          'COALESCE(p.sale_price, p.base_price)',
          'price',
        );
      }
    },
  );

  it('returns empty review state when the clinic has no public products', async () => {
    const publicProductsQb = createQueryBuilderMock();
    publicProductsQb.getMany.mockResolvedValue([]);
    productRepo.createQueryBuilder.mockReturnValue(publicProductsQb);
    partnersService.findOneById.mockResolvedValue(partner);

    const result = await service.getClinicReviews(partner.id, {});

    expect(result).toEqual({
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
    });
    expect(publicProductsQb.andWhere).toHaveBeenNthCalledWith(
      2,
      'p.is_visible_online = true',
    );
  });

  it('filters reviews by clinic public products and partner response scope', async () => {
    const publicProductsQb = createQueryBuilderMock();
    const reviewsQb = createQueryBuilderMock();
    publicProductsQb.getMany.mockResolvedValue([{ id: 'prod-1' }]);
    reviewsQb.getCount.mockResolvedValue(1);
    reviewsQb.getMany.mockResolvedValue([
      {
        id: 'review-1',
        rating: 4,
        comment: 'Very good',
        photoUrls: ['https://example.com/photo.jpg'],
        createdAt: new Date('2026-04-04T00:00:00.000Z'),
        booking: {
          product: { name: 'Salt Stone Massage (90 min)' },
        },
        user: {
          email: 'anna@example.com',
          userProfile: { name: 'Anna' },
        },
      },
    ]);
    productRepo.createQueryBuilder.mockReturnValue(publicProductsQb);
    reviewRepo.createQueryBuilder.mockReturnValue(reviewsQb);
    partnersService.findOneById.mockResolvedValue(partner);
    clinicReviewResponseRepo.find.mockResolvedValue([
      { reviewId: 'review-1', responseText: 'Thank you' },
    ]);
    jest.spyOn(service as any, 'buildReviewSummary').mockResolvedValue({
      averageRating: 4.7,
      totalReviewCount: 12,
      ratingLabel: 'Excellent',
      starDistribution: { 5: 0.9, 4: 0.1, 3: 0, 2: 0, 1: 0 },
    });
    jest.spyOn(service as any, 'buildReviewFilters').mockResolvedValue([
      {
        id: 'all',
        label: 'All (12)',
        starCount: null,
        requiresMedia: false,
      },
      {
        id: '4star',
        label: '4 Star (1)',
        starCount: 4,
        requiresMedia: false,
      },
      {
        id: 'media',
        label: 'With Photos (1)',
        starCount: null,
        requiresMedia: true,
      },
    ]);

    const result = await service.getClinicReviews(partner.id, {
      page: 2,
      limit: 5,
      starCount: 4,
      hasMedia: true,
    });

    expect(reviewsQb.andWhere).toHaveBeenCalledWith('tr.rating = :starCount', {
      starCount: 4,
    });
    expect(reviewsQb.andWhere).toHaveBeenCalledWith(
      'jsonb_array_length(tr.photo_urls) > 0',
    );
    expect(reviewsQb.skip).toHaveBeenCalledWith(5);
    expect(reviewsQb.take).toHaveBeenCalledWith(5);
    expect(clinicReviewResponseRepo.find).toHaveBeenCalledWith({
      where: { reviewId: In(['review-1']), partnerId: partner.id },
    });
    expect(result).toEqual(
      expect.objectContaining({
        totalCount: 1,
        hasMore: false,
        summary: expect.objectContaining({ totalReviewCount: 12 }),
        filters: expect.arrayContaining([
          expect.objectContaining({ id: 'all' }),
          expect.objectContaining({ id: '4star' }),
          expect.objectContaining({ id: 'media' }),
        ]),
        reviews: [
          expect.objectContaining({
            id: 'review-1',
            reviewerName: 'a***a',
            starCount: 4,
            dateLabel: '04-04-2026',
            serviceName: 'Salt Stone Massage (90 min)',
            memberBadge: null,
            serviceIcon: null,
            clinicResponse: { responseText: 'Thank you' },
          }),
        ],
      }),
    );
  });

  it('loads active specialists only', async () => {
    const publicProductsQb = createQueryBuilderMock();
    publicProductsQb.getMany.mockResolvedValue([]);
    productRepo.createQueryBuilder.mockReturnValue(publicProductsQb);
    partnersService.findOneById.mockResolvedValue(partner);
    employeeRepo.find.mockResolvedValue([]);
    certificationRepo.find.mockResolvedValue([]);
    jest.spyOn(service as any, 'buildRatingsMap').mockResolvedValue(new Map());
    jest.spyOn(service as any, 'countUniqueBookingUsers').mockResolvedValue(0);

    await service.getClinicInfo(partner.id);

    expect(employeeRepo.find).toHaveBeenCalledWith({
      where: { partnerId: partner.id, status: EmployeeStatus.ACTIVE },
      relations: ['doctorProfile'],
      take: 5,
    });
  });
});
