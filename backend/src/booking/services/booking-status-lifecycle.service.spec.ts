import { ConflictException, ForbiddenException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { BookingStatus } from '../enums/booking-status.enum';
import { BookingStatusUpdate } from '../dto/update-booking-status.dto';
import { BookingStatusLifecycleService } from './booking-status-lifecycle.service';
import { BookingAccessService } from './booking-access.service';
import { BookingStatusReasonCode } from '../enums/booking-status-reason-code.enum';
import { BookingStatusLogWriterService } from './booking-status-log-writer.service';
import { BookingStatusRealtimePublisher } from './booking-status-realtime.publisher';

describe('BookingStatusLifecycleService', () => {
  const accountId = '11111111-1111-1111-1111-111111111111';
  const bookingId = '22222222-2222-2222-2222-222222222222';
  const employeeId = '33333333-3333-3333-3333-333333333333';

  let service: BookingStatusLifecycleService;
  let queryRunner: any;
  let accessService: jest.Mocked<
    Pick<BookingAccessService, 'resolveEmployeeForAccount'>
  >;
  let logWriter: jest.Mocked<Pick<BookingStatusLogWriterService, 'write'>>;
  let publisher: jest.Mocked<
    Pick<BookingStatusRealtimePublisher, 'publishStatusChange'>
  >;

  beforeEach(() => {
    queryRunner = {
      connect: jest.fn(),
      startTransaction: jest.fn(),
      commitTransaction: jest.fn(),
      rollbackTransaction: jest.fn(),
      release: jest.fn(),
      manager: {
        findOne: jest.fn(),
        save: jest.fn(async (_entity: unknown, value: unknown) => value),
        create: jest.fn((_entity: unknown, value: unknown) => value),
      },
    };

    accessService = {
      resolveEmployeeForAccount: jest.fn().mockResolvedValue({
        id: employeeId,
        partnerId: 'partner-1',
      }),
    };
    logWriter = { write: jest.fn().mockResolvedValue({}) };
    publisher = { publishStatusChange: jest.fn().mockResolvedValue(1) };

    service = new BookingStatusLifecycleService(
      { createQueryRunner: () => queryRunner } as unknown as DataSource,
      accessService as unknown as BookingAccessService,
      logWriter as unknown as BookingStatusLogWriterService,
      publisher as unknown as BookingStatusRealtimePublisher,
    );
  });

  it('moves CONFIRMED bookings to public PROCESSING and persisted IN_PROGRESS', async () => {
    queryRunner.manager.findOne.mockResolvedValue({
      id: bookingId,
      userId: 'user-1',
      staffId: employeeId,
      status: BookingStatus.CONFIRMED,
      deletedAt: null,
      staff: { partnerId: 'partner-1' },
      product: { partnerId: 'partner-from-product' },
    });

    const event = await service.updateEmployeeStatus(
      accountId,
      bookingId,
      BookingStatusUpdate.PROCESSING,
    );

    expect(event.status).toBe('PROCESSING');
    expect(event.persistedStatus).toBe(BookingStatus.IN_PROGRESS);
    expect(event.previousStatus).toBe(BookingStatus.CONFIRMED);
    expect(queryRunner.manager.findOne).toHaveBeenCalledWith(
      expect.anything(),
      expect.objectContaining({
        lock: { mode: 'pessimistic_write', tables: ['bookings'] },
      }),
    );
    expect(queryRunner.commitTransaction).toHaveBeenCalled();
    expect(logWriter.write).toHaveBeenCalledWith(
      queryRunner.manager,
      expect.objectContaining({
        bookingId,
        fromStatus: BookingStatus.CONFIRMED,
        toStatus: BookingStatus.IN_PROGRESS,
        changedBy: accountId,
        reasonCode: BookingStatusReasonCode.EMPLOYEE_STARTED_SERVICE,
        reason: 'Employee moved booking to processing',
      }),
    );
    expect(publisher.publishStatusChange).toHaveBeenCalledWith(
      expect.objectContaining({ bookingId, partnerId: 'partner-1' }),
    );
  });

  it('moves IN_PROGRESS bookings to COMPLETED', async () => {
    queryRunner.manager.findOne.mockResolvedValue({
      id: bookingId,
      userId: 'user-1',
      staffId: employeeId,
      status: BookingStatus.IN_PROGRESS,
      endTime: null,
      deletedAt: null,
      staff: { partnerId: 'partner-1' },
      product: null,
    });

    const event = await service.updateEmployeeStatus(
      accountId,
      bookingId,
      BookingStatusUpdate.COMPLETED,
    );

    expect(event.status).toBe('COMPLETED');
    expect(event.persistedStatus).toBe(BookingStatus.COMPLETED);
    expect(queryRunner.manager.save).toHaveBeenCalledWith(
      expect.anything(),
      expect.objectContaining({
        status: BookingStatus.COMPLETED,
        endTime: expect.any(Date),
      }),
    );
    expect(logWriter.write).toHaveBeenCalledWith(
      queryRunner.manager,
      expect.objectContaining({
        fromStatus: BookingStatus.IN_PROGRESS,
        toStatus: BookingStatus.COMPLETED,
        reasonCode: BookingStatusReasonCode.EMPLOYEE_COMPLETED_SERVICE,
        reason: 'Employee completed booking',
      }),
    );
  });

  it('rejects unassigned employees inside the transaction', async () => {
    queryRunner.manager.findOne.mockResolvedValue({
      id: bookingId,
      userId: 'user-1',
      staffId: 'other-employee',
      status: BookingStatus.CONFIRMED,
      deletedAt: null,
      staff: { partnerId: 'partner-1' },
      product: null,
    });

    await expect(
      service.updateEmployeeStatus(
        accountId,
        bookingId,
        BookingStatusUpdate.PROCESSING,
      ),
    ).rejects.toBeInstanceOf(ForbiddenException);
    expect(queryRunner.rollbackTransaction).toHaveBeenCalled();
    expect(publisher.publishStatusChange).not.toHaveBeenCalled();
  });

  it('rejects invalid transitions', async () => {
    queryRunner.manager.findOne.mockResolvedValue({
      id: bookingId,
      userId: 'user-1',
      staffId: employeeId,
      status: BookingStatus.PENDING_PAYMENT,
      deletedAt: null,
      staff: { partnerId: 'partner-1' },
      product: null,
    });

    await expect(
      service.updateEmployeeStatus(
        accountId,
        bookingId,
        BookingStatusUpdate.PROCESSING,
      ),
    ).rejects.toBeInstanceOf(ConflictException);
    expect(queryRunner.rollbackTransaction).toHaveBeenCalled();
  });
});
