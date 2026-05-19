import { ForbiddenException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Role } from '@/account/enum/role.enum';
import { BookingAccessService } from './booking-access.service';

describe('BookingAccessService', () => {
  let service: BookingAccessService;
  let dataSource: { manager: { query: jest.Mock } };

  beforeEach(() => {
    dataSource = { manager: { query: jest.fn() } };
    service = new BookingAccessService(dataSource as unknown as DataSource);
  });

  it('allows a customer to access their own booking', async () => {
    dataSource.manager.query.mockResolvedValueOnce([
      {
        bookingId: 'booking-1',
        userId: 'user-1',
        specialistId: 'employee-1',
        partnerId: 'partner-1',
      },
    ]);

    await expect(
      service.assertCanAccessBooking(
        { id: 'user-1', role: Role.USER },
        'booking-1',
      ),
    ).resolves.toMatchObject({ bookingId: 'booking-1' });
  });

  it('forbids a customer from another customer booking', async () => {
    dataSource.manager.query.mockResolvedValueOnce([
      {
        bookingId: 'booking-1',
        userId: 'user-1',
        specialistId: 'employee-1',
        partnerId: 'partner-1',
      },
    ]);

    await expect(
      service.assertCanAccessBooking(
        { id: 'user-2', role: Role.USER },
        'booking-1',
      ),
    ).rejects.toBeInstanceOf(ForbiddenException);
  });

  it('allows the assigned employee', async () => {
    dataSource.manager.query
      .mockResolvedValueOnce([
        {
          bookingId: 'booking-1',
          userId: 'user-1',
          specialistId: 'employee-1',
          partnerId: 'partner-1',
        },
      ])
      .mockResolvedValueOnce([{ id: 'employee-1', partnerId: 'partner-1' }]);

    await expect(
      service.assertCanAccessBooking(
        { id: 'account-employee-1', role: Role.EMPLOYEE },
        'booking-1',
      ),
    ).resolves.toMatchObject({ specialistId: 'employee-1' });
  });

  it('allows the owning partner', async () => {
    dataSource.manager.query
      .mockResolvedValueOnce([
        {
          bookingId: 'booking-1',
          userId: 'user-1',
          specialistId: 'employee-1',
          partnerId: 'partner-1',
        },
      ])
      .mockResolvedValueOnce([{ id: 'partner-1' }]);

    await expect(
      service.assertCanAccessBooking(
        { id: 'partner-account-1', role: Role.HEALTH_PARTNER },
        'booking-1',
      ),
    ).resolves.toMatchObject({ partnerId: 'partner-1' });
  });
});
