import { ApiProperty } from '@nestjs/swagger';

export class UploadUrlResponseDto {
    @ApiProperty({
        description: 'Presigned URL for uploading the file directly to R2/S3',
        example: 'https://r2.example.com/presigned-url...',
    })
    uploadUrl: string;

    @ApiProperty({
        description: 'Document key to reference this file after upload',
        example: 'documents/abc-123/1234567890-business-license.pdf',
    })
    documentKey: string;
}
