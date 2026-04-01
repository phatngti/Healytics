import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';

/**
 * Status values expected by the frontend's RecentActivitySection.
 */
export enum RecentActivityStatus {
  COMPLETED = 'COMPLETED',
  SCHEDULED = 'SCHEDULED',
  CANCELED = 'CANCELED',
}

export class RecentActivityResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  id: string;

  @ApiProperty({ example: 'Aromatherapy' })
  @Expose()
  title: string;

  @ApiProperty({
    example: '2026-03-27T15:00:00.000Z',
    description: 'ISO 8601 scheduled date/time — not pre-formatted',
  })
  @Expose()
  scheduled_at: string;

  @ApiProperty({
    enum: RecentActivityStatus,
    example: RecentActivityStatus.COMPLETED,
  })
  @Expose()
  status: RecentActivityStatus;

  @ApiProperty({
    example: 'AROMATHERAPY',
    description: 'Uppercased category slug used by frontend for icon mapping',
  })
  @Expose()
  service_type_code: string;

  // ── Mapping helpers ─────────────────────────────────────────

  private static mapStatus(bookingStatus: BookingStatus): RecentActivityStatus {
    switch (bookingStatus) {
      case BookingStatus.CONFIRMED:
      case BookingStatus.PENDING_PAYMENT:
        return RecentActivityStatus.SCHEDULED;
      case BookingStatus.COMPLETED:
        return RecentActivityStatus.COMPLETED;
      case BookingStatus.CANCELLED:
      case BookingStatus.NO_SHOW:
        return RecentActivityStatus.CANCELED;
      default:
        return RecentActivityStatus.SCHEDULED;
    }
  }

  /**
   * Derives a service_type_code from the category slug.
   * Falls back to 'SERVICE' if no category is loaded.
   */
  private static deriveServiceTypeCode(booking: Booking): string {
    const slug = booking.product?.category?.slug;
    if (slug) {
      return slug.toUpperCase().replace(/-/g, '_');
    }
    return 'SERVICE';
  }

  static fromEntity(booking: Booking): RecentActivityResponseDto {
    const dto = new RecentActivityResponseDto();
    dto.id = booking.id;
    dto.title = booking.product?.name ?? 'Unknown Service';
    dto.scheduled_at = booking.startTime?.toISOString() ?? '';
    dto.status = RecentActivityResponseDto.mapStatus(booking.status);
    dto.service_type_code =
      RecentActivityResponseDto.deriveServiceTypeCode(booking);
    return dto;
  }

  static fromEntities(bookings: Booking[]): RecentActivityResponseDto[] {
    return bookings.map((b) => RecentActivityResponseDto.fromEntity(b));
  }
}
