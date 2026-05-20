import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';
import { BadRequestException, NotFoundException } from '@nestjs/common';
import { Account } from '@/common/entities/account.entity';
import { Payment } from '@/common/entities/payment.entity';
import { PaymentTransactionLog } from '@/common/entities/payment-transaction-log.entity';
import { UserPaymentCustomer } from '@/common/entities/user-payment-customer.entity';
import { UserPaymentMethod } from '@/common/entities/user-payment-method.entity';
import { BookingPaymentService } from './booking-payment.service';
import { PaymentMethod } from './enums/payment-method.enum';
import { PaymentStatus } from './enums/payment-status.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { BookingStatusReasonCode } from '@/booking/enums/booking-status-reason-code.enum';
import {
  MockRepository,
  createMockRepository,
} from '../../test/mocks/mock-types';
import { Product } from '@/common/entities/product.entity';
import { NotificationEventService } from '@/notification/services/notification-event.service';
import { NotificationType } from '@/notification/enums/notification-type.enum';

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
    setupIntents: {
      create: jest.fn(),
      retrieve: jest.fn(),
    },
    customers: {
      create: jest.fn(),
    },
    paymentMethods: {
      retrieve: jest.fn(),
      detach: jest.fn(),
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
  let accountRepo: MockRepository<Account>;
  let paymentRepo: MockRepository<Payment>;
  let txLogRepo: MockRepository<PaymentTransactionLog>;
  let customerRepo: MockRepository<UserPaymentCustomer>;
  let cardRepo: MockRepository<UserPaymentMethod>;
  let bookingPaymentService: {
    findByIdAndUser: jest.Mock;
    findById: jest.Mock;
    resolveBookingAmount: jest.Mock;
    updateBookingStatus: jest.Mock;
    updatePaymentLinks: jest.Mock;
  };
  let notificationEventService: { emit: jest.Mock };
  let productRepo: MockRepository<Product>;

  beforeEach(async () => {
    accountRepo = createMockRepository<Account>();
    paymentRepo = createMockRepository<Payment>();
    txLogRepo = createMockRepository<PaymentTransactionLog>();
    customerRepo = createMockRepository<UserPaymentCustomer>();
    cardRepo = createMockRepository<UserPaymentMethod>();
    bookingPaymentService = {
      findByIdAndUser: jest.fn(),
      findById: jest.fn(),
      resolveBookingAmount: jest.fn(),
      updateBookingStatus: jest.fn(),
      updatePaymentLinks: jest.fn(),
    };
    notificationEventService = { emit: jest.fn() };
    productRepo = createMockRepository<Product>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        StripePaymentService,
        {
          provide: getRepositoryToken(Account),
          useValue: accountRepo,
        },
        {
          provide: getRepositoryToken(Payment),
          useValue: paymentRepo,
        },
        {
          provide: getRepositoryToken(PaymentTransactionLog),
          useValue: txLogRepo,
        },
        {
          provide: getRepositoryToken(UserPaymentCustomer),
          useValue: customerRepo,
        },
        {
          provide: getRepositoryToken(UserPaymentMethod),
          useValue: cardRepo,
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
        {
          provide: NotificationEventService,
          useValue: notificationEventService,
        },
        {
          provide: getRepositoryToken(Product),
          useValue: productRepo,
        },
      ],
    }).compile();

    service = module.get<StripePaymentService>(StripePaymentService);
    accountRepo.findOne.mockResolvedValue({
      id: 'user-1',
      email: 'user@example.com',
    });
    customerRepo.findOne.mockResolvedValue(null);
    customerRepo.save.mockImplementation(async (value) => ({
      id: 'customer-row-1',
      ...value,
    }));
    customerRepo.create.mockImplementation((value) => value);
    cardRepo.find.mockResolvedValue([]);
    cardRepo.count.mockResolvedValue(0);
    cardRepo.update.mockResolvedValue({ affected: 1 });
    cardRepo.save.mockImplementation(async (value) => ({
      id: value.id ?? 'card-row-1',
      isDefault: value.isDefault ?? false,
      ...value,
    }));
    cardRepo.create.mockImplementation((value) => value);
    cardRepo.softDelete.mockResolvedValue({ affected: 1 });

    const stripe = (service as any).stripe;
    stripe.customers.create.mockResolvedValue({ id: 'cus_test_123' });
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

    it('should create payment intent using a saved card', async () => {
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
      cardRepo.findOne.mockResolvedValue({
        id: 'card-1',
        userId: 'user-1',
        customerId: 'customer-row-1',
        provider: PaymentMethod.STRIPE,
        gatewayPaymentMethodId: 'pm_test_123',
      });
      customerRepo.findOne.mockResolvedValue({
        id: 'customer-row-1',
        userId: 'user-1',
        provider: PaymentMethod.STRIPE,
        gatewayCustomerId: 'cus_test_123',
      });

      const stripe = (service as any).stripe;
      stripe.paymentIntents.create.mockResolvedValue({
        id: 'pi_test_123',
        client_secret: 'pi_test_123_secret_abc',
        status: 'requires_confirmation',
        amount: 500000,
      });

      await service.createPayment('booking-1', 'user-1', 'card-1');

      expect(stripe.paymentIntents.create).toHaveBeenCalledWith(
        expect.objectContaining({
          customer: 'cus_test_123',
          payment_method: 'pm_test_123',
          payment_method_types: ['card'],
        }),
      );
    });
  });

  describe('saved cards', () => {
    it('should create a SetupIntent for the current user customer', async () => {
      const stripe = (service as any).stripe;
      stripe.setupIntents.create.mockResolvedValue({
        id: 'seti_test_123',
        client_secret: 'seti_test_123_secret_abc',
      });

      const result = await service.createSetupIntent('user-1');

      expect(result.setupIntentId).toBe('seti_test_123');
      expect(stripe.customers.create).toHaveBeenCalledWith(
        expect.objectContaining({
          email: 'user@example.com',
          metadata: { userId: 'user-1' },
        }),
      );
      expect(stripe.setupIntents.create).toHaveBeenCalledWith(
        expect.objectContaining({
          customer: 'cus_test_123',
          payment_method_types: ['card'],
          usage: 'on_session',
        }),
      );
    });

    it('should persist confirmed SetupIntent card and set it default when first card', async () => {
      customerRepo.findOne.mockResolvedValue({
        id: 'customer-row-1',
        userId: 'user-1',
        provider: PaymentMethod.STRIPE,
        gatewayCustomerId: 'cus_test_123',
      });
      cardRepo.findOne.mockResolvedValue(null);
      cardRepo.count.mockResolvedValue(0);

      const stripe = (service as any).stripe;
      stripe.setupIntents.retrieve.mockResolvedValue({
        id: 'seti_test_123',
        customer: 'cus_test_123',
        status: 'succeeded',
        payment_method: 'pm_test_123',
      });
      stripe.paymentMethods.retrieve.mockResolvedValue({
        id: 'pm_test_123',
        billing_details: { address: { country: 'US' } },
        card: {
          brand: 'visa',
          last4: '4242',
          exp_month: 12,
          exp_year: 2030,
          funding: 'credit',
          country: 'US',
        },
      });

      const result = await service.confirmSetupIntent(
        'seti_test_123',
        'user-1',
        false,
      );

      expect(result.last4).toBe('4242');
      expect(cardRepo.save).toHaveBeenCalledWith(
        expect.objectContaining({
          gatewayPaymentMethodId: 'pm_test_123',
          isDefault: true,
        }),
      );
    });

    it('should replace the default card exclusively', async () => {
      const card = {
        id: 'card-1',
        userId: 'user-1',
        provider: PaymentMethod.STRIPE,
        isDefault: false,
        brand: 'visa',
        last4: '4242',
        expMonth: 12,
        expYear: 2030,
        funding: 'credit',
        country: 'US',
      };
      cardRepo.findOne.mockResolvedValue(card);

      const result = await service.setDefaultCard('user-1', 'card-1');

      expect(cardRepo.update).toHaveBeenCalledWith(
        { userId: 'user-1', provider: PaymentMethod.STRIPE },
        { isDefault: false },
      );
      expect(result.isDefault).toBe(true);
    });

    it('should detach and remove a default card, then promote newest card', async () => {
      cardRepo.findOne
        .mockResolvedValueOnce({
          id: 'card-1',
          userId: 'user-1',
          provider: PaymentMethod.STRIPE,
          gatewayPaymentMethodId: 'pm_test_123',
          isDefault: true,
        })
        .mockResolvedValueOnce({
          id: 'card-2',
          userId: 'user-1',
          provider: PaymentMethod.STRIPE,
          gatewayPaymentMethodId: 'pm_test_456',
          isDefault: false,
        });
      cardRepo.find.mockResolvedValue([
        {
          id: 'card-2',
          brand: 'mastercard',
          last4: '4444',
          expMonth: 11,
          expYear: 2031,
          funding: 'debit',
          country: 'US',
          isDefault: true,
        },
      ]);

      const result = await service.deleteCard('user-1', 'card-1');

      const stripe = (service as any).stripe;
      expect(stripe.paymentMethods.detach).toHaveBeenCalledWith('pm_test_123');
      expect(cardRepo.softDelete).toHaveBeenCalledWith({
        id: 'card-1',
        userId: 'user-1',
      });
      expect(result[0].id).toBe('card-2');
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
        BookingStatusReasonCode.PAYMENT_REFUND_STRIPE_CANCELLED,
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
      bookingPaymentService.findById.mockResolvedValue({
        id: 'booking-1',
        userId: 'user-1',
        productId: 'prod-1',
        startTime: new Date('2025-10-25T14:00:00Z'),
      });
      productRepo.findOne.mockResolvedValue({ id: 'prod-1', name: 'Dental Cleaning' });

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
        BookingStatusReasonCode.PAYMENT_CONFIRMED_STRIPE,
      );

      // Notification should be emitted after payment success
      expect(bookingPaymentService.findById).toHaveBeenCalledWith('booking-1');
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
            last_payment_error: {
              message: 'Card declined',
              code: 'card_declined',
            },
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
      // Notification should NOT be emitted for failed payment
      expect(notificationEventService.emit).not.toHaveBeenCalled();
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
