import {
  Body,
  Controller,
  Param,
  ParseUUIDPipe,
  Patch,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiForbiddenResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Role } from '@/account/enum/role.enum';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { Roles } from '@/common/decorators/auth/roles.decorator';
import { BookingOwnershipGuard } from './guards/booking-ownership.guard';
import { BookingStatusLifecycleService } from './services/booking-status-lifecycle.service';
import { UpdateBookingStatusDto } from './dto/update-booking-status.dto';
import { BookingStatusChangeEventDto } from './dto/booking-status-change-event.dto';

interface CurrentJwtUser {
  id: string;
  role: Role;
}

@ApiTags('Bookings')
@ApiBearerAuth()
@Controller({ path: 'bookings', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(Role.EMPLOYEE)
export class BookingStatusController {
  constructor(
    private readonly lifecycleService: BookingStatusLifecycleService,
  ) {}

  @Patch(':id/status')
  @UseGuards(BookingOwnershipGuard)
  @ApiOperation({
    summary: 'Update booking status through the shared booking lifecycle',
  })
  @ApiOkResponse({ type: BookingStatusChangeEventDto })
  @ApiForbiddenResponse({
    description:
      'Forbidden when role is not allowed to mutate or booking ownership fails.',
  })
  async updateStatus(
    @CurrentUser() user: CurrentJwtUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateBookingStatusDto,
  ): Promise<BookingStatusChangeEventDto> {
    return this.lifecycleService.updateEmployeeStatus(user.id, id, dto.status);
  }
}
