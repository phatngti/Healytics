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
import { Account } from './account.entity';
import { UserPaymentMethod } from './user-payment-method.entity';
import { PaymentMethod } from '@/payment-gateway/enums/payment-method.enum';

@Entity('user_payment_customers')
@Index(
  'UQ_USER_PAYMENT_CUSTOMERS_USER_PROVIDER_ACTIVE',
  ['userId', 'provider'],
  {
    unique: true,
    where: 'deleted_at IS NULL',
  },
)
@Index('UQ_USER_PAYMENT_CUSTOMERS_GATEWAY_CUSTOMER', ['gatewayCustomerId'], {
  unique: true,
})
export class UserPaymentCustomer {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'user_id', type: 'uuid' })
  userId: string;

  @Column({
    name: 'provider',
    type: 'varchar',
    length: 30,
    default: PaymentMethod.STRIPE,
  })
  provider: PaymentMethod;

  @Column({ name: 'gateway_customer_id', type: 'varchar', length: 100 })
  gatewayCustomerId: string;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;

  @ManyToOne(() => Account, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: Account;

  @OneToMany(() => UserPaymentMethod, (method) => method.customer)
  paymentMethods: UserPaymentMethod[];
}
