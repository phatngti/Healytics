import { ApiProperty } from '@nestjs/swagger';

export class LocationDto {
    @ApiProperty({ example: 'uuid-string' })
    id: string;

    @ApiProperty({ example: '01' })
    code: string;

    @ApiProperty({ example: 'Hà Nội' })
    name: string;

    @ApiProperty({ example: 'Ha Noi', required: false })
    nameEn?: string;

    @ApiProperty({ example: 'Thành phố Hà Nội' })
    fullName: string;

    @ApiProperty({ example: 'Hanoi City', required: false })
    fullNameEn?: string;

    @ApiProperty({ example: 'PROVINCE' })
    level: string;
}

export class GetProvincesResponseDto {
    @ApiProperty({ type: [LocationDto] })
    data: LocationDto[];

    @ApiProperty({ example: 63 })
    total: number;
}
