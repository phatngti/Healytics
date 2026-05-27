import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { Employee } from '@/common/entities/employee.entity';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import {
  EmployeeRevenueQueryDto,
  EmployeeRevenuePeriod,
} from '../../dto/employee/employee-revenue-query.dto';
import { EmployeeRevenueSummaryResponseDto } from '../../dto/employee/employee-revenue-response.dto';

/**
 * Handler for computing employee revenue summary from booking data.
 */
@Injectable()
export class GetEmployeeRevenueSummaryHandler {
  private readonly logger = new Logger(GetEmployeeRevenueSummaryHandler.name);
  /** Default commission rate (15%). */
  private readonly COMMISSION_RATE = 0.15;

  constructor(
    @InjectRepository(Employee)
    private readonly employeeRepository: Repository<Employee>,
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
  ) {}

  async execute(
    accountId: string,
    query: EmployeeRevenueQueryDto,
  ): Promise<EmployeeRevenueSummaryResponseDto> {
    // 1. Resolve employee
    const employee = await this.employeeRepository.findOne({
      where: { accountId },
      select: ['id'],
    });
    if (!employee) {
      throw new NotFoundException(
        'Employee profile not found for this account',
      );
    }

    // 2. Compute period range
    const period = query.period ?? EmployeeRevenuePeriod.MONTH;
    const refDate = query.date ? new Date(query.date) : new Date();
    const { start, end } = this.computePeriodRange(period, refDate);

    // 3. Aggregate completed bookings
    const completedResult = await this.bookingRepository
      .createQueryBuilder('booking')
      .select('COALESCE(SUM(product.base_price), 0)', 'total')
      .addSelect('COUNT(*)::int', 'count')
      .leftJoin('booking.product', 'product')
      .where('booking.staffId = :staffId', { staffId: employee.id })
      .andWhere('booking.status = :status', {
        status: BookingStatus.COMPLETED,
      })
      .andWhere('booking.startTime BETWEEN :start AND :end', { start, end })
      .andWhere('booking.deletedAt IS NULL')
      .getRawOne();

    // 4. Count canceled bookings
    const canceledResult = await this.bookingRepository
      .createQueryBuilder('booking')
      .select('COUNT(*)::int', 'count')
      .where('booking.staffId = :staffId', { staffId: employee.id })
      .andWhere('booking.status IN (:...statuses)', {
        statuses: [BookingStatus.CANCELLED, BookingStatus.NO_SHOW],
      })
      .andWhere('booking.startTime BETWEEN :start AND :end', { start, end })
      .andWhere('booking.deletedAt IS NULL')
      .getRawOne();

    const totalRevenue = Number(completedResult?.total ?? 0);
    const totalCommission = totalRevenue * this.COMMISSION_RATE;

    const dto = new EmployeeRevenueSummaryResponseDto();
    dto.totalRevenue = totalRevenue;
    dto.totalCommission = totalCommission;
    dto.netEarnings = totalRevenue - totalCommission;
    dto.completedAppointments = Number(completedResult?.count ?? 0);
    dto.canceledAppointments = Number(canceledResult?.count ?? 0);
    dto.period = period;
    dto.periodStart = start;
    dto.periodEnd = end;
    return dto;
  }

  private computePeriodRange(
    period: EmployeeRevenuePeriod,
    refDate: Date,
  ): { start: Date; end: Date } {
    switch (period) {
      case EmployeeRevenuePeriod.DAY:
        return {
          start: new Date(
            refDate.getFullYear(),
            refDate.getMonth(),
            refDate.getDate(),
          ),
          end: new Date(
            refDate.getFullYear(),
            refDate.getMonth(),
            refDate.getDate(),
            23,
            59,
            59,
            999,
          ),
        };
      case EmployeeRevenuePeriod.MONTH:
        return {
          start: new Date(refDate.getFullYear(), refDate.getMonth(), 1),
          end: new Date(
            refDate.getFullYear(),
            refDate.getMonth() + 1,
            0,
            23,
            59,
            59,
            999,
          ),
        };
      case EmployeeRevenuePeriod.YEAR:
        return {
          start: new Date(refDate.getFullYear(), 0, 1),
          end: new Date(refDate.getFullYear(), 11, 31, 23, 59, 59, 999),
        };
    }
  }
}
