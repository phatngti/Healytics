import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    CreateDateColumn,
    UpdateDateColumn,
    DeleteDateColumn,
    OneToOne,
    JoinColumn,
} from 'typeorm';
import { Partner } from './partner.entity';
import { IdType } from '../enum/id-type.enum';

@Entity('legal_representative')
export class LegalRepresentative {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ name: 'full_name', length: 150 })
    fullName: string;

    @Column({ length: 100 })
    position: string;

    @Column({
        name: 'id_type',
        type: 'enum',
        enum: IdType,
    })
    idType: IdType;

    @Column({ name: 'id_number', length: 20 })
    idNumber: string;

    @Column({ name: 'id_issue_date', type: 'date' })
    idIssueDate: Date;

    @Column({ name: 'id_front_img_url', type: 'text' })
    idFrontImgUrl: string;

    @Column({ name: 'id_back_img_url', type: 'text' })
    idBackImgUrl: string;

    @Column({ name: 'is_authorized_user', default: false })
    isAuthorizedUser: boolean;

    @Column({ name: 'auth_letter_doc_url', type: 'text', nullable: true })
    authLetterDocUrl: string | null;

    // Relationship to Partner
    @Column({ name: 'partner_id' })
    partnerId: string;

    @OneToOne(() => Partner, (entity) => entity.legalRepresentative)
    @JoinColumn({ name: 'partner_id' })
    partner: Partner;

    @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
    createdAt: Date;

    @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
    updatedAt: Date;

    @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
    deletedAt: Date | null;
}
