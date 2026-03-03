import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Employee } from '@/common/entities/employee.entity';
import { DoctorProfile } from '@/common/entities/doctor-profile.entity';
import { TherapistProfile } from '@/common/entities/therapist-profile.entity';
import { Partner } from '@/common/entities/partner.entity';
import { EmployeeRole } from '@/employees/enum/employee-role.enum';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { Gender } from '@/employees/enum/gender.enum';
import { TherapistLevel } from '@/employees/enum/therapist-level.enum';
import { StrengthLevel } from '@/employees/enum/strength-level.enum';
import { ISeeder } from '../seeder.interface';

const SEED_EMPLOYEES = [
  {
    employeeCode: 'EMP-001',
    fullName: 'Dr. James Anderson',
    displayName: 'Dr. Anderson',
    email: 'doctor.anderson@healytics.vn',
    phone: '0901000001',
    jobTitle: 'General Practitioner',
    role: EmployeeRole.DOCTOR,
    gender: Gender.MALE,
  },
  {
    employeeCode: 'EMP-002',
    fullName: 'Sarah Mitchell',
    displayName: 'Sarah M.',
    email: 'therapist.mitchell@healytics.vn',
    phone: '0901000002',
    jobTitle: 'Physical Therapy Technician',
    role: EmployeeRole.THERAPIST,
    gender: Gender.FEMALE,
  },
  {
    employeeCode: 'EMP-003',
    fullName: 'David Nguyen',
    displayName: 'David N.',
    email: 'reception.nguyen@healytics.vn',
    phone: '0901000003',
    jobTitle: 'Receptionist',
    role: EmployeeRole.RECEPTIONIST,
    gender: Gender.MALE,
  },
  {
    employeeCode: 'EMP-004',
    fullName: 'Emily Parker',
    displayName: 'Emily P.',
    email: 'manager.parker@healytics.vn',
    phone: '0901000004',
    jobTitle: 'Branch Manager',
    role: EmployeeRole.MANAGER,
    gender: Gender.FEMALE,
  },
];

/** Doctor profile seed data keyed by employee code */
const SEED_DOCTOR_PROFILES: Record<string, Partial<Omit<DoctorProfile, 'employeeId' | 'employee'>>> = {
  'EMP-001': {
    title: 'M.D.',
    medicalLicense: 'ML-2024-001',
    experienceYears: 12,
    consultationFee: 350000,
    specializations: ['Internal Medicine', 'Preventive Care', 'Chronic Disease Management'],
    education: [
      'Doctor of Medicine - University of Medicine HCMC (2014)',
      'Residency – Internal Medicine - Cho Ray Hospital (2017)',
    ],
    certifications: [
      'Board Certified – Internal Medicine - Vietnam Medical Council (2018)',
      'Advanced Cardiac Life Support - AHA (2023)',
    ],
  },
};

/** Therapist profile seed data keyed by employee code */
const SEED_THERAPIST_PROFILES: Record<string, Partial<Omit<TherapistProfile, 'employeeId' | 'employee'>>> = {
  'EMP-002': {
    level: TherapistLevel.SENIOR,
    type: 'Physical Therapy',
    strengthLevel: StrengthLevel.MEDIUM,
    commissionRate: 15.5,
    healthCheckDate: new Date('2025-12-15'),
    skills: ['Deep Tissue Massage', 'Sports Rehabilitation', 'Trigger Point Therapy', 'Myofascial Release'],
    deviceProficiency: ['Ultrasound Therapy', 'TENS Unit', 'Laser Therapy Device'],
  },
};

@Injectable()
export class EmployeeSeeder implements ISeeder {
  private readonly logger = new Logger(EmployeeSeeder.name);

