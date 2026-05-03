import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { CreateCheckoutTicketHandler } from './create-checkout-ticket.handler';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { Account } from '@/common/entities/account.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Product } from '@/common/entities/product.entity';
import { CheckSlotAvailabilityHandler } from './check-slot-availability.handler';
import { AsyncCheckoutResponseDto } from '../../dto/async-checkout-response.dto';
import { CheckoutTicketStatus } from '@/booking/enums/checkout-ticket-status.enum';
import {
  MockRepository,
  createMockRepository,
} from '../../../../test/mocks/mock-types';
import { createCheckoutTicketEntity } from '../../../../test/fixtures/test-data.factory';
import { BadRequestException } from '@nestjs/common';
import { RedisService } from '@/redis/redis.service';

describe('CreateCheckoutTicketHandler', () => {
  let handler: CreateCheckoutTicketHandler;
  let ticketRepo: MockRepository<CheckoutTicket>;
  let accountRepo: MockRepository<Account>;
  let employeeRepo: MockRepository<Employee>;
  let productRepo: MockRepository<Product>;
  let slotChecker: { execute: jest.Mock };
  let rmqClient: { emit: jest.Mock };
  let redisService: { [key: string]: jest.Mock };

  beforeEach(async () => {
    ticketRepo = createMockRepository<CheckoutTicket>();
    accountRepo = createMockRepository<Account>();
    employeeRepo = createMockRepository<Employee>();
    productRepo = createMockRepository<Product>();
    slotChecker = { execute: jest.fn() };
    rmqClient = { emit: jest.fn() };
    redisService = {
      get: jest.fn().mockResolvedValue(null),
      set: jest.fn().mockResolvedValue(undefined),
      acquireLock: jest.fn().mockResolvedValue('mock-lock-token'),
      releaseLock: jest.fn().mockResolvedValue(undefined),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CreateCheckoutTicketHandler,
        {
          provide: getRepositoryToken(CheckoutTicket),
          useValue: ticketRepo,
        },
        {
          provide: getRepositoryToken(Account),
          useValue: accountRepo,
        },
        {
          provide: getRepositoryToken(Employee),
          useValue: employeeRepo,
        },
        {
          provide: getRepositoryToken(Product),
          useValue: productRepo,
        },
        {
          provide: 'RABBITMQ_CLIENT',
          useValue: rmqClient,
        },
        {
          provide: CheckSlotAvailabilityHandler,
          useValue: slotChecker,
        },
        {
          provide: RedisService,
          useValue: redisService,
        },
      ],
    }).compile();

    handler = module.get<CreateCheckoutTicketHandler>(
      CreateCheckoutTicketHandler,
    );

    // Default: FK validation passes (entities exist)
    accountRepo.findOne.mockResolvedValue({ id: 'user-1' });
    employeeRepo.findOne.mockResolvedValue({ id: 'staff-1' });
    productRepo.findOne.mockResolvedValue({ id: 'prod-1' });
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

  describe('FK validation', () => {
    it('should throw BadRequestException when userId does not exist', async () => {
      // Arrange
      ticketRepo.findOne.mockResolvedValue(null); // No existing ticket
      accountRepo.findOne.mockResolvedValue(null); // User not found

      // Act & Assert
      await expect(handler.execute(baseDto as any)).rejects.toThrow(
        BadRequestException,
      );
      expect(slotChecker.execute).not.toHaveBeenCalled();
    });

    it('should throw BadRequestException when staffId does not exist', async () => {
      // Arrange
      ticketRepo.findOne.mockResolvedValue(null);
      employeeRepo.findOne.mockResolvedValue(null); // Staff not found

      // Act & Assert
      await expect(handler.execute(baseDto as any)).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should throw BadRequestException when productId does not exist', async () => {
      // Arrange
      ticketRepo.findOne.mockResolvedValue(null);
      productRepo.findOne.mockResolvedValue(null); // Product not found

      const dtoWithProduct = { ...baseDto, productId: 'non-existent' };

      // Act & Assert
      await expect(handler.execute(dtoWithProduct as any)).rejects.toThrow(
        BadRequestException,
      );
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
        lockToken: 'mock-lock-token',
      });
    });
  });
});
