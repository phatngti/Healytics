import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { ListEmployeeAppointmentsHandler } from './list-employee-appointments.handler';
import { EmployeeBookingStatusFilter } from '../../dto/employee/get-employee-appointments-query.dto';

describe('ListEmployeeAppointmentsHandler', () => {
  const createQueryBuilder = () => {
    const qb = {
      leftJoinAndSelect: jest.fn().mockReturnThis(),
      where: jest.fn().mockReturnThis(),
      andWhere: jest.fn().mockReturnThis(),
      orderBy: jest.fn().mockReturnThis(),
      skip: jest.fn().mockReturnThis(),
      take: jest.fn().mockReturnThis(),
      getManyAndCount: jest.fn(),
    };
    return qb;
  };

  it('filters upcoming employee appointments to confirmed bookings only', async () => {
    const qb = createQueryBuilder();
    qb.getManyAndCount.mockResolvedValue([
      [
        {
          id: 'booking-1',
          userId: 'user-1',
          product: null,
          user: {
            email: 'patient@example.com',
            userProfile: null,
          },
          status: BookingStatus.CONFIRMED,
          startTime: new Date('2026-05-19T09:00:00.000Z'),
          endTime: new Date('2026-05-19T10:00:00.000Z'),
          notes: null,
        },
      ],
      1,
    ]);

    const employeeRepository = {
      findOne: jest.fn().mockResolvedValue({
        id: 'employee-1',
        partnerId: 'partner-1',
      }),
    };
    const bookingRepository = {
      createQueryBuilder: jest.fn().mockReturnValue(qb),
    };
    const partnerRepository = {
      findOne: jest.fn().mockResolvedValue({
        id: 'partner-1',
        brandName: 'Healytics Clinic',
        streetAddress: '123 Wellness St',
      }),
    };

    const handler = new ListEmployeeAppointmentsHandler(
      employeeRepository as any,
      bookingRepository as any,
      partnerRepository as any,
    );

    await handler.execute('account-1', {
      status: EmployeeBookingStatusFilter.UPCOMING,
      page: 1,
      limit: 20,
    });

    expect(qb.andWhere).toHaveBeenCalledWith(
      'booking.status IN (:...statuses)',
      { statuses: [BookingStatus.CONFIRMED] },
    );
  });
});
