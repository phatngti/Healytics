import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class DashboardReviewDto {
  @ApiProperty({ example: 'Nguyễn Văn Hùng' })
  @Expose()
  reviewerName: string;

  @ApiPropertyOptional({ example: 'https://example.com/avatar.jpg' })
  @Expose()
  avatarUrl?: string;

  @ApiProperty({ example: 5 })
  @Expose()
  rating: number;

  @ApiProperty({ example: 'published', enum: ['published', 'hidden'] })
  @Expose()
  status: string;

  @ApiProperty({ example: '2026-04-09T12:00:00.000Z' })
  @Expose()
  date: string;

  @ApiProperty({ example: 'Dịch vụ tuyệt vời! Nhân viên rất chuyên nghiệp.' })
  @Expose()
  text: string;

  @ApiProperty({ type: [String], example: [] })
  @Expose()
  imageUrls: string[];
}
