import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToOne,
  JoinColumn,
} from 'typeorm';
import { Account } from './account.entity';

@Entity()
export class UserProfile {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ nullable: true })
  firstName?: string;

  @Column({ nullable: true })
  lastName?: string;

  @Column({ nullable: true })
  phone?: string;

  @Column({ nullable: true, type: 'text' })
  bio?: string | null;

  @Column({ nullable: true, type: 'date' })
  dateOfBirth?: Date | null;

  @Column({ default: false })
  profileCompleted: boolean;

  @Column({ default: false })
  isUsed: boolean;

  @OneToOne(() => Account, (account) => account.userProfile, { onDelete: 'CASCADE' })
  @JoinColumn()
  account: Account;

  // Preferences removed — stored directly on Account as a JSONB column

  // @CreateDateColumn()
  // createdAt: Date;

  // @UpdateDateColumn()
  // updatedAt: Date;

  // Derived property
  get name(): string {
    const parts: string[] = [];
    if (this.firstName) parts.push(this.firstName);
    if (this.lastName) parts.push(this.lastName);
    return parts.join(' ').trim();
  }
}
