import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { BookingResponseDto } from '../../dto/booking-response.dto';

@Injectable()
export class ListUserBookingsHandler {
  private readonly logger = new Logger(ListUserBookingsHandler.name);

  constructor(
    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,
  ) {}

  async execute(
    userId: string,
    page = 1,
    limit = 10,
  ): Promise<BookingResponseDto[]> {
    this.logger.log(`Listing bookings: user=${userId}, page=${page}, limit=${limit}`);

    const bookings = await this.bookingRepo.find({
      where: { userId },
      order: { startTime: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });

    return bookings.map(BookingResponseDto.fromEntity);
  }
}
