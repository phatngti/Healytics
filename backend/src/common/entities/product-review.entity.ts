import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { Product } from './product.entity';

@Entity('product_reviews')
export class ProductReview {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'product_id', type: 'uuid' })
  productId: string;

  @Column({ name: 'reviewer_name', length: 100 })
  reviewerName: string;

  @Column({ name: 'avatar_url', type: 'text', nullable: true })
  avatarUrl: string | null;

  @Column({ type: 'int' })
  rating: number;

  @Column({ length: 20, default: 'Completed' })
  status: string;

  @Column({ type: 'timestamptz' })
  date: Date;

  @Column({ type: 'text' })
  text: string;

  @Column({ name: 'image_urls', type: 'jsonb', default: '[]' })
  imageUrls: string[];

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;

  // Relations
  @ManyToOne(() => Product, (product) => product.reviews, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'product_id' })
  product: Product;
}
