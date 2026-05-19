import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { BookingStatus } from '@/booking/enums/booking-status.enum';

export enum PartnerBookingStatus {
  WAITING = 'Waiting',
  ON_PROCESS = 'OnProcess',
  CANCELED = 'Canceled',
  FINISHED = 'Finished',
}

export class PartnerBookingCustomerDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty()
  fullName: string;

  @ApiProperty({ type: Number })
  age: number;

  @ApiPropertyOptional({ nullable: true })
  avatarUrl: string | null;
}

export class PartnerBookingSpecialistDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty()
  fullName: string;

  @ApiProperty()
  roleLabel: string;

  @ApiPropertyOptional({ nullable: true })
  avatarUrl: string | null;
}

export class PartnerBookingServiceDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty()
  name: string;

  @ApiProperty()
  categoryName: string;

  @ApiProperty({ type: Number })
  price: number;

  @ApiProperty()
  currencyCode: string;
}

export class PartnerBookingSlotDto {
  @ApiProperty({ format: 'date-time' })
  start: Date;

  @ApiProperty({ format: 'date-time' })
  end: Date;
}

interface PartnerBookingRow {
  id: string;
  status: BookingStatus;
  customerId: string;
  customerFullName: string | null;
  customerEmail: string | null;
  customerDateOfBirth: string | Date | null;
  customerAvatarUrl: string | null;
  specialistId: string;
  specialistFullName: string | null;
  specialistRoleLabel: string | null;
  specialistAvatarUrl: string | null;
  serviceId: string;
  serviceName: string | null;
  categoryName: string | null;
  price: string | number | null;
  currencyCode: string | null;
  slotStart: string | Date;
  slotEnd: string | Date;
}

export class PartnerBookingResponseDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ type: PartnerBookingCustomerDto })
  customer: PartnerBookingCustomerDto;

  @ApiProperty({ type: PartnerBookingSpecialistDto })
  specialist: PartnerBookingSpecialistDto;

  @ApiProperty({ type: PartnerBookingServiceDto })
  service: PartnerBookingServiceDto;

  @ApiProperty({ type: PartnerBookingSlotDto })
  slot: PartnerBookingSlotDto;

  @ApiProperty({
    enum: PartnerBookingStatus,
    enumName: 'PartnerBookingStatus',
  })
  status: PartnerBookingStatus;

  static fromRow(row: PartnerBookingRow): PartnerBookingResponseDto {
    const dto = new PartnerBookingResponseDto();
    dto.id = row.id;
    dto.customer = {
      id: row.customerId,
      fullName: row.customerFullName?.trim() || row.customerEmail || 'Customer',
      age: calculateAge(row.customerDateOfBirth),
      avatarUrl: row.customerAvatarUrl,
    };
    dto.specialist = {
      id: row.specialistId,
      fullName: row.specialistFullName?.trim() || 'Specialist',
      roleLabel: row.specialistRoleLabel?.trim() || 'Specialist',
      avatarUrl: row.specialistAvatarUrl,
    };
    dto.service = {
      id: row.serviceId,
      name: row.serviceName?.trim() || 'Unknown Service',
      categoryName: row.categoryName?.trim() || 'General',
      price: Number(row.price ?? 0),
      currencyCode: row.currencyCode || 'VND',
    };
    dto.slot = {
      start: new Date(row.slotStart),
      end: new Date(row.slotEnd),
    };
    dto.status = mapPartnerBookingStatus(row.status);
    return dto;
  }
}

function mapPartnerBookingStatus(status: BookingStatus): PartnerBookingStatus {
  switch (status) {
    case BookingStatus.IN_PROGRESS:
      return PartnerBookingStatus.ON_PROCESS;
    case BookingStatus.COMPLETED:
      return PartnerBookingStatus.FINISHED;
    case BookingStatus.CANCELLED:
    case BookingStatus.NO_SHOW:
      return PartnerBookingStatus.CANCELED;
    default:
      return PartnerBookingStatus.WAITING;
  }
}

function calculateAge(dateOfBirth: string | Date | null): number {
  if (!dateOfBirth) return 0;
  const birthDate = new Date(dateOfBirth);
  if (Number.isNaN(birthDate.getTime())) return 0;

  const today = new Date();
  let age = today.getFullYear() - birthDate.getFullYear();
  const monthDelta = today.getMonth() - birthDate.getMonth();
  if (
    monthDelta < 0 ||
    (monthDelta === 0 && today.getDate() < birthDate.getDate())
  ) {
    age -= 1;
  }
  return Math.max(0, age);
}
