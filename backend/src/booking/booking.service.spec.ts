import { Test, TestingModule } from '@nestjs/testing';
import { BookingService } from './booking.service';
import { AcquireMicroLockHandler } from './application/handlers/acquire-micro-lock.handler';
import { CreateCheckoutTicketHandler } from './application/handlers/create-checkout-ticket.handler';
import { GetBookingHandler } from './application/handlers/get-booking.handler';
import { GetCheckoutTicketHandler } from './application/handlers/get-checkout-ticket.handler';
import { ListUserBookingsHandler } from './application/handlers/list-user-bookings.handler';
import {
  MockHandler,
  createMockHandler,
} from '../../test/mocks/mock-types';

describe('BookingService', () => {
  let service: BookingService;
  let acquireMicroLockHandler: MockHandler;
  let createCheckoutTicketHandler: MockHandler;
  let getBookingHandler: MockHandler;
  let getCheckoutTicketHandler: MockHandler;
  let listUserBookingsHandler: MockHandler;

  beforeEach(async () => {
    acquireMicroLockHandler = createMockHandler();
    createCheckoutTicketHandler = createMockHandler();
    getBookingHandler = createMockHandler();
    getCheckoutTicketHandler = createMockHandler();
    listUserBookingsHandler = createMockHandler();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BookingService,
        { provide: AcquireMicroLockHandler, useValue: acquireMicroLockHandler },
        { provide: CreateCheckoutTicketHandler, useValue: createCheckoutTicketHandler },
        { provide: GetBookingHandler, useValue: getBookingHandler },
        { provide: GetCheckoutTicketHandler, useValue: getCheckoutTicketHandler },
        { provide: ListUserBookingsHandler, useValue: listUserBookingsHandler },
      ],
    }).compile();

    service = module.get<BookingService>(BookingService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('acquireMicroLock', () => {
    it('should delegate to AcquireMicroLockHandler', async () => {
      const dto = { staffId: 'staff-1', startTime: '2025-10-25T14:00:00Z' };
      const expected = { locked: true, expiresIn: 120 };
      acquireMicroLockHandler.execute.mockResolvedValue(expected);

      const result = await service.acquireMicroLock(dto as any);

      expect(result).toEqual(expected);
      expect(acquireMicroLockHandler.execute).toHaveBeenCalledWith(dto);
      expect(acquireMicroLockHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('asyncCheckout', () => {
    it('should delegate to CreateCheckoutTicketHandler', async () => {
      const dto = { userId: 'user-1', idempotencyKey: 'key-1' };
      const expected = { ticketId: 'ticket-1', status: 'QUEUED', message: 'Processing...' };
      createCheckoutTicketHandler.execute.mockResolvedValue(expected);

      const result = await service.asyncCheckout(dto as any);

      expect(result).toEqual(expected);
      expect(createCheckoutTicketHandler.execute).toHaveBeenCalledWith(dto);
      expect(createCheckoutTicketHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('getTicketStatus', () => {
    it('should delegate to GetCheckoutTicketHandler', async () => {
      const ticketId = 'ticket-1';
      const expected = { id: ticketId, status: 'QUEUED' };
      getCheckoutTicketHandler.execute.mockResolvedValue(expected);

      const result = await service.getTicketStatus(ticketId);

      expect(result).toEqual(expected);
      expect(getCheckoutTicketHandler.execute).toHaveBeenCalledWith(ticketId);
      expect(getCheckoutTicketHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('getBooking', () => {
    it('should delegate to GetBookingHandler', async () => {
      const bookingId = 'bk-1';
      const expected = { id: bookingId, status: 'CONFIRMED' };
      getBookingHandler.execute.mockResolvedValue(expected);

      const result = await service.getBooking(bookingId);

      expect(result).toEqual(expected);
      expect(getBookingHandler.execute).toHaveBeenCalledWith(bookingId);
      expect(getBookingHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('listMyBookings', () => {
    it('should delegate to ListUserBookingsHandler with pagination params', async () => {
      const userId = 'user-1';
      const page = 2;
      const limit = 5;
      const expected = [{ id: 'bk-1' }, { id: 'bk-2' }];
      listUserBookingsHandler.execute.mockResolvedValue(expected);

      const result = await service.listMyBookings(userId, page, limit);

      expect(result).toEqual(expected);
      expect(listUserBookingsHandler.execute).toHaveBeenCalledWith(userId, page, limit);
      expect(listUserBookingsHandler.execute).toHaveBeenCalledTimes(1);
    });
  });
});
