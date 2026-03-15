import {
  Post,
  Get,
  Param,
  Delete,
  Body,
} from '@nestjs/common';
import {
  ApiOperation,
  ApiParam,
  ApiCreatedResponse,
  ApiOkResponse,
} from '@nestjs/swagger';
import { PublicApi } from '@/common/decorators/api/public-api.decorator';
import { S3Service } from './s3.service';
import {
  PresignRequestDto,
  PresignResponseDto,
  FileUrlResponseDto,
  DeleteFileResponseDto,
} from './dto';
import { Throttle } from '@nestjs/throttler';

/**
 * Public controller for S3-compatible storage operations.
 * Handles file uploads, downloads, and deletions via presigned URLs.
 * Route prefix: /v1/s3
 */
@PublicApi('s3')
export class S3Controller {
  constructor(private readonly s3Service: S3Service) {}

  /**
   * Generates a presigned URL for uploading a file.
   */
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @Post('presign')
  @ApiOperation({ summary: 'Get presigned upload URL' })
  @ApiCreatedResponse({
    description: 'The presigned URL has been successfully created.',
    type: PresignResponseDto,
  })
  async preSign(@Body() dto: PresignRequestDto): Promise<PresignResponseDto> {
    return this.s3Service.getPresignedUploadUrl(dto.fileName, dto.contentType);
  }

  /**
   * Gets the public or signed URL for a file.
   */
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @Get(':key')
  @ApiOperation({ summary: 'Get file URL' })
  @ApiParam({ name: 'key', type: 'string', description: 'File key' })
  @ApiOkResponse({
    description: 'Return the file URL.',
    type: FileUrlResponseDto,
  })
  async getFileUrl(@Param('key') key: string): Promise<FileUrlResponseDto> {
    const url = await this.s3Service.getFileUrl(key);
    return { url };
  }

  /**
   * Deletes a file from the bucket.
   */
  @Delete(':key')
  @ApiOperation({ summary: 'Delete file' })
  @ApiParam({ name: 'key', type: 'string', description: 'File key' })
  @ApiOkResponse({
    description: 'The file has been successfully deleted.',
    type: DeleteFileResponseDto,
  })
  async deleteFile(@Param('key') key: string): Promise<DeleteFileResponseDto> {
    await this.s3Service.deleteFile(key);
    return { message: 'File deleted successfully' };
  }
}
