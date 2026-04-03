import { Get, Post, Body } from '@nestjs/common';
import { ApiOperation, ApiCreatedResponse, ApiOkResponse } from '@nestjs/swagger';
import { AdminApi } from '@/common/decorators/api/admin-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { NotificationService } from './notification.service';
import { CreateBroadcastDto } from './dto/create-broadcast.dto';
import { NotificationResponseDto } from './dto/notification-response.dto';

/**
 * Admin-facing notification endpoints for broadcast management.
 * Protected by JWT auth + ADMIN_ROLES via @AdminApi decorator.
 */
@AdminApi('notifications')
export class AdminNotificationController {
  constructor(private readonly notificationService: NotificationService) {}

  @Post('broadcast')
  @ApiOperation({ summary: 'Create and send a system-wide broadcast notification' })
  @ApiCreatedResponse({
    description: 'Broadcast created and pushed to all users',
    type: NotificationResponseDto,
  })
  async createBroadcast(
    @Body() dto: CreateBroadcastDto,
    @CurrentUser('id') senderId: string,
  ): Promise<NotificationResponseDto> {
    return this.notificationService.createAndPushBroadcast({
      title: dto.title,
      body: dto.body,
      data: dto.data,
      senderId,
    });
  }

  @Get('broadcasts')
  @ApiOperation({ summary: 'List sent broadcast notifications (audit)' })
  @ApiOkResponse({
    description: 'List of broadcast notifications',
    type: [NotificationResponseDto],
  })
  async getBroadcasts(): Promise<NotificationResponseDto[]> {
    return this.notificationService.getBroadcasts();
  }
}
