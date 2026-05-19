import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { Partner } from '@/common/entities/partner.entity';
import { BookingStatusUpdate } from '@/booking/dto/update-booking-status.dto';
import { BookingStatusLifecycleService } from '@/booking/services/booking-status-lifecycle.service';
import { EmployeeAppointmentResponseDto } from '../../dto/employee/employee-appointment-response.dto';

/**
 * Compatibility handler for the existing employee complete endpoint.
 * The shared lifecycle service owns authorization, transaction, audit, and realtime publish.
 */
@Injectable()
export class CompleteEmployeeServiceHandler {
  private readonly logger = new Logger(CompleteEmployeeServiceHandler.name);

  constructor(
    private readonly dataSource: DataSource,
    private readonly lifecycleService: BookingStatusLifecycleService,
  ) {}

  async execute(
    accountId: string,
    bookingId: string,
  ): Promise<EmployeeAppointmentResponseDto> {
    this.logger.log(`Completing service for booking: ${bookingId}`);
    const event = await this.lifecycleService.updateEmployeeStatus(
      accountId,
      bookingId,
      BookingStatusUpdate.COMPLETED,
    );
    return this.toAppointmentResponse(bookingId, event.partnerId);
  }

  private async toAppointmentResponse(
    bookingId: string,
    partnerId: string | null,
  ): Promise<EmployeeAppointmentResponseDto> {
    const reloaded = await this.dataSource.manager.findOneOrFail(Booking, {
      where: { id: bookingId },
      relations: [
        'product',
        'product.productDefinition',
        'product.category',
        'user',
        'user.userProfile',
      ],
    });

    let clinicName = 'Healytics Clinic';
    let clinicAddress = '';
    if (partnerId) {
      const partner = await this.dataSource.manager.findOne(Partner, {
        where: { id: partnerId },
        select: ['id', 'brandName', 'streetAddress'],
      });
      clinicName = partner?.brandName ?? clinicName;
      clinicAddress = partner?.streetAddress ?? '';
    }

    return EmployeeAppointmentResponseDto.fromBooking(
      reloaded,
      clinicName,
      clinicAddress,
    );
  }
}
