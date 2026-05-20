import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { PaymentExpiryService } from './payment-expiry.service';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatusReasonCode } from '@/booking/enums/booking-status-reason-code.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { RedisService } from '@/redis/redis.service';
import { BookingStatusLogWriterService } from './booking-status-log-writer.service';

describe('PaymentExpiryService', () => {
  let service: PaymentExpiryService;
  let bookingRepo: any;
  let logWriter: Record<string, jest.Mock>;
  let redisService: Record<string, jest.Mock>;

  beforeEach(async () => {
    bookingRepo = {
      find: jest.fn(),
      save: jest.fn(),
      manager: {},
    };
    logWriter = {
      write: jest.fn().mockResolvedValue({}),
    };
    redisService = {
      del: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PaymentExpiryService,
        { provide: getRepositoryToken(Booking), useValue: bookingRepo },
        { provide: RedisService, useValue: redisService },
        { provide: BookingStatusLogWriterService, useValue: logWriter },
      ],
    }).compile();

    service = module.get<PaymentExpiryService>(PaymentExpiryService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('cancelExpiredPayments', () => {
    it('should do nothing when no expired bookings exist', async () => {
      // Arrange
      bookingRepo.find.mockResolvedValue([]);

      // Act
      await service.cancelExpiredPayments();

      // Assert
      expect(bookingRepo.find).toHaveBeenCalledTimes(1);
      expect(bookingRepo.save).not.toHaveBeenCalled();
      expect(logWriter.write).not.toHaveBeenCalled();
      expect(redisService.del).not.toHaveBeenCalled();
    });

    it('should cancel an expired booking and release lock', async () => {
      // Arrange
      const expiredBooking = {
        id: 'booking-1',
        userId: 'user-1',
        staffId: 'staff-1',
        status: BookingStatus.PENDING_PAYMENT,
        startTime: new Date('2026-04-14T09:00:00.000Z'),
        paymentExpiresAt: new Date('2026-04-14T09:10:00.000Z'),
      };
      bookingRepo.find.mockResolvedValue([expiredBooking]);
      bookingRepo.save.mockResolvedValue({
        ...expiredBooking,
        status: BookingStatus.CANCELLED,
      });
      redisService.del.mockResolvedValue(1);

      // Act
      await service.cancelExpiredPayments();

      // Assert
      expect(bookingRepo.save).toHaveBeenCalledWith(
        expect.objectContaining({
          id: 'booking-1',
          status: BookingStatus.CANCELLED,
        }),
      );
      expect(logWriter.write).toHaveBeenCalledWith(
        bookingRepo.manager,
        expect.objectContaining({
          bookingId: 'booking-1',
          fromStatus: BookingStatus.PENDING_PAYMENT,
          toStatus: BookingStatus.CANCELLED,
          changedBy: 'system:payment-expiry',
          reasonCode: BookingStatusReasonCode.PAYMENT_EXPIRED_AUTO_CANCEL,
          reason: 'Payment expired after 10-minute window',
        }),
      );
      expect(logWriter.write).toHaveBeenCalledTimes(1);
      expect(redisService.del).toHaveBeenCalledWith(
        'lock:checkout:staff-1_2026-04-14_0900',
      );
    });

    it('should process multiple expired bookings independently', async () => {
      // Arrange
      const booking1 = {
        id: 'booking-1',
        userId: 'user-1',
        staffId: 'staff-1',
        status: BookingStatus.PENDING_PAYMENT,
        startTime: new Date('2026-04-14T09:00:00.000Z'),
        paymentExpiresAt: new Date('2026-04-14T09:10:00.000Z'),
      };
      const booking2 = {
        id: 'booking-2',
        userId: 'user-2',
        staffId: 'staff-2',
        status: BookingStatus.PENDING_PAYMENT,
        startTime: new Date('2026-04-14T14:30:00.000Z'),
        paymentExpiresAt: new Date('2026-04-14T14:40:00.000Z'),
      };
      bookingRepo.find.mockResolvedValue([booking1, booking2]);
      bookingRepo.save.mockImplementation((b) =>
        Promise.resolve({ ...b, status: BookingStatus.CANCELLED }),
      );
      redisService.del.mockResolvedValue(1);

      // Act
      await service.cancelExpiredPayments();

      // Assert
      expect(bookingRepo.save).toHaveBeenCalledTimes(2);
      expect(logWriter.write).toHaveBeenCalledTimes(2);
      expect(redisService.del).toHaveBeenCalledTimes(2);
    });

    it('should continue processing remaining bookings if one fails', async () => {
      // Arrange
      const booking1 = {
        id: 'booking-fail',
        userId: 'user-1',
        staffId: 'staff-1',
        status: BookingStatus.PENDING_PAYMENT,
        startTime: new Date('2026-04-14T09:00:00.000Z'),
        paymentExpiresAt: new Date('2026-04-14T09:10:00.000Z'),
      };
      const booking2 = {
        id: 'booking-ok',
        userId: 'user-2',
        staffId: 'staff-2',
        status: BookingStatus.PENDING_PAYMENT,
        startTime: new Date('2026-04-14T10:00:00.000Z'),
        paymentExpiresAt: new Date('2026-04-14T10:10:00.000Z'),
      };
      bookingRepo.find.mockResolvedValue([booking1, booking2]);
      bookingRepo.save
        .mockRejectedValueOnce(new Error('DB connection lost'))
        .mockResolvedValueOnce({
          ...booking2,
          status: BookingStatus.CANCELLED,
        });
      redisService.del.mockResolvedValue(1);

      // Act
      await service.cancelExpiredPayments();

      // Assert — second booking still processed despite first failing
      expect(bookingRepo.save).toHaveBeenCalledTimes(2);
      expect(logWriter.write).toHaveBeenCalledTimes(1); // only second succeeded
    });

    it('should not throw if Redis del fails', async () => {
      // Arrange
      const booking = {
        id: 'booking-1',
        userId: 'user-1',
        staffId: 'staff-1',
        status: BookingStatus.PENDING_PAYMENT,
        startTime: new Date('2026-04-14T09:00:00.000Z'),
        paymentExpiresAt: new Date('2026-04-14T09:10:00.000Z'),
      };
      bookingRepo.find.mockResolvedValue([booking]);
      bookingRepo.save.mockResolvedValue({
        ...booking,
        status: BookingStatus.CANCELLED,
      });
      redisService.del.mockRejectedValue(new Error('Redis down'));

      // Act & Assert — should not throw
      await expect(
        service.cancelExpiredPayments(),
      ).resolves.not.toThrow();
      expect(bookingRepo.save).toHaveBeenCalledTimes(1);
    });
  });
});
