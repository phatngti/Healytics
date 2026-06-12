import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CheckDuplicateSlotResponseDto {
  @ApiProperty({
    description: 'Whether a conflicting booking exists at this datetime',
    example: true,
  })
  isDuplicate: boolean;

  @ApiPropertyOptional({
    description: 'Name of the conflicting service/product (if duplicate found)',
    example: 'Premium Skin Treatment',
  })
  conflictingServiceName?: string;

  @ApiPropertyOptional({
    description: 'ID of the conflicting booking (if duplicate found)',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  conflictingBookingId?: string;

  constructor(
    isDuplicate: boolean,
    conflictingServiceName?: string,
    conflictingBookingId?: string,
  ) {
    this.isDuplicate = isDuplicate;
    this.conflictingServiceName = conflictingServiceName;
    this.conflictingBookingId = conflictingBookingId;
  }
}
