import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty } from 'class-validator';

export class PartnerLoginDto {
    @ApiProperty({
        example: 'partner@clinic.com',
        description: 'The email of the partner',
        format: 'email',
        type: String,
        required: true,
    })
    @IsEmail()
    email: string;

    @ApiProperty({
        example: 'StrongP@ssw0rd!',
        description: 'The password of the partner',
        format: 'password',
        type: String,
        required: true,
    })
    @IsNotEmpty()
    password: string;
}
