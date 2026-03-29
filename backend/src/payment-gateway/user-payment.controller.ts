import {
  Post,
  Body,
  Param,
  ParseUUIDPipe,
} from '@nestjs/common';
import {
  ApiOperation,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiBadRequestResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { MoMoPaymentService } from './momo-payment.service';
import {
  CreateMoMoPaymentDto,
  CreateMoMoRefundDto,
  MoMoPaymentResponseDto,
  MoMoRefundResponseDto,
} from './dto';

/**
 * User-facing payment endpoints.
 *
 * All endpoints require USER authentication.
 * Route prefix: /v1/user/payments
 */
@UserApi('payments')
export class UserPaymentController {
  constructor(
    private readonly momoService: MoMoPaymentService,
  ) {}

  /**
   * Create a MoMo payment link for a booking.
   *
   * Returns the MoMo payment URL/deeplink/QR code.
   * Client should redirect user to payUrl or open deeplink.
   */
  @Post('momo/:bookingId')
  @ApiOperation({ summary: 'Create MoMo payment for booking' })
  @ApiCreatedResponse({ type: MoMoPaymentResponseDto })
  @ApiBadRequestResponse({ description: 'Booking not in PENDING_PAYMENT status or invalid amount' })
  @ApiNotFoundResponse({ description: 'Booking not found' })
  async createMoMoPayment(
    @Param('bookingId', ParseUUIDPipe) bookingId: string,
    @CurrentUser('id') userId: string,
    @Body() dto: CreateMoMoPaymentDto,
  ): Promise<MoMoPaymentResponseDto> {
    return this.momoService.createPayment(
      bookingId,
      userId,
      dto.requestType,
    );
  }

  /**
   * Request a MoMo refund for a booking.
   *
   * Requires the MoMo transId from the original payment.
   * Result is synchronous — no polling needed.
   */
  @Post('momo/:bookingId/refund')
  @ApiOperation({ summary: 'Request MoMo refund for booking' })
  @ApiOkResponse({ type: MoMoRefundResponseDto })
  @ApiBadRequestResponse({ description: 'Invalid transId' })
  @ApiNotFoundResponse({ description: 'Booking not found' })
  async refundMoMoPayment(
    @Param('bookingId', ParseUUIDPipe) bookingId: string,
    @CurrentUser('id') userId: string,
    @Body() dto: CreateMoMoRefundDto,
  ): Promise<MoMoRefundResponseDto> {
    return this.momoService.refundPayment(
      bookingId,
      userId,
      dto.transId,
    );
  }
}
