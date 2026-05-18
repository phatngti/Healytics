import { ApiProperty } from '@nestjs/swagger';
import { BookingSpecialistResponseDto } from '@/categories/dto/booking-specialist-response.dto';
import { BookingServiceResponseDto } from '@/employees/dto/booking-service-response.dto';

export class BookingSearchResponseDto {
  @ApiProperty({ type: [BookingServiceResponseDto] })
  services: BookingServiceResponseDto[];

  @ApiProperty({ type: [BookingSpecialistResponseDto] })
  specialists: BookingSpecialistResponseDto[];
}
