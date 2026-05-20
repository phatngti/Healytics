import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { AppointmentResponseDto } from '../../dto/appointment-response.dto';

@Injectable()
export class GetAppointmentHandler {
  private readonly logger = new Logger(GetAppointmentHandler.name);

  constructor(
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
  ) {}

  async execute(userId: string, id: string): Promise<AppointmentResponseDto> {
    this.logger.log(`Getting appointment: user=${userId}, appointment=${id}`);

    const booking = await this.bookingRepository.findOne({
      where: { id, userId },
      relations: [
        'product',
        'product.partner',
        'product.category',
        'product.media',
        'product.productDefinition',
        'staff',
        'staff.partner',
      ],
    });

    if (!booking) {
      this.logger.warn(
        `Appointment not found or forbidden: user=${userId}, appointment=${id}`,
      );
      throw new NotFoundException(`Appointment with ID ${id} not found`);
    }

    return AppointmentResponseDto.fromEntity(booking);
  }
}
