import { Get, Param, ParseUUIDPipe } from '@nestjs/common';
import {
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
} from '@nestjs/swagger';
import { PartnerApi } from '@/common/decorators/api/partner-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { ListPartnerBookingsHandler } from './application/handlers/list-partner-bookings.handler';
import { PartnerBookingResponseDto } from './dto/partner/partner-booking-response.dto';

@PartnerApi('bookings')
export class PartnerBookingsController {
  constructor(private readonly handler: ListPartnerBookingsHandler) {}

  @Get()
  @ApiOperation({ summary: 'List bookings for the authenticated partner' })
  @ApiOkResponse({ type: [PartnerBookingResponseDto] })
  listBookings(
    @CurrentUser('id') accountId: string,
  ): Promise<PartnerBookingResponseDto[]> {
    return this.handler.list(accountId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get partner booking detail' })
  @ApiOkResponse({ type: PartnerBookingResponseDto })
  @ApiNotFoundResponse({ description: 'Booking not found' })
  getBooking(
    @CurrentUser('id') accountId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<PartnerBookingResponseDto> {
    return this.handler.get(accountId, id);
  }
}
