import { JwtService } from '@nestjs/jwt';
import { AccountService } from '@/account/account.service';
import { Role } from '@/account/enum/role.enum';
import { BookingStatus } from '../enums/booking-status.enum';
import { PublicBookingStatus } from '../dto/update-booking-status.dto';
import {
  BOOKING_STATUS_SOCKET_EVENT,
  bookingPartnerRoom,
  bookingUserRoom,
} from '../constants/booking-realtime.constants';
import { BookingAccessService } from '../services/booking-access.service';
import { BookingEventsGateway } from './booking-events.gateway';

describe('BookingEventsGateway', () => {
  it('fans status events out to user and partner rooms', () => {
    const to = jest.fn().mockReturnThis();
    const emit = jest.fn();
    const gateway = new BookingEventsGateway(
      {} as JwtService,
      {} as AccountService,
      {} as BookingAccessService,
      { duplicate: jest.fn() } as any,
    );
    (gateway as any).server = { to, emit };

    (gateway as any).emitStatusChange(
      JSON.stringify({
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
      }),
    );

    expect(to).toHaveBeenCalledWith(bookingUserRoom('user-1'));
    expect(to).toHaveBeenCalledWith(bookingPartnerRoom('partner-1'));
    expect(emit).toHaveBeenCalledTimes(2);
    expect(emit).toHaveBeenCalledWith(
      BOOKING_STATUS_SOCKET_EVENT,
      expect.objectContaining({ bookingId: 'booking-1' }),
    );
  });

  it('auto-joins partner sockets to their partner room', async () => {
    const access = {
      resolvePartnerIdForAccount: jest.fn().mockResolvedValue('partner-1'),
    };
    const gateway = new BookingEventsGateway(
      {} as JwtService,
      {} as AccountService,
      access as unknown as BookingAccessService,
      { duplicate: jest.fn() } as any,
    );
    const client = {
      data: { user: { id: 'account-1', role: Role.HEALTH_PARTNER } },
      join: jest.fn(),
      disconnect: jest.fn(),
    };

    await gateway.handleConnection(client as any);

    expect(client.join).toHaveBeenCalledWith(bookingPartnerRoom('partner-1'));
  });
});
