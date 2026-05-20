import {
  Post,
  Get,
  Body,
  Param,
  Query,
  HttpCode,
  HttpStatus,
  ParseUUIDPipe,
} from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
  ApiAcceptedResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { BookingService } from './booking.service';
import { AsyncCheckoutDto } from './dto/async-checkout.dto';
import { AsyncCheckoutResponseDto } from './dto/async-checkout-response.dto';
import { BookingResponseDto } from './dto/booking-response.dto';
import { CheckoutTicketResponseDto } from './dto/checkout-ticket-response.dto';

/**
 * User controller for booking endpoints.
 * All endpoints require USER authentication.
 * Route prefix: /v1/user/bookings
 */
@UserApi('bookings')
export class BookingController {
  constructor(private readonly bookingService: BookingService) {}

  /**
   * Start an async checkout process.
   * Creates a checkout ticket, pushes to queue, and returns 202 Accepted.
   */
  @Post('async-checkout')
  @HttpCode(HttpStatus.ACCEPTED)
  @ApiOperation({
    summary: 'Start async checkout (returns 202 with ticket ID)',
  })
  @ApiAcceptedResponse({ type: AsyncCheckoutResponseDto })
  async asyncCheckout(
    @Body() dto: AsyncCheckoutDto,
  ): Promise<AsyncCheckoutResponseDto> {
    return this.bookingService.asyncCheckout(dto);
  }

  /**
   * Get checkout ticket status by ID.
   * Used by AI/Frontend to poll for checkout result.
   */
  @Get('tickets/:id')
  @ApiOperation({ summary: 'Get checkout ticket status' })
  @ApiOkResponse({ type: CheckoutTicketResponseDto })
  @ApiNotFoundResponse({ description: 'Ticket not found' })
  async getTicketStatus(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<CheckoutTicketResponseDto> {
    return this.bookingService.getTicketStatus(id);
  }

  /**
   * List authenticated user's bookings with pagination.
   */
  @Get()
  @ApiOperation({ summary: 'List my bookings' })
  @ApiOkResponse({ type: [BookingResponseDto] })
  async listMyBookings(
    @CurrentUser('id') userId: string,
    @Query('page') page = 1,
    @Query('limit') limit = 10,
  ): Promise<BookingResponseDto[]> {
    return this.bookingService.listMyBookings(userId, +page, +limit);
  }

  /**
   * Get a single booking by ID.
   */
  @Get(':id')
  @ApiOperation({ summary: 'Get booking by ID' })
  @ApiOkResponse({ type: BookingResponseDto })
  @ApiNotFoundResponse({ description: 'Booking not found' })
  async getBooking(
    @CurrentUser('id') userId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<BookingResponseDto> {
    return this.bookingService.getBooking(userId, id);
  }
}
