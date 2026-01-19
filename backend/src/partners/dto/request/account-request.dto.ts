import { ApiProperty } from '@nestjs/swagger';
import {
    IsEmail,
    IsString,
    IsNotEmpty,
    MinLength,
    MaxLength,
    Matches,
} from 'class-validator';

class AccountRequestDto {
    @ApiProperty({ example: 'spahanoi123', description: 'Username' })
    @IsString()
    @IsNotEmpty()
    @MinLength(3)
    @MaxLength(50)
    username: string;

    @ApiProperty({
        example: 'Password123',
        description: 'Password (min 8 characters)',
    })
    @IsString()
    @IsNotEmpty()
    @MinLength(8)
    password: string;

    @ApiProperty({
        example: 'contact@spahanoi.com',
        description: 'Email address',
    })
    @IsEmail()
    email: string;

    @ApiProperty({
        example: '0912345678',
        description: 'Phone number (10 digits)',
    })
    @IsString()
    @IsNotEmpty()
    @Matches(/^0\d{9}$/, {
        message: 'Phone number must be 10 digits starting with 0',
    })
    phoneNumber: string;
}

export { AccountRequestDto };
