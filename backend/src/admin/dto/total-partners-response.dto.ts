import { ApiProperty } from '@nestjs/swagger';

export class TotalPartnersResponseDto {
    @ApiProperty({ example: 150, description: 'Total number of partners' })
    total: number;
}
