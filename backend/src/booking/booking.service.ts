import { Injectable, Logger } from '@nestjs/common';
import { AcquireMicroLockHandler } from './application/handlers/acquire-micro-lock.handler';
import { CreateCheckoutTicketHandler } from './application/handlers/create-checkout-ticket.handler';
import { GetBookingHandler } from './application/handlers/get-booking.handler';
import { GetCheckoutTicketHandler } from './application/handlers/get-checkout-ticket.handler';
import { ListUserBookingsHandler } from './application/handlers/list-user-bookings.handler';
import { MicroLockDto } from './dto/micro-lock.dto';
import { MicroLockResponseDto } from './dto/micro-lock-response.dto';
import { AsyncCheckoutDto } from './dto/async-checkout.dto';
import { AsyncCheckoutResponseDto } from './dto/async-checkout-response.dto';
import { BookingResponseDto } from './dto/booking-response.dto';
import { CheckoutTicketResponseDto } from './dto/checkout-ticket-response.dto';

/**
 * Booking service facade — delegates all operations to domain handlers.
 */
@Injectable()
export class BookingService {
  private readonly logger = new Logger(BookingService.name);

  constructor(
    private readonly acquireMicroLockHandler: AcquireMicroLockHandler,
    private readonly createCheckoutTicketHandler: CreateCheckoutTicketHandler,
    private readonly getBookingHandler: GetBookingHandler,
    private readonly getCheckoutTicketHandler: GetCheckoutTicketHandler,
    private readonly listUserBookingsHandler: ListUserBookingsHandler,
  ) {}

  // ── Slot Lock ─────────────────────────────────────────────

  async acquireMicroLock(dto: MicroLockDto): Promise<MicroLockResponseDto> {
    this.logger.log(
      `acquireMicroLock: staff=${dto.staffId}, time=${dto.startTime}`,
    );
    return this.acquireMicroLockHandler.execute(dto);
  }

  // ── Async Checkout ────────────────────────────────────────

  async asyncCheckout(
    dto: AsyncCheckoutDto,
  ): Promise<AsyncCheckoutResponseDto> {
    this.logger.log(
      `asyncCheckout: user=${dto.userId}, key=${dto.idempotencyKey}`,
    );
    return this.createCheckoutTicketHandler.execute(dto);
  }

  // ── Queries ───────────────────────────────────────────────

  async getTicketStatus(id: string): Promise<CheckoutTicketResponseDto> {
    this.logger.log(`getTicketStatus: ${id}`);
    return this.getCheckoutTicketHandler.execute(id);
  }

  async getBooking(id: string): Promise<BookingResponseDto> {
    this.logger.log(`getBooking: ${id}`);
    return this.getBookingHandler.execute(id);
  }

  async listMyBookings(
    userId: string,
    page: number,
    limit: number,
  ): Promise<BookingResponseDto[]> {
    this.logger.log(`listMyBookings: user=${userId}, page=${page}`);
    return this.listUserBookingsHandler.execute(userId, page, limit);
  }
}
