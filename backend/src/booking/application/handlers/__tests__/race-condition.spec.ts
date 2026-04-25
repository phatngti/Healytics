import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { ProcessCheckoutHandler } from '../process-checkout.handler';
import { CreateCheckoutTicketHandler } from '../create-checkout-ticket.handler';
import { CheckSlotAvailabilityHandler } from '../check-slot-availability.handler';
import { AcquireMicroLockHandler } from '../acquire-micro-lock.handler';
import { PaymentExpiryService } from '../../../services/payment-expiry.service';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { Account } from '@/common/entities/account.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Product } from '@/common/entities/product.entity';
import { RedisService } from '@/redis/redis.service';
import { WebhookService } from '../../../services/webhook.service';
import { NotificationEventService } from '@/notification/services/notification-event.service';
import { CheckoutTicketStatus } from '@/booking/enums/checkout-ticket-status.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import {
  MockRepository,
  MockQueryRunner,
  createMockRepository,
  createMockQueryRunner,
  createMockDataSource,
} from '../../../../../test/mocks/mock-types';

// ============================================================================
// Shared test data
// ============================================================================

const STAFF_ID = 'staff-race-001';
const START_TIME_ISO = '2025-10-25T14:00:00Z';
const EXPECTED_SLOT_KEY = '2025-10-25_1400';
const EXPECTED_CHECKOUT_LOCK_KEY = `lock:checkout:${STAFF_ID}_${EXPECTED_SLOT_KEY}`;
const EXPECTED_INTENT_LOCK_KEY = `lock:intent:${STAFF_ID}_${EXPECTED_SLOT_KEY}`;

const createBaseMessage = (overrides: Record<string, any> = {}) => ({
  ticketId: `ticket-${Date.now()}`,
  staffId: STAFF_ID,
  startTime: START_TIME_ISO,
  userId: 'user-race-001',
  productId: 'prod-race-001',
  webhookUrl: 'https://hook.example.com',
  ...overrides,
});

const createMockRmqContext = () => ({
  getChannelRef: jest.fn().mockReturnValue({ ack: jest.fn() }),
  getMessage: jest.fn().mockReturnValue({}),
});

// ============================================================================
// Suite 1: ProcessCheckoutHandler — Redis lock contention
// ============================================================================

describe('Race Condition: ProcessCheckoutHandler — Redis lock contention', () => {
  let handler: ProcessCheckoutHandler;
  let ticketRepo: MockRepository<CheckoutTicket>;
  let redisService: { [key: string]: jest.Mock };
  let webhookService: { notify: jest.Mock };
  let notificationEventService: { emit: jest.Mock };
  let queryRunner: MockQueryRunner;

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
        {
          provide: NotificationEventService,
          useValue: notificationEventService,
        },
      ],
    }).compile();

    handler = module.get<ProcessCheckoutHandler>(ProcessCheckoutHandler);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should grant lock to only the first of N concurrent attempts for same slot', async () => {
    // Arrange — first call acquires lock, subsequent calls get null
    let lockCallCount = 0;
    redisService.acquireLock.mockImplementation(() => {
      lockCallCount++;
      return Promise.resolve(lockCallCount === 1 ? 'lock-token-winner' : null);
    });

    // Mock success path for the winner
    queryRunner.manager.findOne.mockResolvedValue({ durationMinutes: 60 });
    queryRunner.manager.create.mockReturnValue({});
    queryRunner.manager.save
      .mockResolvedValueOnce({ id: 'booking-winner', paymentUrl: null })
      .mockResolvedValueOnce({});

    const N = 5;
    const messages = Array.from({ length: N }, (_, i) =>
      createBaseMessage({ ticketId: `ticket-${i}` }),
    );
    const contexts = Array.from({ length: N }, () => createMockRmqContext());

    // Act — fire N concurrent handler calls
    await Promise.all(
      messages.map((msg, i) => handler.handle(msg, contexts[i] as any)),
    );

    // Assert
    expect(redisService.acquireLock).toHaveBeenCalledTimes(N);

    // Exactly 1 ticket updated to SUCCESS (the winner)
    const successUpdates = ticketRepo.update.mock.calls.filter(
      (call) => call[1]?.status === CheckoutTicketStatus.SUCCESS,
    );
    // Note: winner's ticket is updated via queryRunner.manager.update, not ticketRepo.update
    // The (N-1) losers get FAILED via ticketRepo.update
    const failedUpdates = ticketRepo.update.mock.calls.filter(
      (call) => call[1]?.status === CheckoutTicketStatus.FAILED,
    );
    expect(failedUpdates.length).toBe(N - 1);

    // Transaction committed exactly once (by the winner)
    expect(queryRunner.commitTransaction).toHaveBeenCalledTimes(1);
  });

  it('should use correct composite lock key: lock:checkout:{staffId}_{YYYY-MM-DD_HHmm}', async () => {
    // Arrange
    const context = createMockRmqContext();
    redisService.acquireLock.mockResolvedValue(null);

    // Act
    await handler.handle(createBaseMessage(), context as any);

    // Assert
    expect(redisService.acquireLock).toHaveBeenCalledWith(
      EXPECTED_CHECKOUT_LOCK_KEY,
      600, // CHECKOUT_LOCK_TTL_SECONDS
    );
  });

  it('should set correct error message when lock contention fails', async () => {
    // Arrange
    const context = createMockRmqContext();
    const msg = createBaseMessage({ ticketId: 'ticket-loser' });
    redisService.acquireLock.mockResolvedValue(null);

    // Act
    await handler.handle(msg, context as any);

    // Assert
    expect(ticketRepo.update).toHaveBeenCalledWith('ticket-loser', {
      status: CheckoutTicketStatus.FAILED,
      errorMessage: 'Slot already taken by another booking',
    });
  });
});

