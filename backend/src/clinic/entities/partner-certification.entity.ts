import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Partner } from '@/common/entities/partner.entity';

@Entity('partner_certifications')
export class PartnerCertification {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'partner_id', type: 'uuid' })
  partnerId: string;

  @Column({ length: 200 })
  title: string;

  @Column({ type: 'varchar', length: 200, nullable: true })
  subtitle: string | null;

  @Column({
    name: 'icon_name',
    length: 50,
    default: 'workspace_premium',
  })
  iconName: string;

  @Column({ name: 'sort_order', type: 'int', default: 0 })
  sortOrder: number;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @ManyToOne(() => Partner, (partner) => partner.certifications, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'partner_id' })
  partner: Partner;
}
