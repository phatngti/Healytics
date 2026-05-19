import { ApiProperty } from '@nestjs/swagger';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { registerWsEnum, WsModel } from '@/common/decorators/ws';
import { Role } from '@/account/enum/role.enum';
import { BookingStatus } from '../enums/booking-status.enum';
import { PublicBookingStatus } from './update-booking-status.dto';

registerWsEnum('PublicBookingStatus', {
  contractName: 'PublicBookingStatus',
  description: 'Public booking status emitted to realtime clients',
  values: Object.values(PublicBookingStatus),
});

registerWsEnum('BookingStatus', {
  contractName: 'BookingStatus',
  description: 'Persisted booking lifecycle status',
  values: Object.values(BookingStatus),
});

@WsModel({
  description: 'Actor that changed a booking status',
})
export class BookingStatusChangedByDto {
  @ApiProperty({ format: 'uuid' })
  accountId: string;

  @ApiProperty({ type: String, example: Role.EMPLOYEE })
  role: Role;
}

@WsModel({
  description:
    'Server event emitted when a booking status changes through the lifecycle API',
})
export class BookingStatusChangeEventDto {
  @ApiProperty({ format: 'uuid' })
  eventId: string;

  @ApiProperty({ format: 'uuid' })
  bookingId: string;

  @ApiProperty({
    enum: PublicBookingStatus,
    enumName: 'PublicBookingStatus',
    example: PublicBookingStatus.PROCESSING,
  })
  status: PublicBookingStatus;

  @ApiProperty({
    enum: BookingStatus,
    enumName: 'BookingStatus',
    example: BookingStatus.IN_PROGRESS,
  })
  persistedStatus: BookingStatus;

  @ApiProperty({
    enum: BookingStatus,
    enumName: 'BookingStatus',
    example: BookingStatus.CONFIRMED,
  })
  previousStatus: BookingStatus;

  @ApiProperty({ format: 'uuid' })
  userId: string;

  @ApiPropertyOptional({ type: String, format: 'uuid', nullable: true })
  partnerId: string | null;

  @ApiProperty({ format: 'uuid' })
  specialistId: string;

  @ApiProperty({ type: BookingStatusChangedByDto })
  changedBy: BookingStatusChangedByDto;

  @ApiProperty({ format: 'date-time' })
  occurredAt: string;

  static fromPlain(
    payload: BookingStatusChangeEventDto,
  ): BookingStatusChangeEventDto {
    const dto = new BookingStatusChangeEventDto();
    dto.eventId = payload.eventId;
    dto.bookingId = payload.bookingId;
    dto.status = payload.status;
    dto.persistedStatus = payload.persistedStatus;
    dto.previousStatus = payload.previousStatus;
    dto.userId = payload.userId;
    dto.partnerId = payload.partnerId;
    dto.specialistId = payload.specialistId;
    dto.changedBy = payload.changedBy;
    dto.occurredAt = payload.occurredAt;
    return dto;
  }
}