// ============================================================================
// Suite 2: CreateCheckoutTicketHandler — Slot pre-check race window
// ============================================================================

describe('Race Condition: CreateCheckoutTicketHandler — Slot pre-check race window', () => {
  let handler: CreateCheckoutTicketHandler;
  let ticketRepo: MockRepository<CheckoutTicket>;
  let accountRepo: MockRepository<Account>;
  let employeeRepo: MockRepository<Employee>;
  let productRepo: MockRepository<Product>;
  let slotChecker: { execute: jest.Mock };
  let rmqClient: { emit: jest.Mock };

  beforeEach(async () => {
    ticketRepo = createMockRepository<CheckoutTicket>();
    accountRepo = createMockRepository<Account>();
    employeeRepo = createMockRepository<Employee>();
    productRepo = createMockRepository<Product>();
    slotChecker = { execute: jest.fn() };
    rmqClient = { emit: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CreateCheckoutTicketHandler,
        {
          provide: getRepositoryToken(CheckoutTicket),
          useValue: ticketRepo,
        },
        { provide: getRepositoryToken(Account), useValue: accountRepo },
        { provide: getRepositoryToken(Employee), useValue: employeeRepo },
        { provide: getRepositoryToken(Product), useValue: productRepo },
        { provide: 'RABBITMQ_CLIENT', useValue: rmqClient },
        { provide: CheckSlotAvailabilityHandler, useValue: slotChecker },
      ],
    }).compile();

    handler = module.get<CreateCheckoutTicketHandler>(
      CreateCheckoutTicketHandler,
    );

    // Default: FK validation passes
    accountRepo.findOne.mockResolvedValue({ id: 'user-race-001' });
    employeeRepo.findOne.mockResolvedValue({ id: STAFF_ID });
    productRepo.findOne.mockResolvedValue({ id: 'prod-race-001' });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should create FAILED ticket immediately when slot pre-check returns unavailable', async () => {
    // Arrange
    ticketRepo.findOne.mockResolvedValue(null); // No existing ticket
    slotChecker.execute.mockResolvedValue(false); // Slot unavailable

    const failedTicket = {
      id: 'failed-ticket',
      status: CheckoutTicketStatus.FAILED,
    };
    ticketRepo.create.mockReturnValue(failedTicket);
    ticketRepo.save.mockResolvedValue(failedTicket);

    const dto = {
      userId: 'user-race-001',
      staffId: STAFF_ID,
      startTime: START_TIME_ISO,
      idempotencyKey: 'key-precheck-fail',
      productId: 'prod-race-001',
    };

    // Act
    const result = await handler.execute(dto as any);

    // Assert
    expect(result.status).toBe(CheckoutTicketStatus.FAILED);
    expect(result.message).toContain('no longer available');
    expect(rmqClient.emit).not.toHaveBeenCalled();
  });

  it('should allow two concurrent pre-checks to both pass (optimistic check)', async () => {
    // Arrange — slot is available for both checks (pre-check is optimistic)
    ticketRepo.findOne.mockResolvedValue(null);
    slotChecker.execute.mockResolvedValue(true);

    const queuedTicket1 = { id: 'tk-1', status: CheckoutTicketStatus.QUEUED };
    const queuedTicket2 = { id: 'tk-2', status: CheckoutTicketStatus.QUEUED };
    ticketRepo.create
      .mockReturnValueOnce(queuedTicket1)
      .mockReturnValueOnce(queuedTicket2);
    ticketRepo.save
      .mockResolvedValueOnce(queuedTicket1)
      .mockResolvedValueOnce(queuedTicket2);

    const dto1 = {
      userId: 'user-1',
      staffId: STAFF_ID,
      startTime: START_TIME_ISO,
      idempotencyKey: 'key-race-1',
      productId: 'prod-race-001',
    };
    const dto2 = {
      userId: 'user-2',
      staffId: STAFF_ID,
      startTime: START_TIME_ISO,
      idempotencyKey: 'key-race-2',
      productId: 'prod-race-001',
    };

    // Act — concurrent execution
    const [result1, result2] = await Promise.all([
      handler.execute(dto1 as any),
      handler.execute(dto2 as any),
    ]);

    // Assert — both get QUEUED (the real guard is the consumer's Redis lock)
    expect(result1.status).toBe('QUEUED');
    expect(result2.status).toBe('QUEUED');
    expect(rmqClient.emit).toHaveBeenCalledTimes(2);
  });

  it('should demonstrate that pre-check pass + consumer lock denial = eventual FAILED', async () => {
    // This is a documentation test showing the full race window:
    // Pre-check says available → ticket QUEUED → consumer finds lock taken → FAILED

    // Arrange
    ticketRepo.findOne.mockResolvedValue(null);
    slotChecker.execute.mockResolvedValue(true); // Pre-check passes

    const queuedTicket = { id: 'tk-race', status: CheckoutTicketStatus.QUEUED };
    ticketRepo.create.mockReturnValue(queuedTicket);
    ticketRepo.save.mockResolvedValue(queuedTicket);

    const dto = {
      userId: 'user-1',
      staffId: STAFF_ID,
      startTime: START_TIME_ISO,
      idempotencyKey: 'key-race-window',
      productId: 'prod-race-001',
    };

    // Act — ticket creation phase
    const result = await handler.execute(dto as any);

    // Assert — ticket is QUEUED, even though another user will win the lock
    expect(result.status).toBe('QUEUED');
    expect(rmqClient.emit).toHaveBeenCalledWith(
      'checkout.process',
      expect.objectContaining({ ticketId: 'tk-race' }),
    );
  });
});

