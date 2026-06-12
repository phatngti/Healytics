import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';

export class BookingResponseDto {
  @ApiProperty({ type: String, example: 'BK_555' })
  id: string;

  @ApiProperty({ type: String })
  userId: string;

  @ApiProperty({ type: String })
  staffId: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  productId: string | null;

  @ApiProperty({ type: Date, example: '2023-10-25T14:00:00Z' })
  startTime: Date;

  @ApiPropertyOptional({
    type: Date,
    nullable: true,
    example: '2023-10-25T15:00:00Z',
  })
  endTime: Date | null;

  @ApiProperty({
    enum: BookingStatus,
    enumName: 'BookingStatus',
    example: BookingStatus.PENDING_PAYMENT,
  })
  status: BookingStatus;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
    example: 'https://payment.gateway.com/pay/BK_555',
  })
  paymentUrl: string | null;

  @ApiPropertyOptional({
    type: Date,
    nullable: true,
    example: '2023-10-25T14:10:00Z',
  })
  paymentExpiresAt: Date | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  notes: string | null;

  @ApiProperty({ type: Date })
  createdAt: Date;

  @ApiProperty({ type: Date })
  updatedAt: Date;

  static fromEntity(booking: Booking): BookingResponseDto {
    const dto = new BookingResponseDto();
    dto.id = booking.id;
    dto.userId = booking.userId;
    dto.staffId = booking.staffId;
    dto.productId = booking.productId;
    dto.startTime = booking.startTime;
    dto.endTime = booking.endTime;
    dto.status = booking.status;
    dto.paymentUrl = booking.paymentUrl;
    dto.paymentExpiresAt = booking.paymentExpiresAt;
    dto.notes = booking.notes;
    dto.createdAt = booking.createdAt;
    dto.updatedAt = booking.updatedAt;
    return dto;
  }
}
