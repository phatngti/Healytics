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
 * Handler for completing a service (IN_PROGRESS → COMPLETED transition).
 * Owns the transaction lifecycle.
 */
@Injectable()
export class CompleteEmployeeServiceHandler {
  private readonly logger = new Logger(CompleteEmployeeServiceHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(accountId: string, bookingId: string): Promise<Booking> {
    this.logger.log(`Completing service for booking: ${bookingId}`);
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

      // 3. Invariant: only IN_PROGRESS → COMPLETED
      if (booking.status !== BookingStatus.IN_PROGRESS) {
        throw new ConflictException(
          `Cannot complete service: booking status is '${booking.status}', expected 'IN_PROGRESS'`,
        );
      }

      // 4. Transition
      booking.status = BookingStatus.COMPLETED;
      booking.endTime = booking.endTime ?? new Date();
      await queryRunner.manager.save(Booking, booking);

      // 5. Add status log
      const log = queryRunner.manager.create(BookingStatusLog, {
        bookingId: booking.id,
        previousStatus: BookingStatus.IN_PROGRESS,
        newStatus: BookingStatus.COMPLETED,
        changedBy: accountId,
        reason: 'Employee completed service',
      });
      await queryRunner.manager.save(BookingStatusLog, log);

      // 6. Commit
      await queryRunner.commitTransaction();
      this.logger.log(`Service completed for booking: ${bookingId}`);

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
        `Complete service failed: ${error.message}`,
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
