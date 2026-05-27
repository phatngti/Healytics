import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
  CreateDateColumn,
  Unique,
} from 'typeorm';
import { Partner } from './partner.entity';

/**
 * Catalog of skills available for employees.
 *
 * Each skill belongs to a specific partner and has a type
 * (MASSAGE, SPA, DOCTOR, etc.). Default skills are seeded
 * and shared; partner-created skills are scoped.
 */
@Entity('skill_catalog')
@Unique('UQ_SKILL_CATALOG_PARTNER_SLUG_TYPE', ['partnerId', 'slug', 'type'])
export class SkillCatalog {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'partner_id', type: 'uuid' })
  partnerId: string;

  @Column({ length: 100 })
  slug: string;

  @Column({ length: 200 })
  label: string;

  @Column({ length: 50 })
  type: string;

  @Column({ name: 'is_default', default: false })
  isDefault: boolean;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @ManyToOne(() => Partner, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'partner_id' })
  partner: Partner;
}
