import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException } from '@nestjs/common';
import { HealthServiceService } from './health-service.service';
import { Product } from '@/common/entities/product.entity';
import { UserWishlistItem } from '@/common/entities/user-wishlist-item.entity';
import { Booking } from '@/common/entities/booking.entity';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { CreatePartnerHealthServiceDto } from './dto/partner/create-partner-health-service.dto';
import { UpdatePartnerHealthServiceDto } from './dto/partner/update-partner-health-service.dto';
import { CreateHealthServiceHandler } from './application/handlers/create-health-service.handler';
import { UpdateHealthServiceHandler } from './application/handlers/update-health-service.handler';
import { RemoveHealthServiceHandler } from './application/handlers/remove-health-service.handler';
import { GetOverviewAnalyticsHandler } from './application/handlers/get-overview-analytics.handler';
import { GetDetailAnalyticsHandler } from './application/handlers/get-detail-analytics.handler';
import { PublicServiceListQueryDto } from './dto/public/service-list-query.dto';
import { PartnersService } from '@/partners/partners.service';
import { ElasticsearchBookingService } from '@/search/services/elasticsearch-booking.service';
import {
  MockRepository,
  MockHandler,
  MockType,
  createMockRepository,
  createMockHandler,
} from '../../test/mocks/mock-types';

