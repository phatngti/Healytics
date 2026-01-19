import { ApiProperty } from '@nestjs/swagger';
import { LocationDto } from './get-provinces-response.dto';

export class GetWardsResponseDto {
    @ApiProperty({ type: [LocationDto] })
    data: LocationDto[];

    @ApiProperty({ example: 14 })
    total: number;
}
