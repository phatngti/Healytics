import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsUUID,
  IsDateString,
  IsString,
  IsOptional,
  IsUrl,
  IsBoolean,
  MaxLength,
  ValidateIf,
} from 'class-validator';

export class AsyncCheckoutDto {
  @ApiProperty({ description: 'User account UUID' })
  @IsUUID()
  userId: string;

  @ApiProperty({
    description: 'Staff/employee UUID. Optional when autoAssignStaff is true.',
    required: false,
  })
  @ValidateIf((dto: AsyncCheckoutDto) => !dto.autoAssignStaff)
  @IsUUID()
  staffId?: string;

  @ApiProperty({
    description: 'Desired slot start time (ISO 8601)',
    example: '2023-10-25T14:00:00Z',
  })
  @IsDateString()
  startTime: string;

  @ApiProperty({ description: 'Product/service UUID' })
  @IsUUID()
  productId: string;

  @ApiProperty({
    description: 'Idempotency key to prevent duplicate requests from AI retry',
    example: 'ai_chat_session_888_msg_12',
  })
  @IsString()
  @MaxLength(255)
  idempotencyKey: string;

  @ApiPropertyOptional({
    description: 'Webhook URL to receive checkout result',
    example: 'https://ai-service.com/webhook/booking-result',
  })
  @IsUrl()
  @IsOptional()
  webhookUrl?: string;

  @ApiPropertyOptional({
    type: Boolean,
    description:
      'If true, booking is immediately CONFIRMED without requiring payment. ' +
      'The booking has no payment URL or expiry — suitable for in-person pay-later scenarios.',
    example: false,
    default: false,
  })
  @IsBoolean()
  @IsOptional()
  payLater?: boolean;

  @ApiPropertyOptional({
    type: Boolean,
    description:
      'If true, backend selects the best eligible available specialist for the service and start time.',
    example: true,
    default: false,
  })
  @IsBoolean()
  @IsOptional()
  autoAssignStaff?: boolean;
}
