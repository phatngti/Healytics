import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsString, IsOptional } from 'class-validator';
import { DocumentStatus } from '@/partners/enum/document-status.enum';

export class ReviewDocumentDto {
    @ApiProperty({
        enum: DocumentStatus,
        example: DocumentStatus.APPROVED,
        description: 'Review decision',
    })
    @IsEnum(DocumentStatus)
    status: DocumentStatus;

    @ApiProperty({
        example: 'Ảnh bị mờ, vui lòng chụp lại rõ hơn',
        description: 'Feedback for partner (required when rejecting)',
        required: false,
    })
    @IsString()
    @IsOptional()
    adminFeedback?: string;

    @ApiProperty({
        example: 'Verified license number matches database',
        description: 'Internal admin notes',
        required: false,
    })
    @IsString()
    @IsOptional()
    verificationNotes?: string;
}
