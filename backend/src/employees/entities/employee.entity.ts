import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToOne,
  Index,
} from 'typeorm';
import { EmployeeRole } from '@/employees/enum/employee-role.enum';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { Gender } from '@/employees/enum/gender.enum';
import { DoctorProfile } from './doctor-profile.entity';
import { TherapistProfile } from './therapist-profile.entity';

@Entity('employees')
export class Employee {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'auth_id', nullable: true, unique: true, length: 255 })
  authId: string;

  @Index()
  @Column({ name: 'employee_code', unique: true, length: 50 })
  employeeCode: string;

  @Column({ name: 'full_name', length: 100 })
  fullName: string;

  @Column({ name: 'display_name', length: 50, nullable: true })
  displayName: string;

  @Index()
  @Column({ unique: true, length: 100 })
  email: string;

  @Index()
  @Column({ length: 20, nullable: true })
  phone: string;

  @Column({ name: 'avatar_url', type: 'text', nullable: true })
  avatarUrl: string;

  @Column({ type: 'date', nullable: true })
  dob: Date;

  @Column({ type: 'enum', enum: Gender, nullable: true })
  gender: Gender;

  @Column({ type: 'enum', enum: EmployeeRole })
  role: EmployeeRole;

  @Column({
    type: 'enum',
    enum: EmployeeStatus,
    default: EmployeeStatus.ACTIVE,
  })
  status: EmployeeStatus;

  @Column({ type: 'decimal', precision: 3, scale: 2, default: 0 })
  rating: number;

  @Column({ name: 'review_count', type: 'int', default: 0 })
  reviewCount: number;

  @Column({ name: 'branch_id', type: 'uuid', nullable: true })
  branchId: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @OneToOne(() => DoctorProfile, (profile) => profile.employee, {
    cascade: true,
    eager: false,
  })
  doctorProfile: DoctorProfile;

  @OneToOne(() => TherapistProfile, (profile) => profile.employee, {
    cascade: true,
    eager: false,
  })
  therapistProfile: TherapistProfile;
}
