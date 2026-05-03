import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Partner } from '@/common/entities/partner.entity';
import { EmployeeAppointmentResponseDto } from '../../dto/employee/employee-appointment-response.dto';

/**
 * Handler to get a single appointment detail for the authenticated employee.
 * Verifies the booking belongs to the employee (staffId === employee.id).
 */
@Injectable()
export class GetEmployeeAppointmentHandler {
  private readonly logger = new Logger(GetEmployeeAppointmentHandler.name);

  constructor(
    @InjectRepository(Employee)
    private readonly employeeRepository: Repository<Employee>,
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
    @InjectRepository(Partner)
    private readonly partnerRepository: Repository<Partner>,
  ) {}

  async execute(
    accountId: string,
    bookingId: string,
  ): Promise<EmployeeAppointmentResponseDto> {
    // 1. Resolve employee
    const employee = await this.employeeRepository.findOne({
      where: { accountId },
      select: ['id', 'partnerId'],
    });
    if (!employee) {
      throw new NotFoundException('Employee profile not found for this account');
    }

    // 2. Load booking with ownership check
    const booking = await this.bookingRepository.findOne({
      where: { id: bookingId, staffId: employee.id },
      relations: [
        'product',
        'product.productDefinition',
        'product.category',
        'user',
        'user.userProfile',
      ],
    });
    if (!booking) {
      this.logger.warn(
        `Appointment ${bookingId} not found for employee ${employee.id}`,
      );
      throw new NotFoundException(`Appointment with ID ${bookingId} not found`);
    }

    // 3. Resolve clinic info
    let clinicName = 'Healytics Clinic';
    let clinicAddress = '';
    if (employee.partnerId) {
      const partner = await this.partnerRepository.findOne({
        where: { id: employee.partnerId },
        select: ['id', 'brandName', 'streetAddress'],
      });
      if (partner) {
        clinicName = partner.brandName ?? clinicName;
        clinicAddress = partner.streetAddress ?? '';
      }
    }

    return EmployeeAppointmentResponseDto.fromBooking(
      booking,
      clinicName,
      clinicAddress,
    );
  }
}
