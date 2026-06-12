import {
  Injectable,
  Logger,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, FindOptionsWhere, Not, In, Between } from 'typeorm';
import { CreateDoctorDto } from './dto/create-doctor.dto';
import {
  CreateSpaTherapistDto,
  CreateMassageTherapistDto,
} from './dto/create-therapist.dto';
import { UpdateEmployeeDto } from './dto/update-employee.dto';
import {
  EmployeeListSort,
  GetEmployeesQueryDto,
} from './dto/get-employees-query.dto';
import { GetTimeSlotsQueryDto } from './dto/get-time-slots-query.dto';
import { Employee } from '@/common/entities/employee.entity';
import { Partner } from '@/common/entities/partner.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { Booking } from '@/common/entities/booking.entity';
import { SpecialistReview } from '@/common/entities/specialist-review.entity';
import { SkillCatalog } from '@/common/entities/skill-catalog.entity';
import { BookingServiceResponseDto } from './dto/booking-service-response.dto';
import {
  CreateSkillDto,
  SkillCatalogResponseDto,
} from './dto/skill-catalog.dto';
import { FeaturedSpecialistResponseDto } from './dto/featured-specialist-response.dto';
import {
  EmployeeTimeSlotsResponseDto,
  DayScheduleDto,
  TimeSlotDto,
} from './dto/employee-time-slots-response.dto';
import { EmployeeStatus } from './enum/employee-status.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';
import { PartnersService } from '@/partners/partners.service';
import { CreateDoctorHandler } from './application/handlers/create-doctor.handler';
import { CreateTherapistHandler } from './application/handlers/create-therapist.handler';
import { UpdateEmployeeHandler } from './application/handlers/update-employee.handler';
import { RemoveEmployeeHandler } from './application/handlers/remove-employee.handler';
import { GetEmployeeOverviewAnalyticsHandler } from './application/handlers/get-employee-overview-analytics.handler';
import { GetEmployeeDetailAnalyticsHandler } from './application/handlers/get-employee-detail-analytics.handler';
import { DashboardTimePeriod } from '@/dashboard-partner/dto/query/dashboard-period-query.dto';
import { EmployeeOverviewAnalyticsResponseDto } from './dto/analytics/employee-overview-analytics.dto';
import { EmployeeDetailAnalyticsResponseDto } from './dto/analytics/employee-detail-analytics.dto';
import { EmployeeAssignedServiceDto } from './dto/employee-assigned-service.dto';
import { PublicEmployeeReviewResponseDto } from './dto/public-employee-review-response.dto';

/**
 * Service facade for managing employees (doctors, therapists, staff).
 * Delegates mutation operations to dedicated handlers.
 */
@Injectable()
export class EmployeesService {
  private readonly logger = new Logger(EmployeesService.name);

  /** Slot duration in minutes. */
  private readonly SLOT_DURATION_MINUTES = 30;
  /** Default number of days ahead to return. */
  private readonly DEFAULT_DAYS_AHEAD = 7;
  /** Business timezone used for employee schedules and booking slots. */
  private static readonly BUSINESS_TIME_ZONE = 'Asia/Ho_Chi_Minh';

  constructor(
    @InjectRepository(Employee)
    private readonly employeeRepository: Repository<Employee>,
    @InjectRepository(Partner)
    private readonly partnerRepository: Repository<Partner>,
    @InjectRepository(ProductEmployeeEligibility)
    private readonly eligibilityRepository: Repository<ProductEmployeeEligibility>,
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
    @InjectRepository(SpecialistReview)
    private readonly specialistReviewRepository: Repository<SpecialistReview>,
    @InjectRepository(SkillCatalog)
    private readonly skillCatalogRepository: Repository<SkillCatalog>,
    private readonly partnersService: PartnersService,
    private readonly createDoctorHandler: CreateDoctorHandler,
    private readonly createTherapistHandler: CreateTherapistHandler,
    private readonly updateEmployeeHandler: UpdateEmployeeHandler,
    private readonly removeEmployeeHandler: RemoveEmployeeHandler,
    private readonly getEmployeeOverviewAnalyticsHandler: GetEmployeeOverviewAnalyticsHandler,
    private readonly getEmployeeDetailAnalyticsHandler: GetEmployeeDetailAnalyticsHandler,
  ) {}

