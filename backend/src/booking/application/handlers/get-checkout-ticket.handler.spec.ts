import { Test, TestingModule } from '@nestjs/testing';
import { NotFoundException } from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import { GetCheckoutTicketHandler } from './get-checkout-ticket.handler';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { CheckoutTicketResponseDto } from '../../dto/checkout-ticket-response.dto';
import {
  MockRepository,
  createMockRepository,
} from '../../../../test/mocks/mock-types';
import { createCheckoutTicketEntity } from '../../../../test/fixtures/test-data.factory';

describe('GetCheckoutTicketHandler', () => {
  let handler: GetCheckoutTicketHandler;
  let ticketRepo: MockRepository<CheckoutTicket>;

  beforeEach(async () => {
    ticketRepo = createMockRepository<CheckoutTicket>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GetCheckoutTicketHandler,
        {
          provide: getRepositoryToken(CheckoutTicket),
          useValue: ticketRepo,
        },
      ],
    }).compile();

    handler = module.get<GetCheckoutTicketHandler>(GetCheckoutTicketHandler);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should return CheckoutTicketResponseDto when ticket is found', async () => {
    // Arrange
    const ticketEntity = createCheckoutTicketEntity({ id: 'tk-test-1' });
    ticketRepo.findOne.mockResolvedValue(ticketEntity);

    // Act
    const result = await handler.execute('tk-test-1');

    // Assert
    expect(result).toBeInstanceOf(CheckoutTicketResponseDto);
    expect(result.id).toBe('tk-test-1');
    expect(result.userId).toBe(ticketEntity.userId);
    expect(result.staffId).toBe(ticketEntity.staffId);
    expect(result.status).toBe(ticketEntity.status);
    expect(result.idempotencyKey).toBe(ticketEntity.idempotencyKey);
    expect(ticketRepo.findOne).toHaveBeenCalledWith({
      where: { id: 'tk-test-1' },
    });
  });

  it('should throw NotFoundException when ticket is not found', async () => {
    // Arrange
    ticketRepo.findOne.mockResolvedValue(null);

    // Act & Assert
    await expect(handler.execute('non-existent')).rejects.toThrow(
      NotFoundException,
    );
    await expect(handler.execute('non-existent')).rejects.toThrow(
      'Checkout ticket with ID non-existent not found',
    );
  });
});
