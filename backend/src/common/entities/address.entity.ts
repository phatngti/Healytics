import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  OneToOne,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { UserProfile } from './user-profile.entity';
import { Location } from './location.entity';

@Entity('address')
export class Address {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  street: string;

  @Column()
  ward: string;

  @Column()
  district: string;

  @Column({ name: 'city_or_province' })
  cityOrProvince: string;

  @Index()
  @Column({ name: 'province_id', type: 'uuid', nullable: true })
  provinceId: string | null;

  @ManyToOne(() => Location, { onDelete: 'SET NULL', nullable: true })
  @JoinColumn({ name: 'province_id' })
  province: Location | null;

  @Index()
  @Column({ name: 'district_id', type: 'uuid', nullable: true })
  districtId: string | null;

  @ManyToOne(() => Location, { onDelete: 'SET NULL', nullable: true })
  @JoinColumn({ name: 'district_id' })
  districtLocation: Location | null;

  @Index()
  @Column({ name: 'ward_id', type: 'uuid', nullable: true })
  wardId: string | null;

  @ManyToOne(() => Location, { onDelete: 'SET NULL', nullable: true })
  @JoinColumn({ name: 'ward_id' })
  wardLocation: Location | null;

  @Column({ name: 'coordinates', type: 'text', nullable: true })
  coordinates: string | null;

  @Column({
    name: 'location',
    type: 'geography',
    spatialFeatureType: 'Point',
    srid: 4326,
    nullable: true,
  })
  location: object | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;

  // Link back to UserProfile
  @OneToOne(() => UserProfile, (profile) => profile.address)
  userProfile: UserProfile;

  get latitude(): number | null {
    if (!this.coordinates) return null;
    const lat = parseFloat(this.coordinates.split(',')[0]);
    return Number.isNaN(lat) ? null : lat;
  }

  get longitude(): number | null {
    if (!this.coordinates) return null;
    const lng = parseFloat(this.coordinates.split(',')[1]);
    return Number.isNaN(lng) ? null : lng;
  }
}