  // ──────────────────────────────────────────────────────────────
  // Partner resolution
  // ──────────────────────────────────────────────────────────────

  /**
   * Resolves the partner ID from the authenticated account ID.
   * @throws NotFoundException if no partner profile exists for the account
   */
  async getPartnerIdByAccountId(accountId: string): Promise<string> {
    const partner = await this.partnerRepository.findOne({
      where: { accountId },
      select: ['id'],
    });
    if (!partner) {
      this.logger.warn(`Partner not found for account: ${accountId}`);
      throw new NotFoundException(
        `Partner profile not found for account ${accountId}`,
      );
    }
    return partner.id;
  }

  // ──────────────────────────────────────────────────────────────
  // Create operations
  // ──────────────────────────────────────────────────────────────

  /**
   * Facade: Delegates to CreateDoctorHandler.
   */
  async createDoctor(
    createDoctorDto: CreateDoctorDto,
    partnerId?: string,
  ): Promise<Employee> {
    const dtoWithPartner = partnerId
      ? { ...createDoctorDto, partnerId }
      : createDoctorDto;
    return this.createDoctorHandler.execute(dtoWithPartner);
  }

  /**
   * Facade: Delegates to CreateTherapistHandler for SPA type.
   */
  async createSpaTherapist(
    dto: CreateSpaTherapistDto,
    partnerId?: string,
  ): Promise<Employee> {
    const dtoWithPartner = partnerId ? { ...dto, partnerId } : dto;
    return this.createTherapistHandler.execute(dtoWithPartner, 'SPA');
  }

  /**
   * Facade: Delegates to CreateTherapistHandler for MASSAGE type.
   */
  async createMassageTherapist(
    dto: CreateMassageTherapistDto,
    partnerId?: string,
  ): Promise<Employee> {
    const dtoWithPartner = partnerId ? { ...dto, partnerId } : dto;
    return this.createTherapistHandler.execute(dtoWithPartner, 'MASSAGE');
  }

  // ──────────────────────────────────────────────────────────────
  // Read operations
  // ──────────────────────────────────────────────────────────────

  /**
   * Retrieves all employees with optional role filter.
   */
  async findAll(
    query?: GetEmployeesQueryDto,
    partnerId?: string,
  ): Promise<Employee[]> {
    const qb = this.employeeRepository
      .createQueryBuilder('employee')
      .leftJoinAndSelect('employee.doctorProfile', 'doctorProfile')
      .leftJoinAndSelect('employee.therapistProfile', 'therapistProfile')
      .leftJoinAndSelect('employee.partner', 'partner')
      .leftJoinAndSelect('partner.province', 'province')
      .leftJoinAndSelect('partner.district', 'district')
      .leftJoinAndSelect('partner.ward', 'ward');

    if (query?.role) {
      qb.andWhere('employee.role = :role', { role: query.role });
    }
    if (partnerId || query?.clinicId) {
      qb.andWhere('employee.partner_id = :partnerId', {
        partnerId: partnerId ?? query?.clinicId,
      });
    }
    if (query?.provinceId) {
      qb.andWhere('partner.province_id = :provinceId', {
        provinceId: query.provinceId,
      });
    }
    if (query?.districtId) {
      qb.andWhere('partner.district_id = :districtId', {
        districtId: query.districtId,
      });
    }
    if (query?.wardId) {
      qb.andWhere('partner.ward_id = :wardId', { wardId: query.wardId });
    }
    if (query?.minExperienceYears != null) {
      qb.andWhere(
        `COALESCE(
          doctorProfile.experience_years,
          FLOOR(EXTRACT(YEAR FROM AGE(CURRENT_DATE, employee.start_date)))
        ) >= :minExperienceYears`,
        { minExperienceYears: query.minExperienceYears },
      );
    }

    switch (query?.sort) {
      case EmployeeListSort.RATING_DESC:
        qb.orderBy('employee.rating', 'DESC').addOrderBy(
          'employee.review_count',
          'DESC',
        );
        break;
      case EmployeeListSort.REVIEWS_DESC:
        qb.orderBy('employee.review_count', 'DESC').addOrderBy(
          'employee.rating',
          'DESC',
        );
        break;
      case EmployeeListSort.EXPERIENCE_DESC:
        qb.orderBy(
          `COALESCE(
            doctorProfile.experience_years,
            FLOOR(EXTRACT(YEAR FROM AGE(CURRENT_DATE, employee.start_date))),
            0
          )`,
          'DESC',
        );
        break;
      case EmployeeListSort.DEFAULT:
      default:
        qb.orderBy('employee.created_at', 'DESC');
        break;
    }

    const employees = await qb.getMany();
    return employees.map((employee) =>
      this.normalizeEmployeeResponse(employee),
    );
  }

