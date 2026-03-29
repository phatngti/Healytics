import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { ServiceManualResponseDto } from '../../dto/service-manual-response.dto';

@Injectable()
export class GetServiceManualHandler {
  private readonly logger = new Logger(GetServiceManualHandler.name);

  constructor(
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
  ) {}

  async execute(appointmentId: string): Promise<ServiceManualResponseDto> {
    this.logger.log(`Getting service manual for appointment: ${appointmentId}`);

    const booking = await this.bookingRepository.findOne({
      where: { id: appointmentId },
      relations: [
        'product',
        'product.media',
        'product.productDefinition',
        'product.reviews',
        'product.facilityImages',
      ],
    });

    if (!booking) {
      this.logger.warn(`Appointment not found: ${appointmentId}`);
      throw new NotFoundException(`Appointment with ID ${appointmentId} not found`);
    }

    return ServiceManualResponseDto.fromBooking(booking);
  }
}
