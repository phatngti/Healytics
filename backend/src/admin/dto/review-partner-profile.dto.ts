import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsOptional, IsString, IsArray, ValidateNested, IsUUID, IsNotEmpty, IsBoolean } from 'class-validator';
import { Type } from 'class-transformer';

export enum ReviewDecision {
    APPROVED = 'APPROVED',
    REJECTED = 'REJECTED',
}

export enum ReviewItemType {
    DOCUMENT = 'DOCUMENT',
    FIELD = 'FIELD',
}

export class ReviewItemDto {
    @ApiProperty({ enum: ReviewItemType, description: 'Type of item being reviewed' })
    @IsEnum(ReviewItemType)
    @IsNotEmpty()
    type: ReviewItemType;

    @ApiProperty({ description: 'UUID of the document (if type is DOCUMENT)', required: false })
    @IsOptional()
    @IsUUID()
    documentId?: string;

    @ApiProperty({ description: 'Name of the field (if type is FIELD)', required: false })
    @IsOptional()
    @IsString()
    fieldName?: string;

    @ApiProperty({ description: 'Mark the item as valid or invalid', example: true })
    @IsBoolean()
    isValid: boolean;

    @ApiProperty({ description: 'Reason for rejection or feedback', required: false })
    @IsOptional()
    @IsString()
    reason?: string;
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
