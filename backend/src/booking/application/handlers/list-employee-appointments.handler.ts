import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Partner } from '@/common/entities/partner.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import {
  GetEmployeeAppointmentsQueryDto,
  EmployeeBookingStatusFilter,
} from '../../dto/employee/get-employee-appointments-query.dto';
import { EmployeeAppointmentResponseDto } from '../../dto/employee/employee-appointment-response.dto';

/**
 * Handler to list appointments assigned to the authenticated employee.
 * Queries bookings where staffId = employee.id with optional status filter.
 */
@Injectable()
export class ListEmployeeAppointmentsHandler {
  private readonly logger = new Logger(ListEmployeeAppointmentsHandler.name);

  constructor(
    @InjectRepository(Employee)
    private readonly employeeRepository: Repository<Employee>,
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
    @InjectRepository(Partner)
    private readonly partnerRepository: Repository<Partner>,
  ) {}

  /**
   * Maps the frontend status filter to backend BookingStatus values.
   */
  private mapFilterToStatuses(
    filter: EmployeeBookingStatusFilter,
  ): BookingStatus[] {
    switch (filter) {
      case EmployeeBookingStatusFilter.UPCOMING:
        return [BookingStatus.PENDING_PAYMENT, BookingStatus.CONFIRMED];
      case EmployeeBookingStatusFilter.IN_PROGRESS:
        return [BookingStatus.IN_PROGRESS];
      case EmployeeBookingStatusFilter.COMPLETED:
        return [BookingStatus.COMPLETED];
      case EmployeeBookingStatusFilter.CANCELED:
        return [BookingStatus.CANCELLED, BookingStatus.NO_SHOW];
    }
  }

  async execute(
    accountId: string,
    query: GetEmployeeAppointmentsQueryDto,
  ): Promise<{
    data: EmployeeAppointmentResponseDto[];
    meta: { page: number; limit: number; total: number; totalPages: number };
  }> {
    // 1. Resolve employee from account
    const employee = await this.employeeRepository.findOne({
      where: { accountId },
      select: ['id', 'partnerId'],
    });
    if (!employee) {
      throw new NotFoundException('Employee profile not found for this account');
    }

    // 2. Build query
    const page = query.page ?? 1;
    const limit = query.limit ?? 20;
    const skip = (page - 1) * limit;

    const qb = this.bookingRepository
      .createQueryBuilder('booking')
      .leftJoinAndSelect('booking.product', 'product')
      .leftJoinAndSelect('product.productDefinition', 'productDefinition')
      .leftJoinAndSelect('product.category', 'category')
      .leftJoinAndSelect('booking.user', 'user')
      .leftJoinAndSelect('user.userProfile', 'userProfile')
      .where('booking.staffId = :staffId', { staffId: employee.id })
      .andWhere('booking.deletedAt IS NULL');

    // 3. Apply status filter
    if (query.status) {
      const statuses = this.mapFilterToStatuses(query.status);
      qb.andWhere('booking.status IN (:...statuses)', { statuses });
    }

    // 4. Order and paginate
    qb.orderBy('booking.startTime', 'DESC')
      .skip(skip)
      .take(limit);

    const [bookings, total] = await qb.getManyAndCount();

    // 5. Resolve clinic info
    let clinicName = 'Healytics Clinic';
    let clinicAddress = '';
    if (employee.partnerId) {
      const partner = await this.partnerRepository.findOne({
        where: { id: employee.partnerId },
        select: ['id', 'brandName', 'streetAddress'],
      });
      if (partner) {
        clinicName = partner.brandName ?? clinicName;
        clinicAddress = partner.streetAddress ?? '';
      }
    }

    // 6. Map to response DTOs
    const data = EmployeeAppointmentResponseDto.fromBookings(
      bookings,
      clinicName,
      clinicAddress,
    );

    return {
      data,
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }
}