  /**
   * Finds an employee by ID.
   */
  async findOne(id: string): Promise<Employee> {
    const employee = await this.employeeRepository.findOne({
      where: { id },
      relations: [
        'doctorProfile',
        'therapistProfile',
        'partner',
        'partner.province',
        'partner.district',
        'partner.ward',
      ],
    });
    if (!employee) {
      this.logger.warn(`Employee not found: ${id}`);
      throw new NotFoundException(`Employee with ID ${id} not found`);
    }

    return this.normalizeEmployeeResponse(employee);
  }

  /**
   * Returns public reviews for an employee/specialist.
   */
  async findReviewsByEmployee(
    id: string,
  ): Promise<PublicEmployeeReviewResponseDto[]> {
    const employee = await this.employeeRepository.findOne({
      where: { id },
      select: ['id'],
    });
    if (!employee) {
      this.logger.warn(`Employee not found for reviews: ${id}`);
      throw new NotFoundException(`Employee with ID ${id} not found`);
    }

    const reviews = await this.specialistReviewRepository
      .createQueryBuilder('review')
      .innerJoinAndSelect('review.user', 'account')
      .leftJoinAndSelect('account.userProfile', 'profile')
      .where('review.specialist_id = :id', { id })
      .orderBy('review.createdAt', 'DESC')
      .getMany();

    return PublicEmployeeReviewResponseDto.fromEntities(reviews);
  }

  /**
   * Finds an employee by ID scoped to a specific partner.
   */
  async findOneForPartner(id: string, partnerId: string): Promise<Employee> {
    const employee = await this.employeeRepository.findOne({
      where: { id, partnerId },
      relations: [
        'doctorProfile',
        'therapistProfile',
        'partner',
        'partner.province',
        'partner.district',
        'partner.ward',
      ],
    });
    if (!employee) {
      this.logger.warn(`Employee ${id} not found for partner ${partnerId}`);
      throw new NotFoundException(`Employee with ID ${id} not found`);
    }
    return this.normalizeEmployeeResponse(employee);
  }

