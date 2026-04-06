import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { Product } from '@/common/entities/product.entity';
import { Category } from '@/common/entities/category.entity';

@Entity('coupons')
@Index('UQ_COUPONS_CODE', ['code'], { unique: true })
export class Coupon {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'code', type: 'varchar', length: 50 })
  code: string;

  @Column({ name: 'discount_percent', type: 'int' })
  discountPercent: number;

  @Column({ name: 'max_discount_amount', type: 'int', nullable: true })
  maxDiscountAmount: number | null;

  @Column({ name: 'usage_limit', type: 'int', nullable: true })
  usageLimit: number | null;

  @Column({ name: 'used_count', type: 'int', default: 0 })
  usedCount: number;

  @Column({ name: 'is_active', type: 'boolean', default: true })
  isActive: boolean;

  @Column({ name: 'expires_at', type: 'timestamptz', nullable: true })
  expiresAt: Date | null;

  @Column({ name: 'service_id', type: 'uuid', nullable: true })
  serviceId: string | null;

  @Column({ name: 'category_id', type: 'uuid', nullable: true })
  categoryId: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @ManyToOne(() => Product, { onDelete: 'SET NULL' })
  @JoinColumn({ name: 'service_id' })
  service: Product | null;

  @ManyToOne(() => Category, { onDelete: 'SET NULL' })
  @JoinColumn({ name: 'category_id' })
  category: Category | null;
}
