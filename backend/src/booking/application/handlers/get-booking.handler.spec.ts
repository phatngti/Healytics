import { Test, TestingModule } from '@nestjs/testing';
import { NotFoundException } from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import { GetBookingHandler } from './get-booking.handler';
import { Booking } from '@/common/entities/booking.entity';
import { BookingResponseDto } from '../../dto/booking-response.dto';
import {
  MockRepository,
  createMockRepository,
} from '../../../../test/mocks/mock-types';
import { createBookingEntity } from '../../../../test/fixtures/test-data.factory';

describe('GetBookingHandler', () => {
  let handler: GetBookingHandler;
  let bookingRepo: MockRepository<Booking>;

  beforeEach(async () => {
    bookingRepo = createMockRepository<Booking>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GetBookingHandler,
        {
          provide: getRepositoryToken(Booking),
          useValue: bookingRepo,
        },
      ],
    }).compile();

    handler = module.get<GetBookingHandler>(GetBookingHandler);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should return BookingResponseDto when booking is found', async () => {
    // Arrange
    const bookingEntity = createBookingEntity({ id: 'bk-test-1' });
    bookingRepo.findOne.mockResolvedValue(bookingEntity);

    // Act
    const result = await handler.execute('bk-test-1');

    // Assert
    expect(result).toBeInstanceOf(BookingResponseDto);
    expect(result.id).toBe('bk-test-1');
    expect(result.userId).toBe(bookingEntity.userId);
    expect(result.staffId).toBe(bookingEntity.staffId);
    expect(result.status).toBe(bookingEntity.status);
    expect(bookingRepo.findOne).toHaveBeenCalledWith({
      where: { id: 'bk-test-1' },
    });
  });

  it('should throw NotFoundException when booking is not found', async () => {
    // Arrange
    bookingRepo.findOne.mockResolvedValue(null);

    // Act & Assert
    await expect(handler.execute('non-existent')).rejects.toThrow(
      NotFoundException,
    );
    await expect(handler.execute('non-existent')).rejects.toThrow(
      'Booking with ID non-existent not found',
    );
  });
});
