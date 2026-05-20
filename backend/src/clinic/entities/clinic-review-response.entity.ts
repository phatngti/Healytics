import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToOne,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
import { Partner } from '@/common/entities/partner.entity';

@Entity('clinic_review_responses')
export class ClinicReviewResponse {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'review_id', type: 'uuid', unique: true })
  reviewId: string;

  @Column({ name: 'partner_id', type: 'uuid' })
  partnerId: string;

  @Column({ name: 'response_text', type: 'text' })
  responseText: string;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @OneToOne(() => TreatmentReview, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'review_id' })
  review: TreatmentReview;

  @ManyToOne(() => Partner, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'partner_id' })
  partner: Partner;
}
