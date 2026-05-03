import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';
import { BadRequestException, NotFoundException } from '@nestjs/common';
import { Payment } from '@/common/entities/payment.entity';
import { PaymentTransactionLog } from '@/common/entities/payment-transaction-log.entity';
import { BookingPaymentService } from './booking-payment.service';
import { PaymentMethod } from './enums/payment-method.enum';
import { PaymentStatus } from './enums/payment-status.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import {
  MockRepository,
  createMockRepository,
} from '../../test/mocks/mock-types';

/**
 * StripePaymentService calls Stripe SDK directly in the constructor,
 * so we test its methods via a partially-mocked class approach.
 * The actual Stripe SDK calls (paymentIntents.create, refunds.create,
 * webhooks.constructEvent) are mocked at the instance level.
 */

// We import the class after jest mock setup
jest.mock('stripe', () => {
  return jest.fn().mockImplementation(() => ({
    paymentIntents: {
      create: jest.fn(),
    },
    refunds: {
      create: jest.fn(),
    },
    webhooks: {
      constructEvent: jest.fn(),
    },
  }));
});

import { StripePaymentService } from './stripe-payment.service';

describe('StripePaymentService', () => {
  let service: StripePaymentService;
  let paymentRepo: MockRepository<Payment>;
  let txLogRepo: MockRepository<PaymentTransactionLog>;
  let bookingPaymentService: {
    findByIdAndUser: jest.Mock;
    findById: jest.Mock;
    resolveBookingAmount: jest.Mock;
    updateBookingStatus: jest.Mock;
    updatePaymentLinks: jest.Mock;
  };

  beforeEach(async () => {
    paymentRepo = createMockRepository<Payment>();
    txLogRepo = createMockRepository<PaymentTransactionLog>();
    bookingPaymentService = {
      findByIdAndUser: jest.fn(),
      findById: jest.fn(),
      resolveBookingAmount: jest.fn(),
      updateBookingStatus: jest.fn(),
      updatePaymentLinks: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        StripePaymentService,
        {
          provide: getRepositoryToken(Payment),
          useValue: paymentRepo,
        },
        {
          provide: getRepositoryToken(PaymentTransactionLog),
          useValue: txLogRepo,
        },
        {
          provide: BookingPaymentService,
          useValue: bookingPaymentService,
        },
        {
          provide: ConfigService,
          useValue: {
            getOrThrow: jest.fn().mockReturnValue('sk_test_mock_key'),
            get: jest.fn().mockReturnValue('vnd'),
          },
        },
      ],
    }).compile();

    service = module.get<StripePaymentService>(StripePaymentService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  // ── createPayment ──────────────────────────────────────────

  describe('createPayment', () => {
    it('should throw BadRequestException when booking is not PENDING_PAYMENT', async () => {
      bookingPaymentService.findByIdAndUser.mockResolvedValue({
        id: 'booking-1',
        status: BookingStatus.CONFIRMED,
      });

      await expect(
        service.createPayment('booking-1', 'user-1'),
      ).rejects.toThrow(BadRequestException);
    });

    it('should throw BadRequestException when amount is invalid', async () => {
      bookingPaymentService.findByIdAndUser.mockResolvedValue({
        id: 'booking-1',
        status: BookingStatus.PENDING_PAYMENT,
      });
      bookingPaymentService.resolveBookingAmount.mockResolvedValue(0);

      await expect(
        service.createPayment('booking-1', 'user-1'),
      ).rejects.toThrow(BadRequestException);
    });

    it('should create payment intent and return client secret', async () => {
      const mockBooking = {
        id: 'booking-1',
        status: BookingStatus.PENDING_PAYMENT,
      };
      bookingPaymentService.findByIdAndUser.mockResolvedValue(mockBooking);
      bookingPaymentService.resolveBookingAmount.mockResolvedValue(500000);

      const savedPayment = { id: 'payment-1', bookingId: 'booking-1' };
      paymentRepo.create.mockReturnValue(savedPayment);
      paymentRepo.save.mockResolvedValue(savedPayment);
      txLogRepo.create.mockReturnValue({});
      txLogRepo.save.mockResolvedValue({});

      // Mock Stripe SDK via internal reference
      const stripe = (service as any).stripe;
      stripe.paymentIntents.create.mockResolvedValue({
        id: 'pi_test_123',
        client_secret: 'pi_test_123_secret_abc',
        status: 'requires_payment_method',
        amount: 500000,
      });

      const result = await service.createPayment('booking-1', 'user-1');

      expect(result.paymentIntentId).toBe('pi_test_123');
      expect(result.clientSecret).toBe('pi_test_123_secret_abc');
      expect(stripe.paymentIntents.create).toHaveBeenCalledWith(
        expect.objectContaining({
          amount: 500000,
          currency: 'vnd',
        }),
      );
    });
  });

  // ── refundPayment ──────────────────────────────────────────

  describe('refundPayment', () => {
    it('should throw NotFoundException when no paid payment found', async () => {
      bookingPaymentService.findByIdAndUser.mockResolvedValue({
        id: 'booking-1',
      });
      paymentRepo.findOne.mockResolvedValue(null);

      await expect(
        service.refundPayment('booking-1', 'user-1'),
      ).rejects.toThrow(NotFoundException);
    });

    it('should create refund and update booking status on success', async () => {
      const mockBooking = { id: 'booking-1' };
      bookingPaymentService.findByIdAndUser.mockResolvedValue(mockBooking);

      const existingPayment = {
        id: 'payment-1',
        gatewayTransId: 'pi_test_123',
        bookingId: 'booking-1',
        paymentMethod: PaymentMethod.STRIPE,
        paymentStatus: PaymentStatus.PAID,
      };
      paymentRepo.findOne.mockResolvedValue(existingPayment);
      paymentRepo.save.mockResolvedValue(existingPayment);
      txLogRepo.create.mockReturnValue({});
      txLogRepo.save.mockResolvedValue({});
      bookingPaymentService.updateBookingStatus.mockResolvedValue(mockBooking);

      const stripe = (service as any).stripe;
      stripe.refunds.create.mockResolvedValue({
        id: 're_test_456',
        status: 'succeeded',
        amount: 500000,
        currency: 'vnd',
      });

      const result = await service.refundPayment('booking-1', 'user-1');

      expect(result.refundId).toBe('re_test_456');
      expect(result.status).toBe('succeeded');
      expect(bookingPaymentService.updateBookingStatus).toHaveBeenCalledWith(
        'booking-1',
        BookingStatus.CANCELLED,
        'user-1',
        expect.stringContaining('Refund successful'),
      );
    });
  });

  // ── handleWebhookEvent ─────────────────────────────────────

  describe('handleWebhookEvent', () => {
    it('should return false when signature verification fails', async () => {
      const stripe = (service as any).stripe;
      stripe.webhooks.constructEvent.mockImplementation(() => {
        throw new Error('Invalid signature');
      });

      const result = await service.handleWebhookEvent(
        Buffer.from('body'),
        'bad-sig',
      );

      expect(result).toBe(false);
    });

    it('should process payment_intent.succeeded and update status to PAID', async () => {
      const stripe = (service as any).stripe;
      stripe.webhooks.constructEvent.mockReturnValue({
        type: 'payment_intent.succeeded',
        id: 'evt_test_1',
        data: {
          object: {
            id: 'pi_test_123',
            status: 'succeeded',
            amount: 500000,
            metadata: { bookingId: 'booking-1', paymentId: 'payment-1' },
          },
        },
      });

      const payment = {
        id: 'payment-1',
        paymentStatus: PaymentStatus.UNPAID,
      };
      paymentRepo.findOne.mockResolvedValue(payment);
      paymentRepo.save.mockResolvedValue(payment);
      txLogRepo.create.mockReturnValue({});
      txLogRepo.save.mockResolvedValue({});
      bookingPaymentService.updateBookingStatus.mockResolvedValue({});

      const result = await service.handleWebhookEvent(
        Buffer.from('body'),
        'valid-sig',
      );

      expect(result).toBe(true);
      expect(payment.paymentStatus).toBe(PaymentStatus.PAID);
      expect(bookingPaymentService.updateBookingStatus).toHaveBeenCalledWith(
        'booking-1',
        BookingStatus.CONFIRMED,
        'system',
        expect.any(String),
      );
    });

    it('should process payment_intent.payment_failed without changing booking status', async () => {
      const stripe = (service as any).stripe;
      stripe.webhooks.constructEvent.mockReturnValue({
        type: 'payment_intent.payment_failed',
        id: 'evt_test_2',
        data: {
          object: {
            id: 'pi_test_fail',
            status: 'requires_payment_method',
            last_payment_error: { message: 'Card declined', code: 'card_declined' },
          },
        },
      });

      const payment = {
        id: 'payment-fail',
        paymentStatus: PaymentStatus.UNPAID,
      };
      paymentRepo.findOne.mockResolvedValue(payment);
      paymentRepo.save.mockResolvedValue(payment);
      txLogRepo.create.mockReturnValue({});
      txLogRepo.save.mockResolvedValue({});

      const result = await service.handleWebhookEvent(
        Buffer.from('body'),
        'valid-sig',
      );

      expect(result).toBe(true);
      expect(bookingPaymentService.updateBookingStatus).not.toHaveBeenCalled();
    });

    it('should handle unrecognized event types gracefully', async () => {
      const stripe = (service as any).stripe;
      stripe.webhooks.constructEvent.mockReturnValue({
        type: 'charge.updated',
        id: 'evt_test_3',
        data: { object: {} },
      });

      const result = await service.handleWebhookEvent(
        Buffer.from('body'),
        'valid-sig',
      );

      expect(result).toBe(true);
    });
  });
});