  constructor(
    @InjectRepository(Employee)
    private readonly employeeRepo: Repository<Employee>,
    @InjectRepository(DoctorProfile)
    private readonly doctorProfileRepo: Repository<DoctorProfile>,
    @InjectRepository(TherapistProfile)
    private readonly therapistProfileRepo: Repository<TherapistProfile>,
    @InjectRepository(Partner)
    private readonly partnerRepo: Repository<Partner>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding employees...');

    // Resolve partner FK — assign all seed employees to the first APPROVED partner
    const partner = await this.partnerRepo.findOne({
      where: { taxCode: '0123456789' }, // "Healytics Spa & Wellness"
    });

    if (!partner) {
      this.logger.warn('  ⚠ No partner found with taxCode "0123456789" — employees will have no partner. Run PartnerSeeder first.');
    }

    for (const empData of SEED_EMPLOYEES) {
      const exists = await this.employeeRepo.findOne({
        where: { employeeCode: empData.employeeCode },
      });

      if (exists) {
        this.logger.log(`  ⏭ Employee "${empData.employeeCode}" already exists, skipping`);
        await this.seedProfiles(exists);
        continue;
      }

      const employee = this.employeeRepo.create({
        ...empData,
        status: EmployeeStatus.ACTIVE,
        rating: 0,
        reviewCount: 0,
        partnerId: partner?.id ?? null,
        // branchId is nullable — left null for seed data
      });

      await this.employeeRepo.save(employee);
      this.logger.log(`  ✅ Created employee "${empData.fullName}" (${empData.role}) → partner: ${partner?.brandName ?? 'none'}`);

      await this.seedProfiles(employee);
    }

    this.logger.log('Employees seeding completed');
  }

  /** Seed doctor/therapist profiles for a given employee */
  private async seedProfiles(employee: Employee): Promise<void> {
    const doctorData = SEED_DOCTOR_PROFILES[employee.employeeCode];
    if (doctorData) {
      const exists = await this.doctorProfileRepo.findOne({
        where: { employeeId: employee.id },
      });
      if (!exists) {
        const profile = this.doctorProfileRepo.create({
          ...doctorData,
          employeeId: employee.id,
        });
        await this.doctorProfileRepo.save(profile);
        this.logger.log(`  ✅ Created doctor profile for "${employee.fullName}"`);
      } else {
        this.logger.log(`  ⏭ Doctor profile for "${employee.employeeCode}" already exists, skipping`);
      }
    }

    const therapistData = SEED_THERAPIST_PROFILES[employee.employeeCode];
    if (therapistData) {
      const exists = await this.therapistProfileRepo.findOne({
        where: { employeeId: employee.id },
      });
      if (!exists) {
        const profile = this.therapistProfileRepo.create({
          ...therapistData,
          employeeId: employee.id,
        });
        await this.therapistProfileRepo.save(profile);
        this.logger.log(`  ✅ Created therapist profile for "${employee.fullName}"`);
      } else {
        this.logger.log(`  ⏭ Therapist profile for "${employee.employeeCode}" already exists, skipping`);
      }
    }
  }

  async clear(): Promise<void> {
    const codes = SEED_EMPLOYEES.map((e) => e.employeeCode);

    // Find employees first to get their IDs for profile deletion
    const employees = await this.employeeRepo.find({
      where: { employeeCode: In(codes) },
      select: ['id', 'employeeCode'],
    });
    const empIds = employees.map((e) => e.id);

    // Delete profiles first (FK constraint)
    if (empIds.length > 0) {
      const { affected: doctorDeleted } = await this.doctorProfileRepo.delete({
        employeeId: In(empIds),
      });
      if (doctorDeleted) {
        this.logger.log(`🗑️ Deleted ${doctorDeleted} seed doctor profile(s)`);
      }

      const { affected: therapistDeleted } = await this.therapistProfileRepo.delete({
        employeeId: In(empIds),
      });
      if (therapistDeleted) {
        this.logger.log(`🗑️ Deleted ${therapistDeleted} seed therapist profile(s)`);
      }
    }

    // Then delete employees
    const { affected } = await this.employeeRepo.delete({ employeeCode: In(codes) });
    if (!affected) {
      this.logger.warn('⚠ No seed employees found to delete');
    } else {
      this.logger.log(`🗑️ Hard-deleted ${affected} seed employee(s)`);
    }
  }
}
