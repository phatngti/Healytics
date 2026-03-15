import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { CheckoutTicketStatus } from '@/booking/enums/checkout-ticket-status.enum';

export class CheckoutTicketResponseDto {
  @ApiProperty({ description: 'Ticket ID (same as ticket_id in webhook)', example: 'TICKET_ABCD123' })
  id: string;

  @ApiProperty()
  userId: string;

  @ApiProperty()
  staffId: string;

  @ApiProperty({ example: '2023-10-25T14:00:00Z' })
  startTime: Date;

  @ApiProperty({ enum: CheckoutTicketStatus, example: CheckoutTicketStatus.QUEUED })
  status: CheckoutTicketStatus;

  @ApiProperty({ example: 'ai_chat_session_888_msg_12' })
  idempotencyKey: string;

  @ApiPropertyOptional({ description: 'Booking ID when checkout succeeds' })
  bookingId: string | null;

  @ApiPropertyOptional({ description: 'Error message when checkout fails' })
  errorMessage: string | null;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
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
