import {
  Injectable,
  Logger,
  BadRequestException,
  ConflictException,
  Inject,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, QueryFailedError } from 'typeorm';
import { ClientProxy } from '@nestjs/microservices';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { Account } from '@/common/entities/account.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Product } from '@/common/entities/product.entity';
import { CheckoutTicketStatus } from '@/booking/enums/checkout-ticket-status.enum';
import { AsyncCheckoutDto } from '../../dto/async-checkout.dto';
import { AsyncCheckoutResponseDto } from '../../dto/async-checkout-response.dto';
import { CheckSlotAvailabilityHandler } from './check-slot-availability.handler';
import { RABBITMQ_CLIENT } from '@/rabbitmq/rabbitmq.module';
import { RedisService } from '@/redis/redis.service';
import { formatSlotKey } from '../../utils/slot-key.util';

/** Pre-lock TTL in seconds — must be >= max queue delay + transaction time */
const CHECKOUT_PRELOCK_TTL_SECONDS = 600; // 10 minutes

@Injectable()
export class CreateCheckoutTicketHandler {
  private readonly logger = new Logger(CreateCheckoutTicketHandler.name);

  /** Redis key prefix for caching ticket responses by idempotency key */
  private static readonly CACHE_PREFIX = 'checkout:ticket:';
  /** Cache TTL in seconds — 1 hour */
  private static readonly CACHE_TTL = 3600;

  constructor(
    @InjectRepository(CheckoutTicket)
    private readonly ticketRepo: Repository<CheckoutTicket>,
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
    @InjectRepository(Employee)
    private readonly employeeRepo: Repository<Employee>,
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,
    @Inject(RABBITMQ_CLIENT)
    private readonly rmqClient: ClientProxy,
    private readonly slotChecker: CheckSlotAvailabilityHandler,
    private readonly redisService: RedisService,
  ) {}

