import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class InventoryAlertDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  id: string;

  @ApiProperty({ example: 'Essential Oil — Lavender' })
  @Expose()
  productName: string;

  @ApiProperty({
    example: 'low_stock',
    enum: ['low_stock', 'expiring', 'out_of_stock'],
  })
  @Expose()
  alertType: string;

  @ApiProperty({ example: 'Only 3 units remaining. Reorder threshold: 10.' })
  @Expose()
  message: string;

  @ApiProperty({ example: '2026-04-09T06:00:00.000Z' })
  @Expose()
  createdAt: string;

  @ApiProperty({
    example: 'warning',
    enum: ['info', 'warning', 'critical'],
    default: 'warning',
  })
  @Expose()
  severity: string;
}
