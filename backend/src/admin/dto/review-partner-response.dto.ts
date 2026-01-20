import { ApiProperty } from '@nestjs/swagger';

export class ReviewPartnerResponseDto {
    @ApiProperty({ example: 'Review submitted successfully', description: 'Success message' })
    message: string;
}
