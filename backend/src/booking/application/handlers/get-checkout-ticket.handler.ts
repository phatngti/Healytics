import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { CheckoutTicketResponseDto } from '../../dto/checkout-ticket-response.dto';

@Injectable()
export class GetCheckoutTicketHandler {
  private readonly logger = new Logger(GetCheckoutTicketHandler.name);

  constructor(
    @InjectRepository(CheckoutTicket)
    private readonly ticketRepo: Repository<CheckoutTicket>,
  ) {}

  async execute(id: string): Promise<CheckoutTicketResponseDto> {
    const ticket = await this.ticketRepo.findOne({
      where: { id },
    });

    if (!ticket) {
      this.logger.warn(`Checkout ticket not found: ${id}`);
      throw new NotFoundException(`Checkout ticket with ID ${id} not found`);
    }

    return CheckoutTicketResponseDto.fromEntity(ticket);
  }
}
