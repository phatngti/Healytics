import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsBoolean, IsString, IsInt, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class GetPartnersQueryDto {
    @ApiPropertyOptional({
        example: 1,
        description: 'Page number',
        default: 1,
    })
    @IsOptional()
    @Type(() => Number)
    @IsInt()
    @Min(1)
    page?: number = 1;

    @ApiPropertyOptional({
        example: 10,
        description: 'Items per page',
        default: 10,
    })
    @IsOptional()
    @Type(() => Number)
    @IsInt()
    @Min(1)
    limit?: number = 10;

    @ApiPropertyOptional({
        example: true,
        description: 'Filter by verification status',
    })
    @IsOptional()
    @Type(() => Boolean)
    @IsBoolean()
    isVerified?: boolean;

    @ApiPropertyOptional({
        example: 'spa',
        description: 'Search by tax code, brand name, legal name, or email',
    })
    @IsOptional()
    @IsString()
    search?: string;
}
