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
import { Employee } from '@/common/entities/employee.entity';
import { CartItemStatus } from '@/cart/enums/cart-item-status.enum';

@Entity('cart_items')
@Index('IDX_CART_ITEMS_USER_ID', ['userId'])
@Index(
  'UQ_CART_ITEMS_USER_SERVICE_EMPLOYEE_SLOT',
  ['userId', 'serviceId', 'employeeId', 'timeSlot'],
  { unique: true },
)
export class CartItem {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id', type: 'uuid' })
  userId: string;

  @Column({ name: 'service_id', type: 'uuid' })
  serviceId: string;

  @Column({ name: 'employee_id', type: 'uuid' })
  employeeId: string;

  @Column({ name: 'time_slot', type: 'timestamptz' })
  timeSlot: Date;

  @Column({
    name: 'status',
    type: 'varchar',
    length: 20,
    default: CartItemStatus.ACTIVE,
  })
  status: CartItemStatus;

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

  @ManyToOne(() => Employee, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'employee_id' })
  employee: Employee;
}
