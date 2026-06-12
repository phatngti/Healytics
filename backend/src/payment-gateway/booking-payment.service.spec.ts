import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException } from '@nestjs/common';
import { BookingPaymentService } from './booking-payment.service';
import { Booking } from '@/common/entities/booking.entity';
import { Product } from '@/common/entities/product.entity';
import { BookingStatusReasonCode } from '@/booking/enums/booking-status-reason-code.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { BookingStatusLogWriterService } from '@/booking/services/booking-status-log-writer.service';
import {
  MockRepository,
  createMockRepository,
} from '../../test/mocks/mock-types';

describe('BookingPaymentService', () => {
  let service: BookingPaymentService;
  let bookingRepo: MockRepository<Booking>;
  let productRepo: MockRepository<Product>;
  let logWriter: jest.Mocked<Pick<BookingStatusLogWriterService, 'write'>>;

  beforeEach(async () => {
    bookingRepo = createMockRepository<Booking>();
    (bookingRepo as MockRepository<Booking> & { manager: unknown }).manager =
      {};
    productRepo = createMockRepository<Product>();
    logWriter = { write: jest.fn().mockResolvedValue({}) };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BookingPaymentService,
        {
          provide: getRepositoryToken(Booking),
          useValue: bookingRepo,
        },
        {
          provide: getRepositoryToken(Product),
          useValue: productRepo,
        },
        { provide: BookingStatusLogWriterService, useValue: logWriter },
      ],
    }).compile();

    service = module.get<BookingPaymentService>(BookingPaymentService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  // ── findByIdAndUser ────────────────────────────────────────

  describe('findByIdAndUser', () => {
    it('should return booking when found', async () => {
      const booking = { id: 'booking-1', userId: 'user-1' };
      bookingRepo.findOne.mockResolvedValue(booking);

      const result = await service.findByIdAndUser('booking-1', 'user-1');
      expect(result).toEqual(booking);
    });

    it('should throw NotFoundException when booking not found', async () => {
      bookingRepo.findOne.mockResolvedValue(null);

      await expect(
        service.findByIdAndUser('booking-1', 'user-1'),
      ).rejects.toThrow(NotFoundException);
    });
  });

  // ── findById ───────────────────────────────────────────────

  describe('findById', () => {
    it('should return booking when found', async () => {
      const booking = { id: 'booking-1' };
      bookingRepo.findOne.mockResolvedValue(booking);

      const result = await service.findById('booking-1');
      expect(result).toEqual(booking);
    });

    it('should throw NotFoundException when booking not found', async () => {
      bookingRepo.findOne.mockResolvedValue(null);

      await expect(service.findById('booking-1')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  // ── resolveBookingAmount ───────────────────────────────────

  describe('resolveBookingAmount', () => {
    it('should throw when booking has no productId', async () => {
      await expect(
        service.resolveBookingAmount({ id: 'booking-1' } as any),
      ).rejects.toThrow(NotFoundException);
    });

    it('should throw when product not found', async () => {
      productRepo.findOne.mockResolvedValue(null);

      await expect(
        service.resolveBookingAmount({
          id: 'booking-1',
          productId: 'product-1',
        } as any),
      ).rejects.toThrow(NotFoundException);
    });

    it('should return salePrice when available', async () => {
      productRepo.findOne.mockResolvedValue({
        id: 'product-1',
        basePrice: 500000,
        salePrice: 350000,
      });

      const amount = await service.resolveBookingAmount({
        id: 'booking-1',
        productId: 'product-1',
      } as any);

      expect(amount).toBe(350000);
    });

    it('should fallback to basePrice when salePrice is null', async () => {
      productRepo.findOne.mockResolvedValue({
        id: 'product-1',
        basePrice: 500000,
        salePrice: null,
      });

      const amount = await service.resolveBookingAmount({
        id: 'booking-1',
        productId: 'product-1',
      } as any);

      expect(amount).toBe(500000);
    });
  });

  // ── updatePaymentLinks ─────────────────────────────────────

  describe('updatePaymentLinks', () => {
    it('should update payment URL and deeplink', async () => {
      const booking = {
        id: 'booking-1',
        paymentUrl: null,
        paymentDeeplink: null,
      };
      bookingRepo.findOne.mockResolvedValue(booking);
      bookingRepo.save.mockResolvedValue(booking);

      const result = await service.updatePaymentLinks(
        'booking-1',
        'https://pay.example.com',
        'momo://pay',
      );

      expect(result.paymentUrl).toBe('https://pay.example.com');
      expect(result.paymentDeeplink).toBe('momo://pay');
      expect(bookingRepo.save).toHaveBeenCalled();
    });
  });

  // ── updateBookingStatus ────────────────────────────────────

  describe('updateBookingStatus', () => {
    it('should update status and create status log', async () => {
      const booking = {
        id: 'booking-1',
        status: BookingStatus.PENDING_PAYMENT,
      };
      bookingRepo.findOne.mockResolvedValue(booking);
      bookingRepo.save.mockResolvedValue({
        ...booking,
        status: BookingStatus.CONFIRMED,
      });
      const result = await service.updateBookingStatus(
        'booking-1',
        BookingStatus.CONFIRMED,
        'system',
        'Payment confirmed',
        BookingStatusReasonCode.PAYMENT_CONFIRMED_MOMO,
      );

      expect(result.status).toBe(BookingStatus.CONFIRMED);
      expect(logWriter.write).toHaveBeenCalledWith(
        (bookingRepo as MockRepository<Booking> & { manager: unknown }).manager,
        expect.objectContaining({
          bookingId: 'booking-1',
          fromStatus: BookingStatus.PENDING_PAYMENT,
          toStatus: BookingStatus.CONFIRMED,
          changedBy: 'system',
          reason: 'Payment confirmed',
          reasonCode: BookingStatusReasonCode.PAYMENT_CONFIRMED_MOMO,
        }),
      );
    });

    it('should return unchanged booking when status is already the same', async () => {
      const booking = { id: 'booking-1', status: BookingStatus.CONFIRMED };
      bookingRepo.findOne.mockResolvedValue(booking);

      const result = await service.updateBookingStatus(
        'booking-1',
        BookingStatus.CONFIRMED,
      );

      expect(result).toBe(booking);
      expect(logWriter.write).not.toHaveBeenCalled();
    });
  });
});
