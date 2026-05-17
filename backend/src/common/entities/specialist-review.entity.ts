import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { Account } from './account.entity';
import { Booking } from './booking.entity';
import { Employee } from './employee.entity';

@Index('IDX_SPECIALIST_REVIEWS_SPECIALIST_RATING', [
  'specialistId',
  'rating',
])
@Index('IDX_SPECIALIST_REVIEWS_SPECIALIST_CREATED_AT', [
  'specialistId',
  'createdAt',
])
@Entity('specialist_reviews')
export class SpecialistReview {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'appointment_id', type: 'uuid', unique: true })
  appointmentId: string;

  @Index()
  @Column({ name: 'specialist_id', type: 'uuid' })
  specialistId: string;

  @Index()
  @Column({ name: 'user_id', type: 'uuid' })
  userId: string;

  @Column({ type: 'int' })
  rating: number;

  @Column({ type: 'text', nullable: true })
  comment: string | null;

  @Column({ type: 'jsonb', default: '[]' })
  tags: string[];

  @Column({ name: 'would_recommend', type: 'boolean', default: true })
  wouldRecommend: boolean;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  // ── Relations ────────────────────────────────────────────────

  @ManyToOne(() => Account, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: Account;

  @ManyToOne(() => Booking, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'appointment_id' })
  booking: Booking;

  @ManyToOne(() => Employee, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'specialist_id' })
  specialist: Employee;
}
