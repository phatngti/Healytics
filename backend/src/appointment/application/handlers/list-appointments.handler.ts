import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { AppointmentResponseDto } from '../../dto/appointment-response.dto';
import { ListAppointmentsQueryDto } from '../../dto/list-appointments-query.dto';

@Injectable()
export class ListAppointmentsHandler {
  private readonly logger = new Logger(ListAppointmentsHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    userId: string,
    query?: ListAppointmentsQueryDto,
  ): Promise<AppointmentResponseDto[]> {
    this.logger.log(`Listing appointments for user: ${userId}`);

    const hasCoordinates = query?.latitude != null && query?.longitude != null;

    const qb = this.dataSource
      .getRepository(Booking)
      .createQueryBuilder('booking')
      .leftJoinAndSelect('booking.product', 'product')
      .leftJoinAndSelect('product.partner', 'productPartner')
      .leftJoinAndSelect('product.category', 'category')
      .leftJoinAndSelect('product.media', 'media')
      .leftJoinAndSelect('product.productDefinition', 'productDefinition')
      .leftJoinAndSelect('booking.staff', 'staff')
      .leftJoinAndSelect('staff.partner', 'partner')
      .leftJoinAndSelect('partner.ward', 'ward')
      .leftJoinAndSelect('partner.district', 'district')
      .leftJoinAndSelect('partner.province', 'province')
      .where('booking.user_id = :userId', { userId })
      .orderBy('booking.start_time', 'DESC');

    if (hasCoordinates) {
      qb.addSelect(
        `ST_Distance(partner.location, ST_SetSRID(ST_MakePoint(:lng, :lat), 4326))`,
        'distance_meters',
      ).setParameters({
        lat: query.latitude,
        lng: query.longitude,
      });
    }

    const rawAndEntities = await qb.getRawAndEntities();
    const { entities, raw } = rawAndEntities;

    this.logger.log(`Found ${entities.length} appointments`);

    return entities.map((booking, index) => {
      // Build address from partner location hierarchy
      const partner = booking.staff?.partner;
      const addressParts = [
        partner?.streetAddress,
        partner?.ward?.fullName,
        partner?.district?.fullName,
        partner?.province?.fullName,
      ].filter(Boolean);
      const clinicAddress = addressParts.join(', ');

      const distanceMeters = hasCoordinates
        ? parseFloat(raw[index]?.distance_meters) || -1
        : -1;

      return AppointmentResponseDto.fromEntity(booking, {
        clinicAddress,
        distanceMeters,
      });
    });
  }
}
