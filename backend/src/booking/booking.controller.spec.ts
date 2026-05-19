import { Test, TestingModule } from '@nestjs/testing';
import { BookingController } from './booking.controller';
import { BookingService } from './booking.service';

describe('BookingController', () => {
  let controller: BookingController;
  let bookingService: { [key: string]: jest.Mock };

  beforeEach(async () => {
    bookingService = {
      asyncCheckout: jest.fn(),
      getTicketStatus: jest.fn(),
      listMyBookings: jest.fn(),
      getBooking: jest.fn(),
      acquireMicroLock: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [BookingController],
      providers: [{ provide: BookingService, useValue: bookingService }],
    }).compile();

    controller = module.get<BookingController>(BookingController);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('asyncCheckout', () => {
    it('should call bookingService.asyncCheckout and return response', async () => {
      const dto = {
        userId: 'user-1',
        staffId: 'staff-1',
        startTime: '2025-10-25T14:00:00Z',
        idempotencyKey: 'key-1',
      };
      const expected = {
        ticketId: 'ticket-1',
        status: 'QUEUED',
        message: 'Processing...',
      };
      bookingService.asyncCheckout.mockResolvedValue(expected);

      const result = await controller.asyncCheckout(dto as any);

      expect(result).toEqual(expected);
      expect(bookingService.asyncCheckout).toHaveBeenCalledWith(dto);
    });
  });

  describe('getTicketStatus', () => {
    it('should call bookingService.getTicketStatus with UUID', async () => {
      const ticketId = '550e8400-e29b-41d4-a716-446655440000';
      const expected = { id: ticketId, status: 'QUEUED' };
      bookingService.getTicketStatus.mockResolvedValue(expected);

      const result = await controller.getTicketStatus(ticketId);

      expect(result).toEqual(expected);
      expect(bookingService.getTicketStatus).toHaveBeenCalledWith(ticketId);
    });
  });

  describe('listMyBookings', () => {
    it('should call bookingService.listMyBookings with userId from @CurrentUser', async () => {
      const expected = [{ id: 'bk-1' }];
      bookingService.listMyBookings.mockResolvedValue(expected);

      const result = await controller.listMyBookings('user-1', 1, 10);

      expect(result).toEqual(expected);
      expect(bookingService.listMyBookings).toHaveBeenCalledWith(
        'user-1',
        1,
        10,
      );
    });
  });

  describe('getBooking', () => {
    it('should call bookingService.getBooking with UUID', async () => {
      const bookingId = '550e8400-e29b-41d4-a716-446655440000';
      const expected = { id: bookingId, status: 'CONFIRMED' };
      bookingService.getBooking.mockResolvedValue(expected);

      const result = await controller.getBooking('user-1', bookingId);

      expect(result).toEqual(expected);
      expect(bookingService.getBooking).toHaveBeenCalledWith(
        'user-1',
        bookingId,
      );
    });
  });
});
