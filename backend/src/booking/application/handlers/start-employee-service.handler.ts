import {
  Injectable,
  Logger,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Partner } from '@/common/entities/partner.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { EmployeeAppointmentResponseDto } from '../../dto/employee/employee-appointment-response.dto';

/**
 * Handler for starting a service (CONFIRMED → IN_PROGRESS transition).
 * Owns the transaction lifecycle.
 */
@Injectable()
export class StartEmployeeServiceHandler {
  private readonly logger = new Logger(StartEmployeeServiceHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    accountId: string,
    bookingId: string,
  ): Promise<EmployeeAppointmentResponseDto> {
    this.logger.log(`Starting service for booking: ${bookingId}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Resolve employee
      const employee = await queryRunner.manager.findOne(Employee, {
        where: { accountId },
        select: ['id', 'partnerId'],
      });
      if (!employee) {
        throw new NotFoundException(
          'Employee profile not found for this account',
        );
      }

      // 2. Load booking with ownership check
      const booking = await queryRunner.manager.findOne(Booking, {
        where: { id: bookingId, staffId: employee.id },
      });
      if (!booking) {
        throw new NotFoundException(
          `Appointment with ID ${bookingId} not found`,
        );
      }

      // 3. Invariant: only CONFIRMED → IN_PROGRESS
      if (booking.status !== BookingStatus.CONFIRMED) {
        throw new ConflictException(
          `Cannot start service: booking status is '${booking.status}', expected 'CONFIRMED'`,
        );
      }

      // 4. Transition
      booking.status = BookingStatus.IN_PROGRESS;
      await queryRunner.manager.save(Booking, booking);

      // 5. Add status log
      const log = queryRunner.manager.create(BookingStatusLog, {
        bookingId: booking.id,
        previousStatus: BookingStatus.CONFIRMED,
        newStatus: BookingStatus.IN_PROGRESS,
        changedBy: accountId,
        reason: 'Employee started service',
      });
      await queryRunner.manager.save(BookingStatusLog, log);

      // 6. Commit
      await queryRunner.commitTransaction();
      this.logger.log(`Service started for booking: ${bookingId}`);

      // Post-commit: reload with relations
      const reloaded = await this.dataSource.manager.findOne(Booking, {
        where: { id: bookingId },
        relations: [
          'product',
          'product.productDefinition',
          'product.category',
          'user',
          'user.userProfile',
        ],
      });

      // Resolve clinic info from partner
      let clinicName = 'Healytics Clinic';
      let clinicAddress = '';
      if (employee.partnerId) {
        const partner = await this.dataSource.manager.findOne(Partner, {
          where: { id: employee.partnerId },
          select: ['id', 'brandName', 'streetAddress'],
        });
        if (partner) {
          clinicName = partner.brandName ?? clinicName;
          clinicAddress = partner.streetAddress ?? '';
        }
      }

      return EmployeeAppointmentResponseDto.fromBooking(
        reloaded!,
        clinicName,
        clinicAddress,
      );
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Start service failed: ${error.message}`,
        error.stack,
      );
      if (
        error instanceof NotFoundException ||
        error instanceof ConflictException
      )
        throw error;
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
