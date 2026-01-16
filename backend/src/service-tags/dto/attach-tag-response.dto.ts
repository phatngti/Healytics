import { Expose } from 'class-transformer';
import { ApiProperty } from '@nestjs/swagger';

/**
 * Response DTO for attaching a tag to a product.
 */
export class AttachTagResponseDto {
  @Expose()
  @ApiProperty({
    description: 'Service tag ID',
    example: 'uuid-tag-id',
  })
  tagId: string;

  @Expose()
  @ApiProperty({
    description: 'Product ID',
    example: 'uuid-product-id',
  })
  productId: string;

  @Expose()
  @ApiProperty({
    description: 'Creation timestamp of the relationship',
  })
  createdAt: Date;
}
