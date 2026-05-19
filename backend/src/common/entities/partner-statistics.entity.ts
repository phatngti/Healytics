import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  OneToOne,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Partner } from './partner.entity';

@Entity('partner_statistics')
export class PartnerStatistics {
  @PrimaryColumn({ name: 'partner_id', type: 'uuid' })
  partnerId: string;

  @Column({ name: 'completed_bookings_count', type: 'int', default: 0 })
  completedBookingsCount: number;

  @Column({ name: 'review_count', type: 'int', default: 0 })
  reviewCount: number;

  @Column({
    name: 'average_stars',
    type: 'numeric',
    precision: 3,
    scale: 2,
    default: 0,
  })
  averageStars: number;

  @Column({
    name: 'last_calculated_at',
    type: 'timestamptz',
    default: () => 'NOW()',
  })
  lastCalculatedAt: Date;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @OneToOne(() => Partner, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'partner_id' })
  partner: Partner;
}
