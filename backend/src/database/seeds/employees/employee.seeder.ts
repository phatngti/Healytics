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
    firstName: 'James',
    lastName: 'Anderson',

    email: 'doctor.anderson@healytics.vn',
    phone: '0901000001',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=James',
    jobTitle: 'General Practitioner',
    role: EmployeeRole.DOCTOR,
    gender: Gender.MALE,
    dob: new Date('1985-03-15'),
    startDate: new Date('2020-06-01'),
    employmentType: 'Full-time',
    description:
      'Dr. James Anderson is a board-certified General Practitioner with over 12 years of clinical experience specializing in internal medicine and preventive care. He is passionate about providing comprehensive, patient-centered healthcare and chronic disease management.',
    schedule: [
      { day: 'Monday', start: '08:00', end: '17:00', isWorking: true },
      { day: 'Tuesday', start: '08:00', end: '17:00', isWorking: true },
      { day: 'Wednesday', start: '08:00', end: '12:00', isWorking: true },
      { day: 'Thursday', start: '08:00', end: '17:00', isWorking: true },
      { day: 'Friday', start: '08:00', end: '17:00', isWorking: true },
      { day: 'Saturday', start: '09:00', end: '13:00', isWorking: true },
      { day: 'Sunday', start: '00:00', end: '00:00', isWorking: false },
    ],
    workHistory: [
      {
        facility: 'Healytics Medical Center',
        position: 'General Practitioner',
        period: '2020–Present',
        isCurrent: true,
      },
      {
        facility: 'Cho Ray Hospital',
        position: 'Resident – Internal Medicine',
        period: '2014–2020',
        isCurrent: false,
      },
    ],
  },
  {
    employeeCode: 'EMP-002',
    firstName: 'Sarah',
    lastName: 'Mitchell',

    email: 'therapist.mitchell@healytics.vn',
    phone: '0901000002',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=Sarah',
    jobTitle: 'Physical Therapy Technician',
    role: EmployeeRole.THERAPIST,
    gender: Gender.FEMALE,
    dob: new Date('1990-07-22'),
    startDate: new Date('2021-02-15'),
    employmentType: 'Full-time',
    description:
      'Sarah Mitchell is a Senior Physical Therapist with expertise in deep tissue massage, sports rehabilitation, and myofascial release. She combines modern therapeutic techniques with advanced medical devices to deliver outstanding patient outcomes.',
    schedule: [
      { day: 'Monday', start: '09:00', end: '18:00', isWorking: true },
      { day: 'Tuesday', start: '09:00', end: '18:00', isWorking: true },
      { day: 'Wednesday', start: '09:00', end: '18:00', isWorking: true },
      { day: 'Thursday', start: '09:00', end: '18:00', isWorking: true },
      { day: 'Friday', start: '09:00', end: '18:00', isWorking: true },
      { day: 'Saturday', start: '10:00', end: '15:00', isWorking: true },
      { day: 'Sunday', start: '00:00', end: '00:00', isWorking: false },
    ],
    workHistory: [
      {
        facility: 'Healytics Spa & Wellness',
        position: 'Senior Physical Therapist',
        period: '2021–Present',
        isCurrent: true,
      },
      {
        facility: 'Glow Saigon Spa Retreat',
        position: 'Physical Therapist',
        period: '2018–2021',
        isCurrent: false,
      },
    ],
  },
  {
    employeeCode: 'EMP-003',
    firstName: 'David',
    lastName: 'Nguyen',

    email: 'reception.nguyen@healytics.vn',
    phone: '0901000003',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=David',
    jobTitle: 'Receptionist',
    role: EmployeeRole.RECEPTIONIST,
    gender: Gender.MALE,
    dob: new Date('1995-11-08'),
    startDate: new Date('2023-01-10'),
    employmentType: 'Full-time',
    description:
      'David Nguyen is a professional receptionist who ensures seamless front-desk operations, patient check-ins, and appointment scheduling. He is known for excellent communication skills and a welcoming attitude.',
    schedule: [
      { day: 'Monday', start: '07:30', end: '16:30', isWorking: true },
      { day: 'Tuesday', start: '07:30', end: '16:30', isWorking: true },
      { day: 'Wednesday', start: '07:30', end: '16:30', isWorking: true },
      { day: 'Thursday', start: '07:30', end: '16:30', isWorking: true },
      { day: 'Friday', start: '07:30', end: '16:30', isWorking: true },
      { day: 'Saturday', start: '08:00', end: '12:00', isWorking: true },
      { day: 'Sunday', start: '00:00', end: '00:00', isWorking: false },
    ],
  },
  {
    employeeCode: 'EMP-004',
    firstName: 'Emily',
    lastName: 'Parker',

    email: 'manager.parker@healytics.vn',
    phone: '0901000004',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=Emily',
    jobTitle: 'Branch Manager',
    role: EmployeeRole.MANAGER,
    gender: Gender.FEMALE,
    dob: new Date('1988-05-30'),
    startDate: new Date('2019-09-01'),
    employmentType: 'Full-time',
    description:
      'Emily Parker is an experienced Branch Manager overseeing day-to-day clinic operations, staff coordination, and quality assurance. She brings strong leadership and organizational skills honed over 7 years in healthcare management.',
    schedule: [
      { day: 'Monday', start: '08:00', end: '17:00', isWorking: true },
      { day: 'Tuesday', start: '08:00', end: '17:00', isWorking: true },
      { day: 'Wednesday', start: '08:00', end: '17:00', isWorking: true },
      { day: 'Thursday', start: '08:00', end: '17:00', isWorking: true },
      { day: 'Friday', start: '08:00', end: '17:00', isWorking: true },
      { day: 'Saturday', start: '00:00', end: '00:00', isWorking: false },
      { day: 'Sunday', start: '00:00', end: '00:00', isWorking: false },
    ],
  },
];

