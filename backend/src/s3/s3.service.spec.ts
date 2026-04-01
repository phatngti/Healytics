import { Test, TestingModule } from '@nestjs/testing';
import { S3Service } from './s3.service';

// Mock AWS SDK
jest.mock('@aws-sdk/client-s3', () => ({
  S3Client: jest.fn().mockImplementation(() => ({
    send: jest.fn(),
  })),
  PutObjectCommand: jest.fn(),
  GetObjectCommand: jest.fn(),
  DeleteObjectCommand: jest.fn(),
}));

jest.mock('@aws-sdk/s3-request-presigner', () => ({
  getSignedUrl: jest
    .fn()
    .mockResolvedValue('https://presigned-url.example.com'),
}));

describe('S3Service', () => {
  let service: S3Service;

  beforeEach(async () => {
    // Set environment variables for testing
    process.env.R2_ACCOUNT_ID = 'test-account-id';
    process.env.R2_ACCESS_KEY_ID = 'test-access-key';
    process.env.R2_SECRET_ACCESS_KEY = 'test-secret-key';
    process.env.R2_BUCKET_NAME = 'test-bucket';

    const module: TestingModule = await Test.createTestingModule({
      providers: [S3Service],
    }).compile();

    service = module.get<S3Service>(S3Service);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getPresignedUploadUrl', () => {
    it('should return presigned URL and key', async () => {
      // Act
      const result = await service.getPresignedUploadUrl(
        'test.jpg',
        'image/jpeg',
      );

      // Assert
      expect(result).toHaveProperty('uploadUrl');
      expect(result).toHaveProperty('key');
      expect(result.key).toContain('test.jpg');
    });
  });

  describe('getFileUrl', () => {
    it('should return public URL when publicUrl is set', async () => {
      // Arrange
      process.env.R2_PUBLIC_URL = 'https://public.example.com';
      const serviceWithPublicUrl = new S3Service();

      // Act
      const result = await serviceWithPublicUrl.getFileUrl('test-key');

      // Assert
      expect(result).toBe('https://public.example.com/test-key');
    });

    it('should return signed URL when no publicUrl is set', async () => {
      // Arrange
      delete process.env.R2_PUBLIC_URL;
      const serviceWithoutPublicUrl = new S3Service();

      // Act
      const result = await serviceWithoutPublicUrl.getFileUrl('test-key');

      // Assert
      expect(result).toBe('https://presigned-url.example.com');
    });
  });

  describe('deleteFile', () => {
    it('should call S3 client to delete file', async () => {
      // Act & Assert - should not throw
      await expect(service.deleteFile('test-key')).resolves.not.toThrow();
    });
  });
});