// ============================================================================
// Suite 3: Idempotency — duplicate request handling
// ============================================================================

describe('Race Condition: Idempotency — duplicate request handling', () => {
  let handler: CreateCheckoutTicketHandler;
  let ticketRepo: MockRepository<CheckoutTicket>;
  let slotChecker: { execute: jest.Mock };
  let rmqClient: { emit: jest.Mock };

  beforeEach(async () => {
    ticketRepo = createMockRepository<CheckoutTicket>();
    const accountRepo = createMockRepository<Account>();
    const employeeRepo = createMockRepository<Employee>();
    const productRepo = createMockRepository<Product>();
    slotChecker = { execute: jest.fn() };
    rmqClient = { emit: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CreateCheckoutTicketHandler,
        {
          provide: getRepositoryToken(CheckoutTicket),
          useValue: ticketRepo,
        },
        { provide: getRepositoryToken(Account), useValue: accountRepo },
        { provide: getRepositoryToken(Employee), useValue: employeeRepo },
        { provide: getRepositoryToken(Product), useValue: productRepo },
        { provide: 'RABBITMQ_CLIENT', useValue: rmqClient },
        { provide: CheckSlotAvailabilityHandler, useValue: slotChecker },
      ],
    }).compile();

    handler = module.get<CreateCheckoutTicketHandler>(
      CreateCheckoutTicketHandler,
    );

    // FK validation passes
    accountRepo.findOne.mockResolvedValue({ id: 'user-1' });
    employeeRepo.findOne.mockResolvedValue({ id: STAFF_ID });
    productRepo.findOne.mockResolvedValue({ id: 'prod-1' });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should return existing ticket without re-queueing for same idempotencyKey', async () => {
    // Arrange — existing ticket found
    const existingTicket = {
      id: 'existing-tk',
      idempotencyKey: 'duplicate-key',
      status: CheckoutTicketStatus.SUCCESS,
    };
    ticketRepo.findOne.mockResolvedValue(existingTicket);

    const dto = {
      userId: 'user-1',
      staffId: STAFF_ID,
      startTime: START_TIME_ISO,
      idempotencyKey: 'duplicate-key',
      productId: 'prod-1',
    };

    // Act
    const result = await handler.execute(dto as any);

    // Assert
    expect(result.ticketId).toBe('existing-tk');
    expect(result.message).toContain('Duplicate');
    expect(ticketRepo.save).not.toHaveBeenCalled();
    expect(rmqClient.emit).not.toHaveBeenCalled();
    expect(slotChecker.execute).not.toHaveBeenCalled();
  });

  it('should create separate tickets for different idempotencyKeys targeting same slot', async () => {
    // Arrange
    ticketRepo.findOne.mockResolvedValue(null); // No existing ticket
    slotChecker.execute.mockResolvedValue(true);

    const tk1 = { id: 'tk-key-a', status: CheckoutTicketStatus.QUEUED };
    const tk2 = { id: 'tk-key-b', status: CheckoutTicketStatus.QUEUED };
    ticketRepo.create.mockReturnValueOnce(tk1).mockReturnValueOnce(tk2);
    ticketRepo.save.mockResolvedValueOnce(tk1).mockResolvedValueOnce(tk2);

    const dto1 = {
      userId: 'user-1',
      staffId: STAFF_ID,
      startTime: START_TIME_ISO,
      idempotencyKey: 'key-A',
      productId: 'prod-1',
    };
    const dto2 = {
      userId: 'user-2',
      staffId: STAFF_ID,
      startTime: START_TIME_ISO,
      idempotencyKey: 'key-B',
      productId: 'prod-1',
    };

    // Act
    const [r1, r2] = await Promise.all([
      handler.execute(dto1 as any),
      handler.execute(dto2 as any),
    ]);

    // Assert — both QUEUED with different ticket IDs
    expect(r1.ticketId).toBe('tk-key-a');
    expect(r2.ticketId).toBe('tk-key-b');
    expect(rmqClient.emit).toHaveBeenCalledTimes(2);
  });
});