describe('HealthServiceService', () => {
  let service: HealthServiceService;
  let productRepository: MockRepository<Product>;
  let bookingRepository: MockRepository<Booking>;
  let treatmentReviewRepository: MockRepository<TreatmentReview>;
  let eligibilityRepository: MockRepository<ProductEmployeeEligibility>;
  let wishlistRepository: MockRepository<UserWishlistItem>;
  let createHandler: MockHandler;
  let updateHandler: MockHandler;
  let removeHandler: MockHandler;
  let overviewAnalyticsHandler: MockHandler;
  let detailAnalyticsHandler: MockHandler;
  let partnersService: MockType<PartnersService>;
  let elasticsearchBookingService: {
    isAvailable: boolean;
    searchServiceIds: jest.Mock;
  };

  beforeEach(async () => {
    // Arrange - Create fresh mocks for each test
    productRepository = createMockRepository<Product>();
    bookingRepository = createMockRepository<Booking>();
    treatmentReviewRepository = createMockRepository<TreatmentReview>();
    eligibilityRepository = createMockRepository<ProductEmployeeEligibility>();
    wishlistRepository = createMockRepository<UserWishlistItem>();
    createHandler = createMockHandler();
    updateHandler = createMockHandler();
    removeHandler = createMockHandler();
    overviewAnalyticsHandler = createMockHandler();
    detailAnalyticsHandler = createMockHandler();
    elasticsearchBookingService = {
      isAvailable: false,
      searchServiceIds: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        HealthServiceService,
        {
          provide: getRepositoryToken(Product),
          useValue: productRepository,
        },
        {
          provide: getRepositoryToken(Booking),
          useValue: bookingRepository,
        },
        {
          provide: getRepositoryToken(TreatmentReview),
          useValue: treatmentReviewRepository,
        },
        {
          provide: getRepositoryToken(ProductEmployeeEligibility),
          useValue: eligibilityRepository,
        },
        {
          provide: getRepositoryToken(UserWishlistItem),
          useValue: wishlistRepository,
        },
        {
          provide: CreateHealthServiceHandler,
          useValue: createHandler,
        },
        {
          provide: UpdateHealthServiceHandler,
          useValue: updateHandler,
        },
        {
          provide: RemoveHealthServiceHandler,
          useValue: removeHandler,
        },
        {
          provide: GetOverviewAnalyticsHandler,
          useValue: overviewAnalyticsHandler,
        },
        {
          provide: GetDetailAnalyticsHandler,
          useValue: detailAnalyticsHandler,
        },
        {
          provide: PartnersService,
          useValue: {
            getPartnerProfile: jest
              .fn()
              .mockResolvedValue({ id: 'partner-uuid' }),
            getFirstHealthPartner: jest.fn().mockResolvedValue(null),
          },
        },
        {
          provide: ElasticsearchBookingService,
          useValue: elasticsearchBookingService,
        },
      ],
    }).compile();

    service = module.get<HealthServiceService>(HealthServiceService);
    partnersService = module.get(PartnersService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('create', () => {
    it('should delegate to CreateHealthServiceHandler and return created product', async () => {
      // Arrange
      const accountId = 'account-uuid';
      const partnerId = 'partner-uuid';
      const dto: CreatePartnerHealthServiceDto = {
        name: 'Test Product',
      } as CreatePartnerHealthServiceDto;
      const expectedProduct = {
        id: 'uuid-1',
        name: 'Test Product',
        partnerId,
      };
      createHandler.execute.mockResolvedValue(expectedProduct);

      // Act
      const result = await service.create(accountId, dto);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(partnersService.getPartnerProfile).toHaveBeenCalledWith(accountId);
      expect(createHandler.execute).toHaveBeenCalledWith({
        ...dto,
        partnerId,
      });
      expect(createHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('update', () => {
    it('should delegate to UpdateHealthServiceHandler and return updated product', async () => {
      // Arrange
      const accountId = 'account-uuid';
      const partnerId = 'partner-uuid';
      const id = 'uuid-1';
      const dto: UpdatePartnerHealthServiceDto = {
        name: 'Updated Product',
      } as UpdatePartnerHealthServiceDto;
      const expectedProduct = { id, name: 'Updated Product' };
      updateHandler.execute.mockResolvedValue(expectedProduct);

      // Act
      const result = await service.update(accountId, id, dto);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(partnersService.getPartnerProfile).toHaveBeenCalledWith(accountId);
      expect(updateHandler.execute).toHaveBeenCalledWith(id, dto, partnerId);
      expect(updateHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('remove', () => {
    it('should delegate to RemoveHealthServiceHandler', async () => {
      // Arrange
      const id = 'uuid-1';
      removeHandler.execute.mockResolvedValue(undefined);

      // Act
      await service.remove(id);

      // Assert
      expect(removeHandler.execute).toHaveBeenCalledWith(id);
      expect(removeHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('findAll', () => {
    it('should return all products with relations ordered by createdAt DESC and id DESC', async () => {
      // Arrange
      const expectedProducts = [
        { id: 'uuid-1', name: 'Product 1' },
        { id: 'uuid-2', name: 'Product 2' },
      ];
      productRepository.find.mockResolvedValue(expectedProducts);

      // Act
      const result = await service.findAll();

      // Assert
      expect(result).toEqual(expectedProducts);
      expect(productRepository.find).toHaveBeenCalledWith(
        expect.objectContaining({
          relations: expect.any(Array),
          order: { createdAt: 'DESC', id: 'DESC' },
        }),
      );
    });

    it('should return empty array when no products exist', async () => {
      // Arrange
      productRepository.find.mockResolvedValue([]);

      // Act
      const result = await service.findAll();

      // Assert
      expect(result).toEqual([]);
    });
  });

  describe('findOne', () => {
    it('should return a product when found by ID', async () => {
      // Arrange
      const id = 'uuid-1';
      const expectedProduct = { id, name: 'Test Product' };
      productRepository.findOne.mockResolvedValue(expectedProduct);

      // Act
      const result = await service.findOne(id);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(productRepository.findOne).toHaveBeenCalledWith(
        expect.objectContaining({ where: { id } }),
      );
    });

    it('should throw NotFoundException when product not found', async () => {
      // Arrange
      const id = 'non-existent-id';
      productRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(service.findOne(id)).rejects.toThrow(NotFoundException);
      await expect(service.findOne(id)).rejects.toThrow(
        `Product with ID ${id} not found`,
      );
    });
  });

  describe('findBySlug', () => {
    it('should return a product when found by slug', async () => {
      // Arrange
      const slug = 'test-product';
      const expectedProduct = { id: 'uuid-1', slug };
      productRepository.findOne.mockResolvedValue(expectedProduct);

      // Act
      const result = await service.findBySlug(slug);

      // Assert
      expect(result).toEqual(expectedProduct);
      expect(productRepository.findOne).toHaveBeenCalledWith(
        expect.objectContaining({ where: { slug } }),
      );
    });

    it('should throw NotFoundException when product slug not found', async () => {
      // Arrange
      const slug = 'non-existent-slug';
      productRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(service.findBySlug(slug)).rejects.toThrow(NotFoundException);
      await expect(service.findBySlug(slug)).rejects.toThrow(
        `Product with slug "${slug}" not found`,
      );
    });
  });

  describe('getEligibilityDetail', () => {
    it('uses the selected product partner for booking summary location', async () => {
      const partner = {
        id: 'partner-hcm',
        brandName: 'Yoga phuc hoi TPHCM 17',
        streetAddress: '40 Nguyen Trai',
        ward: null,
        district: { fullName: 'Quan 8' },
        province: { fullName: 'Thanh pho Ho Chi Minh' },
        latitude: 10.75,
        longitude: 106.66,
      };
      const eligibility = {
        id: 'elig-1',
        product: {
          id: 'service-1',
          name: 'Stress Reset TPHCM 0529',
          description: 'Therapy session',
          basePrice: 430000,
          salePrice: null,
          currency: 'VND',
          partner,
          category: {
            id: 'category-1',
            name: 'Psychology Therapy',
            parent: null,
          },
          media: [],
          productDefinition: { durationMinutes: 50 },
        },
        employee: {
          id: 'employee-1',
          fullName: 'Dr. TPHCM',
          jobTitle: 'Therapist',
          avatarUrl: null,
          doctorProfile: null,
        },
      } as ProductEmployeeEligibility;
      eligibilityRepository.findOne.mockResolvedValue(eligibility);

      const result = await service.getEligibilityDetail('elig-1');

      expect(eligibilityRepository.findOne).toHaveBeenCalledWith(
        expect.objectContaining({
          where: { id: 'elig-1' },
          relations: expect.arrayContaining([
            'product.partner',
            'product.partner.province',
            'product.partner.district',
            'product.partner.ward',
          ]),
        }),
      );
      expect(partnersService.getFirstHealthPartner).not.toHaveBeenCalled();
      expect(result.location.name).toBe('Yoga phuc hoi TPHCM 17');
      expect(result.location.address).toBe(
        '40 Nguyen Trai, Quan 8, Thanh pho Ho Chi Minh',
      );
    });
  });

  describe('getProductEmployees', () => {
    it('should throw NotFoundException when product not found', async () => {
      // Arrange
      productRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(service.getProductEmployees('missing-id')).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should return empty array when product has no employees', async () => {
      // Arrange
      productRepository.findOne.mockResolvedValue({
        id: 'prod-1',
        productEmployeeEligibilities: [],
      });

      // Act
      const result = await service.getProductEmployees('prod-1');

      // Assert
      expect(result).toEqual([]);
    });

    it('should return employees with day schedules generated from work schedule', async () => {
      // Arrange
      const employee = {
        id: 'emp-1',
        fullName: 'Dr. Test',
        jobTitle: 'Doctor',
        role: 'doctor',
        avatarUrl: null,
        description: null,
        doctorProfile: null,
        therapistProfile: null,
        schedule: [
          { day: 'Monday', start: '09:00', end: '10:00', isWorking: true },
          { day: 'Tuesday', start: '', end: '', isWorking: false },
        ],
      };

      productRepository.findOne.mockResolvedValue({
        id: 'prod-1',
        productEmployeeEligibilities: [
          { id: 'elig-1', employeeId: 'emp-1', isPrimary: false, employee },
        ],
      });
      bookingRepository.find.mockResolvedValue([]);

      // Act
      const result = await service.getProductEmployees('prod-1');

      // Assert
      expect(result).toHaveLength(1);
      expect(result[0].id).toBe('emp-1');
      expect(result[0].eligibilityId).toBe('elig-1');
      expect(result[0].name).toBe('Dr. Test');
      expect(result[0].isSelected).toBe(true); // first employee is selected
      expect(result[0].daySchedules).toHaveLength(30);

      // Find a Monday in the schedules
      const mondaySchedule = result[0].daySchedules.find((d) => {
        const date = new Date(d.date + 'T00:00:00');
        return date.getDay() === 1; // Monday
      });
      expect(mondaySchedule).toBeDefined();
      expect(mondaySchedule!.isAvailable).toBe(true);
      expect(mondaySchedule!.timeSlots.length).toBe(2); // 09:00, 09:30

      // Find a Tuesday
      const tuesdaySchedule = result[0].daySchedules.find((d) => {
        const date = new Date(d.date + 'T00:00:00');
        return date.getDay() === 2; // Tuesday
      });
      expect(tuesdaySchedule).toBeDefined();
      expect(tuesdaySchedule!.isAvailable).toBe(false);
      expect(tuesdaySchedule!.timeSlots).toEqual([]);
    });

    it('should mark booked slots as unavailable', async () => {
      // Arrange — find next Monday from today
      const today = new Date();
      const todayDay = today.getDay();
      const daysUntilMonday =
        todayDay === 1 ? 0 : todayDay === 0 ? 1 : 8 - todayDay;
      const nextMonday = new Date(
        today.getFullYear(),
        today.getMonth(),
        today.getDate() + daysUntilMonday,
      );

      const employee = {
        id: 'emp-1',
        fullName: 'Dr. Test',
        jobTitle: 'Doctor',
        role: 'doctor',
        avatarUrl: null,
        description: null,
        doctorProfile: null,
        therapistProfile: null,
        schedule: [
          { day: 'Monday', start: '09:00', end: '10:00', isWorking: true },
        ],
      };

      productRepository.findOne.mockResolvedValue({
        id: 'prod-1',
        productEmployeeEligibilities: [
          { id: 'elig-1', employeeId: 'emp-1', isPrimary: false, employee },
        ],
      });

      // Create a booking at 09:00 on next Monday
      const bookingTime = new Date(nextMonday);
      bookingTime.setHours(9, 0, 0, 0);
      bookingRepository.find.mockResolvedValue([
        { staffId: 'emp-1', startTime: bookingTime, status: 'CONFIRMED' },
      ]);

      // Act
      const result = await service.getProductEmployees('prod-1');

      // Assert
      const mondayDate = `${nextMonday.getFullYear()}-${String(nextMonday.getMonth() + 1).padStart(2, '0')}-${String(nextMonday.getDate()).padStart(2, '0')}`;
      const mondaySchedule = result[0].daySchedules.find(
        (d) => d.date === mondayDate,
      );
      expect(mondaySchedule).toBeDefined();

      const slot9am = mondaySchedule!.timeSlots.find(
        (s) => s.label === '09:00 AM',
      );
      const slot930am = mondaySchedule!.timeSlots.find(
        (s) => s.label === '09:30 AM',
      );
      expect(slot9am!.isAvailable).toBe(false); // booked
      expect(slot930am!.isAvailable).toBe(true); // not booked
    });

    it('should set isSelected on the primary employee', async () => {
      // Arrange
      const emp1 = {
        id: 'emp-1',
        fullName: 'Doctor A',
        jobTitle: 'Doctor',
        role: 'doctor',
        avatarUrl: null,
        description: null,
        doctorProfile: null,
        therapistProfile: null,
        schedule: [],
      };
      const emp2 = {
        id: 'emp-2',
        fullName: 'Doctor B',
        jobTitle: 'Doctor',
        role: 'doctor',
        avatarUrl: null,
        description: null,
        doctorProfile: null,
        therapistProfile: null,
        schedule: [],
      };

      productRepository.findOne.mockResolvedValue({
        id: 'prod-1',
        productEmployeeEligibilities: [
          {
            id: 'elig-1',
            employeeId: 'emp-1',
            isPrimary: false,
            employee: emp1,
          },
          {
            id: 'elig-2',
            employeeId: 'emp-2',
            isPrimary: true,
            employee: emp2,
          },
        ],
      });
      bookingRepository.find.mockResolvedValue([]);

      // Act
      const result = await service.getProductEmployees('prod-1');

      // Assert
      expect(result[0].isSelected).toBe(false); // emp-1
      expect(result[1].isSelected).toBe(true); // emp-2 is primary
    });
  });

  describe('getPremiumTreatments', () => {
    it('should query active visible products and return card DTOs', async () => {
      // Arrange
      const mockProducts = [
        {
          id: 'uuid-1',
          name: 'Product 1',
          type: 'service',
          basePrice: 500000,
          media: [],
          reviews: [],
          productEmployeeEligibilities: [],
        },
      ];
      const qb = productRepository.createQueryBuilder();
      qb.getMany.mockResolvedValue(mockProducts);

      // Act
      const result = await service.getPremiumTreatments();

      // Assert
      expect(result).toBeDefined();
      expect(Array.isArray(result)).toBe(true);
      expect(productRepository.createQueryBuilder).toHaveBeenCalledWith(
        'product',
      );
      expect(qb.andWhere).toHaveBeenCalledWith(
        'product.is_visible_online = :isVisibleOnline',
        { isVisibleOnline: true },
      );
      expect(qb.take).toHaveBeenCalledWith(50);
    });

    it('should not clamp paginated premium treatment results to ten items', async () => {
      // Arrange
      const mockProducts = Array.from({ length: 13 }, (_, index) => ({
        id: `uuid-${index + 1}`,
        name: `Product ${index + 1}`,
        slug: `product-${index + 1}`,
        type: 'service',
        basePrice: 500000,
        media: [],
        reviews: [],
        productEmployeeEligibilities: [],
      }));
      const qb = productRepository.createQueryBuilder();
      qb.getMany.mockResolvedValue(mockProducts);

      // Act
      const result = await service.getPremiumTreatments({
        limit: 13,
        offset: 12,
      });

      // Assert
      expect(qb.skip).toHaveBeenCalledWith(12);
      expect(qb.take).toHaveBeenCalledWith(13);
      expect(result).toHaveLength(13);
    });

    it('should normalize pagination query params received as strings', async () => {
      // Arrange
      const mockProducts = Array.from({ length: 13 }, (_, index) => ({
        id: `uuid-${index + 1}`,
        name: `Product ${index + 1}`,
        slug: `product-${index + 1}`,
        type: 'service',
        basePrice: 500000,
        media: [],
        reviews: [],
        productEmployeeEligibilities: [],
      }));
      const qb = productRepository.createQueryBuilder();
      qb.getMany.mockResolvedValue(mockProducts);

      // Act
      await service.getPremiumTreatments({
        limit: '13',
        offset: '12',
      } as unknown as PublicServiceListQueryDto);

      // Assert
      expect(qb.skip).toHaveBeenCalledWith(12);
      expect(qb.take).toHaveBeenCalledWith(13);
    });

    it('should return empty array when no products exist', async () => {
      // Arrange
      const qb = productRepository.createQueryBuilder();
      qb.getMany.mockResolvedValue([]);

      // Act
      const result = await service.getPremiumTreatments();

      // Assert
      expect(result).toEqual([]);
    });

    it('should narrow clinic and location text filters through Elasticsearch', async () => {
      // Arrange
      elasticsearchBookingService.isAvailable = true;
      elasticsearchBookingService.searchServiceIds
        .mockResolvedValueOnce(['service-1', 'service-2'])
        .mockResolvedValueOnce(['service-2', 'service-3']);
      const qb = productRepository.createQueryBuilder();
      qb.getMany.mockResolvedValue([]);

      // Act
      await service.getPremiumTreatments({
        clinic: 'Healytics',
        district: 'District 1',
      });

      // Assert
      expect(elasticsearchBookingService.searchServiceIds).toHaveBeenCalledWith(
        'Healytics',
        ['clinicNameSearch', 'clinicAddressSearch'],
      );
      expect(elasticsearchBookingService.searchServiceIds).toHaveBeenCalledWith(
        'District 1',
        ['districtName', 'locationText'],
      );
      expect(qb.andWhere).toHaveBeenCalledWith(
        'product.id IN (:...textFilteredServiceIds)',
        { textFilteredServiceIds: ['service-2'] },
      );
    });
  });

  describe('getHomeRecommend', () => {
    it('should query active visible products and return card DTOs', async () => {
      // Arrange
      const mockProducts = [
        {
          id: 'uuid-2',
          name: 'Product 2',
          type: 'package',
          basePrice: 750000,
          media: [],
          reviews: [],
          productEmployeeEligibilities: [],
        },
      ];
      productRepository.find.mockResolvedValue(mockProducts);

      // Act
      const result = await service.getHomeRecommend();

      // Assert
      expect(result).toBeDefined();
      expect(Array.isArray(result)).toBe(true);
      expect(productRepository.find).toHaveBeenCalledWith(
        expect.objectContaining({
          where: { status: 'active', isVisibleOnline: true },
          take: 10,
        }),
      );
    });

    it('should return empty array when no products exist', async () => {
      // Arrange
      productRepository.find.mockResolvedValue([]);

      // Act
      const result = await service.getHomeRecommend();

      // Assert
      expect(result).toEqual([]);
    });
  });
});
