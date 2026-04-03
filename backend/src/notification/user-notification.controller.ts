import {
  Get,
  Patch,
  Param,
  Query,
  HttpCode,
  HttpStatus,
  ParseUUIDPipe,
} from '@nestjs/common';
import { ApiOperation, ApiOkResponse, ApiNoContentResponse } from '@nestjs/swagger';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { NotificationService } from './notification.service';
import { NotificationResponseDto } from './dto/notification-response.dto';
import { NotificationsQueryDto } from './dto/notifications-query.dto';

/**
 * User-facing notification endpoints.
 * Protected by JWT auth + Role.USER via @UserApi decorator.
 */
@UserApi('notifications')
export class UserNotificationController {
  constructor(private readonly notificationService: NotificationService) {}

  @Get()
  @ApiOperation({ summary: 'Get user notifications (paginated, cursor-based)' })
  @ApiOkResponse({
    description: 'Paginated list of notifications',
  })
  async getNotifications(
    @CurrentUser('id') userId: string,
    @Query() query: NotificationsQueryDto,
  ): Promise<{
    notifications: NotificationResponseDto[];
    hasMore: boolean;
    nextCursor: string | null;
  }> {
    return this.notificationService.getNotifications(userId, query);
  }

  @Get('unread-count')
  @ApiOperation({ summary: 'Get unread notification count' })
  @ApiOkResponse({
    description: 'The current unread notification count',
  })
  async getUnreadCount(
    @CurrentUser('id') userId: string,
  ): Promise<{ count: number }> {
    const count = await this.notificationService.getUnreadCount(userId);
    return { count };
  }

  @Patch(':id/read')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Mark a specific notification as read' })
  @ApiNoContentResponse({ description: 'Notification marked as read' })
  async markRead(
    @Param('id', ParseUUIDPipe) id: string,
    @CurrentUser('id') userId: string,
  ): Promise<void> {
    await this.notificationService.markRead(id, userId);
  }

  @Patch('read-all')
  @ApiOperation({ summary: 'Mark all notifications as read' })
  @ApiOkResponse({ description: 'Number of notifications marked as read' })
  async markAllRead(
    @CurrentUser('id') userId: string,
  ): Promise<{ markedCount: number }> {
    return this.notificationService.markAllRead(userId);
  }
}
