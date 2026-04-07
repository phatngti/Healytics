import {
  Injectable,
  Logger,
  BadRequestException,
  ConflictException,
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
import { Inject } from '@nestjs/common';

@Injectable()
export class CreateCheckoutTicketHandler {
  private readonly logger = new Logger(CreateCheckoutTicketHandler.name);

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
  ) {}

  async execute(dto: AsyncCheckoutDto): Promise<AsyncCheckoutResponseDto> {
    this.logger.log(
      `Creating checkout ticket: user=${dto.userId}, staff=${dto.staffId}, key=${dto.idempotencyKey}`,
    );

    // 1. Idempotency check — return existing ticket if same key
    try {
      const existing = await this.ticketRepo.findOne({
        where: { idempotencyKey: dto.idempotencyKey },
      });
      if (existing) {
        this.logger.log(
          `Idempotent return: ticket=${existing.id}, status=${existing.status}`,
        );
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
      // Create a FAILED ticket immediately instead of queueing
      try {
        const failedTicket = this.ticketRepo.create({
          userId: dto.userId,
          staffId: dto.staffId,
          startTime: new Date(dto.startTime),
          productId: dto.productId || null,
          idempotencyKey: dto.idempotencyKey,
          webhookUrl: dto.webhookUrl || null,
          status: CheckoutTicketStatus.FAILED,
          errorMessage: 'Slot is no longer available.',
        });
        const saved = await this.ticketRepo.save(failedTicket);
        return new AsyncCheckoutResponseDto(
          saved.id,
          saved.status,
          'Slot is no longer available.',
        );
      } catch (error) {
        this.logger.error(
          `DB error saving FAILED ticket — data=${JSON.stringify({ userId: dto.userId, staffId: dto.staffId, startTime: dto.startTime, productId: dto.productId, idempotencyKey: dto.idempotencyKey })}`,
          error.stack,
        );
        throw error;
      }
    }

    // 4. Create QUEUED ticket
    let saved: CheckoutTicket;
    try {
      const ticket = this.ticketRepo.create({
        userId: dto.userId,
        staffId: dto.staffId,
        startTime: new Date(dto.startTime),
        productId: dto.productId || null,
        idempotencyKey: dto.idempotencyKey,
        webhookUrl: dto.webhookUrl || null,
        status: CheckoutTicketStatus.QUEUED,
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

    // 5. Publish to RabbitMQ queue
    const rmqPayload = {
      ticketId: saved.id,
      staffId: dto.staffId,
      startTime: dto.startTime,
      userId: dto.userId,
      productId: dto.productId,
      webhookUrl: dto.webhookUrl,
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
      'QUEUED',
      'Your booking request is being processed. You will be notified via webhook.',
    );
  }

  /**
   * Validate that all FK references exist in their respective tables.
   * Throws BadRequestException with clear detail if any reference is invalid.
   */
  private async validateForeignKeys(dto: AsyncCheckoutDto): Promise<void> {
    const errors: string[] = [];

    // Check userId exists in accounts
    const accountExists = await this.accountRepo.findOne({
      where: { id: dto.userId },
      select: ['id'],
    });
    if (!accountExists) {
      errors.push(`Account with id "${dto.userId}" does not exist`);
    }

    // Check staffId exists in employees
    const employeeExists = await this.employeeRepo.findOne({
      where: { id: dto.staffId },
      select: ['id'],
    });
    if (!employeeExists) {
      errors.push(`Employee with id "${dto.staffId}" does not exist`);
    }

    // Check productId exists in products (if provided)
    if (dto.productId) {
      const productExists = await this.productRepo.findOne({
        where: { id: dto.productId },
        select: ['id'],
      });
      if (!productExists) {
        errors.push(`Product with id "${dto.productId}" does not exist`);
      }
    }

    if (errors.length > 0) {
      this.logger.warn(
        `FK validation failed — userId=${dto.userId}, staffId=${dto.staffId}, productId=${dto.productId ?? 'null'}: ${errors.join('; ')}`,
      );
      throw new BadRequestException(errors);
    }
  }
}
