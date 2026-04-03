import {
  Injectable,
  Logger,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, FindOptionsWhere, Not, In } from 'typeorm';
import { CreateDoctorDto } from './dto/create-doctor.dto';
import {
  CreateSpaTherapistDto,
  CreateMassageTherapistDto,
} from './dto/create-therapist.dto';
import { UpdateEmployeeDto } from './dto/update-employee.dto';
import { GetEmployeesQueryDto } from './dto/get-employees-query.dto';
import { GetTimeSlotsQueryDto } from './dto/get-time-slots-query.dto';
import { Employee } from '@/common/entities/employee.entity';
import { Partner } from '@/common/entities/partner.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { Booking } from '@/common/entities/booking.entity';
import { BookingServiceResponseDto } from './dto/booking-service-response.dto';
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

  constructor(
    @InjectRepository(Employee)
    private readonly employeeRepository: Repository<Employee>,
    @InjectRepository(Partner)
    private readonly partnerRepository: Repository<Partner>,
    @InjectRepository(ProductEmployeeEligibility)
    private readonly eligibilityRepository: Repository<ProductEmployeeEligibility>,
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
    private readonly partnersService: PartnersService,
    private readonly createDoctorHandler: CreateDoctorHandler,
    private readonly createTherapistHandler: CreateTherapistHandler,
    private readonly updateEmployeeHandler: UpdateEmployeeHandler,
    private readonly removeEmployeeHandler: RemoveEmployeeHandler,
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
    const { role } = query || {};
    const where: FindOptionsWhere<Employee> = {};
    if (role) {
      where.role = role;
    }
    if (partnerId) {
      where.partnerId = partnerId;
    }
    return this.employeeRepository.find({
      where,
      relations: ['doctorProfile', 'therapistProfile'],
    });
  }

  /**
   * Finds an employee by ID.
   */
  async findOne(id: string): Promise<Employee> {
    const employee = await this.employeeRepository.findOne({
      where: { id },
      relations: ['doctorProfile', 'therapistProfile'],
    });
    if (!employee) {
      this.logger.warn(`Employee not found: ${id}`);
      throw new NotFoundException(`Employee with ID ${id} not found`);
    }
    return employee;
  }

  /**
   * Finds an employee by ID scoped to a specific partner.
   */
  async findOneForPartner(id: string, partnerId: string): Promise<Employee> {
    const employee = await this.employeeRepository.findOne({
      where: { id, partnerId },
      relations: ['doctorProfile', 'therapistProfile'],
    });
    if (!employee) {
      this.logger.warn(`Employee ${id} not found for partner ${partnerId}`);
      throw new NotFoundException(`Employee with ID ${id} not found`);
    }
    return employee;
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
    return this.updateEmployeeHandler.execute(id, updateEmployeeDto);
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
    return this.updateEmployeeHandler.execute(id, updateEmployeeDto);
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
  // Booking flow operations
  // ──────────────────────────────────────────────────────────────

  /**
   * Returns all services (products) that a specialist can perform.
   * Query path: ProductEmployeeEligibility → Product (with definition + media).
   * Includes clinic info from the health partner profile.
   */
  async findServicesBySpecialist(
    specialistId: string,
  ): Promise<BookingServiceResponseDto[]> {
    // Verify employee exists
    const employee = await this.employeeRepository.findOne({
      where: { id: specialistId },
    });
    if (!employee) {
      this.logger.warn(`Specialist not found: ${specialistId}`);
      throw new NotFoundException(
        `Specialist with ID ${specialistId} not found`,
      );
    }

    // Query eligible products with their definitions and media
    const eligibilities = await this.eligibilityRepository.find({
      where: { employeeId: specialistId },
      relations: ['product', 'product.productDefinition', 'product.media'],
    });

    // Filter to active products only
    const activeProducts = eligibilities
      .map((e) => e.product)
      .filter((p) => p && p.status === HealthServiceStatus.ACTIVE);

    // Load partner for clinic info
    const partner = await this.partnersService.getFirstHealthPartner();

    return BookingServiceResponseDto.fromEntities(activeProducts, partner);
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
    const rangeStart = query.date
      ? new Date(query.date)
      : new Date(
          new Date().getFullYear(),
          new Date().getMonth(),
          new Date().getDate(),
        );
    const rangeEnd = new Date(rangeStart);
    rangeEnd.setDate(rangeEnd.getDate() + days);

    // 3. Fetch non-cancelled bookings for this employee in the range
    const bookings = await this.bookingRepository.find({
      where: {
        staffId: employeeId,
        status: Not(In([BookingStatus.CANCELLED])),
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
      const date = new Date(rangeStart);
      date.setDate(date.getDate() + i);

      const dayName = EmployeesService.DAY_NAMES[date.getDay()];
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