/** Doctor profile seed data keyed by employee code */
const SEED_DOCTOR_PROFILES: Record<
  string,
  Partial<Omit<DoctorProfile, 'employeeId' | 'employee'>>
> = {
  'EMP-001': {
    title: 'M.D.',
    medicalCredentials: [{ title: 'M.D.', license: 'ML-2024-001' }],
    experienceYears: 12,
    consultationFee: 350000,
    specializations: [
      'Internal Medicine',
      'Preventive Care',
      'Chronic Disease Management',
    ],
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
const SEED_THERAPIST_PROFILES: Record<
  string,
  Partial<Omit<TherapistProfile, 'employeeId' | 'employee'>>
> = {
  'EMP-002': {
    level: TherapistLevel.SENIOR,
    type: 'Physical Therapy',
    strengthLevel: StrengthLevel.MEDIUM,
    commissionRate: 15.5,
    healthCheckDate: new Date('2025-12-15'),
    skills: [
      'Deep Tissue Massage',
      'Sports Rehabilitation',
      'Trigger Point Therapy',
      'Myofascial Release',
    ],
    deviceProficiency: [
      'Ultrasound Therapy',
      'TENS Unit',
      'Laser Therapy Device',
    ],
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
      this.logger.warn(
        '  ⚠ No partner found with taxCode "0123456789" — employees will have no partner. Run PartnerSeeder first.',
      );
    }

    for (const empData of SEED_EMPLOYEES) {
      const exists = await this.employeeRepo.findOne({
        where: { employeeCode: empData.employeeCode },
      });

      if (exists) {
        // Update fields that may have been added after initial seeding
        const fieldsToUpdate: Partial<Employee> = {};
        if (empData.avatarUrl && !exists.avatarUrl)
          fieldsToUpdate.avatarUrl = empData.avatarUrl;
        if (empData.description && !exists.description)
          fieldsToUpdate.description = empData.description;
        if (empData.schedule && !exists.schedule)
          fieldsToUpdate.schedule = empData.schedule;

        if (Object.keys(fieldsToUpdate).length > 0) {
          await this.employeeRepo.update(exists.id, fieldsToUpdate);
          this.logger.log(
            `  🔄 Updated employee "${empData.employeeCode}" with: ${Object.keys(fieldsToUpdate).join(', ')}`,
          );
        } else {
          this.logger.log(
            `  ⏭ Employee "${empData.employeeCode}" already exists, skipping`,
          );
        }
        await this.seedProfiles(exists);
        continue;
      }

      const employee = this.employeeRepo.create({
        ...empData,
        status: EmployeeStatus.ACTIVE,
        rating: 0,
        reviewCount: 0,
        partnerId: partner?.id ?? null,
      });

      await this.employeeRepo.save(employee);
      this.logger.log(
        `  ✅ Created employee "${employee.fullName}" (${empData.role}) → partner: ${partner?.brandName ?? 'none'}`,
      );

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
        this.logger.log(
          `  ✅ Created doctor profile for "${employee.fullName}"`,
        );
      } else {
        this.logger.log(
          `  ⏭ Doctor profile for "${employee.employeeCode}" already exists, skipping`,
        );
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
        this.logger.log(
          `  ✅ Created therapist profile for "${employee.fullName}"`,
        );
      } else {
        this.logger.log(
          `  ⏭ Therapist profile for "${employee.employeeCode}" already exists, skipping`,
        );
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

      const { affected: therapistDeleted } =
        await this.therapistProfileRepo.delete({
          employeeId: In(empIds),
        });
      if (therapistDeleted) {
        this.logger.log(
          `🗑️ Deleted ${therapistDeleted} seed therapist profile(s)`,
        );
      }
    }

    // Then delete employees
    const { affected } = await this.employeeRepo.delete({
      employeeCode: In(codes),
    });
    if (!affected) {
      this.logger.warn('⚠ No seed employees found to delete');
    } else {
      this.logger.log(`🗑️ Hard-deleted ${affected} seed employee(s)`);
    }
  }
}
