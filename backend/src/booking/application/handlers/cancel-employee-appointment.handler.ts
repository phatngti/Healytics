import {
  Injectable,
  Logger,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { Employee } from '@/common/entities/employee.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';

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

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    accountId: string,
    bookingId: string,
    reason?: string,
  ): Promise<Booking> {
    this.logger.log(`Canceling appointment: ${bookingId}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Resolve employee
      const employee = await queryRunner.manager.findOne(Employee, {
        where: { accountId },
        select: ['id'],
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
      booking.status = BookingStatus.CANCELLED;
      if (reason) {
        booking.notes = booking.notes
          ? `${booking.notes}\n[Cancelled] ${reason}`
          : `[Cancelled] ${reason}`;
      }
      await queryRunner.manager.save(Booking, booking);

      // 5. Add status log
      const log = queryRunner.manager.create(BookingStatusLog, {
        bookingId: booking.id,
        previousStatus,
        newStatus: BookingStatus.CANCELLED,
        changedBy: accountId,
        reason: reason ?? 'Employee cancelled appointment',
      });
      await queryRunner.manager.save(BookingStatusLog, log);

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
      return reloaded!;
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
