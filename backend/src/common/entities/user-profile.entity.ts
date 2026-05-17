import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  OneToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { Account } from './account.entity';
import { Address } from './address.entity';

@Entity('user_profile')
export class UserProfile {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'first_name', nullable: true })
  firstName?: string;

  @Column({ name: 'last_name', nullable: true })
  lastName?: string;

  @Column({ nullable: true })
  phone?: string;

  @Column({ nullable: true, type: 'text' })
  bio?: string | null;

  @Column({ name: 'date_of_birth', nullable: true, type: 'date' })
  dateOfBirth?: Date | null;

  @Column({ name: 'avatar_url', type: 'text', nullable: true })
  avatarUrl?: string | null;

  @Column({ name: 'profile_completed', default: false })
  profileCompleted: boolean;

  @Column({ name: 'is_used', default: false })
  isUsed: boolean;

  @Index()
  @Column({ name: 'account_id', type: 'uuid', nullable: true })
  accountId: string | null;

  @Index()
  @Column({ name: 'address_id', type: 'uuid', nullable: true })
  addressId: string | null;

  @OneToOne(() => Account, (account) => account.userProfile, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'account_id' })
  account: Account;

  @OneToOne(() => Address, (address) => address.userProfile, {
    cascade: true,
    eager: true,
    nullable: true,
  })
  @JoinColumn({ name: 'address_id' })
  address?: Address;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;

  // Derived property
  get name(): string {
    const parts: string[] = [];
    if (this.firstName) parts.push(this.firstName);
    if (this.lastName) parts.push(this.lastName);
    return parts.join(' ').trim();
  }
}
