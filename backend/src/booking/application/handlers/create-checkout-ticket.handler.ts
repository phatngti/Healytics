import {
  Injectable,
  Logger,
  Inject,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ClientProxy } from '@nestjs/microservices';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { CheckoutTicketStatus } from '@/booking/enums/checkout-ticket-status.enum';
import { AsyncCheckoutDto } from '../../dto/async-checkout.dto';
import { AsyncCheckoutResponseDto } from '../../dto/async-checkout-response.dto';
import { CheckSlotAvailabilityHandler } from './check-slot-availability.handler';

@Injectable()
export class CreateCheckoutTicketHandler {
  private readonly logger = new Logger(CreateCheckoutTicketHandler.name);

  constructor(
    @InjectRepository(CheckoutTicket)
    private readonly ticketRepo: Repository<CheckoutTicket>,
    @Inject('RABBITMQ_CLIENT')
    private readonly rmqClient: ClientProxy,
    private readonly slotChecker: CheckSlotAvailabilityHandler,
  ) {}

  async execute(dto: AsyncCheckoutDto): Promise<AsyncCheckoutResponseDto> {
    this.logger.log(
      `Creating checkout ticket: user=${dto.userId}, key=${dto.idempotencyKey}`,
    );

    // 1. Idempotency check — return existing ticket if same key
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

    // 2. Pre-check slot availability (optional fast fail)
    const available = await this.slotChecker.execute(
      dto.staffId,
      new Date(dto.startTime),
    );
    if (!available) {
      this.logger.warn(
        `Slot pre-check failed: staff=${dto.staffId}, time=${dto.startTime}`,
      );
      // Create a FAILED ticket immediately instead of queueing
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
    }

    // 3. Create QUEUED ticket
    const ticket = this.ticketRepo.create({
      userId: dto.userId,
      staffId: dto.staffId,
      startTime: new Date(dto.startTime),
      productId: dto.productId || null,
      idempotencyKey: dto.idempotencyKey,
      webhookUrl: dto.webhookUrl || null,
      status: CheckoutTicketStatus.QUEUED,
    });
    const saved = await this.ticketRepo.save(ticket);

    // 4. Publish to RabbitMQ queue
    this.rmqClient.emit('checkout.process', {
      ticketId: saved.id,
      staffId: dto.staffId,
      startTime: dto.startTime,
      userId: dto.userId,
      productId: dto.productId,
      webhookUrl: dto.webhookUrl,
    });

    this.logger.log(
      `Ticket queued: ${saved.id}, published to checkout.process`,
    );

    return new AsyncCheckoutResponseDto(
      saved.id,
      'QUEUED',
      'Your booking request is being processed. You will be notified via webhook.',
    );
  }
}
