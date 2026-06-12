import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Employee } from '@/common/entities/employee.entity';
import { Account } from '@/common/entities/account.entity';
import { DoctorProfile } from '@/common/entities/doctor-profile.entity';
import { TherapistProfile } from '@/common/entities/therapist-profile.entity';
import { Partner } from '@/common/entities/partner.entity';
import { EmployeeRole } from '@/employees/enum/employee-role.enum';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { Gender } from '@/employees/enum/gender.enum';
import { TherapistLevel } from '@/employees/enum/therapist-level.enum';
import { StrengthLevel } from '@/employees/enum/strength-level.enum';
import { ISeeder } from '../seeder.interface';
import { BULK_WELLNESS_EMPLOYEES } from '../wellness-bulk.seed';

const schedule = (
  weekdayStart = '08:00',
  weekdayEnd = '17:00',
  saturdayStart = '09:00',
  saturdayEnd = '13:00',
) => [
  { day: 'Monday', start: weekdayStart, end: weekdayEnd, isWorking: true },
  { day: 'Tuesday', start: weekdayStart, end: weekdayEnd, isWorking: true },
  { day: 'Wednesday', start: weekdayStart, end: weekdayEnd, isWorking: true },
  { day: 'Thursday', start: weekdayStart, end: weekdayEnd, isWorking: true },
  { day: 'Friday', start: weekdayStart, end: weekdayEnd, isWorking: true },
  { day: 'Saturday', start: saturdayStart, end: saturdayEnd, isWorking: true },
  { day: 'Sunday', start: '00:00', end: '00:00', isWorking: false },
];

