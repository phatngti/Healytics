import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty, IsEnum } from 'class-validator';
import { DevicePlatform } from '@/notification/enums/device-platform.enum';

/**
 * Input DTO for registering a device token for push notifications.
 */
export class RegisterDeviceDto {
  @ApiProperty({
    type: String,
    description: 'FCM or APNs device token',
    example: 'fMv7B4Yp...long_token_string',
  })
  @IsString()
  @IsNotEmpty()
  token: string;

  @ApiProperty({
    enum: DevicePlatform,
    enumName: 'DevicePlatform',
    description: 'Device platform',
    example: DevicePlatform.ANDROID,
  })
  @IsEnum(DevicePlatform)
  platform: DevicePlatform;
}