  /**
   * Returns service assignments for a partner-owned employee.
   *
   * An existing employee with no assignments returns an empty list; unknown or
   * cross-partner employees still fail through findOneForPartner.
   */
  async findAssignedServicesForPartner(
    employeeId: string,
    partnerId: string,
  ): Promise<EmployeeAssignedServiceDto[]> {
    await this.findOneForPartner(employeeId, partnerId);

    const eligibilities = await this.eligibilityRepository
      .createQueryBuilder('eligibility')
      .innerJoinAndSelect(
        'eligibility.product',
        'product',
        'product.partner_id = :partnerId AND product.deleted_at IS NULL',
        { partnerId },
      )
      .leftJoinAndSelect('product.productDefinition', 'productDefinition')
      .leftJoinAndSelect('product.category', 'category')
      .leftJoinAndSelect('product.media', 'media')
      .where('eligibility.employee_id = :employeeId', { employeeId })
      .orderBy('eligibility.is_primary', 'DESC')
      .addOrderBy('product.name', 'ASC')
      .addOrderBy('media.sort_order', 'ASC')
      .getMany();

    return eligibilities.map((eligibility) =>
      EmployeeAssignedServiceDto.fromEligibility(eligibility),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Mutation operations
  // ──────────────────────────────────────────────────────────────

  /**
   * Facade: Delegates to UpdateEmployeeHandler.
   */
  async update(
    id: string,
    updateEmployeeDto: UpdateEmployeeDto,
  ): Promise<Employee> {
    const employee = await this.updateEmployeeHandler.execute(
      id,
      updateEmployeeDto,
    );
    return this.normalizeEmployeeResponse(employee);
  }

  /**
   * Updates an employee scoped to a specific partner.
   * Verifies ownership before delegating to the handler.
   */
  async updateForPartner(
    id: string,
    partnerId: string,
    updateEmployeeDto: UpdateEmployeeDto,
  ): Promise<Employee> {
    await this.findOneForPartner(id, partnerId);
    const employee = await this.updateEmployeeHandler.execute(
      id,
      updateEmployeeDto,
    );
    return this.normalizeEmployeeResponse(employee);
  }

  /**
   * Facade: Delegates to RemoveEmployeeHandler.
   */
  async remove(id: string): Promise<void> {
    return this.removeEmployeeHandler.execute(id);
  }

  /**
   * Removes an employee scoped to a specific partner.
   * Verifies ownership before delegating to the handler.
   */
  async removeForPartner(id: string, partnerId: string): Promise<void> {
    await this.findOneForPartner(id, partnerId);
    return this.removeEmployeeHandler.execute(id);
  }

  // ──────────────────────────────────────────────────────────────
  // Skill catalog operations
  // ──────────────────────────────────────────────────────────────

  /**
   * Returns all skills of a given type for the partner.
   */
  async getSkillsByType(
    partnerId: string,
    type: string,
  ): Promise<SkillCatalogResponseDto[]> {
    const skills = await this.skillCatalogRepository.find({
      where: { partnerId, type },
      order: { label: 'ASC' },
    });
    return skills.map((s) => ({ key: s.slug, label: s.label }));
  }

  /**
   * Creates a new skill in the catalog for the partner.
   * Normalizes the name to a slug and checks for duplicates.
   */
  async createSkill(
    partnerId: string,
    dto: CreateSkillDto,
    type: string,
  ): Promise<SkillCatalogResponseDto> {
    const slug = dto.name
      .trim()
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '_')
      .replace(/^_|_$/g, '');

    const existing = await this.skillCatalogRepository.findOne({
      where: { partnerId, slug, type },
    });
    if (existing) {
      throw new ConflictException(`Skill '${dto.name}' already exists`);
    }

    const skill = this.skillCatalogRepository.create({
      partnerId,
      slug,
      label: dto.name.trim(),
      type,
    });
    const saved = await this.skillCatalogRepository.save(skill);
    this.logger.log(
      `Created ${type} skill '${saved.label}' ` + `for partner ${partnerId}`,
    );
    return { key: saved.slug, label: saved.label };
  }

  // ──────────────────────────────────────────────────────────────
  // Analytics operations
  // ──────────────────────────────────────────────────────────────

  /**
   * Returns overview analytics for all employees of the authenticated partner.
   */
  async getOverviewAnalytics(
    accountId: string,
    period: DashboardTimePeriod,
  ): Promise<EmployeeOverviewAnalyticsResponseDto> {
    const partnerId = await this.getPartnerIdByAccountId(accountId);
    return this.getEmployeeOverviewAnalyticsHandler.execute(partnerId, period);
  }

  /**
   * Returns per-employee detail analytics for a specific employee.
   */
  async getDetailAnalytics(
    accountId: string,
    employeeId: string,
    period: DashboardTimePeriod,
  ): Promise<EmployeeDetailAnalyticsResponseDto> {
    const partnerId = await this.getPartnerIdByAccountId(accountId);
    return this.getEmployeeDetailAnalyticsHandler.execute(
      partnerId,
      employeeId,
      period,
    );
  }

  private normalizeEmployeeResponse(employee: Employee): Employee {
    employee.verificationDocuments = employee.verificationDocuments ?? [];
    employee.schedule = employee.schedule ?? [];
    employee.workHistory = employee.workHistory ?? [];

    if (employee.doctorProfile) {
      employee.doctorProfile.medicalCredentials =
        employee.doctorProfile.medicalCredentials ?? [];
      employee.doctorProfile.specializations =
        employee.doctorProfile.specializations ?? [];
      employee.doctorProfile.education = employee.doctorProfile.education ?? [];
      employee.doctorProfile.certifications =
        employee.doctorProfile.certifications ?? [];
    }

    if (employee.therapistProfile) {
      employee.therapistProfile.skills = employee.therapistProfile.skills ?? [];
      employee.therapistProfile.deviceProficiency =
        employee.therapistProfile.deviceProficiency ?? [];
    }

    const response = employee as Employee & {
      clinicId: string | null;
      clinicName: string | null;
      location: string | null;
      experienceYears: number | null;
    };
    response.clinicId = employee.partner?.id ?? employee.partnerId ?? null;
    response.clinicName = employee.partner?.brandName ?? null;
    response.location = employee.partner
      ? [
          employee.partner.district?.fullName,
          employee.partner.province?.fullName,
        ]
          .filter(Boolean)
          .join(', ')
      : null;
    response.experienceYears =
      employee.doctorProfile?.experienceYears ??
      this.calculateExperienceYears(employee.startDate);

    return employee;
  }

  private calculateExperienceYears(startDate?: Date | null): number | null {
    if (!startDate) return null;
    const start = new Date(startDate);
    if (Number.isNaN(start.getTime())) return null;
    const now = new Date();
    let years = now.getFullYear() - start.getFullYear();
    const hasNotReachedAnniversary =
      now.getMonth() < start.getMonth() ||
      (now.getMonth() === start.getMonth() && now.getDate() < start.getDate());
    if (hasNotReachedAnniversary) years -= 1;
    return Math.max(years, 0);
  }

  // ──────────────────────────────────────────────────────────────
  // Booking flow operations
  // ──────────────────────────────────────────────────────────────

  /** Cached first health partner (changes extremely rarely). */
  private cachedFirstPartner: Partner | null = null;
  private cachedFirstPartnerTime = 0;
  /** Cache TTL for the first health partner — 5 minutes */
  private static readonly PARTNER_CACHE_TTL_MS = 5 * 60 * 1000;

  /**
   * Returns all services (products) that a specialist can perform.
   * Query path: ProductEmployeeEligibility → Product (with definition + media).
   * Includes clinic info from the health partner profile.
   *
   * Optimized: removed redundant employee existence check (the eligibility
   * query result already indicates whether the specialist exists), and
   * cached getFirstHealthPartner() to avoid 2 DB queries per request.
   */
  async findServicesBySpecialist(
    specialistId: string,
  ): Promise<BookingServiceResponseDto[]> {
    // Query eligible products with their definitions and media
    const eligibilities = await this.eligibilityRepository.find({
      where: { employeeId: specialistId },
      relations: ['product', 'product.productDefinition', 'product.media'],
    });

    // If no eligibilities, specialist either doesn't exist or has no services
    if (eligibilities.length === 0) {
      this.logger.warn(`No services found for specialist: ${specialistId}`);
      throw new NotFoundException(
        `Specialist with ID ${specialistId} not found`,
      );
    }

    // Filter to active products only
    const activeProducts = eligibilities
      .map((e) => e.product)
      .filter((p) => p && p.status === HealthServiceStatus.ACTIVE);

    // Load partner for clinic info — cached for 5 minutes
    const now = Date.now();
    if (
      !this.cachedFirstPartner ||
      now - this.cachedFirstPartnerTime > EmployeesService.PARTNER_CACHE_TTL_MS
    ) {
      this.cachedFirstPartner =
        await this.partnersService.getFirstHealthPartner();
      this.cachedFirstPartnerTime = now;
    }

    return BookingServiceResponseDto.fromEntities(
      activeProducts,
      this.cachedFirstPartner,
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Time slots
  // ──────────────────────────────────────────────────────────────

  /**
   * Returns all configured time slots for an employee, with each slot
   * marked as 'free' or 'busy' based on existing non-cancelled bookings.
   */
  async getTimeSlots(
    employeeId: string,
    query: GetTimeSlotsQueryDto,
  ): Promise<EmployeeTimeSlotsResponseDto> {
    // 1. load the employee
    const employee = await this.employeeRepository.findOne({
      where: { id: employeeId },
    });
    if (!employee) {
      this.logger.warn(`Employee not found for time-slots: ${employeeId}`);
      throw new NotFoundException(`Employee with ID ${employeeId} not found`);
    }

    // 2. Determine date range
    const days = query.days ?? this.DEFAULT_DAYS_AHEAD;
    const rangeStart = this.startOfBusinessDayUtc(query.date);
    const rangeEnd = this.addUtcDays(rangeStart, days);

    // 3. Fetch non-cancelled bookings for this employee in the range
    const bookings = await this.bookingRepository.find({
      where: {
        staffId: employeeId,
        status: Not(In([BookingStatus.CANCELLED, BookingStatus.COMPLETED])),
        startTime: Between(rangeStart, rangeEnd),
      },
    });

    // 4. Index booked slots into a Set<"YYYY-MM-DD|HH:mm">
    const bookedSlots = this.indexBookedSlotsForEmployee(
      bookings,
      rangeStart,
      rangeEnd,
    );

    // 5. Build day-by-day schedule
    const weeklySchedule = employee.schedule ?? [];
    const scheduleByDay = new Map<
      string,
      { start: string; end: string; isWorking: boolean }
    >();
    for (const entry of weeklySchedule) {
      scheduleByDay.set(entry.day, entry);
    }

    const schedule: DayScheduleDto[] = [];
    for (let i = 0; i < days; i++) {
      const date = this.addUtcDays(rangeStart, i);

      const dayName = this.formatDayName(date);
      const dateStr = this.formatDate(date);
      const entry = scheduleByDay.get(dayName);

      if (!entry || !entry.isWorking || !entry.start || !entry.end) {
        schedule.push({
          date: dateStr,
          dayOfWeek: dayName,
          isWorkingDay: false,
          slots: [],
        });
        continue;
      }

      const slots = this.generateSlots(
        entry.start,
        entry.end,
        dateStr,
        bookedSlots,
      );
      schedule.push({
        date: dateStr,
        dayOfWeek: dayName,
        isWorkingDay: true,
        slots,
      });
    }

    // 6. Build response
    const response = new EmployeeTimeSlotsResponseDto();
    response.employeeId = employee.id;
    response.employeeName = employee.fullName;
    response.slotDurationMinutes = this.SLOT_DURATION_MINUTES;
    response.schedule = schedule;
    response.rangeStart = this.formatDate(rangeStart);
    response.rangeEnd = this.formatDate(rangeEnd);

    return response;
  }

  // ──────────────────────────────────────────────────────────────
  // Featured specialists (home page)
  // ──────────────────────────────────────────────────────────────

  /**
   * Returns featured specialists for the home page, ranked by
   * completed booking count (sold count) then rating.
   */
  async getFeaturedSpecialists(
    limit = 10,
  ): Promise<FeaturedSpecialistResponseDto[]> {
    // 1. Load active employees with partner relation
    const employees = await this.employeeRepository.find({
      where: { status: EmployeeStatus.ACTIVE },
      relations: ['partner'],
    });

    if (employees.length === 0) return [];

    // 2. Aggregate completed booking counts per employee
    const soldCounts: { staff_id: string; count: string }[] =
      await this.bookingRepository
        .createQueryBuilder('booking')
        .select('booking.staff_id', 'staff_id')
        .addSelect('COUNT(*)::int', 'count')
        .where('booking.staff_id IN (:...ids)', {
          ids: employees.map((e) => e.id),
        })
        .andWhere('booking.status = :status', {
          status: BookingStatus.COMPLETED,
        })
        .groupBy('booking.staff_id')
        .getRawMany();

    const soldMap = new Map<string, number>(
      soldCounts.map((row) => [row.staff_id, Number(row.count)]),
    );

    // 3. Sort by sold count DESC, then rating DESC, take limit
    const sorted = employees
      .map((emp) => ({ employee: emp, sold: soldMap.get(emp.id) ?? 0 }))
      .sort(
        (a, b) =>
          b.sold - a.sold ||
          Number(b.employee.rating) - Number(a.employee.rating),
      )
      .slice(0, limit);

    return sorted.map(({ employee, sold }) =>
      FeaturedSpecialistResponseDto.fromEntity(employee, sold),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Private time-slot helpers
  // ──────────────────────────────────────────────────────────────

  /**
   * Indexes bookings into a Set<"YYYY-MM-DD|HH:mm"> for fast lookup.
   */
  private indexBookedSlotsForEmployee(
    bookings: Booking[],
    rangeStart: Date,
    rangeEnd: Date,
  ): Set<string> {
    const set = new Set<string>();
    for (const booking of bookings) {
      const startTime = new Date(booking.startTime);
      if (startTime < rangeStart || startTime >= rangeEnd) continue;

      const dateStr = this.formatDate(startTime);
      const timeStr = this.formatTime24(startTime);
      set.add(`${dateStr}|${timeStr}`);
    }
    return set;
  }

  /**
   * Generates 30-minute time slots between startTime and endTime,
   * marking each as 'free' or 'busy'.
   */
  private generateSlots(
    startTime: string,
    endTime: string,
    dateStr: string,
    bookedSlots: Set<string>,
  ): TimeSlotDto[] {
    const [startH, startM] = startTime.split(':').map(Number);
    const [endH, endM] = endTime.split(':').map(Number);

    const startMinutes = startH * 60 + startM;
    const endMinutes = endH * 60 + endM;

    const slots: TimeSlotDto[] = [];

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

      const slot = new TimeSlotDto();
      slot.label = label;
      slot.time = time24;
      slot.isBusy = bookedSlots.has(slotKey);
      slots.push(slot);
    }

    return slots;
  }

  /** Formats a Date to YYYY-MM-DD. */
  private formatDate(date: Date): string {
    const parts = this.businessDateParts(date);
    return `${parts.year}-${parts.month}-${parts.day}`;
  }

  /** Formats a Date's time to HH:mm (24h). */
  private formatTime24(date: Date): string {
    const parts = new Intl.DateTimeFormat('en-GB', {
      timeZone: EmployeesService.BUSINESS_TIME_ZONE,
      hour: '2-digit',
      minute: '2-digit',
      hour12: false,
    }).formatToParts(date);
    const value = (type: string) =>
      parts.find((part) => part.type === type)?.value ?? '00';
    return `${value('hour')}:${value('minute')}`;
  }

  /** Converts any incoming ISO date/datetime into Vietnam-local day start. */
  private startOfBusinessDayUtc(date?: string): Date {
    const parts = date
      ? this.businessDatePartsFromInput(date)
      : this.businessDateParts(new Date());
    return this.businessDateStartUtc(parts.year, parts.month, parts.day);
  }

  private businessDatePartsFromInput(date: string): {
    year: string;
    month: string;
    day: string;
  } {
    const dateOnly = /^(\d{4})-(\d{2})-(\d{2})$/.exec(date);
    if (dateOnly) {
      return {
        year: dateOnly[1],
        month: dateOnly[2],
        day: dateOnly[3],
      };
    }

    const parsed = new Date(date);
    if (Number.isNaN(parsed.getTime())) {
      return this.businessDateParts(new Date());
    }
    return this.businessDateParts(parsed);
  }

  private businessDateParts(date: Date): {
    year: string;
    month: string;
    day: string;
  } {
    const parts = new Intl.DateTimeFormat('en-CA', {
      timeZone: EmployeesService.BUSINESS_TIME_ZONE,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    }).formatToParts(date);
    const value = (type: string) =>
      parts.find((part) => part.type === type)?.value ?? '';
    return {
      year: value('year'),
      month: value('month'),
      day: value('day'),
    };
  }

  private businessDateStartUtc(year: string, month: string, day: string): Date {
    return new Date(
      Date.UTC(Number(year), Number(month) - 1, Number(day), -7, 0, 0, 0),
    );
  }

  private addUtcDays(date: Date, days: number): Date {
    const next = new Date(date);
    next.setUTCDate(next.getUTCDate() + days);
    return next;
  }

  private formatDayName(date: Date): string {
    return new Intl.DateTimeFormat('en-US', {
      timeZone: EmployeesService.BUSINESS_TIME_ZONE,
      weekday: 'long',
    }).format(date);
  }

  /** Converts 24h hour/minute to 12h format label (e.g. "09:00 AM"). */
  private formatTime12(hour: number, minute: number): string {
    const period = hour >= 12 ? 'PM' : 'AM';
    const h12 = hour === 0 ? 12 : hour > 12 ? hour - 12 : hour;
    return `${String(h12).padStart(2, '0')}:${String(minute).padStart(2, '0')} ${period}`;
  }
}
