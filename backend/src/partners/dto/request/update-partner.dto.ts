import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, MaxLength, IsPhoneNumber } from 'class-validator';

export class UpdatePartnerDto {
    @ApiPropertyOptional({
        example: 'Hanoi Spa & Wellness',
        description: 'Brand name of the business',
    })
    @IsOptional()
    @IsString()
    @MaxLength(150)
    brandName?: string;

    @ApiPropertyOptional({
        example: '+84987654321',
        description: 'Contact phone number',
    })
    @IsOptional()
    @IsString()
    phoneNumber?: string;

    @ApiPropertyOptional({
        example: '123 Le Loi Street',
        description: 'Street address (can only update if not verified)',
    })
    @IsOptional()
    @IsString()
    @MaxLength(300)
    streetAddress?: string;
}
