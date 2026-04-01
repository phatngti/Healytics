import { Test, TestingModule } from '@nestjs/testing';
import { S3Controller } from './s3.controller';
import { S3Service } from './s3.service';
import { PresignRequestDto } from './dto';
import { MockType } from '../../test/mocks/mock-types';

describe('S3Controller', () => {
  let controller: S3Controller;
  let s3Service: MockType<S3Service>;

  beforeEach(async () => {
    // Arrange - Create typed mock for S3Service
    const mockS3Service: MockType<S3Service> = {
      getPresignedUploadUrl: jest.fn(),
      getFileUrl: jest.fn(),
      deleteFile: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [S3Controller],
      providers: [
        {
          provide: S3Service,
          useValue: mockS3Service,
        },
      ],
    }).compile();

    controller = module.get<S3Controller>(S3Controller);
    s3Service = module.get(S3Service);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('preSign', () => {
    it('should return presigned upload URL and key', async () => {
      // Arrange
      const dto: PresignRequestDto = {
        fileName: 'test-image.png',
        contentType: 'image/png',
      };
      const expectedResult = {
        uploadUrl: 'https://presigned-url.example.com',
        key: 'uploads/test-image.png',
      };
      s3Service.getPresignedUploadUrl!.mockResolvedValue(expectedResult);

      // Act
      const result = await controller.preSign(dto);

      // Assert
      expect(result).toEqual(expectedResult);
      expect(s3Service.getPresignedUploadUrl).toHaveBeenCalledWith(
        dto.fileName,
        dto.contentType,
      );
    });
  });

  describe('getFileUrl', () => {
    it('should return file URL object', async () => {
      // Arrange
      const key = 'uploads/test-image.png';
      const fileUrl = 'https://public.example.com/uploads/test-image.png';
      s3Service.getFileUrl!.mockResolvedValue(fileUrl);

      // Act
      const result = await controller.getFileUrl(key);

      // Assert
      expect(result).toEqual({ url: fileUrl });
      expect(s3Service.getFileUrl).toHaveBeenCalledWith(key);
    });
  });

  describe('deleteFile', () => {
    it('should delete file and return success message', async () => {
      // Arrange
      const key = 'uploads/test-image.png';
      s3Service.deleteFile!.mockResolvedValue(undefined);

      // Act
      const result = await controller.deleteFile(key);

      // Assert
      expect(result).toEqual({ message: 'File deleted successfully' });
      expect(s3Service.deleteFile).toHaveBeenCalledWith(key);
    });
  });
});