  async execute(dto: AsyncCheckoutDto): Promise<AsyncCheckoutResponseDto> {
    this.logger.log(
      `Creating checkout ticket: user=${dto.userId}, staff=${dto.staffId}, key=${dto.idempotencyKey}`,
    );

    // 1. Idempotency check — Redis fast path, then DB fallback
    const cacheKey = `${CreateCheckoutTicketHandler.CACHE_PREFIX}${dto.idempotencyKey}`;

    // 1a. Try Redis first (sub-ms lookup)
    try {
      const cached = await this.redisService.get(cacheKey);
      if (cached) {
        const parsed = JSON.parse(cached) as {
          ticketId: string;
          status: string;
          message: string;
        };
        this.logger.log(
          `Idempotent return (Redis): ticket=${parsed.ticketId}, status=${parsed.status}`,
        );
        return new AsyncCheckoutResponseDto(
          parsed.ticketId,
          parsed.status,
          'Duplicate request — returning existing ticket.',
        );
      }
    } catch (error) {
      // Redis unavailable — fall through to DB
      this.logger.warn(
        `Redis cache read failed for idempotencyKey=${dto.idempotencyKey}: ${error.message}`,
      );
    }

    // 1b. DB fallback — authoritative idempotency check
    try {
      const existing = await this.ticketRepo.findOne({
        where: { idempotencyKey: dto.idempotencyKey },
      });
      if (existing) {
        this.logger.log(
          `Idempotent return (DB): ticket=${existing.id}, status=${existing.status}`,
        );

        // Back-fill Redis cache for future fast lookups
        await this.cacheTicketResponse(cacheKey, {
          ticketId: existing.id,
          status: existing.status,
          message: 'Duplicate request — returning existing ticket.',
        });

        return new AsyncCheckoutResponseDto(
          existing.id,
          existing.status,
          'Duplicate request — returning existing ticket.',
        );
      }
    } catch (error) {
      this.logger.error(
        `DB error during idempotency check: idempotencyKey=${dto.idempotencyKey}`,
        error.stack,
      );
      throw error;
    }

    // 2. Validate FK references exist before insert
    await this.validateForeignKeys(dto);

    // 3. Pre-check slot availability (optional fast fail)
    let available: boolean;
    try {
      available = await this.slotChecker.execute(
        dto.staffId,
        new Date(dto.startTime),
      );
    } catch (error) {
      this.logger.error(
        `Slot availability check failed — staffId=${dto.staffId}, startTime=${dto.startTime}`,
        error.stack,
      );
      throw error;
    }

    if (!available) {
      this.logger.warn(
        `Slot pre-check failed: staff=${dto.staffId}, time=${dto.startTime}`,
      );
      return this.createFailedTicket(dto, cacheKey, 'Slot is no longer available.');
    }

    // 3b. Acquire checkout pre-lock (closes TOCTOU gap between API and consumer)
    const startDate = new Date(dto.startTime);
    const dateStr = formatSlotKey(startDate);
    const lockKey = `lock:checkout:${dto.staffId}_${dateStr}`;
    let lockToken: string | null = null;

    try {
      lockToken = await this.redisService.acquireLock(
        lockKey,
        CHECKOUT_PRELOCK_TTL_SECONDS,
      );
    } catch (error) {
      this.logger.error(
        `Redis pre-lock acquisition failed — key=${lockKey}`,
        error.stack,
      );
      // Redis failure: allow through — consumer will fall back to acquireLock()
    }

    if (lockToken === null) {
      // Another ticket already holds this slot — fast fail
      this.logger.warn(
        `Pre-lock denied: staff=${dto.staffId}, time=${dto.startTime}, key=${lockKey}`,
      );
      return this.createFailedTicket(dto, cacheKey, 'Slot is no longer available.');
    }

    // 4. Create QUEUED ticket (with lockToken for consumer validation)
    let saved: CheckoutTicket;
    try {
      const ticket = this.ticketRepo.create({
        userId: dto.userId,
        staffId: dto.staffId,
        startTime: startDate,
        productId: dto.productId || null,
        idempotencyKey: dto.idempotencyKey,
        webhookUrl: dto.webhookUrl || null,
        status: CheckoutTicketStatus.QUEUED,
        lockToken,
      });
      saved = await this.ticketRepo.save(ticket);
    } catch (error) {
      const ticketData = {
        userId: dto.userId,
        staffId: dto.staffId,
        startTime: dto.startTime,
        productId: dto.productId,
        idempotencyKey: dto.idempotencyKey,
      };

      // Release pre-lock on ticket save failure so slot becomes available again
      if (lockToken) {
        try {
          await this.redisService.releaseLock(lockKey, lockToken);
        } catch (releaseError) {
          this.logger.warn(
            `Failed to release pre-lock after ticket save error — key=${lockKey}`,
          );
        }
      }

      if (
        error instanceof QueryFailedError &&
        (error as QueryFailedError & { code?: string }).code === '23503'
      ) {
        this.logger.error(
          `FK constraint violation saving QUEUED ticket — data=${JSON.stringify(ticketData)}, detail=${(error as any).detail ?? error.message}`,
        );
        throw new BadRequestException(
          `Referenced entity does not exist. Please verify userId, staffId, and productId are valid.`,
        );
      }

      this.logger.error(
        `DB error saving QUEUED ticket — data=${JSON.stringify(ticketData)}`,
        error.stack,
      );
      throw error;
    }

    // 5. Cache QUEUED ticket for fast future lookups
    await this.cacheTicketResponse(cacheKey, {
      ticketId: saved.id,
      status: CheckoutTicketStatus.QUEUED,
      message:
        'Your booking request is being processed. You will be notified via webhook.',
    });

    // 6. Publish to RabbitMQ queue (include lockToken for consumer validation)
    const rmqPayload = {
      ticketId: saved.id,
      staffId: dto.staffId,
      startTime: dto.startTime,
      userId: dto.userId,
      productId: dto.productId,
      webhookUrl: dto.webhookUrl,
      lockToken,
    };
    try {
      this.rmqClient.emit('checkout.process', rmqPayload);
      this.logger.log(
        `Ticket queued: ${saved.id}, published to checkout.process`,
      );
    } catch (error) {
      this.logger.error(
        `RabbitMQ emit failed for checkout.process — payload=${JSON.stringify(rmqPayload)}`,
        error.stack,
      );
      // Don't throw — ticket is already saved as QUEUED; consumer retry will pick it up
    }

    return new AsyncCheckoutResponseDto(
      saved.id,
      CheckoutTicketStatus.QUEUED,
      'Your booking request is being processed. You will be notified via webhook.',
    );
  }

