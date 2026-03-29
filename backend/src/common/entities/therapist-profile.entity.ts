import { Entity, Column, OneToOne, JoinColumn, PrimaryColumn } from 'typeorm';
import { Employee } from './employee.entity';
import { TherapistLevel } from '@/employees/enum/therapist-level.enum';
import { StrengthLevel } from '@/employees/enum/strength-level.enum';

@Entity('therapist_profiles')
export class TherapistProfile {
  @PrimaryColumn({ name: 'employee_id', type: 'uuid' })
  employeeId: string;

  @Column({
    type: 'enum',
    enum: TherapistLevel,
    default: TherapistLevel.JUNIOR,
  })
  level: TherapistLevel;

  @Column({ length: 50, nullable: true })
  type: string;

  @Column({
    name: 'strength_level',
    type: 'enum',
    enum: StrengthLevel,
    nullable: true,
  })
  strengthLevel: StrengthLevel;

  @Column({
    name: 'commission_rate',
    type: 'decimal',
    precision: 5,
    scale: 2,
    default: 0,
  })
  commissionRate: number;

  @Column({ name: 'health_check_date', type: 'date', nullable: true })
  healthCheckDate: Date;

  @Column({ type: 'jsonb', nullable: true })
  skills: string[];

  @Column({ name: 'device_proficiency', type: 'jsonb', nullable: true })
  deviceProficiency: string[];

  @OneToOne(() => Employee, (employee) => employee.therapistProfile, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'employee_id' })
  employee: Employee;
}
