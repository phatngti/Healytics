import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { AppointmentStatus } from '../../enums/appointment-status.enum';
import { ListAppointmentsHandler } from './list-appointments.handler';

describe('ListAppointmentsHandler', () => {
  const createQueryBuilder = () => {
    const qb = {
      leftJoinAndSelect: jest.fn().mockReturnThis(),
      where: jest.fn().mockReturnThis(),
      andWhere: jest.fn().mockReturnThis(),
      orderBy: jest.fn().mockReturnThis(),
      addSelect: jest.fn().mockReturnThis(),
      setParameters: jest.fn().mockReturnThis(),
      getRawAndEntities: jest.fn().mockResolvedValue({
        entities: [],
        raw: [],
      }),
    };
    return qb;
  };

  const createHandler = () => {
    const qb = createQueryBuilder();
    const dataSource = {
      getRepository: jest.fn().mockReturnValue({
        createQueryBuilder: jest.fn().mockReturnValue(qb),
      }),
    };

    return {
      handler: new ListAppointmentsHandler(dataSource as any),
      qb,
    };
  };

  const andWhereClauses = (
    qb: ReturnType<typeof createQueryBuilder>,
  ): string[] => qb.andWhere.mock.calls.map(([clause]) => clause);

  it('filters upcoming appointments to future confirmed bookings', async () => {
    const { handler, qb } = createHandler();

    await handler.execute('user-1', { status: AppointmentStatus.UPCOMING });

    expect(qb.andWhere).toHaveBeenCalledWith(
      'booking.status IN (:...bookingStatuses)',
      { bookingStatuses: [BookingStatus.CONFIRMED] },
    );
    expect(qb.andWhere).toHaveBeenCalledWith('booking.start_time >= :now', {
      now: expect.any(Date),
    });
  });

  it('filters pending appointments to future unexpired payment bookings', async () => {
    const { handler, qb } = createHandler();

    await handler.execute('user-1', {
      status: AppointmentStatus.PENDING_PAYMENT,
    });

    expect(qb.andWhere).toHaveBeenCalledWith(
      'booking.status IN (:...bookingStatuses)',
      { bookingStatuses: [BookingStatus.PENDING_PAYMENT] },
    );
    expect(qb.andWhere).toHaveBeenCalledWith('booking.start_time >= :now', {
      now: expect.any(Date),
    });
    expect(qb.andWhere).toHaveBeenCalledWith(
      '(booking.payment_expires_at IS NULL OR booking.payment_expires_at >= :now)',
      { now: expect.any(Date) },
    );
  });

  it('does not time-filter completed appointments', async () => {
    const { handler, qb } = createHandler();

    await handler.execute('user-1', { status: AppointmentStatus.COMPLETED });

    expect(qb.andWhere).toHaveBeenCalledWith(
      'booking.status IN (:...bookingStatuses)',
      { bookingStatuses: [BookingStatus.COMPLETED] },
    );
    expect(andWhereClauses(qb)).not.toContain('booking.start_time >= :now');
  });

  it('filters canceled appointments to cancelled and no-show bookings', async () => {
    const { handler, qb } = createHandler();

    await handler.execute('user-1', { status: AppointmentStatus.CANCELED });

    expect(qb.andWhere).toHaveBeenCalledWith(
      'booking.status IN (:...bookingStatuses)',
      {
        bookingStatuses: [BookingStatus.CANCELLED, BookingStatus.NO_SHOW],
      },
    );
    expect(andWhereClauses(qb)).not.toContain('booking.start_time >= :now');
  });

  it('filters processing appointments to in-progress bookings', async () => {
    const { handler, qb } = createHandler();

    await handler.execute('user-1', { status: AppointmentStatus.PROCESSING });

    expect(qb.andWhere).toHaveBeenCalledWith(
      'booking.status IN (:...bookingStatuses)',
      { bookingStatuses: [BookingStatus.IN_PROGRESS] },
    );
    expect(andWhereClauses(qb)).not.toContain('booking.start_time >= :now');
  });
});