const SEED_EMPLOYEES = [
  {
    employeeCode: 'EMP-001',
    partnerTaxCode: '0123456789',
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
    partnerTaxCode: '0123456789',
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
    partnerTaxCode: '0123456789',
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
    partnerTaxCode: '0123456789',
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
  {
    employeeCode: 'EMP-005',
    partnerTaxCode: '0987654321',
    firstName: 'Olivia',
    lastName: 'Tran',
    email: 'dentist.tran@healytics.vn',
    phone: '0902000005',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=Olivia',
    jobTitle: 'Cosmetic Dentist',
    role: EmployeeRole.DOCTOR,
    gender: Gender.FEMALE,
    dob: new Date('1986-09-18'),
    startDate: new Date('2018-04-02'),
    employmentType: 'Full-time',
    description:
      'Dr. Olivia Tran specializes in preventive dentistry, whitening and cosmetic treatment planning with a conservative, patient-first approach.',
    schedule: schedule('08:30', '17:30', '08:30', '12:30'),
    workHistory: [
      {
        facility: 'Healytics Dental',
        position: 'Lead Dentist',
        period: '2018–Present',
        isCurrent: true,
      },
      {
        facility: 'HCMC Odonto-Stomatology Hospital',
        position: 'Dentist',
        period: '2012–2018',
        isCurrent: false,
      },
    ],
  },
  {
    employeeCode: 'EMP-006',
    partnerTaxCode: '0987654321',
    firstName: 'Mia',
    lastName: 'Le',
    email: 'hygienist.le@healytics.vn',
    phone: '0902000006',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=Mia',
    jobTitle: 'Dental Hygienist',
    role: EmployeeRole.THERAPIST,
    gender: Gender.FEMALE,
    dob: new Date('1992-04-11'),
    startDate: new Date('2020-05-12'),
    employmentType: 'Full-time',
    description:
      'Mia Le supports preventive dental care, chair-side preparation and sensitivity management for whitening treatments.',
    schedule: schedule('09:00', '18:00', '09:00', '13:00'),
  },
  {
    employeeCode: 'EMP-007',
    partnerTaxCode: '1122334455',
    firstName: 'Marcus',
    lastName: 'Le',
    email: 'coach.le@healytics.vn',
    phone: '0902000007',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=Marcus',
    jobTitle: 'Recovery Yoga Coach',
    role: EmployeeRole.THERAPIST,
    gender: Gender.MALE,
    dob: new Date('1989-12-03'),
    startDate: new Date('2021-10-01'),
    employmentType: 'Contract',
    description:
      'Marcus Le combines guided mobility work, assisted stretching and breathing drills for post-training recovery.',
    schedule: schedule('10:00', '19:00', '08:00', '14:00'),
  },
  {
    employeeCode: 'EMP-008',
    partnerTaxCode: '1122334455',
    firstName: 'Hannah',
    lastName: 'Vo',
    email: 'manager.vo@healytics.vn',
    phone: '0902000008',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=Hannah',
    jobTitle: 'Fitness Operations Manager',
    role: EmployeeRole.MANAGER,
    gender: Gender.FEMALE,
    dob: new Date('1987-02-20'),
    startDate: new Date('2019-06-18'),
    employmentType: 'Full-time',
    description:
      'Hannah Vo manages class capacity, coach scheduling and safety compliance for gym and yoga programs.',
    schedule: schedule('08:00', '17:00', '08:00', '12:00'),
  },
  {
    employeeCode: 'EMP-009',
    partnerTaxCode: '5566778899',
    firstName: 'Quang',
    lastName: 'Pham',
    email: 'nutrition.pham@healytics.vn',
    phone: '0902000009',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=Quang',
    jobTitle: 'Clinical Nutritionist',
    role: EmployeeRole.DOCTOR,
    gender: Gender.MALE,
    dob: new Date('1984-08-25'),
    startDate: new Date('2017-03-06'),
    employmentType: 'Full-time',
    description:
      'Quang Pham provides nutrition screening, supplement counseling and practical meal planning for metabolic health.',
    schedule: schedule('08:00', '16:30', '08:00', '11:30'),
    workHistory: [
      {
        facility: 'Saigon Pharma',
        position: 'Clinical Nutritionist',
        period: '2017–Present',
        isCurrent: true,
      },
    ],
  },
  {
    employeeCode: 'EMP-010',
    partnerTaxCode: '6677889900',
    firstName: 'Mai',
    lastName: 'Nguyen',
    email: 'traditional.nguyen@healytics.vn',
    phone: '0902000010',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=Mai',
    jobTitle: 'Traditional Medicine Doctor',
    role: EmployeeRole.DOCTOR,
    gender: Gender.FEMALE,
    dob: new Date('1979-01-14'),
    startDate: new Date('2015-08-21'),
    employmentType: 'Full-time',
    description:
      'Dr. Mai Nguyen practices traditional medicine consultation, herbal protocols and pain-management care plans.',
    schedule: schedule('08:00', '17:00', '08:00', '12:00'),
  },
  {
    employeeCode: 'EMP-011',
    partnerTaxCode: '6677889900',
    firstName: 'Bao',
    lastName: 'Tran',
    email: 'acupuncture.tran@healytics.vn',
    phone: '0902000011',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=Bao',
    jobTitle: 'Acupuncture Therapist',
    role: EmployeeRole.THERAPIST,
    gender: Gender.MALE,
    dob: new Date('1991-10-09'),
    startDate: new Date('2019-01-15'),
    employmentType: 'Full-time',
    description:
      'Bao Tran supports acupuncture sessions, cupping preparation and post-treatment mobility guidance.',
    schedule: schedule('09:00', '18:00', '09:00', '13:00'),
  },
  {
    employeeCode: 'EMP-012',
    partnerTaxCode: '7788990011',
    firstName: 'Lan',
    lastName: 'Huynh',
    email: 'dermatology.huynh@healytics.vn',
    phone: '0902000012',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=Lan',
    jobTitle: 'Dermatologist',
    role: EmployeeRole.DOCTOR,
    gender: Gender.FEMALE,
    dob: new Date('1983-06-27'),
    startDate: new Date('2016-11-01'),
    employmentType: 'Full-time',
    description:
      'Dr. Lan Huynh specializes in acne care, pigmentation consultation and practical dermatology treatment plans.',
    schedule: schedule('08:30', '17:30', '08:30', '12:30'),
  },
  {
    employeeCode: 'EMP-013',
    partnerTaxCode: '7788990011',
    firstName: 'Nhi',
    lastName: 'Do',
    email: 'psychology.do@healytics.vn',
    phone: '0902000013',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=Nhi',
    jobTitle: 'Clinical Psychologist',
    role: EmployeeRole.DOCTOR,
    gender: Gender.FEMALE,
    dob: new Date('1988-03-05'),
    startDate: new Date('2020-09-07'),
    employmentType: 'Full-time',
    description:
      'Nhi Do provides structured counseling sessions for stress, anxiety and sleep-related concerns.',
    schedule: schedule('10:00', '19:00', '10:00', '14:00'),
  },
  {
    employeeCode: 'EMP-014',
    partnerTaxCode: '7788990011',
    firstName: 'Karen',
    lastName: 'Pham',
    email: 'coordinator.pham@healytics.vn',
    phone: '0902000014',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=Karen',
    jobTitle: 'Care Coordinator',
    role: EmployeeRole.RECEPTIONIST,
    gender: Gender.FEMALE,
    dob: new Date('1996-07-17'),
    startDate: new Date('2022-04-04'),
    employmentType: 'Full-time',
    description:
      'Karen Pham coordinates intake forms, appointment reminders and follow-up scheduling for MindSkin patients.',
    schedule: schedule('08:00', '17:00', '08:00', '12:00'),
  },
  {
    employeeCode: 'EMP-015',
    partnerTaxCode: '0123456789',
    accountEmail: 'doctor@healytics.vn',
    firstName: 'Minh',
    lastName: 'Tran',
    email: 'doctor.tran@healytics.vn',
    phone: '0901000015',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=Minh',
    jobTitle: 'Internal Medicine Physician',
    role: EmployeeRole.DOCTOR,
    gender: Gender.MALE,
    dob: new Date('1982-11-20'),
    startDate: new Date('2019-03-01'),
    employmentType: 'Full-time',
    description:
      'Dr. Minh Tran is a skilled Internal Medicine Physician with deep expertise in cardiovascular health screening and chronic disease prevention. He provides evidence-based consultations and personalized treatment plans.',
    schedule: schedule('08:00', '17:00', '08:00', '12:00'),
    workHistory: [
      {
        facility: 'Healytics Medical Center',
        position: 'Internal Medicine Physician',
        period: '2019–Present',
        isCurrent: true,
      },
      {
        facility: 'University Medical Center HCMC',
        position: 'Attending Physician',
        period: '2012–2019',
        isCurrent: false,
      },
    ],
  },
  {
    employeeCode: 'EMP-016',
    partnerTaxCode: '0123456789',
    accountEmail: 'therapist@healytics.vn',
    firstName: 'Thuy',
    lastName: 'Nguyen',
    email: 'therapist.nguyen@healytics.vn',
    phone: '0901000016',
    avatarUrl: 'https://api.dicebear.com/9.x/avataaars/svg?seed=Thuy',
    jobTitle: 'Rehabilitation Therapist',
    role: EmployeeRole.THERAPIST,
    gender: Gender.FEMALE,
    dob: new Date('1993-05-12'),
    startDate: new Date('2021-08-15'),
    employmentType: 'Full-time',
    description:
      'Thuy Nguyen is a dedicated Rehabilitation Therapist specializing in post-operative recovery, therapeutic massage, and functional movement restoration. She combines hands-on techniques with modern equipment for optimal patient recovery.',
    schedule: schedule('09:00', '18:00', '09:00', '13:00'),
    workHistory: [
      {
        facility: 'Healytics Medical Center',
        position: 'Rehabilitation Therapist',
        period: '2021–Present',
        isCurrent: true,
      },
      {
        facility: 'Saigon Physiotherapy Clinic',
        position: 'Physical Therapist',
        period: '2018–2021',
        isCurrent: false,
      },
    ],
  },
  ...BULK_WELLNESS_EMPLOYEES,
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
  'EMP-005': {
    title: 'D.D.S.',
    medicalCredentials: [{ title: 'D.D.S.', license: 'DENT-2018-204' }],
    experienceYears: 14,
    consultationFee: 500000,
    specializations: ['Cosmetic Dentistry', 'Preventive Dentistry'],
    education: [
      'Doctor of Dental Surgery - University of Medicine HCMC (2010)',
      'Cosmetic Dentistry Fellowship - Seoul Dental Institute (2016)',
    ],
    certifications: [
      'Laser Dentistry Certificate - Vietnam Dental Association (2022)',
    ],
  },
  'EMP-009': {
    title: 'M.Sc.',
    medicalCredentials: [
      { title: 'Clinical Nutritionist', license: 'NUT-2017-088' },
    ],
    experienceYears: 9,
    consultationFee: 420000,
    specializations: ['Clinical Nutrition', 'Metabolic Health'],
    education: [
      'Master of Clinical Nutrition - HCMC University of Medicine (2016)',
    ],
    certifications: ['Diabetes Nutrition Care - VDD (2023)'],
  },
  'EMP-010': {
    title: 'Dr.',
    medicalCredentials: [
      { title: 'Traditional Medicine Doctor', license: 'YHCT-2015-317' },
    ],
    experienceYears: 18,
    consultationFee: 380000,
    specializations: ['Traditional Medicine', 'Herbal Protocols', 'Pain Care'],
    education: [
      'Traditional Medicine Doctor - Vietnam University of Traditional Medicine (2008)',
    ],
    certifications: ['Acupuncture Practice Certificate - HCMC DOH (2020)'],
  },
  'EMP-012': {
    title: 'M.D.',
    medicalCredentials: [{ title: 'Dermatologist', license: 'DERM-2016-512' }],
    experienceYears: 11,
    consultationFee: 650000,
    specializations: ['Acne Treatment', 'Pigmentation', 'Clinical Dermatology'],
    education: [
      'Doctor of Medicine - University of Medicine HCMC (2010)',
      'Dermatology Residency - HCMC Dermatology Hospital (2015)',
    ],
    certifications: ['Clinical Dermatology Board Certification (2017)'],
  },
  'EMP-013': {
    title: 'Ph.D.',
    medicalCredentials: [
      { title: 'Clinical Psychologist', license: 'PSY-2020-044' },
    ],
    experienceYears: 8,
    consultationFee: 900000,
    specializations: [
      'Stress Management',
      'Anxiety Counseling',
      'Sleep Health',
    ],
    education: [
      'Ph.D. Clinical Psychology - Vietnam National University (2018)',
    ],
    certifications: ['Cognitive Behavioral Therapy Certificate (2021)'],
  },
  'EMP-015': {
    title: 'M.D.',
    medicalCredentials: [
      { title: 'Internal Medicine Physician', license: 'IM-2019-128' },
    ],
    experienceYears: 14,
    consultationFee: 450000,
    specializations: [
      'Internal Medicine',
      'Cardiovascular Screening',
      'Chronic Disease Prevention',
    ],
    education: [
      'Doctor of Medicine - University of Medicine HCMC (2008)',
      'Residency – Internal Medicine - University Medical Center HCMC (2012)',
    ],
    certifications: [
      'Board Certified – Internal Medicine - Vietnam Medical Council (2013)',
      'Cardiovascular Health Screening Certificate - Vietnam Heart Association (2022)',
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
  'EMP-006': {
    level: TherapistLevel.SENIOR,
    type: 'Dental Hygiene',
    strengthLevel: StrengthLevel.SOFT,
    commissionRate: 12,
    healthCheckDate: new Date('2026-01-10'),
    skills: ['Dental Cleaning', 'Sensitivity Screening', 'Chair-side Support'],
    deviceProficiency: ['Ultrasonic Scaler', 'Whitening LED Lamp'],
  },
  'EMP-007': {
    level: TherapistLevel.MASTER,
    type: 'Recovery Yoga',
    strengthLevel: StrengthLevel.MEDIUM,
    commissionRate: 18,
    healthCheckDate: new Date('2026-02-05'),
    skills: ['Assisted Stretching', 'Mobility Training', 'Breathwork'],
    deviceProficiency: ['Reformer Station', 'Mobility Assessment Kit'],
  },
  'EMP-011': {
    level: TherapistLevel.SENIOR,
    type: 'Acupuncture Support',
    strengthLevel: StrengthLevel.SOFT,
    commissionRate: 14,
    healthCheckDate: new Date('2026-01-20'),
    skills: [
      'Acupuncture Preparation',
      'Cupping Support',
      'Aftercare Guidance',
    ],
    deviceProficiency: ['Infrared Therapy Lamp', 'Sterilization Cabinet'],
  },
  'EMP-016': {
    level: TherapistLevel.SENIOR,
    type: 'Rehabilitation',
    strengthLevel: StrengthLevel.MEDIUM,
    commissionRate: 16,
    healthCheckDate: new Date('2026-03-10'),
    skills: [
      'Post-Operative Recovery',
      'Therapeutic Massage',
      'Functional Movement Restoration',
      'Pain Management',
    ],
    deviceProficiency: ['TENS Unit', 'Ultrasound Therapy', 'Hot/Cold Packs'],
  },
};

@Injectable()
export class EmployeeSeeder implements ISeeder {
  private readonly logger = new Logger(EmployeeSeeder.name);

  constructor(
    @InjectRepository(Employee)
    private readonly employeeRepo: Repository<Employee>,
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
    @InjectRepository(DoctorProfile)
    private readonly doctorProfileRepo: Repository<DoctorProfile>,
    @InjectRepository(TherapistProfile)
    private readonly therapistProfileRepo: Repository<TherapistProfile>,
    @InjectRepository(Partner)
    private readonly partnerRepo: Repository<Partner>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding employees...');

    const partnerTaxCodes = [
      ...new Set(
        SEED_EMPLOYEES.map(
          (employee) => employee.partnerTaxCode ?? '0123456789',
        ),
      ),
    ];
    const partners = await this.partnerRepo.find({
      where: { taxCode: In(partnerTaxCodes) },
    });
    const partnerMap = new Map(
      partners.map((partner) => [partner.taxCode, partner]),
    );

    if (!partnerMap.size) {
      this.logger.warn(
        '  ⚠ No seed partners found — employees will have no partner. Run PartnerSeeder first.',
      );
    }

    for (const empData of SEED_EMPLOYEES) {
      const rawEmployeeData = empData as any;
      const { partnerTaxCode, accountEmail, ...employeeData } = rawEmployeeData;
      const partner =
        partnerMap.get(rawEmployeeData.partnerTaxCode ?? '0123456789') ?? null;
      const exists = await this.employeeRepo.findOne({
        where: { employeeCode: employeeData.employeeCode },
        withDeleted: true,
      });

      // Resolve linked account if accountEmail is provided
      let accountId: string | null = null;
      if (rawEmployeeData.accountEmail) {
        const account = await this.accountRepo.findOne({
          where: { email: rawEmployeeData.accountEmail },
          loadEagerRelations: false,
        });
        accountId = account?.id ?? null;
        if (!account) {
          this.logger.warn(
            `  ⚠ Account "${rawEmployeeData.accountEmail}" not found for employee "${employeeData.employeeCode}"`,
          );
        }
      }

      if (exists) {
        // Update fields that may have been added after initial seeding
        const fieldsToUpdate: Partial<Employee> = {};
        if (employeeData.avatarUrl && !exists.avatarUrl)
          fieldsToUpdate.avatarUrl = employeeData.avatarUrl;
        if (employeeData.description && !exists.description)
          fieldsToUpdate.description = employeeData.description;
        if (employeeData.schedule && !exists.schedule)
          fieldsToUpdate.schedule = employeeData.schedule;
        if (partner && !exists.partnerId) fieldsToUpdate.partnerId = partner.id;
        if (accountId && !exists.accountId)
          fieldsToUpdate.accountId = accountId;
        if (exists.deletedAt) fieldsToUpdate.deletedAt = null;

        if (Object.keys(fieldsToUpdate).length > 0) {
          await this.employeeRepo.update(exists.id, fieldsToUpdate);
          this.logger.log(
            `  🔄 Updated employee "${empData.employeeCode}" with: ${Object.keys(fieldsToUpdate).join(', ')}`,
          );
        } else {
          this.logger.log(
            `  ⏭ Employee "${employeeData.employeeCode}" already exists, skipping`,
          );
        }
        await this.seedProfiles(exists);
        continue;
      }

      const employee = this.employeeRepo.create({
        ...employeeData,
        status: EmployeeStatus.ACTIVE,
        rating: 0,
        reviewCount: 0,
        partnerId: partner?.id ?? null,
        accountId,
      } as Partial<Employee>);

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
