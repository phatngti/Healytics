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
import { BookingStatusReasonCode } from '@/booking/enums/booking-status-reason-code.enum';
import { BookingStatusLogWriterService } from '@/booking/services/booking-status-log-writer.service';
import { EmployeeAppointmentResponseDto } from '../../dto/employee/employee-appointment-response.dto';

/**
 * Handler for canceling an appointment by the employee.
 * Allowed transitions: CONFIRMED | IN_PROGRESS → CANCELLED.
 * Owns the transaction lifecycle.
 */
@Injectable()
export class CancelEmployeeAppointmentHandler {
  private readonly logger = new Logger(CancelEmployeeAppointmentHandler.name);

  private static readonly CANCELLABLE_STATUSES = [
    BookingStatus.CONFIRMED,
    BookingStatus.IN_PROGRESS,
  ];

  constructor(
    private readonly dataSource: DataSource,
    private readonly logWriter: BookingStatusLogWriterService,
  ) {}

  async execute(
    accountId: string,
    bookingId: string,
    reason?: string,
  ): Promise<EmployeeAppointmentResponseDto> {
    this.logger.log(`Canceling appointment: ${bookingId}`);
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

      // 3. Invariant: only CONFIRMED or IN_PROGRESS can be cancelled
      if (
        !CancelEmployeeAppointmentHandler.CANCELLABLE_STATUSES.includes(
          booking.status,
        )
      ) {
        throw new ConflictException(
          `Cannot cancel appointment: booking status is '${booking.status}'`,
        );
      }

      // 4. Transition
      const previousStatus = booking.status;
      const trimmedReason = reason?.trim();
      booking.status = BookingStatus.CANCELLED;
      if (trimmedReason) {
        booking.notes = booking.notes
          ? `${booking.notes}\n[Cancelled] ${trimmedReason}`
          : `[Cancelled] ${trimmedReason}`;
      }
      await queryRunner.manager.save(Booking, booking);

      await this.logWriter.write(queryRunner.manager, {
        bookingId: booking.id,
        fromStatus: previousStatus,
        toStatus: BookingStatus.CANCELLED,
        changedBy: accountId,
        reasonCode: BookingStatusReasonCode.EMPLOYEE_CANCELLED,
        reason: trimmedReason,
      });

      // 6. Commit
      await queryRunner.commitTransaction();
      this.logger.log(`Appointment cancelled: ${bookingId}`);

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
        `Cancel appointment failed: ${error.message}`,
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
