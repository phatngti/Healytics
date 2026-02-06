import { ApiProperty } from '@nestjs/swagger';

export class BusinessServiceDto {
    @ApiProperty({
        example: 'SPA',
        description: 'Business type enum value'
    })
    value: string;

    @ApiProperty({
        example: 'Spa & Làm đẹp',
        description: 'Vietnamese label for display'
    })
    label: string;

    @ApiProperty({
        example: 'Spa and beauty services',
        description: 'English description',
        required: false
    })
    description?: string;
}

export class BusinessServicesResponseDto {
    @ApiProperty({
        type: [BusinessServiceDto],
        description: 'List of all available business types'
    })
    data: BusinessServiceDto[];
}
