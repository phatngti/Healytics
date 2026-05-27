import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Employee } from '@/common/entities/employee.entity';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import {
  EmployeeRevenueQueryDto,
  EmployeeRevenuePeriod,
} from '../../dto/employee/employee-revenue-query.dto';
import { EmployeeRevenueTrendPointDto } from '../../dto/employee/employee-revenue-response.dto';

/**
 * Handler for computing employee revenue trend data for charts.
 */
@Injectable()
export class GetEmployeeRevenueTrendHandler {
  private readonly logger = new Logger(GetEmployeeRevenueTrendHandler.name);

  constructor(
    @InjectRepository(Employee)
    private readonly employeeRepository: Repository<Employee>,
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
  ) {}

  async execute(
    accountId: string,
    query: EmployeeRevenueQueryDto,
  ): Promise<EmployeeRevenueTrendPointDto[]> {
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

    const period = query.period ?? EmployeeRevenuePeriod.MONTH;
    const refDate = query.date ? new Date(query.date) : new Date();

    // 2. Build trend based on period
    switch (period) {
      case EmployeeRevenuePeriod.DAY:
        return this.buildDailyTrend(employee.id, refDate);
      case EmployeeRevenuePeriod.MONTH:
        return this.buildMonthlyTrend(employee.id, refDate);
      case EmployeeRevenuePeriod.YEAR:
        return this.buildYearlyTrend(employee.id, refDate);
    }
  }

  /** 7 data points — last 7 days */
  private async buildDailyTrend(
    employeeId: string,
    refDate: Date,
  ): Promise<EmployeeRevenueTrendPointDto[]> {
    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const points: EmployeeRevenueTrendPointDto[] = [];
    for (let i = 6; i >= 0; i--) {
      const day = new Date(refDate);
      day.setDate(day.getDate() - i);
      const start = new Date(day.getFullYear(), day.getMonth(), day.getDate());
      const end = new Date(
        day.getFullYear(),
        day.getMonth(),
        day.getDate(),
        23,
        59,
        59,
        999,
      );
      const amount = await this.sumRevenue(employeeId, start, end);
      const dto = new EmployeeRevenueTrendPointDto();
      dto.date = start;
      dto.amount = amount;
      dto.label = dayNames[start.getDay()];
      points.push(dto);
    }
    return points;
  }

  /** 12 data points — months of the year */
  private async buildMonthlyTrend(
    employeeId: string,
    refDate: Date,
  ): Promise<EmployeeRevenueTrendPointDto[]> {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const points: EmployeeRevenueTrendPointDto[] = [];
    for (let m = 0; m < 12; m++) {
      const start = new Date(refDate.getFullYear(), m, 1);
      const end = new Date(refDate.getFullYear(), m + 1, 0, 23, 59, 59, 999);
      const amount = await this.sumRevenue(employeeId, start, end);
      const dto = new EmployeeRevenueTrendPointDto();
      dto.date = start;
      dto.amount = amount;
      dto.label = monthNames[m];
      points.push(dto);
    }
    return points;
  }

  /** 5 data points — last 5 years */
  private async buildYearlyTrend(
    employeeId: string,
    refDate: Date,
  ): Promise<EmployeeRevenueTrendPointDto[]> {
    const points: EmployeeRevenueTrendPointDto[] = [];
    for (let i = 4; i >= 0; i--) {
      const year = refDate.getFullYear() - i;
      const start = new Date(year, 0, 1);
      const end = new Date(year, 11, 31, 23, 59, 59, 999);
      const amount = await this.sumRevenue(employeeId, start, end);
      const dto = new EmployeeRevenueTrendPointDto();
      dto.date = start;
      dto.amount = amount;
      dto.label = `${year}`;
      points.push(dto);
    }
    return points;
  }

  private async sumRevenue(
    employeeId: string,
    start: Date,
    end: Date,
  ): Promise<number> {
    const result = await this.bookingRepository
      .createQueryBuilder('booking')
      .select('COALESCE(SUM(product.base_price), 0)', 'total')
      .leftJoin('booking.product', 'product')
      .where('booking.staffId = :staffId', { staffId: employeeId })
      .andWhere('booking.status = :status', {
        status: BookingStatus.COMPLETED,
      })
      .andWhere('booking.startTime BETWEEN :start AND :end', { start, end })
      .andWhere('booking.deletedAt IS NULL')
      .getRawOne();
    return Number(result?.total ?? 0);
  }
}
