import {
  Entity,
  PrimaryColumn,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { Product } from './product.entity';
import { ServiceTag } from './service-tag.entity';

/**
 * Junction table entity for many-to-many relationship between products and service tags.
 */
@Entity('product_tags')
export class ProductTag {
  @PrimaryColumn({ name: 'product_id', type: 'uuid' })
  @Index()
  productId: string;

  @PrimaryColumn({ name: 'tag_id', type: 'uuid' })
  @Index()
  tagId: string;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  // Relations
  @ManyToOne(() => Product, (product) => product.productTags, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'product_id' })
  product: Product;

  @ManyToOne(() => ServiceTag, (tag) => tag.productTags, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'tag_id' })
  tag: ServiceTag;
}
