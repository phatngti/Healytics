import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  OneToOne,
  Index,
} from 'typeorm';
import { Role } from '@/account/enum/role.enum';
import { UserProfile } from './user-profile.entity';
import { Partner } from '@/partners/entities/partner.entity';

@Entity('account')
export class Account {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ unique: true })
  email: string;

  @Column({ name: 'password_hash', nullable: true })
  passwordHash?: string;

  @Column({ name: 'refresh_token_hash', type: 'text', nullable: true, select: false })
  refreshTokenHash: string | null;

  @Column({ type: 'enum', enum: Role, default: Role.USER })
  role: Role;

  @OneToOne(() => UserProfile, (p) => p.account, {
    cascade: true,
    nullable: true,
    eager: true,
  })
  userProfile?: UserProfile;

  @OneToOne(() => Partner, (partner) => partner.account)
  partner?: Partner;

  // Store arbitrary user preferences directly on the account as JSONB
  @Column({ type: 'jsonb', nullable: true })
  survey?: Record<string, any> | null;

  @Column({ name: 'is_active', default: true })
  isActive: boolean;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;
}
