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
import { Account } from '@/common/entities/account.entity';
import { Product } from '@/common/entities/product.entity';

@Entity('cart_items')
@Index('IDX_CART_ITEMS_USER_ID', ['userId'])
@Index('UQ_CART_ITEMS_USER_SERVICE', ['userId', 'serviceId'], { unique: true })
export class CartItem {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id', type: 'uuid' })
  userId: string;

  @Column({ name: 'service_id', type: 'uuid' })
  serviceId: string;

  @Column({ name: 'coupon_code', type: 'varchar', length: 50, nullable: true })
  couponCode: string | null;

  @Column({
    name: 'coupon_discount_percent',
    type: 'int',
    nullable: true,
  })
  couponDiscountPercent: number | null;

  @Column({
    name: 'coupon_discount_amount',
    type: 'int',
    nullable: true,
  })
  couponDiscountAmount: number | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @ManyToOne(() => Account, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: Account;

  @ManyToOne(() => Product, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'service_id' })
  service: Product;
}
