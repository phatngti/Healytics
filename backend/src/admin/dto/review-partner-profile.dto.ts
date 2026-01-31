import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsOptional, IsString, IsArray, ValidateNested, IsUUID, IsNotEmpty, IsBoolean } from 'class-validator';
import { Type } from 'class-transformer';

export enum ReviewDecision {
    APPROVED = 'APPROVED',
    CHANGES_REQUIRED = 'CHANGES_REQUIRED',
    REJECTED = 'REJECTED',
}



export class ReviewItemDto {
    @ApiProperty({ description: 'Key of the field or document being reviewed' })
    @IsString()
    fieldKey: string;

    @ApiProperty({ description: 'UUID of the document (if type is DOCUMENT)', required: false })
    @IsOptional()
    @IsUUID()
    documentKey?: string;

    @ApiProperty({ description: 'Mark the item as valid or invalid', example: true })
    @IsBoolean()
    isVerified: boolean;

    @ApiProperty({ description: 'Reason for rejection or feedback', required: false })
    @IsOptional()
    @IsString()
    feedback?: string;
}

export class ReviewPartnerProfileDto {
    @ApiProperty({ enum: ReviewDecision, description: 'Overall decision on the partner profile' })
    @IsEnum(ReviewDecision)
    decision: ReviewDecision;

    @ApiProperty({ description: 'General comment for the review', required: false })
    @IsOptional()
    @IsString()
    generalComment?: string;

    @ApiProperty({
        description: 'List of specific items (fields or documents) with their validation status',
        type: [ReviewItemDto],
        required: false
    })
    @IsOptional()
    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => ReviewItemDto)
    items?: ReviewItemDto[];
}
