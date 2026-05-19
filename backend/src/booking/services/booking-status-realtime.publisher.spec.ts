import { RedisService } from '@/redis/redis.service';
import { Role } from '@/account/enum/role.enum';
import { BookingStatus } from '../enums/booking-status.enum';
import { PublicBookingStatus } from '../dto/update-booking-status.dto';
import { BOOKING_STATUS_REDIS_CHANNEL } from '../constants/booking-realtime.constants';
import { BookingStatusRealtimePublisher } from './booking-status-realtime.publisher';

describe('BookingStatusRealtimePublisher', () => {
  it('publishes the exact booking status payload to Redis', async () => {
    const redisService = { publish: jest.fn().mockResolvedValue(2) };
    const publisher = new BookingStatusRealtimePublisher(
      redisService as unknown as RedisService,
    );

    await publisher.publishStatusChange({
      eventId: 'event-1',
      bookingId: 'booking-1',
      status: PublicBookingStatus.PROCESSING,
      persistedStatus: BookingStatus.IN_PROGRESS,
      previousStatus: BookingStatus.CONFIRMED,
      userId: 'user-1',
      partnerId: 'partner-1',
      specialistId: 'employee-1',
      changedBy: { accountId: 'employee-account-1', role: Role.EMPLOYEE },
      occurredAt: '2026-05-18T00:00:00.000Z',
    });

    expect(redisService.publish).toHaveBeenCalledWith(
      BOOKING_STATUS_REDIS_CHANNEL,
      JSON.stringify({
        eventId: 'event-1',
        bookingId: 'booking-1',
        status: 'PROCESSING',
        persistedStatus: 'IN_PROGRESS',
        previousStatus: 'CONFIRMED',
        userId: 'user-1',
        partnerId: 'partner-1',
        specialistId: 'employee-1',
        changedBy: { accountId: 'employee-account-1', role: 'employee' },
        occurredAt: '2026-05-18T00:00:00.000Z',
      }),
    );
  });
});
