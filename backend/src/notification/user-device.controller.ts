import { Post, Delete, Param, Body } from '@nestjs/common';
import { ApiOperation, ApiCreatedResponse, ApiNoContentResponse } from '@nestjs/swagger';
import { HttpCode, HttpStatus } from '@nestjs/common';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { NotificationService } from './notification.service';
import { RegisterDeviceDto } from './dto/register-device.dto';

/**
 * User-facing device token management endpoints.
 * Users register their FCM/APNs token on login, unregister on logout.
 */
@UserApi('devices')
export class UserDeviceController {
  constructor(private readonly notificationService: NotificationService) {}

  @Post()
  @ApiOperation({ summary: 'Register a device token for push notifications' })
  @ApiCreatedResponse({ description: 'Device token registered' })
  async registerDevice(
    @Body() dto: RegisterDeviceDto,
    @CurrentUser('id') userId: string,
  ): Promise<{ message: string }> {
    await this.notificationService.registerDevice(
      userId,
      dto.token,
      dto.platform,
    );
    return { message: 'Device registered successfully' };
  }

  @Delete(':token')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Unregister a device token (e.g. on logout)' })
  @ApiNoContentResponse({ description: 'Device token unregistered' })
  async unregisterDevice(
    @Param('token') token: string,
    @CurrentUser('id') userId: string,
  ): Promise<void> {
    await this.notificationService.unregisterDevice(userId, token);
  }
}
