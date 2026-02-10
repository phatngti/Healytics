import { Entity, Column, OneToOne, JoinColumn, PrimaryColumn } from 'typeorm';
import { Employee } from './employee.entity';

@Entity('doctor_profiles')
export class DoctorProfile {
  @PrimaryColumn({ name: 'employee_id', type: 'uuid' })
  employeeId: string;

  @Column({ length: 100, nullable: true })
  title: string;

  @Column({ name: 'medical_license', length: 50, unique: true })
  medicalLicense: string;

  @Column({ name: 'experience_years', type: 'int', default: 0 })
  experienceYears: number;

  @Column({
    name: 'consultation_fee',
    type: 'decimal',
    precision: 15,
    scale: 2,
    default: 0,
  })
  consultationFee: number;

  @Column({ type: 'jsonb', nullable: true })
  specializations: string[];

  @Column({ type: 'jsonb', nullable: true })
  education: any[];

  @Column({ type: 'jsonb', nullable: true })
  certifications: any[];

  @OneToOne(() => Employee, (employee) => employee.doctorProfile, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'employee_id' })
  employee: Employee;
}
