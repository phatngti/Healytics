import { ApiProperty } from '@nestjs/swagger';
import { IsEnum } from 'class-validator';
import { BookingStatus } from '../enums/booking-status.enum';

export enum BookingStatusUpdate {
  PROCESSING = 'PROCESSING',
  COMPLETED = 'COMPLETED',
}

export enum PublicBookingStatus {
  PROCESSING = 'PROCESSING',
  COMPLETED = 'COMPLETED',
}

export class UpdateBookingStatusDto {
  @ApiProperty({
    enum: BookingStatusUpdate,
    enumName: 'BookingStatusUpdate',
    example: BookingStatusUpdate.PROCESSING,
  })
  @IsEnum(BookingStatusUpdate)
  status: BookingStatusUpdate;
}

export const toPersistedBookingStatus = (status: BookingStatusUpdate) =>
  status === BookingStatusUpdate.PROCESSING
    ? BookingStatus.IN_PROGRESS
    : BookingStatus.COMPLETED;
