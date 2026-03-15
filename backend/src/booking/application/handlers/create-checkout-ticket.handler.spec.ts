import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { CreateCheckoutTicketHandler } from './create-checkout-ticket.handler';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { CheckSlotAvailabilityHandler } from './check-slot-availability.handler';
import { AsyncCheckoutResponseDto } from '../../dto/async-checkout-response.dto';
import { CheckoutTicketStatus } from '@/booking/enums/checkout-ticket-status.enum';
import {
  MockRepository,
  createMockRepository,
} from '../../../../test/mocks/mock-types';
import { createCheckoutTicketEntity } from '../../../../test/fixtures/test-data.factory';

describe('CreateCheckoutTicketHandler', () => {
  let handler: CreateCheckoutTicketHandler;
  let ticketRepo: MockRepository<CheckoutTicket>;
  let slotChecker: { execute: jest.Mock };
  let rmqClient: { emit: jest.Mock };

  beforeEach(async () => {
    ticketRepo = createMockRepository<CheckoutTicket>();
    slotChecker = { execute: jest.fn() };
    rmqClient = { emit: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CreateCheckoutTicketHandler,
        {
          provide: getRepositoryToken(CheckoutTicket),
          useValue: ticketRepo,
        },
        {
          provide: 'RABBITMQ_CLIENT',
          useValue: rmqClient,
        },
        {
          provide: CheckSlotAvailabilityHandler,
          useValue: slotChecker,
        },
      ],
    }).compile();

    handler = module.get<CreateCheckoutTicketHandler>(CreateCheckoutTicketHandler);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  const baseDto = {
    userId: 'user-1',
    staffId: 'staff-1',
    startTime: '2025-10-25T14:00:00Z',
    idempotencyKey: 'key-1',
    productId: undefined,
    webhookUrl: undefined,
  };

  describe('idempotency check', () => {
    it('should return existing ticket when idempotency key matches', async () => {
      // Arrange
      const existingTicket = createCheckoutTicketEntity({
        id: 'existing-ticket',
        idempotencyKey: 'key-1',
        status: CheckoutTicketStatus.SUCCESS as any,
      });
      ticketRepo.findOne.mockResolvedValue(existingTicket);

      // Act
      const result = await handler.execute(baseDto as any);

      // Assert
      expect(result).toBeInstanceOf(AsyncCheckoutResponseDto);
      expect(result.ticketId).toBe('existing-ticket');
      expect(result.status).toBe(CheckoutTicketStatus.SUCCESS);
      expect(result.message).toContain('Duplicate');
      // Should not check slot or create new ticket
      expect(slotChecker.execute).not.toHaveBeenCalled();
      expect(ticketRepo.save).not.toHaveBeenCalled();
    });
  });

  describe('slot pre-check failure', () => {
    it('should create FAILED ticket when slot is unavailable', async () => {
      // Arrange
      ticketRepo.findOne.mockResolvedValue(null); // No existing ticket
      slotChecker.execute.mockResolvedValue(false); // Slot unavailable

      const failedTicket = createCheckoutTicketEntity({
        id: 'failed-ticket',
        status: CheckoutTicketStatus.FAILED as any,
        errorMessage: 'Slot is no longer available.',
      });
      ticketRepo.create.mockReturnValue(failedTicket);
      ticketRepo.save.mockResolvedValue(failedTicket);

      // Act
      const result = await handler.execute(baseDto as any);

      // Assert
      expect(result).toBeInstanceOf(AsyncCheckoutResponseDto);
      expect(result.ticketId).toBe('failed-ticket');
      expect(result.status).toBe(CheckoutTicketStatus.FAILED);
      expect(result.message).toContain('no longer available');
      // Should not emit to RabbitMQ
      expect(rmqClient.emit).not.toHaveBeenCalled();
    });
  });

  describe('successful queueing', () => {
    it('should create QUEUED ticket and emit to RabbitMQ', async () => {
      // Arrange
      ticketRepo.findOne.mockResolvedValue(null); // No existing ticket
      slotChecker.execute.mockResolvedValue(true); // Slot available

      const queuedTicket = createCheckoutTicketEntity({
        id: 'queued-ticket',
        status: CheckoutTicketStatus.QUEUED as any,
      });
      ticketRepo.create.mockReturnValue(queuedTicket);
      ticketRepo.save.mockResolvedValue(queuedTicket);

      // Act
      const result = await handler.execute(baseDto as any);

      // Assert
      expect(result).toBeInstanceOf(AsyncCheckoutResponseDto);
      expect(result.ticketId).toBe('queued-ticket');
      expect(result.status).toBe('QUEUED');
    });

    it('should publish correct payload to checkout.process queue', async () => {
      // Arrange
      ticketRepo.findOne.mockResolvedValue(null);
      slotChecker.execute.mockResolvedValue(true);

      const savedTicket = createCheckoutTicketEntity({ id: 'tk-queue' });
      ticketRepo.create.mockReturnValue(savedTicket);
      ticketRepo.save.mockResolvedValue(savedTicket);

      const dto = {
        ...baseDto,
        productId: 'prod-1',
        webhookUrl: 'https://hook.example.com',
      };

      // Act
      await handler.execute(dto as any);

      // Assert
      expect(rmqClient.emit).toHaveBeenCalledWith('checkout.process', {
        ticketId: 'tk-queue',
        staffId: dto.staffId,
        startTime: dto.startTime,
        userId: dto.userId,
        productId: dto.productId,
        webhookUrl: dto.webhookUrl,
      });
    });
  });
});