  /**
   * Validate that all FK references exist in their respective tables.
   * Runs all lookups in parallel via Promise.all to minimize latency.
   * Throws BadRequestException with clear detail if any reference is invalid.
   */
  private async validateForeignKeys(dto: AsyncCheckoutDto): Promise<void> {
    const [accountExists, employeeExists, productExists] = await Promise.all([
      this.accountRepo.findOne({ where: { id: dto.userId }, select: ['id'] }),
      this.employeeRepo.findOne({ where: { id: dto.staffId }, select: ['id'] }),
      dto.productId
        ? this.productRepo.findOne({
            where: { id: dto.productId },
            select: ['id'],
          })
        : Promise.resolve(true as any),
    ]);

    const errors: string[] = [];
    if (!accountExists) {
      errors.push(`Account with id "${dto.userId}" does not exist`);
    }
    if (!employeeExists) {
      errors.push(`Employee with id "${dto.staffId}" does not exist`);
    }
    if (dto.productId && !productExists) {
      errors.push(`Product with id "${dto.productId}" does not exist`);
    }

    if (errors.length > 0) {
      this.logger.warn(
        `FK validation failed — userId=${dto.userId}, staffId=${dto.staffId}, productId=${dto.productId ?? 'null'}: ${errors.join('; ')}`,
      );
      throw new BadRequestException(errors);
    }
  }

  // ── FAILED ticket helper ─────────────────────────────────────

  /**
   * Create a FAILED ticket and cache the result. Used when the slot pre-check
   * fails or when the Redis pre-lock is denied.
   */
  private async createFailedTicket(
    dto: AsyncCheckoutDto,
    cacheKey: string,
    errorMessage: string,
  ): Promise<AsyncCheckoutResponseDto> {
    try {
      const failedTicket = this.ticketRepo.create({
        userId: dto.userId,
        staffId: dto.staffId,
        startTime: new Date(dto.startTime),
        productId: dto.productId,
        idempotencyKey: dto.idempotencyKey,
        webhookUrl: dto.webhookUrl || null,
        status: CheckoutTicketStatus.FAILED,
        errorMessage,
      });
      const saved = await this.ticketRepo.save(failedTicket);

      // Cache FAILED result for fast idempotent returns
      await this.cacheTicketResponse(cacheKey, {
        ticketId: saved.id,
        status: saved.status,
        message: errorMessage,
      });

      return new AsyncCheckoutResponseDto(
        saved.id,
        saved.status,
        errorMessage,
      );
    } catch (error) {
      this.logger.error(
        `DB error saving FAILED ticket — data=${JSON.stringify({ userId: dto.userId, staffId: dto.staffId, startTime: dto.startTime, productId: dto.productId, idempotencyKey: dto.idempotencyKey })}`,
        error.stack,
      );
      throw error;
    }
  }

  // ── Redis cache helper ─────────────────────────────────────

  /**
   * Cache a ticket response in Redis. Fire-and-forget — never blocks the
   * happy path if Redis is unavailable.
   */
  private async cacheTicketResponse(
    key: string,
    payload: { ticketId: string; status: string; message: string },
  ): Promise<void> {
    try {
      await this.redisService.set(
        key,
        JSON.stringify(payload),
        CreateCheckoutTicketHandler.CACHE_TTL,
      );
      this.logger.debug(`Cached ticket response: ${key}`);
    } catch (error) {
      this.logger.warn(
        `Redis cache write failed for ${key}: ${error.message}`,
      );
      // Non-critical — DB is the source of truth
    }
  }
}
