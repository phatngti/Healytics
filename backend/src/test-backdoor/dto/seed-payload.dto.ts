import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsArray, IsOptional, ValidateNested } from 'class-validator';
import { SeedUserDto } from './seed-user.dto';
import { SeedCategoryDto } from './seed-category.dto';
import { SeedPartnerDto } from './seed-partner.dto';
import { SeedEmployeeDto } from './seed-employee.dto';
import { SeedServiceDto } from './seed-service.dto';
import { SeedCartItemDto } from './seed-cart-item.dto';
import { SeedBookingDto } from './seed-booking.dto';
import { SeedCouponDto } from './seed-coupon.dto';
import { SeedNotificationDto } from './seed-notification.dto';

export class SeedPayloadDto {
  @ApiPropertyOptional({ type: [SeedUserDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SeedUserDto)
  users?: SeedUserDto[];

  @ApiPropertyOptional({ type: [SeedCategoryDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SeedCategoryDto)
  categories?: SeedCategoryDto[];

  @ApiPropertyOptional({ type: [SeedPartnerDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SeedPartnerDto)
  partners?: SeedPartnerDto[];

  @ApiPropertyOptional({ type: [SeedEmployeeDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SeedEmployeeDto)
  employees?: SeedEmployeeDto[];

  @ApiPropertyOptional({ type: [SeedServiceDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SeedServiceDto)
  services?: SeedServiceDto[];

  @ApiPropertyOptional({ type: [SeedCouponDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SeedCouponDto)
  coupons?: SeedCouponDto[];

  @ApiPropertyOptional({ type: [SeedCartItemDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SeedCartItemDto)
  cartItems?: SeedCartItemDto[];

  @ApiPropertyOptional({ type: [SeedBookingDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SeedBookingDto)
  bookings?: SeedBookingDto[];

  @ApiPropertyOptional({ type: [SeedNotificationDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SeedNotificationDto)
  notifications?: SeedNotificationDto[];
}
