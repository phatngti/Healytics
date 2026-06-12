import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { Booking } from '@/common/entities/booking.entity';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { AddToCartDto } from '@/cart/dto/add-to-cart.dto';
import { CartItemResponseDto } from '@/cart/dto/cart-item-response.dto';
import { AddCartItemHandler } from '@/cart/application/handlers/add-cart-item.handler';
import { RemoveCartItemHandler } from '@/cart/application/handlers/remove-cart-item.handler';
import { ClearCartHandler } from '@/cart/application/handlers/clear-cart.handler';
import { CartItemStatus } from '@/cart/enums/cart-item-status.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { CheckoutTicketStatus } from '@/booking/enums/checkout-ticket-status.enum';

/** Day-of-week names indexed by Date.getDay(). */
const DAY_NAMES = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];

@Injectable()
export class CartService {
  private readonly logger = new Logger(CartService.name);

  constructor(
    @InjectRepository(CartItem)
    private readonly cartItemRepository: Repository<CartItem>,
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
    @InjectRepository(CheckoutTicket)
    private readonly checkoutTicketRepository: Repository<CheckoutTicket>,
    private readonly addCartItemHandler: AddCartItemHandler,
    private readonly removeCartItemHandler: RemoveCartItemHandler,
    private readonly clearCartHandler: ClearCartHandler,
  ) {}

  async getCartItems(userId: string): Promise<CartItemResponseDto[]> {
    this.logger.log(`Getting cart items for user: ${userId}`);

    const items = await this.cartItemRepository.find({
      where: { userId, status: CartItemStatus.ACTIVE },
      relations: ['service', 'service.partner', 'service.media', 'employee'],
      order: { createdAt: 'DESC' },
    });

    if (items.length === 0) {
      return [];
    }

    const availabilityMap = await this.checkTimeSlotAvailability(items);

    return CartItemResponseDto.fromEntities(items, availabilityMap);
  }

  async addItem(
    userId: string,
    dto: AddToCartDto,
  ): Promise<CartItemResponseDto> {
    const created = await this.addCartItemHandler.execute(userId, dto);
    return CartItemResponseDto.fromEntity(created);
  }

  async removeItem(userId: string, cartItemId: string): Promise<void> {
    await this.removeCartItemHandler.execute(userId, cartItemId);
  }

  async clearCart(userId: string): Promise<void> {
    await this.clearCartHandler.execute(userId);
  }

  // ──────────────────────────────────────────────────────────────
  // Private: Time Slot Availability Checking
  // ──────────────────────────────────────────────────────────────

  /**
   * Batch-checks whether each cart item's time slot is still available.
   * A slot is unavailable if:
   *   1. An active booking exists for that employee + time, OR
   *   2. A pending checkout ticket exists for that employee + time, OR
   *   3. The time slot falls outside the employee's working hours.
   *
   * Returns a Map<cartItemId, isAvailable>.
   */
  private async checkTimeSlotAvailability(
    items: CartItem[],
  ): Promise<Map<string, boolean>> {
    const result = new Map<string, boolean>();

    // Collect unique employee IDs for batch queries
    const employeeIds = [...new Set(items.map((item) => item.employeeId))];

    // Batch query: active bookings for all relevant employees
    const conflictingBookings = await this.bookingRepository.find({
      where: {
        staffId: In(employeeIds),
        status: In([BookingStatus.PENDING_PAYMENT, BookingStatus.CONFIRMED]),
      },
      select: ['staffId', 'startTime'],
    });

    // Batch query: pending checkout tickets for all relevant employees
    const conflictingTickets = await this.checkoutTicketRepository.find({
      where: {
        staffId: In(employeeIds),
        status: In([
          CheckoutTicketStatus.QUEUED,
          CheckoutTicketStatus.PROCESSING,
        ]),
      },
      select: ['staffId', 'startTime'],
    });

    // Build a Set<"employeeId|ISO-time"> for O(1) conflict lookup
    const conflictSet = new Set<string>();

    for (const booking of conflictingBookings) {
      conflictSet.add(
        `${booking.staffId}|${new Date(booking.startTime).toISOString()}`,
      );
    }
    for (const ticket of conflictingTickets) {
      conflictSet.add(
        `${ticket.staffId}|${new Date(ticket.startTime).toISOString()}`,
      );
    }

    // Check each cart item
    for (const item of items) {
      const timeSlotIso = new Date(item.timeSlot).toISOString();
      const conflictKey = `${item.employeeId}|${timeSlotIso}`;

      // 1. Check booking / ticket conflicts
      if (conflictSet.has(conflictKey)) {
        result.set(item.id, false);
        continue;
      }

      // 2. Check employee schedule (working hours)
      const isWithinSchedule = this.isTimeSlotWithinSchedule(
        item.employee,
        item.timeSlot,
      );
      result.set(item.id, isWithinSchedule);
    }

    return result;
  }

  /**
   * Checks if a given time slot falls within the employee's working hours
   * by inspecting the JSONB schedule on the employee entity.
   */
  private isTimeSlotWithinSchedule(
    employee: CartItem['employee'],
    timeSlot: Date,
  ): boolean {
    if (!employee?.schedule || employee.schedule.length === 0) {
      return false;
    }

    const slotDate = new Date(timeSlot);
    const dayName = DAY_NAMES[slotDate.getDay()];
    const entry = employee.schedule.find((s) => s.day === dayName);

    if (!entry || !entry.isWorking || !entry.start || !entry.end) {
      return false;
    }

    const slotMinutes = slotDate.getHours() * 60 + slotDate.getMinutes();
    const [startH, startM] = entry.start.split(':').map(Number);
    const [endH, endM] = entry.end.split(':').map(Number);
    const startMinutes = startH * 60 + startM;
    const endMinutes = endH * 60 + endM;

    return slotMinutes >= startMinutes && slotMinutes < endMinutes;
  }
}
