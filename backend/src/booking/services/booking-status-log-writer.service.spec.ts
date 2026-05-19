import { BookingStatusReasonCode } from '../enums/booking-status-reason-code.enum';
import { BookingStatus } from '../enums/booking-status.enum';
import { BookingStatusLogWriterService } from './booking-status-log-writer.service';

describe('BookingStatusLogWriterService', () => {
  let service: BookingStatusLogWriterService;
  let manager: any;

  beforeEach(() => {
    service = new BookingStatusLogWriterService();
    manager = {
      create: jest.fn((_entity: unknown, value: unknown) => value),
      save: jest.fn(async (_entity: unknown, value: unknown) => value),
    };
  });

  it('saves status logs with reason code and non-empty reason', async () => {
    const log = await service.write(manager, {
      bookingId: 'booking-1',
      fromStatus: BookingStatus.PENDING_PAYMENT,
      toStatus: BookingStatus.CONFIRMED,
      changedBy: 'system',
      reasonCode: BookingStatusReasonCode.PAYMENT_CONFIRMED_MOMO,
      reason: 'MoMo payment confirmed: transId=123',
    });

    expect(log).toEqual(
      expect.objectContaining({
        bookingId: 'booking-1',
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'system',
        reasonCode: BookingStatusReasonCode.PAYMENT_CONFIRMED_MOMO,
        reason: 'MoMo payment confirmed: transId=123',
      }),
    );
    expect(manager.save).toHaveBeenCalledTimes(1);
  });

  it('normalizes blank reason to the mapped default reason', async () => {
    const log = await service.write(manager, {
      bookingId: 'booking-1',
      fromStatus: BookingStatus.CONFIRMED,
      toStatus: BookingStatus.CANCELLED,
      changedBy: 'employee-1',
      reasonCode: BookingStatusReasonCode.EMPLOYEE_CANCELLED,
      reason: '   ',
    });

    expect(log.reason).toBe('Employee cancelled appointment');
    expect(log.reasonCode).toBe(BookingStatusReasonCode.EMPLOYEE_CANCELLED);
  });

  it('defaults missing reason code to legacy status change', async () => {
    const log = await service.write(manager, {
      bookingId: 'booking-1',
      fromStatus: null,
      toStatus: BookingStatus.PENDING_PAYMENT,
    });

    expect(log.reasonCode).toBe(BookingStatusReasonCode.LEGACY_STATUS_CHANGE);
    expect(log.reason).toBe(
      'Legacy booking status change from none to PENDING_PAYMENT',
    );
  });
});
