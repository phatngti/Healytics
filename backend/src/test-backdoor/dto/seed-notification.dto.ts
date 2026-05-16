import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsEnum,
  IsNotEmpty,
  IsObject,
  IsOptional,
  IsString,
} from 'class-validator';
import { NotificationType } from '@/notification/enums/notification-type.enum';

export class SeedNotificationDto {
  @ApiPropertyOptional({ type: String, description: 'Unique lookup key' })
  @IsOptional()
  @IsString()
  key?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Key of a previously seeded user',
  })
  @IsOptional()
  @IsString()
  userKey?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Email to look up the recipient user',
  })
  @IsOptional()
  @IsString()
  userEmail?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Key of a previously seeded sender account',
  })
  @IsOptional()
  @IsString()
  senderKey?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Email to look up the sender account',
  })
  @IsOptional()
  @IsString()
  senderEmail?: string;

  @ApiProperty({ enum: NotificationType })
  @IsEnum(NotificationType)
  type: NotificationType;

  @ApiProperty({ type: String, example: 'Booking confirmed' })
  @IsString()
  @IsNotEmpty()
  title: string;

  @ApiProperty({ type: String, example: 'Your appointment is confirmed.' })
  @IsString()
  @IsNotEmpty()
  body: string;

  @ApiPropertyOptional({ type: Object })
  @IsOptional()
  @IsObject()
  data?: Record<string, any>;

  @ApiPropertyOptional({ type: Boolean, default: false })
  @IsOptional()
  @IsBoolean()
  isRead?: boolean;

  @ApiPropertyOptional({ type: Boolean, default: false })
  @IsOptional()
  @IsBoolean()
  isBroadcast?: boolean;
}
