import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty } from 'class-validator';

export class GetUploadUrlRequestDto {
    @ApiProperty({
        description: 'Name of the file to upload',
        example: 'business-license.pdf',
    })
    @IsString()
    @IsNotEmpty()
    fileName: string;

    @ApiProperty({
        description: 'MIME type of the file',
        example: 'application/pdf',
    })
    @IsString()
    @IsNotEmpty()
    contentType: string;
}
