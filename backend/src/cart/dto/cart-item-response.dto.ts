import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { CartItemStatus } from '@/cart/enums/cart-item-status.enum';

export class CartItemResponseDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ format: 'uuid' })
  serviceId: string;

  @ApiProperty({ example: 'Swedish Relax Massage' })
  serviceName: string;

  @ApiProperty({ example: 'https://cdn.example.com/service.jpg' })
  serviceImageUrl: string;

  @ApiProperty({ example: '500.000đ' })
  price: string;

  @ApiProperty({ example: 500000 })
  priceAmount: number;

  @ApiProperty({ format: 'uuid' })
  clinicId: string;

  @ApiProperty({ example: 'Spa An Nhien' })
  clinicName: string;

  @ApiProperty({ example: '123 Dien Bien Phu, Q1, HCM' })
  clinicAddress: string;

  @ApiPropertyOptional({ example: null })
  clinicImageUrl: string | null;

  // ── Employee fields ────────────────────────────────────────

  @ApiProperty({ format: 'uuid' })
  employeeId: string;

  @ApiProperty({ example: 'Dr. Anna Nguyen' })
  employeeName: string;

  @ApiProperty({ example: 'DOCTOR', enum: ['DOCTOR', 'THERAPIST'] })
  employeeRole: string;

  @ApiPropertyOptional({ example: 'https://cdn.example.com/avatar.jpg' })
  employeeAvatarUrl: string | null;

  @ApiProperty({
    format: 'date-time',
    example: '2026-04-10T09:00:00.000Z',
    description: 'Selected time slot for the appointment',
  })
  timeSlot: string;

  @ApiProperty({
    example: true,
    description:
      'Whether the selected time slot is still available in the employee schedule.',
  })
  isTimeSlotAvailable: boolean;

  // ── Status ─────────────────────────────────────────────────

  @ApiProperty({
    enum: CartItemStatus,
    example: CartItemStatus.ACTIVE,
    description: 'Cart item status: ACTIVE, BOOKED, or DELETED',
  })
  status: CartItemStatus;

  @ApiProperty({ format: 'date-time' })
  createdAt: string;

  static fromEntity(
    entity: CartItem,
    isTimeSlotAvailable = true,
  ): CartItemResponseDto {
    const dto = new CartItemResponseDto();
    const service = entity.service;
    const clinic = service?.partner;
    const employee = entity.employee;
    const priceAmount = CartItemResponseDto.resolvePriceAmount(entity);

    dto.id = entity.id;
    dto.serviceId = entity.serviceId;
    dto.serviceName = service?.name ?? '';
    dto.serviceImageUrl = CartItemResponseDto.resolveServiceImageUrl(entity);
    dto.price = CartItemResponseDto.formatVnd(priceAmount);
    dto.priceAmount = priceAmount;
    dto.clinicId = clinic?.id ?? '';
    dto.clinicName = clinic?.brandName ?? '';
    dto.clinicAddress = clinic?.streetAddress ?? '';
    dto.clinicImageUrl = null;

    // Employee
    dto.employeeId = entity.employeeId;
    dto.employeeName = employee?.fullName ?? '';
    dto.employeeRole = employee?.role ?? '';
    dto.employeeAvatarUrl = employee?.avatarUrl ?? null;
    dto.timeSlot = entity.timeSlot.toISOString();
    dto.isTimeSlotAvailable = isTimeSlotAvailable;

    // Status
    dto.status = entity.status;
    dto.createdAt = entity.createdAt.toISOString();

    return dto;
  }

  static fromEntities(
    entities: CartItem[],
    availabilityMap?: Map<string, boolean>,
  ): CartItemResponseDto[] {
    return entities.map((entity) =>
      CartItemResponseDto.fromEntity(
        entity,
        availabilityMap?.get(entity.id) ?? true,
      ),
    );
  }

  private static resolvePriceAmount(entity: CartItem): number {
    const raw = entity.service?.salePrice ?? entity.service?.basePrice ?? 0;
    return Number(raw);
  }

  private static resolveServiceImageUrl(entity: CartItem): string {
    const mediaList = entity.service?.media ?? [];
    if (mediaList.length === 0) {
      return '';
    }

    const thumbnail = mediaList.find((media) => media.isThumbnail);
    return (thumbnail ?? mediaList[0]).url;
  }

  private static formatVnd(amount: number): string {
    return `${new Intl.NumberFormat('vi-VN').format(amount)}đ`;
  }
}
