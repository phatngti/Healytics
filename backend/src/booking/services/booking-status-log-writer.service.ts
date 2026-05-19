import { Injectable } from '@nestjs/common';
import { EntityManager } from 'typeorm';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { BookingStatusReasonCode } from '../enums/booking-status-reason-code.enum';
import { BookingStatus } from '../enums/booking-status.enum';

export interface BookingStatusLogWriteInput {
  bookingId: string;
  fromStatus: BookingStatus | string | null;
  toStatus: BookingStatus | string;
  changedBy?: string | null;
  reasonCode?: BookingStatusReasonCode | null;
  reason?: string | null;
}

@Injectable()
export class BookingStatusLogWriterService {
  async write(
    manager: EntityManager,
    input: BookingStatusLogWriteInput,
  ): Promise<BookingStatusLog> {
    const reasonCode =
      input.reasonCode ?? BookingStatusReasonCode.LEGACY_STATUS_CHANGE;
    const reason = this.normalizeReason(
      input.reason,
      reasonCode,
      input.fromStatus,
      input.toStatus,
    );

    const log = manager.create(BookingStatusLog, {
      bookingId: input.bookingId,
      fromStatus: input.fromStatus,
      toStatus: input.toStatus,
      changedBy: input.changedBy ?? null,
      reasonCode,
      reason,
    });

    return manager.save(BookingStatusLog, log);
  }

  private normalizeReason(
    reason: string | null | undefined,
    reasonCode: BookingStatusReasonCode,
    fromStatus: BookingStatus | string | null,
    toStatus: BookingStatus | string,
  ): string {
    const trimmed = reason?.trim();
    if (trimmed) {
      return trimmed;
    }

    switch (reasonCode) {
      case BookingStatusReasonCode.CHECKOUT_CREATED_PENDING_PAYMENT:
        return 'Checkout created booking pending payment';
      case BookingStatusReasonCode.CHECKOUT_CREATED_CONFIRMED:
        return 'Checkout completed — booking confirmed immediately (pay later)';
      case BookingStatusReasonCode.PAYMENT_CONFIRMED_MOMO:
        return 'MoMo payment confirmed booking';
      case BookingStatusReasonCode.PAYMENT_CONFIRMED_STRIPE:
        return 'Stripe payment confirmed booking';
      case BookingStatusReasonCode.PAYMENT_EXPIRED_AUTO_CANCEL:
        return 'Payment expired and booking was automatically cancelled';
      case BookingStatusReasonCode.PAYMENT_REFUND_MOMO_CANCELLED:
        return 'MoMo refund cancelled booking';
      case BookingStatusReasonCode.PAYMENT_REFUND_STRIPE_CANCELLED:
        return 'Stripe refund cancelled booking';
      case BookingStatusReasonCode.EMPLOYEE_STARTED_SERVICE:
        return 'Employee moved booking to processing';
      case BookingStatusReasonCode.EMPLOYEE_COMPLETED_SERVICE:
        return 'Employee completed booking';
      case BookingStatusReasonCode.EMPLOYEE_CANCELLED:
        return 'Employee cancelled appointment';
      case BookingStatusReasonCode.LEGACY_STATUS_CHANGE:
      default:
        return `Legacy booking status change from ${fromStatus ?? 'none'} to ${toStatus}`;
    }
  }
}
