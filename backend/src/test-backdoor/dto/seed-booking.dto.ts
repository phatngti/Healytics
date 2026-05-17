import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsOptional, IsString } from 'class-validator';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { SeedCartItemDto } from './seed-cart-item.dto';

export class SeedBookingDto extends SeedCartItemDto {
  @ApiPropertyOptional({ enum: BookingStatus })
  @IsOptional()
  @IsEnum(BookingStatus)
  status?: BookingStatus;

  @ApiPropertyOptional({
    type: String,
    example: '2026-06-01T11:00:00Z',
    description: 'ISO 8601 end time',
  })
  @IsOptional()
  @IsString()
  endsAt?: string;

  @ApiPropertyOptional({ type: String, example: 'https://pay.stripe.com/xxx' })
  @IsOptional()
  @IsString()
  paymentUrl?: string;

  @ApiPropertyOptional({ type: String, example: '2026-06-01T10:30:00Z' })
  @IsOptional()
  @IsString()
  paymentExpiresAt?: string;
}
