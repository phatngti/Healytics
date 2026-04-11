import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Not, Repository, In } from 'typeorm';
import { CreatePartnerHealthServiceDto } from './dto/partner/create-partner-health-service.dto';
import { UpdatePartnerHealthServiceDto } from './dto/partner/update-partner-health-service.dto';
import { Product } from '@/common/entities/product.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Booking } from '@/common/entities/booking.entity';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { CreateHealthServiceHandler } from './application/handlers/create-health-service.handler';
import { UpdateHealthServiceHandler } from './application/handlers/update-health-service.handler';
import { RemoveHealthServiceHandler } from './application/handlers/remove-health-service.handler';
import { PartnerHealthServiceDetailResponseDto } from './dto/partner/partner-health-service-detail-response.dto';
import { PublicHealthServiceInfoResponseDto } from './dto/public/public-health-service-info-response.dto';
import {
  PublicHealthServiceEmployeeResponseDto,
  PublicHealthServiceEmployeeDayScheduleDto,
  PublicEmployeeTimeSlotDto,
} from './dto/public/public-health-service-employee-response.dto';
import { PublicHealthServiceReviewResponseDto } from './dto/public/public-health-service-review-response.dto';
import { PublicHealthServiceRecommendedResponseDto } from './dto/public/public-health-service-recommended-response.dto';
import { PublicHealthServiceCardResponseDto } from './dto/public/public-health-service-card-response.dto';
import { PublicClinicInfoResponseDto } from './dto/public/public-clinic-info-response.dto';
import { UserEligibilityDetailResponseDto } from './dto/public/user-eligibility-detail-response.dto';
import { PartnersService } from '@/partners/partners.service';
import { HealthServiceStatus } from './enums/health-service-status.enum';
import { HealthServiceType } from './enums/health-service-type.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';

@Injectable()
export class HealthServiceService {
  private readonly logger = new Logger(HealthServiceService.name);

  /** Slot duration in minutes. */
  private readonly SLOT_DURATION_MINUTES = 30;
  /** Number of days ahead to generate schedules for. */
  private readonly SCHEDULE_DAYS_AHEAD = 30;

  constructor(
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
    @InjectRepository(TreatmentReview)
    private readonly treatmentReviewRepository: Repository<TreatmentReview>,
    @InjectRepository(ProductEmployeeEligibility)
    private readonly eligibilityRepository: Repository<ProductEmployeeEligibility>,
    private readonly createHealthServiceHandler: CreateHealthServiceHandler,
    private readonly updateHealthServiceHandler: UpdateHealthServiceHandler,
    private readonly removeHealthServiceHandler: RemoveHealthServiceHandler,
    private readonly partnersService: PartnersService,
  ) {}

  /**
   * Facade: Delegates to CreateHealthServiceHandler
   */
  async create(createDto: CreatePartnerHealthServiceDto): Promise<Product> {
    return this.createHealthServiceHandler.execute(createDto);
  }

