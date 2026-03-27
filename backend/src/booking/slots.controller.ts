import {
  Post,
  Body,
} from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
} from '@nestjs/swagger';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { BookingService } from './booking.service';
import { MicroLockDto } from './dto/micro-lock.dto';
import { MicroLockResponseDto } from './dto/micro-lock-response.dto';

/**
 * User controller for slot-level operations (micro-lock for AI chatbot).
 * All endpoints require USER authentication.
 * Route prefix: /v1/user/slots
 */
@UserApi('slots')
export class SlotsController {
  constructor(private readonly bookingService: BookingService) {}

  /**
   * Acquire a micro-lock (intent lock) on a time slot.
   * Used by AI chatbot to temporarily hide a slot while the customer decides.
   * Lock TTL: 120 seconds.
   */
  @Post('micro-lock')
  @ApiOperation({ summary: 'Acquire a micro-lock on a time slot (120s TTL)' })
  @ApiOkResponse({ type: MicroLockResponseDto })
  async microLock(@Body() dto: MicroLockDto): Promise<MicroLockResponseDto> {
    return this.bookingService.acquireMicroLock(dto);
  }
}
