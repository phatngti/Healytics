import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ListUserBookingsHandler } from './list-user-bookings.handler';
import { Booking } from '@/common/entities/booking.entity';
import { BookingResponseDto } from '../../dto/booking-response.dto';
import {
  MockRepository,
  createMockRepository,
} from '../../../../test/mocks/mock-types';
import { createBookingEntity } from '../../../../test/fixtures/test-data.factory';

describe('ListUserBookingsHandler', () => {
  let handler: ListUserBookingsHandler;
  let bookingRepo: MockRepository<Booking>;

  beforeEach(async () => {
    bookingRepo = createMockRepository<Booking>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ListUserBookingsHandler,
        {
          provide: getRepositoryToken(Booking),
          useValue: bookingRepo,
        },
      ],
    }).compile();

    handler = module.get<ListUserBookingsHandler>(ListUserBookingsHandler);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should return paginated bookings mapped to DTOs', async () => {
    // Arrange
    const bookings = [
      createBookingEntity({ id: 'bk-1' }),
      createBookingEntity({ id: 'bk-2' }),
    ];
    bookingRepo.find.mockResolvedValue(bookings);

    // Act
    const result = await handler.execute('user-1', 1, 10);

    // Assert
    expect(result).toHaveLength(2);
    expect(result[0]).toBeInstanceOf(BookingResponseDto);
    expect(result[0].id).toBe('bk-1');
    expect(result[1].id).toBe('bk-2');
  });

  it('should return empty array when no bookings exist', async () => {
    // Arrange
    bookingRepo.find.mockResolvedValue([]);

    // Act
    const result = await handler.execute('user-1', 1, 10);

    // Assert
    expect(result).toEqual([]);
  });

  it('should apply correct skip, take, and order parameters', async () => {
    // Arrange
    bookingRepo.find.mockResolvedValue([]);

    // Act — page 3, limit 5
    await handler.execute('user-1', 3, 5);

    // Assert
    expect(bookingRepo.find).toHaveBeenCalledWith({
      where: { userId: 'user-1' },
      order: { startTime: 'DESC' },
      skip: 10, // (3 - 1) * 5
      take: 5,
    });
  });

  it('should apply default pagination when no params provided', async () => {
    // Arrange
    bookingRepo.find.mockResolvedValue([]);

    // Act — use defaults
    await handler.execute('user-1');

    // Assert
    expect(bookingRepo.find).toHaveBeenCalledWith({
      where: { userId: 'user-1' },
      order: { startTime: 'DESC' },
      skip: 0,
      take: 10,
    });
  });
});
