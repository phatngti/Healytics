import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { Booking } from '@/common/entities/booking.entity';
import { AppointmentStatus } from '../enums/appointment-status.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';

export class AppointmentResponseDto {
  @ApiProperty({ type: String, example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  id: string;

  @ApiProperty({ type: String, example: 'Thai Massage' })
  @Expose()
  serviceName: string;

  @ApiProperty({ type: String, example: 'Healytics Spa Center' })
  @Expose()
  healthPartnerName: string;

  @ApiProperty({ type: String, example: 'https://example.com/image.jpg' })
  @Expose()
  imageUrl: string;

  @ApiProperty({ enum: AppointmentStatus, enumName: 'AppointmentStatus', example: AppointmentStatus.UPCOMING })
  @Expose()
  status: AppointmentStatus;

  @ApiProperty({ type: String, example: 'Spa & Wellness' })
  @Expose()
  category: string;

  @ApiProperty({ type: String, example: 'Dr. Jane Smith' })
  @Expose()
  specialistName: string;

  @ApiProperty({ type: String, example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  specialistId: string;

  @ApiProperty({ type: String, example: '123 Main Street, District 1' })
  @Expose()
  address: string;

  @ApiProperty({ type: String, example: '2025-10-25T00:00:00.000Z' })
  @Expose()
  date: string;

  @ApiProperty({ type: String, example: '09:00 AM' })
  @Expose()
  checkInTime: string;

  @ApiProperty({ type: String, example: '10:30 AM' })
  @Expose()
  checkOutTime: string;

  @ApiProperty({ type: String, example: '90 min' })
  @Expose()
  duration: string;

  @ApiProperty({
    type: Boolean,
    example: false,
    description: 'Whether the user has reviewed this appointment',
  })
  @Expose()
  isReviewed: boolean;

  @ApiProperty({
    type: Number,
    example: 2.5,
    nullable: true,
    description:
      'Distance from user to clinic in kilometers (null if coordinates not provided)',
  })
  @Type(() => Number)
  @Expose()
  distanceKm!: number;

  @ApiProperty({
    type: String,
    example: '550e8400-e29b-41d4-a716-446655440000',
    nullable: true,
    description: 'Account ID of the health partner (vendor). Used for chat.',
  })
  @Expose()
  healthPartnerId!: string | null;

  @ApiProperty({
    type: String,
    example: '550e8400-e29b-41d4-a716-446655440000',
    nullable: true,
    description: 'Product/service ID for navigation to service details.',
  })
  @Expose()
  serviceId!: string | null;

  @ApiProperty({
    type: String,
    example: 'https://test-payment.momo.vn/...',
    nullable: true,
    description:
      'Payment gateway checkout URL. Only present when status is pending_payment.',
  })
  @Expose()
  paymentUrl!: string | null;

  @ApiProperty({
    type: String,
    example: 'momo://app?action=payWithApp&...',
    nullable: true,
    description:
      'Deep link to open payment app directly (mobile). Only present when status is pending_payment.',
  })
  @Expose()
  paymentDeeplink!: string | null;

  @ApiProperty({
    type: String,
    example: '2026-04-14T12:10:00.000Z',
    nullable: true,
    description:
      'ISO 8601 timestamp when the payment link expires. Only present when status is pending_payment.',
  })
  @Expose()
  paymentExpiresAt!: string | null;

  /**
   * Maps a BookingStatus to the frontend's AppointmentStatus.
   */
  private static mapStatus(status: BookingStatus): AppointmentStatus {
    switch (status) {
      case BookingStatus.PENDING_PAYMENT:
        return AppointmentStatus.PENDING_PAYMENT;
      case BookingStatus.CONFIRMED:
        return AppointmentStatus.UPCOMING;
      case BookingStatus.COMPLETED:
        return AppointmentStatus.COMPLETED;
      case BookingStatus.CANCELLED:
      case BookingStatus.NO_SHOW:
        return AppointmentStatus.CANCELED;
      default:
        return AppointmentStatus.UPCOMING;
    }
  }

  /**
   * Formats a Date to a 12-hour time string (e.g. '09:00 AM').
   */
  private static formatTime(date: Date | null): string {
    if (!date) return '';
    return date.toLocaleTimeString('en-US', {
      hour: '2-digit',
      minute: '2-digit',
      hour12: true,
    });
  }

  /**
   * Computes duration string from start/end times.
   */
  private static computeDuration(
    start: Date,
    end: Date | null,
    durationMinutes?: number,
  ): string {
    if (durationMinutes) {
      return `${durationMinutes} min`;
    }
    if (end) {
      const diffMs = end.getTime() - start.getTime();
      const diffMin = Math.round(diffMs / 60000);
      return `${diffMin} min`;
    }
    return '';
  }

  static fromEntity(
    booking: Booking,
    options?: { clinicAddress?: string; distanceMeters?: number | null },
  ): AppointmentResponseDto {
    const dto = new AppointmentResponseDto();
    dto.id = booking.id;
    dto.serviceName = booking.product?.name ?? 'Unknown Service';
    dto.healthPartnerName = booking.product?.partner?.brandName ?? '';
    dto.healthPartnerId = booking.product?.partner?.accountId ?? null;

    dto.imageUrl = booking.product?.media?.[0]?.url ?? '';
    dto.status = AppointmentResponseDto.mapStatus(booking.status);
    dto.category = booking.product?.category?.name ?? '';
    dto.specialistName = booking.staff?.fullName ?? '';
    dto.specialistId = booking.staff?.id ?? '';
    dto.address = options?.clinicAddress ?? '';
    dto.date = booking.startTime?.toISOString() ?? '';
    dto.checkInTime = AppointmentResponseDto.formatTime(booking.startTime);
    dto.checkOutTime = AppointmentResponseDto.formatTime(booking.endTime);
    dto.duration = AppointmentResponseDto.computeDuration(
      booking.startTime,
      booking.endTime,
      booking.product?.productDefinition?.durationMinutes,
    );
    dto.isReviewed = booking.isReviewed ?? false;
    dto.distanceKm =
      options?.distanceMeters != null
        ? Math.round((options.distanceMeters / 1000) * 10) / 10
        : -1;
    dto.serviceId = booking.productId ?? null;

    // Payment fields — only populated for pending_payment status
    dto.paymentUrl =
      dto.status === AppointmentStatus.PENDING_PAYMENT
        ? booking.paymentUrl
        : null;
    dto.paymentDeeplink =
      dto.status === AppointmentStatus.PENDING_PAYMENT
        ? booking.paymentDeeplink
        : null;
    dto.paymentExpiresAt =
      dto.status === AppointmentStatus.PENDING_PAYMENT
        ? (booking.paymentExpiresAt?.toISOString() ?? null)
        : null;

    return dto;
  }

  static fromEntities(bookings: Booking[]): AppointmentResponseDto[] {
    return bookings.map((b) => AppointmentResponseDto.fromEntity(b));
  }
}
