// address.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, OneToOne } from 'typeorm';
import { UserProfile } from './user-profile.entity';

@Entity()
export class Address {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  street: string;

  @Column()
  ward: string;

  @Column()
  district: string;

  @Column()
  cityOrProvince: string;

  // Link back to UserProfile
  @OneToOne(() => UserProfile, (profile) => profile.address)
  userProfile: UserProfile;
}
