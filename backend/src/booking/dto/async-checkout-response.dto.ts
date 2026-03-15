import { ApiProperty } from '@nestjs/swagger';

export class AsyncCheckoutResponseDto {
  @ApiProperty({
    description: 'Unique ticket ID for tracking',
    example: 'TICKET_ABCD123',
  })
  ticketId: string;

  @ApiProperty({
    description: 'Current ticket status',
    example: 'QUEUED',
  })
  status: string;

  @ApiProperty({
    description: 'Human-readable message',
    example: 'Request is being processed sequentially.',
  })
  message: string;

  constructor(ticketId: string, status: string, message: string) {
    this.ticketId = ticketId;
    this.status = status;
    this.message = message;
  }
}
