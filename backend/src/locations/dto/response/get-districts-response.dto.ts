import { ApiProperty } from '@nestjs/swagger';
import { LocationDto } from './get-provinces-response.dto';

export class GetDistrictsResponseDto {
    @ApiProperty({ type: [LocationDto] })
    data: LocationDto[];

    @ApiProperty({ example: 12 })
    total: number;
}