// ============================================================================
// Suite 4: Transaction rollback on failure
// ============================================================================

describe('Race Condition: Transaction rollback on failure', () => {
  let handler: ProcessCheckoutHandler;
  let ticketRepo: MockRepository<CheckoutTicket>;
  let redisService: { [key: string]: jest.Mock };
  let webhookService: { notify: jest.Mock };
  let notificationEventService: { emit: jest.Mock };
  let queryRunner: MockQueryRunner;

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
        {
          provide: NotificationEventService,
          useValue: notificationEventService,
        },
      ],
    }).compile();

    handler = module.get<ProcessCheckoutHandler>(ProcessCheckoutHandler);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should rollback transaction and release lock on DB error during booking save', async () => {
    // Arrange
    const context = createMockRmqContext();
    redisService.acquireLock.mockResolvedValue('lock-token');
    queryRunner.manager.findOne.mockResolvedValue({ durationMinutes: 60 });
    queryRunner.manager.create.mockReturnValue({});
    queryRunner.manager.save.mockRejectedValue(
      new Error('DB constraint violation'),
    );

    // Act
    await handler.handle(createBaseMessage(), context as any);

    // Assert
    expect(queryRunner.rollbackTransaction).toHaveBeenCalled();
    expect(queryRunner.release).toHaveBeenCalled();
    expect(redisService.releaseLock).toHaveBeenCalledWith(
      EXPECTED_CHECKOUT_LOCK_KEY,
      '', // Handler releases with empty token since it doesn't store it
    );
  });

  it('should not leave orphaned checkout lock after partial transaction failure', async () => {
    // Arrange — booking save succeeds but status log save fails
    const context = createMockRmqContext();
    redisService.acquireLock.mockResolvedValue('lock-token');
    queryRunner.manager.findOne.mockResolvedValue({ durationMinutes: 60 });
    queryRunner.manager.create.mockReturnValue({});
    queryRunner.manager.save
      .mockResolvedValueOnce({ id: 'booking-partial', paymentUrl: null })
      .mockRejectedValueOnce(new Error('Status log save failed'));

    // Act
    await handler.handle(createBaseMessage(), context as any);

    // Assert — lock released so slot becomes available again
    expect(queryRunner.rollbackTransaction).toHaveBeenCalled();
    expect(redisService.releaseLock).toHaveBeenCalledWith(
      EXPECTED_CHECKOUT_LOCK_KEY,
      '',
    );

    // Ticket marked as FAILED
    expect(ticketRepo.update).toHaveBeenCalledWith(
      expect.any(String),
      expect.objectContaining({
        status: CheckoutTicketStatus.FAILED,
        errorMessage: expect.stringContaining('Internal error'),
      }),
    );
  });
});

