import { Injectable, Logger } from '@nestjs/common';
import {
  S3Client,
  PutObjectCommand,
  GetObjectCommand,
  DeleteObjectCommand,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';

/** Presigned upload URL response */
export interface PresignedUploadResult {
  uploadUrl: string;
  key: string;
}

/**
 * Service for interacting with S3-compatible storage (Cloudflare R2).
 * Handles file uploads, downloads, and deletions.
 */
@Injectable()
export class S3Service {
  private readonly s3Client: S3Client;
  private readonly bucketName: string;
  private readonly publicUrl?: string;
  private readonly logger = new Logger(S3Service.name);

  constructor() {
    const accountId = process.env.R2_ACCOUNT_ID;
    const accessKeyId = process.env.R2_ACCESS_KEY_ID;
    const secretAccessKey = process.env.R2_SECRET_ACCESS_KEY;
    this.bucketName = process.env.R2_BUCKET_NAME || 'freestore';
    this.publicUrl = process.env.R2_PUBLIC_URL;
    if (!accountId || !accessKeyId || !secretAccessKey) {
      this.logger.warn(
        'R2 credentials not fully configured. S3Service might not work as expected.',
      );
    }
    this.s3Client = new S3Client({
      region: 'auto',
      endpoint: `https://${accountId}.r2.cloudflarestorage.com`,
      credentials: {
        accessKeyId: accessKeyId || '',
        secretAccessKey: secretAccessKey || '',
      },
    });
  }

  /**
   * Generates a presigned URL for uploading a file.
   * @param fileName - The original file name
   * @param contentType - The MIME type of the file
   * @returns The presigned upload URL and generated key
   */
  async getPresignedUploadUrl(
    fileName: string,
    contentType: string,
  ): Promise<PresignedUploadResult> {
    const key = `${Date.now()}-${fileName}`;
    const command = new PutObjectCommand({
      Bucket: this.bucketName,
      Key: key,
      ContentType: contentType,
    });
    const url = await getSignedUrl(this.s3Client, command, { expiresIn: 3600 });
    this.logger.debug(`Generated presigned upload URL for key: ${key}`);
    return { uploadUrl: url, key };
  }

  /**
   * Uploads a file directly to the bucket.
   * @param key - The file key/path in the bucket
   * @param buffer - The file buffer to upload
   * @param contentType - The MIME type of the file
   */
  async uploadFile(
    key: string,
    buffer: Buffer,
    contentType: string,
  ): Promise<void> {
    await this.s3Client.send(
      new PutObjectCommand({
        Bucket: this.bucketName,
        Key: key,
        Body: buffer,
        ContentType: contentType,
      }),
    );
    this.logger.log(`File uploaded: ${key}`);
  }

  /**
   * Gets the public or signed URL for a file.
   * @param key - The file key in the bucket
   * @returns The file URL
   */
  async getFileUrl(key: string): Promise<string> {
    if (this.publicUrl) {
      return `${this.publicUrl}/${key}`;
    }
    const command = new GetObjectCommand({
      Bucket: this.bucketName,
      Key: key,
    });
    return getSignedUrl(this.s3Client, command, { expiresIn: 3600 });
  }

  /**
   * Deletes a file from the bucket.
   * @param key - The file key to delete
   */
  async deleteFile(key: string): Promise<void> {
    await this.s3Client.send(
      new DeleteObjectCommand({
        Bucket: this.bucketName,
        Key: key,
      }),
    );
    this.logger.log(`File deleted: ${key}`);
  }
}
