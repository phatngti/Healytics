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
import { EmployeeRevenueBreakdownItemDto } from '../../dto/employee/employee-revenue-response.dto';

/**
 * Handler for computing employee revenue breakdown by service category.
 */
@Injectable()
export class GetEmployeeRevenueBreakdownHandler {
  private readonly logger = new Logger(GetEmployeeRevenueBreakdownHandler.name);

  constructor(
    @InjectRepository(Employee)
    private readonly employeeRepository: Repository<Employee>,
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
  ) {}

  async execute(
    accountId: string,
    query: EmployeeRevenueQueryDto,
  ): Promise<EmployeeRevenueBreakdownItemDto[]> {
    // 1. Resolve employee
    const employee = await this.employeeRepository.findOne({
      where: { accountId },
      select: ['id'],
    });
    if (!employee) {
      throw new NotFoundException('Employee profile not found for this account');
    }

    // 2. Compute period
    const period = query.period ?? EmployeeRevenuePeriod.MONTH;
    const refDate = query.date ? new Date(query.date) : new Date();
    const { start, end } = this.computePeriodRange(period, refDate);

    // 3. Aggregate by product name
    const results = await this.bookingRepository
      .createQueryBuilder('booking')
      .select('product.name', 'serviceName')
      .addSelect('COUNT(*)::int', 'count')
      .addSelect('COALESCE(SUM(product.base_price), 0)', 'totalAmount')
      .leftJoin('booking.product', 'product')
      .where('booking.staffId = :staffId', { staffId: employee.id })
      .andWhere('booking.status = :status', {
        status: BookingStatus.COMPLETED,
      })
      .andWhere('booking.startTime BETWEEN :start AND :end', { start, end })
      .andWhere('booking.deletedAt IS NULL')
      .andWhere('product.name IS NOT NULL')
      .groupBy('product.name')
      .orderBy('"totalAmount"', 'DESC')
      .getRawMany();

    return results.map((r) => {
      const dto = new EmployeeRevenueBreakdownItemDto();
      dto.serviceName = r.serviceName;
      dto.count = Number(r.count);
      dto.totalAmount = Number(r.totalAmount);
      return dto;
    });
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
