import {
  ConflictException,
  ForbiddenException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { randomUUID } from 'crypto';
import { DataSource } from 'typeorm';
import { Role } from '@/account/enum/role.enum';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatusReasonCode } from '../enums/booking-status-reason-code.enum';
import { BookingStatus } from '../enums/booking-status.enum';
import {
  BookingStatusUpdate,
  PublicBookingStatus,
  toPersistedBookingStatus,
} from '../dto/update-booking-status.dto';
import { BookingStatusChangeEventDto } from '../dto/booking-status-change-event.dto';
import { BookingAccessService } from './booking-access.service';
import { BookingStatusLogWriterService } from './booking-status-log-writer.service';
import { BookingStatusRealtimePublisher } from './booking-status-realtime.publisher';

@Injectable()
export class BookingStatusLifecycleService {
  private readonly logger = new Logger(BookingStatusLifecycleService.name);

  constructor(
    private readonly dataSource: DataSource,
    private readonly accessService: BookingAccessService,
    private readonly logWriter: BookingStatusLogWriterService,
    private readonly realtimePublisher: BookingStatusRealtimePublisher,
  ) {}

  async updateEmployeeStatus(
    accountId: string,
    bookingId: string,
    requestedStatus: BookingStatusUpdate,
  ): Promise<BookingStatusChangeEventDto> {
    const persistedStatus = toPersistedBookingStatus(requestedStatus);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    let event: BookingStatusChangeEventDto;
    try {
      const employee = await this.accessService.resolveEmployeeForAccount(
        accountId,
        queryRunner.manager,
      );
      if (!employee) {
        throw new ForbiddenException('Forbidden: employee profile not found');
      }

      const booking = await queryRunner.manager.findOne(Booking, {
        where: { id: bookingId },
        relations: ['product', 'staff'],
        lock: { mode: 'pessimistic_write', tables: ['bookings'] },
      });
      if (!booking || booking.deletedAt) {
        throw new NotFoundException(`Booking with ID ${bookingId} not found`);
      }

      // Re-check employee ownership inside the write transaction before any
      // mutation. Route/body IDs are never trusted for ABAC decisions.
      if (booking.staffId !== employee.id) {
        throw new ForbiddenException(
          'Forbidden: booking ownership check failed',
        );
      }

      const previousStatus = booking.status;
      this.assertValidTransition(previousStatus, persistedStatus);

      booking.status = persistedStatus;
      if (persistedStatus === BookingStatus.COMPLETED) {
        booking.endTime = booking.endTime ?? new Date();
      }
      await queryRunner.manager.save(Booking, booking);

      await this.logWriter.write(queryRunner.manager, {
        bookingId: booking.id,
        fromStatus: previousStatus,
        toStatus: persistedStatus,
        changedBy: accountId,
        reasonCode: this.reasonCodeFor(requestedStatus),
        reason: this.reasonFor(requestedStatus),
      });

      const partnerId =
        booking.staff?.partnerId ?? booking.product?.partnerId ?? null;
      event = BookingStatusChangeEventDto.fromPlain({
        eventId: randomUUID(),
        bookingId: booking.id,
        status: this.toPublicStatus(persistedStatus),
        persistedStatus,
        previousStatus,
        userId: booking.userId,
        partnerId,
        specialistId: booking.staffId,
        changedBy: { accountId, role: Role.EMPLOYEE },
        occurredAt: new Date().toISOString(),
      });

      await queryRunner.commitTransaction();
    } catch (error) {
      await queryRunner.rollbackTransaction();
      throw error;
    } finally {
      await queryRunner.release();
    }

    await this.realtimePublisher.publishStatusChange(event).catch((error) => {
      this.logger.error(
        `Booking status updated but realtime publish failed: ${(error as Error).message}`,
        (error as Error).stack,
      );
    });
    return event;
  }

  private assertValidTransition(
    previousStatus: BookingStatus,
    nextStatus: BookingStatus,
  ): void {
    if (
      nextStatus === BookingStatus.IN_PROGRESS &&
      previousStatus !== BookingStatus.CONFIRMED
    ) {
      throw new ConflictException(
        `Cannot move booking from ${previousStatus} to PROCESSING`,
      );
    }

    if (
      nextStatus === BookingStatus.COMPLETED &&
      previousStatus !== BookingStatus.IN_PROGRESS
    ) {
      throw new ConflictException(
        `Cannot move booking from ${previousStatus} to COMPLETED`,
      );
    }
  }

  private toPublicStatus(status: BookingStatus): PublicBookingStatus {
    return status === BookingStatus.IN_PROGRESS
      ? PublicBookingStatus.PROCESSING
      : PublicBookingStatus.COMPLETED;
  }

  private reasonFor(status: BookingStatusUpdate): string {
    return status === BookingStatusUpdate.PROCESSING
      ? 'Employee moved booking to processing'
      : 'Employee completed booking';
  }

  private reasonCodeFor(status: BookingStatusUpdate): BookingStatusReasonCode {
    return status === BookingStatusUpdate.PROCESSING
      ? BookingStatusReasonCode.EMPLOYEE_STARTED_SERVICE
      : BookingStatusReasonCode.EMPLOYEE_COMPLETED_SERVICE;
  }
}
