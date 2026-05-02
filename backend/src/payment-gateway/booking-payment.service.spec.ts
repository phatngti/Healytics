import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException } from '@nestjs/common';
import { BookingPaymentService } from './booking-payment.service';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { Product } from '@/common/entities/product.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import {
  MockRepository,
  createMockRepository,
} from '../../test/mocks/mock-types';

describe('BookingPaymentService', () => {
  let service: BookingPaymentService;
  let bookingRepo: MockRepository<Booking>;
  let statusLogRepo: MockRepository<BookingStatusLog>;
  let productRepo: MockRepository<Product>;

  beforeEach(async () => {
    bookingRepo = createMockRepository<Booking>();
    statusLogRepo = createMockRepository<BookingStatusLog>();
    productRepo = createMockRepository<Product>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BookingPaymentService,
        {
          provide: getRepositoryToken(Booking),
          useValue: bookingRepo,
        },
        {
          provide: getRepositoryToken(BookingStatusLog),
          useValue: statusLogRepo,
        },
        {
          provide: getRepositoryToken(Product),
          useValue: productRepo,
        },
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
      const booking = { id: 'booking-1', paymentUrl: null, paymentDeeplink: null };
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
      statusLogRepo.create.mockReturnValue({});
      statusLogRepo.save.mockResolvedValue({});

      const result = await service.updateBookingStatus(
        'booking-1',
        BookingStatus.CONFIRMED,
        'system',
        'Payment confirmed',
      );

      expect(result.status).toBe(BookingStatus.CONFIRMED);
      expect(statusLogRepo.save).toHaveBeenCalled();
    });

    it('should return unchanged booking when status is already the same', async () => {
      const booking = { id: 'booking-1', status: BookingStatus.CONFIRMED };
      bookingRepo.findOne.mockResolvedValue(booking);

      const result = await service.updateBookingStatus(
        'booking-1',
        BookingStatus.CONFIRMED,
      );

      expect(result).toBe(booking);
      expect(statusLogRepo.save).not.toHaveBeenCalled();
    });
  });
});
