import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { CheckoutTicketStatus } from '@/booking/enums/checkout-ticket-status.enum';

export class CheckoutTicketResponseDto {
  @ApiProperty({
    type: String,
    description: 'Ticket ID (same as ticket_id in webhook)',
    example: 'TICKET_ABCD123',
  })
  id: string;

  @ApiProperty({
    type: String,
    example: 'USER_ID_123',
  })
  userId: string;

  @ApiProperty({
    type: String,
    example: 'STAFF_ID_123',
  })
  staffId: string;

  @ApiProperty({
    type: Date,
    example: '2023-10-25T14:00:00Z',
  })
  startTime: Date;

  @ApiProperty({
    type: String,
    enum: CheckoutTicketStatus,
    example: CheckoutTicketStatus.QUEUED,
  })
  status: CheckoutTicketStatus;

  @ApiProperty({
    type: String,
    example: 'ai_chat_session_888_msg_12',
  })
  idempotencyKey: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Booking ID when checkout succeeds',
  })
  bookingId: string | null;

  @ApiPropertyOptional({
    type: String,
    description: 'Error message when checkout fails',
  })
  errorMessage: string | null;

  @ApiProperty({
    type: Date,
    example: '2023-10-25T14:00:00Z',
  })
  createdAt: Date;

  @ApiProperty({
    type: Date,
    example: '2023-10-25T14:00:00Z',
  })
  updatedAt: Date;

  static fromEntity(ticket: CheckoutTicket): CheckoutTicketResponseDto {
    const dto = new CheckoutTicketResponseDto();
    dto.id = ticket.id;
    dto.userId = ticket.userId;
    dto.staffId = ticket.staffId;
    dto.startTime = ticket.startTime;
    dto.status = ticket.status;
    dto.idempotencyKey = ticket.idempotencyKey;
    dto.bookingId = ticket.bookingId;
    dto.errorMessage = ticket.errorMessage;
    dto.createdAt = ticket.createdAt;
    dto.updatedAt = ticket.updatedAt;
    return dto;
  }
}
