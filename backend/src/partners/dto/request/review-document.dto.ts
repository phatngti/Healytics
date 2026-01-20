import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsOptional, IsBoolean } from 'class-validator';

export class ReviewDocumentDto {
    @ApiProperty({
        description: 'Set to true if the document is valid, false if invalid',
        example: true
    })
    @IsBoolean()
    isValid: boolean;

    @ApiProperty({
        example: 'Image is too blurry, please re-upload',
        description: 'Feedback for partner (required if isValid is false)',
        required: false,
    })
    @IsString()
    @IsOptional()
    adminFeedback?: string;

    @ApiProperty({
        example: 'Verified against national database',
        description: 'Internal admin notes',
        required: false,
    })
    @IsString()
    @IsOptional()
    verificationNotes?: string;
}
