import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { BookingResponseDto } from '../../dto/booking-response.dto';

@Injectable()
export class GetBookingHandler {
  private readonly logger = new Logger(GetBookingHandler.name);

  constructor(
    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,
  ) {}

  async execute(id: string): Promise<BookingResponseDto> {
    const booking = await this.bookingRepo.findOne({
      where: { id },
    });

    if (!booking) {
      this.logger.warn(`Booking not found: ${id}`);
      throw new NotFoundException(`Booking with ID ${id} not found`);
    }

    return BookingResponseDto.fromEntity(booking);
  }
}
