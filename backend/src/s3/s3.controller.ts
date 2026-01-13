import {
  Controller,
  Post,
  Get,
  Param,
  Delete,
  Body,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBody,
  ApiParam,
  ApiResponse,
} from '@nestjs/swagger';

import { S3Service, PresignedUploadResult } from './s3.service';

@ApiTags('S3')
@Controller('s3')
export class S3Controller {
  constructor(private readonly s3Service: S3Service) {}

  @Post('presign')
  @ApiOperation({ summary: 'Get presigned upload url' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        fileName: { type: 'string', example: 'example.png' },
        contentType: { type: 'string', example: 'image/png' },
      },
      required: ['fileName', 'contentType'],
    },
  })
  @ApiResponse({
    status: 201,
    description: 'The presigned url has been successfully created.',
    schema: {
      type: 'object',
      properties: {
        uploadUrl: { type: 'string' },
        key: { type: 'string' },
      },
    },
  })
  async preSign(
    @Body('fileName') fileName: string,
    @Body('contentType') contentType: string,
  ): Promise<PresignedUploadResult> {
    return this.s3Service.getPresignedUploadUrl(fileName, contentType);
  }

  @Get(':key')
  @ApiOperation({ summary: 'Get file url' })
  @ApiParam({ name: 'key', type: 'string', description: 'File key' })
  @ApiResponse({
    status: 200,
    description: 'Return the file url.',
    schema: {
      type: 'object',
      properties: {
        url: { type: 'string' },
      },
    },
  })
  async getFileUrl(@Param('key') key: string) {
    const url = await this.s3Service.getFileUrl(key);
    return { url };
  }

  @Delete(':key')
  @ApiOperation({ summary: 'Delete file' })
  @ApiParam({ name: 'key', type: 'string', description: 'File key' })
  @ApiResponse({
    status: 200,
    description: 'The file has been successfully deleted.',
    schema: {
      type: 'object',
      properties: {
        message: { type: 'string', example: 'File deleted successfully' },
      },
    },
  })
  async deleteFile(@Param('key') key: string) {
    await this.s3Service.deleteFile(key);
    return { message: 'File deleted successfully' };
  }
}
