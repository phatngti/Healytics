import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { Account } from './account.entity';
import { UserPaymentCustomer } from './user-payment-customer.entity';
import { PaymentMethod } from '@/payment-gateway/enums/payment-method.enum';

@Entity('user_payment_methods')
@Index('UQ_USER_PAYMENT_METHODS_GATEWAY_METHOD', ['gatewayPaymentMethodId'], {
  unique: true,
})
@Index('IDX_USER_PAYMENT_METHODS_USER', ['userId'])
@Index('IDX_USER_PAYMENT_METHODS_CUSTOMER', ['customerId'])
@Index('UQ_USER_PAYMENT_METHODS_ONE_DEFAULT', ['userId', 'provider'], {
  unique: true,
  where: 'is_default = true AND deleted_at IS NULL',
})
export class UserPaymentMethod {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id', type: 'uuid' })
  userId: string;

  @Column({ name: 'customer_id', type: 'uuid' })
  customerId: string;

  @Column({
    name: 'provider',
    type: 'varchar',
    length: 30,
    default: PaymentMethod.STRIPE,
  })
  provider: PaymentMethod;

  @Column({ name: 'gateway_payment_method_id', type: 'varchar', length: 100 })
  gatewayPaymentMethodId: string;

  @Column({ name: 'brand', type: 'varchar', length: 30 })
  brand: string;

  @Column({ name: 'last4', type: 'varchar', length: 4 })
  last4: string;

  @Column({ name: 'exp_month', type: 'int' })
  expMonth: number;

  @Column({ name: 'exp_year', type: 'int' })
  expYear: number;

  @Column({ name: 'funding', type: 'varchar', length: 30, nullable: true })
  funding: string | null;

  @Column({ name: 'country', type: 'varchar', length: 2, nullable: true })
  country: string | null;

  @Column({ name: 'is_default', type: 'boolean', default: false })
  isDefault: boolean;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;

  @ManyToOne(() => Account, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: Account;

  @ManyToOne(() => UserPaymentCustomer, (customer) => customer.paymentMethods, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'customer_id' })
  customer: UserPaymentCustomer;
}
