import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  ManyToOne,
  OneToMany,
  JoinColumn,
  Index,
} from 'typeorm';
import { Account } from '@/account/entities/account.entity';
import { ProductTag } from './product-tag.entity';

/**
 * Service Tag entity for categorizing products/services.
 * Each tag belongs to a partner (user) and can be attached to multiple products.
 */
@Entity('service_tags')
@Index(['userId', 'isActive'])
export class ServiceTag {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'user_id', type: 'uuid' })
  userId: string;

  @Column({ length: 100 })
  name: string;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Column({ name: 'color_value', type: 'int', default: 0xFF6366F1 })
  colorValue: number;

  @Column({ type: 'int', default: 0 })
  usage: number;

  @Column({ name: 'is_active', default: true })
  isActive: boolean;

  @Column({ name: 'sort_order', type: 'int', default: 0 })
  sortOrder: number;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;

  // Relations
  @ManyToOne(() => Account, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: Account;

  @OneToMany(() => ProductTag, (pt) => pt.tag)
  productTags: ProductTag[];
}
