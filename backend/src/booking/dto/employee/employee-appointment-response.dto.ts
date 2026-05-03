import { Expose, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { EmployeeBookingStatusFilter } from './get-employee-appointments-query.dto';

/**
 * Response DTO for employee appointments.
 * Matches the EmployeeAppointmentEntity in the Flutter frontend.
 */
export class EmployeeAppointmentResponseDto {
  @ApiProperty({ type: String })
  @Expose()
  id: string;

  @ApiProperty({ type: String })
  @Expose()
  serviceName: string;

  @ApiProperty({ type: String })
  @Expose()
  customerName: string;

  @ApiProperty({ type: String })
  @Expose()
  customerId: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  @Expose()
  imageUrl: string | null;

  @ApiProperty({
    enum: EmployeeBookingStatusFilter,
    enumName: 'EmployeeBookingStatusFilter',
  })
  @Expose()
  status: EmployeeBookingStatusFilter;

  @ApiProperty({ type: String })
  @Expose()
  category: string;

  @ApiProperty({ type: String })
  @Expose()
  clinicName: string;

  @ApiProperty({ type: String })
  @Expose()
  address: string;

  @ApiProperty({ type: Date })
  @Expose()
  date: Date;

  @ApiProperty({ type: String, example: '09:00 AM' })
  @Expose()
  checkInTime: string;

  @ApiProperty({ type: String, example: '10:00 AM' })
  @Expose()
  checkOutTime: string;

  @ApiProperty({ type: String, example: '60 mins' })
  @Expose()
  duration: string;

  @ApiPropertyOptional({ type: Number, nullable: true })
  @Expose()
  price: number | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  @Expose()
  notes: string | null;

  /**
   * Maps a backend BookingStatus to the frontend EmployeeBookingStatusFilter.
   */
  static mapStatus(status: BookingStatus): EmployeeBookingStatusFilter {
    switch (status) {
      case BookingStatus.PENDING_PAYMENT:
      case BookingStatus.CONFIRMED:
        return EmployeeBookingStatusFilter.UPCOMING;
      case BookingStatus.IN_PROGRESS:
        return EmployeeBookingStatusFilter.IN_PROGRESS;
      case BookingStatus.COMPLETED:
        return EmployeeBookingStatusFilter.COMPLETED;
      case BookingStatus.CANCELLED:
      case BookingStatus.NO_SHOW:
        return EmployeeBookingStatusFilter.CANCELED;
      default:
        return EmployeeBookingStatusFilter.UPCOMING;
    }
  }

  /**
   * Converts a Booking entity (with relations) to the frontend response DTO.
   * Requires booking to have product and user relations loaded.
   */
  static fromBooking(
    booking: Booking,
    clinicName: string,
    clinicAddress: string,
  ): EmployeeAppointmentResponseDto {
    const dto = new EmployeeAppointmentResponseDto();
    dto.id = booking.id;
    dto.serviceName = booking.product?.name ?? 'Unknown Service';
    dto.customerName =
      booking.user?.userProfile
        ? `${booking.user.userProfile.firstName ?? ''} ${booking.user.userProfile.lastName ?? ''}`.trim()
        : booking.user?.email ?? 'Customer';
    dto.customerId = booking.userId;
    dto.imageUrl = null;
    dto.status = this.mapStatus(booking.status);
    dto.category = booking.product?.category?.name ?? 'General';
    dto.clinicName = clinicName;
    dto.address = clinicAddress;
    dto.date = booking.startTime;
    dto.checkInTime = formatTime12(booking.startTime);
    dto.checkOutTime = booking.endTime
      ? formatTime12(booking.endTime)
      : formatTime12(
          new Date(
            booking.startTime.getTime() +
              (booking.product?.productDefinition?.durationMinutes ?? 60) *
                60000,
          ),
        );
    const durationMins =
      booking.product?.productDefinition?.durationMinutes ?? 60;
    dto.duration = `${durationMins} mins`;
    dto.price = booking.product?.basePrice
      ? Number(booking.product.basePrice)
      : null;
    dto.notes = booking.notes ?? null;
    return dto;
  }

  static fromBookings(
    bookings: Booking[],
    clinicName: string,
    clinicAddress: string,
  ): EmployeeAppointmentResponseDto[] {
    return bookings.map((b) => this.fromBooking(b, clinicName, clinicAddress));
  }
}

/** Formats a Date's time to 12h format (e.g. "09:00 AM"). */
function formatTime12(date: Date): string {
  const h = date.getHours();
  const m = date.getMinutes();
  const period = h >= 12 ? 'PM' : 'AM';
  const h12 = h === 0 ? 12 : h > 12 ? h - 12 : h;
  return `${String(h12).padStart(2, '0')}:${String(m).padStart(2, '0')} ${period}`;
}
