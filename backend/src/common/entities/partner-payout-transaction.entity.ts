import { Entity, PrimaryGeneratedColumn, Column, Index } from 'typeorm';

/**
 * Join table linking payouts to their included transactions.
 *
 * Enables the "View breakdown" dialog in the partner transaction UI
 * and prevents duplicate ledger inclusion across payouts.
 */
@Entity('partner_payout_transactions')
@Index('IDX_PPT_PAYOUT_TXN', ['payoutId', 'transactionId'], { unique: true })
export class PartnerPayoutTransaction {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'payout_id', type: 'uuid' })
  payoutId: string;

  @Index()
  @Column({ name: 'transaction_id', type: 'uuid' })
  transactionId: string;

  @Index()
  @Column({ name: 'partner_id', type: 'uuid' })
  partnerId: string;
}