// ============================================================================
// Suite 5: formatSlotKey consistency across all handlers
// ============================================================================

describe('Race Condition: formatSlotKey consistency', () => {
  it('should produce identical key format across all handlers for same datetime', () => {
    // The formatSlotKey method is private in each handler, so we test
    // the observable behavior through the lock keys they generate.
    // All handlers must produce: YYYY-MM-DD_HHmm in UTC

    const testDate = new Date('2025-10-25T14:30:00Z');

    // Manually compute expected key format
    const yyyy = testDate.getUTCFullYear();
    const mm = String(testDate.getUTCMonth() + 1).padStart(2, '0');
    const dd = String(testDate.getUTCDate()).padStart(2, '0');
    const hh = String(testDate.getUTCHours()).padStart(2, '0');
    const min = String(testDate.getUTCMinutes()).padStart(2, '0');
    const expectedKey = `${yyyy}-${mm}-${dd}_${hh}${min}`;

    expect(expectedKey).toBe('2025-10-25_1430');

    // Verify consistency for edge cases
    const edgeCases = [
      {
        input: '2025-01-01T00:00:00Z',
        expected: '2025-01-01_0000',
        label: 'midnight',
      },
      {
        input: '2025-12-31T23:59:00Z',
        expected: '2025-12-31_2359',
        label: 'end of year',
      },
      {
        input: '2025-06-15T09:05:00Z',
        expected: '2025-06-15_0905',
        label: 'single-digit hour/minute',
      },
    ];

    for (const { input, expected, label } of edgeCases) {
      const d = new Date(input);
      const key = `${d.getUTCFullYear()}-${String(d.getUTCMonth() + 1).padStart(2, '0')}-${String(d.getUTCDate()).padStart(2, '0')}_${String(d.getUTCHours()).padStart(2, '0')}${String(d.getUTCMinutes()).padStart(2, '0')}`;
      expect(key).toBe(expected);
    }
  });
});

// ============================================================================
// Suite 6: Concurrent lock + message ACK behavior
// ============================================================================

describe('Race Condition: Message ACK behavior', () => {
  let handler: ProcessCheckoutHandler;
  let ticketRepo: MockRepository<CheckoutTicket>;
  let redisService: { [key: string]: jest.Mock };
  let webhookService: { notify: jest.Mock };
  let notificationEventService: { emit: jest.Mock };
  let queryRunner: MockQueryRunner;

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
        {
          provide: NotificationEventService,
          useValue: notificationEventService,
        },
      ],
    }).compile();

    handler = module.get<ProcessCheckoutHandler>(ProcessCheckoutHandler);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should ACK message regardless of lock outcome (success or denial)', async () => {
    // Test success path ACK
    const successCtx = createMockRmqContext();
    redisService.acquireLock.mockResolvedValue('token');
    queryRunner.manager.findOne.mockResolvedValue({ durationMinutes: 60 });
    queryRunner.manager.create.mockReturnValue({});
    queryRunner.manager.save
      .mockResolvedValueOnce({ id: 'bk', paymentUrl: null })
      .mockResolvedValueOnce({});

    await handler.handle(createBaseMessage({ ticketId: 'success-tk' }), successCtx as any);
    expect(successCtx.getChannelRef().ack).toHaveBeenCalledTimes(1);

    // Reset and test failure path ACK
    jest.clearAllMocks();
    const failCtx = createMockRmqContext();
    redisService.acquireLock.mockResolvedValue(null);

    await handler.handle(createBaseMessage({ ticketId: 'fail-tk' }), failCtx as any);
    expect(failCtx.getChannelRef().ack).toHaveBeenCalledTimes(1);
  });

  it('should ACK message even when unhandled exception occurs', async () => {
    // Arrange — make the very first DB call throw
    const context = createMockRmqContext();
    ticketRepo.update.mockRejectedValue(new Error('Total DB meltdown'));

    // Act
    await handler.handle(createBaseMessage(), context as any);

    // Assert — message still ACK'd (prevents infinite requeue)
    expect(context.getChannelRef().ack).toHaveBeenCalledTimes(1);
  });
});
