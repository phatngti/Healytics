import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { CheckSlotAvailabilityHandler } from './check-slot-availability.handler';
import { Booking } from '@/common/entities/booking.entity';
import { RedisService } from '@/redis/redis.service';
import {
  MockRepository,
  createMockRepository,
} from '../../../../test/mocks/mock-types';
import { createBookingEntity } from '../../../../test/fixtures/test-data.factory';
import { BookingStatus } from '@/booking/enums/booking-status.enum';

describe('CheckSlotAvailabilityHandler', () => {
  let handler: CheckSlotAvailabilityHandler;
  let bookingRepo: MockRepository<Booking>;
  let redisService: { [key: string]: jest.Mock };

  beforeEach(async () => {
    bookingRepo = createMockRepository<Booking>();
    redisService = {
      acquireLock: jest.fn(),
      releaseLock: jest.fn(),
      getLockTTL: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CheckSlotAvailabilityHandler,
        {
          provide: getRepositoryToken(Booking),
          useValue: bookingRepo,
        },
        { provide: RedisService, useValue: redisService },
      ],
    }).compile();

    handler = module.get<CheckSlotAvailabilityHandler>(CheckSlotAvailabilityHandler);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should return false when existing non-cancelled booking found in DB', async () => {
    // Arrange
    const existingBooking = createBookingEntity({ status: BookingStatus.CONFIRMED });
    bookingRepo.findOne.mockResolvedValue(existingBooking);

    // Act
    const result = await handler.execute(
      'staff-1',
      new Date('2025-10-25T14:00:00Z'),
    );

    // Assert
    expect(result).toBe(false);
    // Should not even check Redis
    expect(redisService.getLockTTL).not.toHaveBeenCalled();
  });

  it('should return false when Redis checkout lock is active (TTL > 0)', async () => {
    // Arrange
    bookingRepo.findOne.mockResolvedValue(null); // No DB booking
    redisService.getLockTTL.mockResolvedValue(300); // Lock has 300s TTL

    // Act
    const result = await handler.execute(
      'staff-1',
      new Date('2025-10-25T14:00:00Z'),
    );

    // Assert
    expect(result).toBe(false);
    expect(redisService.getLockTTL).toHaveBeenCalledWith(
      'lock:checkout:staff-1_2025-10-25_1400',
    );
  });

  it('should return true when both DB and Redis are clear', async () => {
    // Arrange
    bookingRepo.findOne.mockResolvedValue(null); // No DB booking
    redisService.getLockTTL.mockResolvedValue(-2); // Key doesn't exist

    // Act
    const result = await handler.execute(
      'staff-1',
      new Date('2025-10-25T14:00:00Z'),
    );

    // Assert
    expect(result).toBe(true);
  });

  it('should return true when Redis lock TTL is 0', async () => {
    // Arrange
    bookingRepo.findOne.mockResolvedValue(null);
    redisService.getLockTTL.mockResolvedValue(0); // Lock expired

    // Act
    const result = await handler.execute(
      'staff-1',
      new Date('2025-10-25T14:00:00Z'),
    );

    // Assert
    expect(result).toBe(true);
  });
});
