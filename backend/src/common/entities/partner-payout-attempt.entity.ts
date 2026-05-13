import {
  Column,
  CreateDateColumn,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { PartnerPayout } from './partner-payout.entity';

@Entity('partner_payout_attempts')
@Index('IDX_PPA_PAYOUT_ATTEMPT', ['payoutId', 'attemptNumber'], {
  unique: true,
})
export class PartnerPayoutAttempt {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'payout_id', type: 'uuid' })
  payoutId: string;

  @Index()
  @Column({ name: 'partner_id', type: 'uuid' })
  partnerId: string;

  @Column({ name: 'attempt_number', type: 'integer' })
  attemptNumber: number;

  @Column({ name: 'attempted_at', type: 'timestamptz' })
  attemptedAt: Date;

  @Column({ name: 'status', type: 'varchar', length: 30 })
  status: string;

  @Column({ name: 'failure_reason', type: 'text', nullable: true })
  failureReason: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @ManyToOne(() => PartnerPayout, (payout) => payout.attempts, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'payout_id' })
  payout: PartnerPayout;
}
