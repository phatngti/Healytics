import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { Role } from '@/account/enum/role.enum';

class AccountAddressDto {
  @ApiProperty({ description: 'Street address' })
  @Expose()
  street: string;

  @ApiProperty({ description: 'Ward or commune' })
  @Expose()
  ward: string;

  @ApiProperty({ description: 'District' })
  @Expose()
  district: string;

  @ApiProperty({ description: 'City or province' })
  @Expose()
  cityOrProvince: string;

  @ApiPropertyOptional({ description: 'Province/city Location UUID' })
  @Expose()
  provinceId?: string | null;

  @ApiPropertyOptional({ description: 'District Location UUID' })
  @Expose()
  districtId?: string | null;

  @ApiPropertyOptional({ description: 'Ward/commune Location UUID' })
  @Expose()
  wardId?: string | null;

  @ApiPropertyOptional({ description: 'Resolved latitude' })
  @Expose()
  latitude?: number | null;

  @ApiPropertyOptional({ description: 'Resolved longitude' })
  @Expose()
  longitude?: number | null;
}

class UserProfileDto {
  @ApiProperty({ description: 'Profile ID' })
  @Expose()
  id: string;

  @ApiPropertyOptional({ description: 'First name' })
  @Expose()
  firstName?: string | null;

  @ApiPropertyOptional({ description: 'Last name' })
  @Expose()
  lastName?: string | null;

  @ApiPropertyOptional({ description: 'Phone number' })
  @Expose()
  phone?: string | null;

  @ApiPropertyOptional({ description: 'Bio' })
  @Expose()
  bio?: string | null;

  @ApiPropertyOptional({
    description: 'Date of birth',
    type: String,
    example: '1990-01-15',
  })
  @Expose()
  dateOfBirth?: Date | null;

  @ApiPropertyOptional({ description: 'Avatar image URL' })
  @Expose()
  avatarUrl?: string | null;

  @ApiProperty({ description: 'Whether the profile is completed' })
  @Expose()
  profileCompleted: boolean;

  @ApiPropertyOptional({
    description: 'Address provided during registration',
    type: AccountAddressDto,
  })
  @Expose()
  @Type(() => AccountAddressDto)
  address?: AccountAddressDto | null;
}

export class AccountMeResponseDto {
  @ApiProperty({ description: 'Account ID' })
  @Expose()
  id: string;

  @ApiProperty({ description: 'Email address' })
  @Expose()
  email: string;

  @ApiProperty({ description: 'Account role', enum: Role, example: Role.USER })
  @Expose()
  role: Role;

  @ApiProperty({ description: 'Whether the account is active' })
  @Expose()
  isActive: boolean;

  @ApiProperty({ description: 'Account creation date' })
  @Expose()
  createdAt: Date;

  @ApiProperty({ description: 'Last update date' })
  @Expose()
  updatedAt: Date;

  @ApiPropertyOptional({
    description: 'User profile data',
    type: UserProfileDto,
  })
  @Expose()
  @Type(() => UserProfileDto)
  userProfile?: UserProfileDto | null;
}