  async findAll(): Promise<Product[]> {
    return this.productRepository.find({
      where: {
        type: HealthServiceType.SERVICE,
      },
      relations: [
        'category',
        'media',
        'productDefinition',
        'productEmployeeEligibilities',
        'productEmployeeEligibilities.employee',
      ],
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string): Promise<Product> {
    const product = await this.productRepository.findOne({
      where: { id },
      relations: [
        'category',
        'media',
        'productDefinition',
        'productEmployeeEligibilities',
        'productEmployeeEligibilities.employee',
      ],
    });

    if (!product) {
      this.logger.warn(`Product not found: ${id}`);
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    return product;
  }

  async findBySlug(slug: string): Promise<Product> {
    const product = await this.productRepository.findOne({
      where: { slug },
      relations: [
        'category',
        'media',
        'productDefinition',
        'productEmployeeEligibilities',
        'productEmployeeEligibilities.employee',
      ],
    });

    if (!product) {
      this.logger.warn(`Product slug not found: ${slug}`);
      throw new NotFoundException(`Product with slug "${slug}" not found`);
    }

    return product;
  }

  /**
   * Returns an enriched detail response by slug.
   * Loads all relations and queries recommended services from the same category.
   */
  async getProductDetails(
    slug: string,
  ): Promise<PartnerHealthServiceDetailResponseDto> {
    const product = await this.productRepository.findOne({
      where: { slug },
      relations: [
        'category',
        'media',
        'productDefinition',
        'productEmployeeEligibilities',
        'productEmployeeEligibilities.employee',
        'productEmployeeEligibilities.employee.doctorProfile',
        'productTags',
        'productTags.tag',
        'reviews',
        'facilityImages',
      ],
    });

    if (!product) {
      this.logger.warn(`Product slug not found for details: ${slug}`);
      throw new NotFoundException(`Product with slug "${slug}" not found`);
    }

    // Query recommended services (same category, exclude self, limit 3)
    let recommended: Product[] = [];
    if (product.categoryId) {
      recommended = await this.productRepository.find({
        where: {
          categoryId: product.categoryId,
          id: Not(product.id),
        },
        relations: ['media'],
        take: 3,
        order: { createdAt: 'DESC' },
      });
    }

    return PartnerHealthServiceDetailResponseDto.fromEntity(
      product,
      recommended,
    );
  }

  // ─── Rating Helpers ──────────────────────────────────────────

  /**
   * Returns { rating, count } for a single product, computed by joining
   * product_treatment_reviews → bookings on productId.
   */
  async getProductRatingData(
    productId: string,
  ): Promise<{ rating: number; count: number }> {
    const result = await this.treatmentReviewRepository
      .createQueryBuilder('tr')
      .innerJoin('tr.booking', 'b')
      .where('b.product_id = :productId', { productId })
      .select('AVG(tr.rating)', 'avg')
      .addSelect('COUNT(tr.id)', 'count')
      .getRawOne<{ avg: string | null; count: string }>();

    const count = parseInt(result?.count ?? '0', 10);
    const rating =
      count > 0 ? Math.round(parseFloat(result?.avg ?? '0') * 10) / 10 : 0;
    return { rating, count };
  }

  /**
   * Bulk version — returns a Map<productId, { rating, count }> for a set of products.
   * Used by listing endpoints to avoid N+1 queries.
   */
  private async buildRatingsMap(
    productIds: string[],
  ): Promise<Map<string, { rating: number; count: number }>> {
    if (!productIds.length) return new Map();

    const rows = await this.treatmentReviewRepository
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

  /**
   * Returns info (service info) for the user detail screen.
   * Loads the health_partner's profile to populate clinic info.
   */
  async getProductInfo(
    id: string,
  ): Promise<PublicHealthServiceInfoResponseDto> {
    const product = await this.productRepository.findOne({
      where: { id },
      relations: [
        'category',
        'media',
        'productTags',
        'productTags.tag',
        'facilityImages',
        'partner',
        'partner.province',
        'partner.district',
        'partner.ward',
      ],
    });

    if (!product) {
      this.logger.warn(`Product not found for info: ${id}`);
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    const ratingData = await this.getProductRatingData(id);

    return PublicHealthServiceInfoResponseDto.fromEntity(
      product,
      product.partner,
      ratingData,
    );
  }

  /**
   * Returns the list of eligible employees for a service, with real
   * day-by-day booking schedules derived from the employee's work schedule
   * and existing bookings.
   */
  async getProductEmployees(
    id: string,
  ): Promise<PublicHealthServiceEmployeeResponseDto[]> {
    const product = await this.productRepository.findOne({
      where: { id },
      relations: [
        'productEmployeeEligibilities',
        'productEmployeeEligibilities.employee',
        'productEmployeeEligibilities.employee.doctorProfile',
        'productEmployeeEligibilities.employee.therapistProfile',
      ],
    });

    if (!product) {
      this.logger.warn(`Product not found for employees: ${id}`);
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    const eligibilities = product.productEmployeeEligibilities ?? [];

    if (eligibilities.length === 0) {
      return [];
    }

    // Determine which employee is "selected" (primary or first)
    const primaryEligibility = eligibilities.find((e) => e.isPrimary);
    const selectedEmployeeId =
      primaryEligibility?.employeeId ?? eligibilities[0]?.employeeId;

    // Date range: today → +30 days
    const now = new Date();
    const rangeStart = new Date(
      now.getFullYear(),
      now.getMonth(),
      now.getDate(),
    );
    const rangeEnd = new Date(rangeStart);
    rangeEnd.setDate(rangeEnd.getDate() + this.SCHEDULE_DAYS_AHEAD);

    // Fetch non-cancelled bookings for all employees in the date range
    const employeeIds = eligibilities.map((e) => e.employeeId);
    const bookings = await this.bookingRepository.find({
      where: {
        staffId: In(employeeIds),
        status: Not(BookingStatus.CANCELLED),
      },
    });

    // Index bookings by staffId → Set<ISO-date-time-key>
    const bookedSlotsByEmployee = this.indexBookedSlots(
      bookings,
      rangeStart,
      rangeEnd,
    );

    // Build response — filter out any eligibilities whose employee relation is missing
    return eligibilities
      .filter((elig) => elig.employee != null)
      .map((elig) => {
        const employee = elig.employee;
        const daySchedules = this.buildDaySchedules(
          employee.schedule ?? [],
          bookedSlotsByEmployee.get(employee.id) ?? new Set(),
          rangeStart,
        );

        return PublicHealthServiceEmployeeResponseDto.fromEntity(employee, {
          eligibilityId: elig.id,
          isSelected: employee.id === selectedEmployeeId,
          daySchedules,
        });
      });
  }

  /**
   * Returns the list of treatment reviews for a service.
   * Queries product_treatment_reviews via bookings.product_id.
   * Loads user → userProfile for reviewer name.
   */
  async getProductReviews(
    id: string,
  ): Promise<PublicHealthServiceReviewResponseDto[]> {
    // Verify the product exists first
    const productExists = await this.productRepository.count({ where: { id } });
    if (!productExists) {
      this.logger.warn(`Product not found for reviews: ${id}`);
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    const reviews = await this.treatmentReviewRepository
      .createQueryBuilder('tr')
      .innerJoin('tr.booking', 'b')
      .innerJoinAndSelect('tr.user', 'account')
      .where('b.product_id = :id', { id })
      .orderBy('tr.createdAt', 'DESC')
      .getMany();

    return PublicHealthServiceReviewResponseDto.fromEntities(reviews);
  }

  /**
   * Returns recommended services from the same category.
   */
  async getRecommendedProducts(
    id: string,
  ): Promise<PublicHealthServiceRecommendedResponseDto[]> {
    const product = await this.productRepository.findOne({
      where: { id },
      select: ['id', 'categoryId'],
    });

    if (!product) {
      this.logger.warn(`Product not found for recommendations: ${id}`);
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    if (!product.categoryId) {
      return [];
    }

    const recommended = await this.productRepository.find({
      where: {
        categoryId: product.categoryId,
        id: Not(product.id),
      },
      relations: ['media'],
      take: 5,
      order: { createdAt: 'DESC' },
    });

    const ratingsMap = await this.buildRatingsMap(recommended.map((p) => p.id));
    return PublicHealthServiceRecommendedResponseDto.fromEntities(
      recommended,
      ratingsMap,
    );
  }

  // ─── Clinic Info ─────────────────────────────────────────────

  /**
   * Returns a public clinic profile by partner ID.
   * Aggregates employees, products, and ratings into
   * the clinic info response.
   */
  async getClinicInfo(
    partnerId: string,
  ): Promise<PublicClinicInfoResponseDto> {
    const partner = await this.partnersService.findOneById(partnerId);

    if (!partner) {
      this.logger.warn(`Partner not found for clinic info: ${partnerId}`);
      throw new NotFoundException(
        `Clinic with ID ${partnerId} not found`,
      );
    }

    const products = await this.productRepository.find({
      where: { partnerId: partner.id },
      relations: ['media', 'facilityImages'],
      order: { createdAt: 'DESC' },
      take: 10,
    });

    const employees = await this.productRepository.manager
      .getRepository(Employee)
      .find({
        where: { partnerId: partner.id },
        take: 10,
      });

    const ratingsMap = await this.buildRatingsMap(
      products.map((p) => p.id),
    );

    return PublicClinicInfoResponseDto.fromPartner(
      partner,
      employees,
      products,
      ratingsMap,
    );
  }

  // ─── User-authenticated Eligibility Endpoint ────────────────

  /**
   * Returns enriched eligibility detail — category, product, and employee info —
   * looked up by the surrogate PK on product_employee_eligibility.
   */
  async getEligibilityDetail(
    eligibilityId: string,
  ): Promise<UserEligibilityDetailResponseDto> {
    const eligibility = await this.eligibilityRepository.findOne({
      where: { id: eligibilityId },
      relations: [
        'product',
        'product.category',
        'product.media',
        'product.productDefinition',
        'employee',
        'employee.doctorProfile',
      ],
    });

    if (!eligibility) {
      this.logger.warn(`Eligibility not found: ${eligibilityId}`);
      throw new NotFoundException(
        `Eligibility with ID ${eligibilityId} not found`,
      );
    }

    const partner = await this.partnersService.getFirstHealthPartner();

    return UserEligibilityDetailResponseDto.fromEntity(eligibility, partner);
  }

  // ─── Public Listing Endpoints ───────────────────────────────

  /** Common relations needed for card DTO mapping. */
  private readonly cardRelations = [
    'category',
    'media',
    'productDefinition',
    'productEmployeeEligibilities',
    'productEmployeeEligibilities.employee',
  ];

  /**
   * Returns premium treatment services (active, visible, highest rated).
   */
  async getPremiumTreatments(): Promise<PublicHealthServiceCardResponseDto[]> {
    const products = await this.productRepository.find({
      where: {
        status: HealthServiceStatus.ACTIVE,
        isVisibleOnline: true,
      },
      relations: this.cardRelations,
      take: 10,
      order: { createdAt: 'DESC' },
    });

    const [partner, ratingsMap] = await Promise.all([
      this.partnersService.getFirstHealthPartner(),
      this.buildRatingsMap(products.map((p) => p.id)),
    ]);
    return PublicHealthServiceCardResponseDto.fromEntities(
      products,
      partner,
      ratingsMap,
    );
  }

  /**
   * Returns home-recommended services (active, visible, newest first).
   */
  async getHomeRecommend(): Promise<PublicHealthServiceCardResponseDto[]> {
    const products = await this.productRepository.find({
      where: {
        status: HealthServiceStatus.ACTIVE,
        isVisibleOnline: true,
      },
      relations: this.cardRelations,
      take: 10,
      order: { createdAt: 'DESC' },
    });

    const [partner, ratingsMap] = await Promise.all([
      this.partnersService.getFirstHealthPartner(),
      this.buildRatingsMap(products.map((p) => p.id)),
    ]);
    return PublicHealthServiceCardResponseDto.fromEntities(
      products,
      partner,
      ratingsMap,
    );
  }

  /**
   * Facade: Delegates to UpdateHealthServiceHandler
   */
  async update(
    id: string,
    updateDto: UpdatePartnerHealthServiceDto,
  ): Promise<Product> {
    return this.updateHealthServiceHandler.execute(id, updateDto);
  }

  /**
   * Facade: Delegates to RemoveHealthServiceHandler
   */
  async remove(id: string): Promise<void> {
    return this.removeHealthServiceHandler.execute(id);
  }

  // ─── Private Schedule Helpers ──────────────────────────────

  /** Day-of-week names matching the employee schedule JSONB keys. */
  private static readonly DAY_NAMES = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  /**
   * Indexes bookings into a Map<employeeId, Set<slotKey>>.
   * Each slotKey is `YYYY-MM-DD|HH:mm` for fast lookup.
   */
  private indexBookedSlots(
    bookings: Booking[],
    rangeStart: Date,
    rangeEnd: Date,
  ): Map<string, Set<string>> {
    const map = new Map<string, Set<string>>();

    for (const booking of bookings) {
      const startTime = new Date(booking.startTime);
      if (startTime < rangeStart || startTime >= rangeEnd) continue;

      if (!map.has(booking.staffId)) {
        map.set(booking.staffId, new Set());
      }

      const dateStr = this.formatDate(startTime);
      const timeStr = this.formatTime24(startTime);
      map.get(booking.staffId)!.add(`${dateStr}|${timeStr}`);
    }

    return map;
  }

  /**
   * Builds 30-day schedules for an employee from their weekly schedule
   * and a set of already-booked slot keys.
   */
  private buildDaySchedules(
    weeklySchedule: {
      day: string;
      start: string;
      end: string;
      isWorking: boolean;
    }[],
    bookedSlots: Set<string>,
    rangeStart: Date,
  ): PublicHealthServiceEmployeeDayScheduleDto[] {
    // Index weekly schedule by day name for O(1) lookup
    const scheduleByDay = new Map<
      string,
      { start: string; end: string; isWorking: boolean }
    >();
    for (const entry of weeklySchedule) {
      scheduleByDay.set(entry.day, entry);
    }

    const days: PublicHealthServiceEmployeeDayScheduleDto[] = [];

    for (let i = 0; i < this.SCHEDULE_DAYS_AHEAD; i++) {
      const date = new Date(rangeStart);
      date.setDate(date.getDate() + i);

      const dayName = HealthServiceService.DAY_NAMES[date.getDay()];
      const dateStr = this.formatDate(date);
      const entry = scheduleByDay.get(dayName);

      if (!entry || !entry.isWorking || !entry.start || !entry.end) {
        days.push({ date: dateStr, isAvailable: false, timeSlots: [] });
        continue;
      }

      const timeSlots = this.generateTimeSlots(
        entry.start,
        entry.end,
        dateStr,
        bookedSlots,
      );
      const isAvailable = timeSlots.some((s) => s.isAvailable);

      days.push({ date: dateStr, isAvailable, timeSlots });
    }

    return days;
  }

  /**
   * Generates 30-minute time slots between startTime and endTime (24h format "HH:mm"),
   * marking each as available/booked based on the bookedSlots set.
   */
  private generateTimeSlots(
    startTime: string,
    endTime: string,
    dateStr: string,
    bookedSlots: Set<string>,
  ): PublicEmployeeTimeSlotDto[] {
    const [startH, startM] = startTime.split(':').map(Number);
    const [endH, endM] = endTime.split(':').map(Number);

    const startMinutes = startH * 60 + startM;
    const endMinutes = endH * 60 + endM;

    const slots: PublicEmployeeTimeSlotDto[] = [];

    for (
      let m = startMinutes;
      m < endMinutes;
      m += this.SLOT_DURATION_MINUTES
    ) {
      const h = Math.floor(m / 60);
      const min = m % 60;

      const time24 = `${String(h).padStart(2, '0')}:${String(min).padStart(2, '0')}`;
      const label = this.formatTime12(h, min);
      const slotKey = `${dateStr}|${time24}`;

      slots.push({
        label,
        isAvailable: !bookedSlots.has(slotKey),
      });
    }

    return slots;
  }

  /** Formats a Date to YYYY-MM-DD. */
  private formatDate(date: Date): string {
    const y = date.getFullYear();
    const m = String(date.getMonth() + 1).padStart(2, '0');
    const d = String(date.getDate()).padStart(2, '0');
    return `${y}-${m}-${d}`;
  }

  /** Formats a Date's time to HH:mm (24h). */
  private formatTime24(date: Date): string {
    return `${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`;
  }

  /** Converts 24h hour/minute to 12h format label (e.g. "09:00 AM"). */
  private formatTime12(hour: number, minute: number): string {
    const period = hour >= 12 ? 'PM' : 'AM';
    const h12 = hour === 0 ? 12 : hour > 12 ? hour - 12 : hour;
    return `${String(h12).padStart(2, '0')}:${String(minute).padStart(2, '0')} ${period}`;
  }
}
