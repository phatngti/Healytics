import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty, MaxLength } from 'class-validator';

export class PartnerAddressRequestDto {
    @ApiProperty({ example: '1', description: 'Province ID' })
    @IsString()
    @IsNotEmpty()
    provinceId: string;

    @ApiProperty({ example: '10', description: 'District ID' })
    @IsString()
    @IsNotEmpty()
    districtId: string;

    @ApiProperty({ example: '50', description: 'Ward ID' })
    @IsString()
    @IsNotEmpty()
    wardId: string;

    @ApiProperty({
        example: '123 Đường Nguyễn Huệ',
        description: 'Street address',
    })
    @IsString()
    @IsNotEmpty()
    @MaxLength(300)
    streetAddress: string;
}
