import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { MediaType } from '@/health-service/enums/media-type.enum';
import { Product } from './product.entity';

@Entity('product_media')
export class ProductMedia {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'product_id', type: 'uuid' })
  productId: string;

  @Column({ length: 500 })
  url: string;

  @Column({
    name: 'media_type',
    type: 'varchar',
    length: 20,
    default: MediaType.IMAGE,
  })
  mediaType: MediaType;

  @Column({ name: 'is_thumbnail', default: false })
  isThumbnail: boolean;

  @Column({ name: 'sort_order', default: 0 })
  sortOrder: number;

  // Relations
  @ManyToOne(() => Product, (product) => product.media, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'product_id' })
  product: Product;
}
