import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { Booking } from '@/common/entities/booking.entity';
import { AppointmentStatus } from '../enums/appointment-status.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';

export class AppointmentResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  id: string;

  @ApiProperty({ example: 'Thai Massage' })
  @Expose()
  serviceName: string;

  @ApiProperty({ example: 'Healytics Spa Center' })
  @Expose()
  healthPartnerName: string;

  @ApiProperty({ example: 'https://example.com/image.jpg' })
  @Expose()
  imageUrl: string;

  @ApiProperty({ enum: AppointmentStatus, example: AppointmentStatus.UPCOMING })
  @Expose()
  status: AppointmentStatus;

  @ApiProperty({ example: 'Spa & Wellness' })
  @Expose()
  category: string;

  @ApiProperty({ example: 'Dr. Jane Smith' })
  @Expose()
  specialistName: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  specialistId: string;

  @ApiProperty({ example: '123 Main Street, District 1' })
  @Expose()
  address: string;

  @ApiProperty({ example: '2025-10-25T00:00:00.000Z' })
  @Expose()
  date: string;

  @ApiProperty({ example: '09:00 AM' })
  @Expose()
  checkInTime: string;

  @ApiProperty({ example: '10:30 AM' })
  @Expose()
  checkOutTime: string;

  @ApiProperty({ example: '90 min' })
  @Expose()
  duration: string;

  @ApiProperty({
    example: false,
    description: 'Whether the user has reviewed this appointment',
  })
  @Expose()
  isReviewed: boolean;

  @ApiProperty({
    example: 2.5,
    nullable: true,
    description:
      'Distance from user to clinic in kilometers (null if coordinates not provided)',
  })
  @Type(() => Number)
  @Expose()
  distanceKm!: number;

  @ApiProperty({
    example: '550e8400-e29b-41d4-a716-446655440000',
    nullable: true,
    description: 'Account ID of the health partner (vendor). Used for chat.',
  })
  @Expose()
  healthPartnerId!: string | null;

  @ApiProperty({
    example: '550e8400-e29b-41d4-a716-446655440000',
    nullable: true,
    description: 'Product/service ID for navigation to service details.',
  })
  @Expose()
  serviceId!: string | null;

  /**
   * Maps a BookingStatus to the frontend's AppointmentStatus.
   */
  private static mapStatus(status: BookingStatus): AppointmentStatus {
    switch (status) {
      case BookingStatus.CONFIRMED:
      case BookingStatus.PENDING_PAYMENT:
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
    return dto;
  }

  static fromEntities(bookings: Booking[]): AppointmentResponseDto[] {
    return bookings.map((b) => AppointmentResponseDto.fromEntity(b));
  }
}
