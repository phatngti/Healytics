import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { ProcessCheckoutHandler } from './process-checkout.handler';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { RedisService } from '@/redis/redis.service';
import { WebhookService } from '../../services/webhook.service';
import { NotificationEventService } from '@/notification/services/notification-event.service';
import { CheckoutTicketStatus } from '@/booking/enums/checkout-ticket-status.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import {
  MockRepository,
  MockQueryRunner,
  createMockRepository,
  createMockQueryRunner,
  createMockDataSource,
} from '../../../../test/mocks/mock-types';

describe('ProcessCheckoutHandler', () => {
  let handler: ProcessCheckoutHandler;
  let ticketRepo: MockRepository<CheckoutTicket>;
  let redisService: { [key: string]: jest.Mock };
  let webhookService: { notify: jest.Mock };
  let notificationEventService: { emit: jest.Mock };
  let queryRunner: MockQueryRunner;

  // Common RMQ context mock
  const createMockContext = () => ({
    getChannelRef: jest.fn().mockReturnValue({ ack: jest.fn() }),
    getMessage: jest.fn().mockReturnValue({}),
  });

  const baseMessage = {
    ticketId: 'ticket-1',
    staffId: 'staff-1',
    startTime: '2025-10-25T14:00:00Z',
    userId: 'user-1',
    productId: 'prod-1',
    webhookUrl: 'https://hook.example.com',
  };

  beforeEach(async () => {
    ticketRepo = createMockRepository<CheckoutTicket>();
    redisService = {
      acquireLock: jest.fn(),
      releaseLock: jest.fn(),
      getLockTTL: jest.fn(),
    };
    webhookService = { notify: jest.fn().mockResolvedValue(undefined) };
    notificationEventService = { emit: jest.fn() };
    queryRunner = createMockQueryRunner();

    const mockDataSource = createMockDataSource(queryRunner);

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProcessCheckoutHandler,
        {
          provide: getRepositoryToken(CheckoutTicket),
          useValue: ticketRepo,
        },
        { provide: DataSource, useValue: mockDataSource },
        { provide: RedisService, useValue: redisService },
        { provide: WebhookService, useValue: webhookService },
        { provide: NotificationEventService, useValue: notificationEventService },
      ],
    }).compile();

    handler = module.get<ProcessCheckoutHandler>(ProcessCheckoutHandler);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('success path', () => {
    it('should acquire lock, create booking + status log, update ticket, commit, and send webhook', async () => {
      // Arrange
      const context = createMockContext();
      redisService.acquireLock.mockResolvedValue('lock-token');

      // Mock product definition lookup (for endTime calculation)
      queryRunner.manager.findOne.mockResolvedValue({ durationMinutes: 60 });

      // Mock booking save
      const savedBooking = {
        id: 'booking-new',
        paymentUrl: null,
      };
      queryRunner.manager.create.mockReturnValue({});
      queryRunner.manager.save
        .mockResolvedValueOnce(savedBooking) // Save booking
        .mockResolvedValueOnce({}); // Save status log

      // Act
      await handler.handle(baseMessage, context as any);

      // Assert
      // 1. Ticket was updated to PROCESSING
      expect(ticketRepo.update).toHaveBeenCalledWith('ticket-1', {
        status: CheckoutTicketStatus.PROCESSING,
      });

      // 2. Lock was acquired
      expect(redisService.acquireLock).toHaveBeenCalledWith(
        'lock:checkout:staff-1_2025-10-25_1400',
        600,
      );

      // 3. Transaction was committed
      expect(queryRunner.connect).toHaveBeenCalled();
      expect(queryRunner.startTransaction).toHaveBeenCalled();
      expect(queryRunner.commitTransaction).toHaveBeenCalled();
      expect(queryRunner.release).toHaveBeenCalled();

      // 4. Webhook was notified
      expect(webhookService.notify).toHaveBeenCalledWith(
        'https://hook.example.com',
        expect.objectContaining({
          ticket_id: 'ticket-1',
          status: 'SUCCESS',
          data: expect.objectContaining({
            booking_id: 'booking-new',
          }),
        }),
      );

      // 5. Message was ACK'd
      expect(context.getChannelRef().ack).toHaveBeenCalled();
    });
  });

  describe('failure path — lock denied', () => {
    it('should update ticket to FAILED and send failure webhook', async () => {
      // Arrange
      const context = createMockContext();
      redisService.acquireLock.mockResolvedValue(null); // Lock denied

      // Act
      await handler.handle(baseMessage, context as any);

      // Assert
      // Ticket updated to FAILED
      expect(ticketRepo.update).toHaveBeenCalledWith('ticket-1', {
        status: CheckoutTicketStatus.FAILED,
        errorMessage: 'Slot already taken by another booking',
      });

      // Webhook sent with FAILED status
      expect(webhookService.notify).toHaveBeenCalledWith(
        'https://hook.example.com',
        expect.objectContaining({
          ticket_id: 'ticket-1',
          status: 'FAILED',
          data: null,
          error: 'Slot already taken by another booking',
        }),
      );

      // Message was still ACK'd
      expect(context.getChannelRef().ack).toHaveBeenCalled();
    });
  });

  describe('error path — transaction failure', () => {
    it('should rollback transaction, release lock, and still ACK message', async () => {
      // Arrange
      const context = createMockContext();
      redisService.acquireLock.mockResolvedValue('lock-token');
      // Simulate transaction error
      queryRunner.manager.findOne.mockRejectedValue(new Error('DB error'));

      // Act
      await handler.handle(baseMessage, context as any);

      // Assert
      // Transaction was rolled back
      expect(queryRunner.rollbackTransaction).toHaveBeenCalled();
      expect(queryRunner.release).toHaveBeenCalled();

      // Lock was released
      expect(redisService.releaseLock).toHaveBeenCalledWith(
        'lock:checkout:staff-1_2025-10-25_1400',
        '',
      );

      // Ticket was updated to FAILED
      expect(ticketRepo.update).toHaveBeenCalledWith('ticket-1', {
        status: CheckoutTicketStatus.FAILED,
        errorMessage: expect.stringContaining('Internal error'),
      });

      // Message was still ACK'd (never requeue deterministic failures)
      expect(context.getChannelRef().ack).toHaveBeenCalled();
    });
  });

  describe('webhook URL handling', () => {
    it('should pass null webhook URL when not provided', async () => {
      // Arrange
      const context = createMockContext();
      redisService.acquireLock.mockResolvedValue(null);

      const msgWithoutWebhook = { ...baseMessage, webhookUrl: undefined };

      // Act
      await handler.handle(msgWithoutWebhook, context as any);

      // Assert
      expect(webhookService.notify).toHaveBeenCalledWith(
        null,
        expect.any(Object),
      );
    });
  });
});
