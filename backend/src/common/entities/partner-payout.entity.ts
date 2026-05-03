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
import { Partner } from './partner.entity';
import { PartnerPayoutStatus } from '@/partner-finance/enums/partner-payout-status.enum';

/**
 * Payout batch record for a partner.
 *
 * Groups settled transactions into a disbursement and tracks
 * the payout lifecycle from scheduling through completion.
 */
@Entity('partner_payouts')
@Index('IDX_PP_PARTNER_SCHEDULED', ['partnerId', 'scheduledDate'])
export class PartnerPayout {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'partner_id', type: 'uuid' })
  partnerId: string;

  @Column({ name: 'period_start', type: 'timestamptz' })
  periodStart: Date;

  @Column({ name: 'period_end', type: 'timestamptz' })
  periodEnd: Date;

  @Column({
    name: 'included_volume',
    type: 'decimal',
    precision: 15,
    scale: 2,
    default: 0,
  })
  includedVolume: number;

  @Column({
    name: 'fees_adjustments',
    type: 'decimal',
    precision: 15,
    scale: 2,
    default: 0,
  })
  feesAdjustments: number;

  @Column({
    name: 'net_payout',
    type: 'decimal',
    precision: 15,
    scale: 2,
    default: 0,
  })
  netPayout: number;

  @Column({ name: 'scheduled_date', type: 'timestamptz' })
  scheduledDate: Date;

  @Column({ name: 'method_label', type: 'varchar', length: 100 })
  methodLabel: string;

  @Column({ name: 'status', type: 'varchar', length: 30 })
  status: PartnerPayoutStatus;

  @Column({ name: 'currency', type: 'varchar', length: 10, default: 'VND' })
  currency: string;

  @Column({ name: 'provider_payout_id', type: 'varchar', length: 100, nullable: true })
  providerPayoutId: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;

  // ── Relations ────────────────────────────────────────────────

  @ManyToOne(() => Partner, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'partner_id' })
  partner: Partner;
}
