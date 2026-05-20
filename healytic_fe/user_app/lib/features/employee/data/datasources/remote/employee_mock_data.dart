import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';
import 'package:user_app/features/employee/domain/entities/medical_credential.entity.dart';

/// Mock employee data for development and testing.
///
/// IDs match those used by home specialists
/// (`spec-*`), booking search, and order details
/// (`emp-*`) so lookups always resolve to
/// distinct profiles.

final List<EmployeeDetailEntity> kMockEmployees = [
  // ─── Featured specialists (home page) ──────────
  EmployeeDetailEntity(
    id: 'spec-1',
    employeeCode: 'EMP-D001',
    fullName: 'Dr. Anna Nguyen',
    avatarUrl:
        'https://api.dicebear.com/9.x/avataaars/'
        'svg?seed=Anna',
    role: EmployeeRole.doctor,
    status: EmployeeStatus.active,
    jobTitle: 'Spa Therapist',
    description:
        'Board-certified spa therapist with over '
        '8 years of experience in luxury wellness '
        'treatments. Specializes in integrative '
        'skincare and relaxation techniques.',
    email: 'anna.nguyen@healytics.com',
    phone: '+84 901 234 567',
    dob: DateTime(1988, 5, 12),
    gender: EmployeeGender.female,
    startDate: DateTime(2020, 3, 1),
    employmentType: 'Full-time',
    rating: 4.9,
    reviewCount: 124,
    schedule: _weekdaySchedule,
    doctorProfile: const DoctorProfileEntity(
      title: 'MD',
      medicalCredentials: [
        MedicalCredentialEntity(
          title: 'Board Certified Dermatologist',
          license: 'LIC-2020-SPA-001',
        ),
      ],
      experienceYears: 8,
      consultationFee: 750000,
      specializations: [
        'Spa Therapy',
        'Skincare',
        'Relaxation',
      ],
      education: [
        'Doctor of Medicine',
        'Diploma in Aesthetic Medicine',
      ],
    ),
    workHistory: const [
      WorkHistoryEntry(
        facility: 'Healytics Spa & Wellness',
        position: 'Lead Spa Therapist',
        period: '2020–Present',
        isCurrent: true,
      ),
      WorkHistoryEntry(
        facility: 'Saigon Luxury Spa',
        position: 'Senior Therapist',
        period: '2016–2020',
      ),
    ],
  ),
  EmployeeDetailEntity(
    id: 'spec-4',
    employeeCode: 'EMP-W001',
    fullName: 'Dr. Hoa Le',
    avatarUrl:
        'https://api.dicebear.com/9.x/avataaars/'
        'svg?seed=Hoa',
    role: EmployeeRole.doctor,
    status: EmployeeStatus.active,
    jobTitle: 'Wellness Coach',
    description:
        'Certified wellness and lifestyle coach '
        'helping clients achieve optimal health '
        'through nutrition, mindfulness, and '
        'personalized fitness programs.',
    email: 'hoa.le@healytics.com',
    phone: '+84 903 456 789',
    dob: DateTime(1992, 11, 3),
    gender: EmployeeGender.female,
    startDate: DateTime(2021, 1, 15),
    employmentType: 'Full-time',
    rating: 4.8,
    reviewCount: 98,
    schedule: _weekdaySchedule,
    doctorProfile: const DoctorProfileEntity(
      title: 'MSc',
      medicalCredentials: [
        MedicalCredentialEntity(
          title: 'Certified Wellness Coach',
          license: 'LIC-2021-WC-004',
        ),
      ],
      experienceYears: 6,
      consultationFee: 500000,
      specializations: [
        'Wellness Coaching',
        'Nutrition',
        'Mindfulness',
      ],
      education: [
        'MSc Health Sciences',
        'ACE Wellness Coach Certification',
      ],
    ),
    workHistory: const [
      WorkHistoryEntry(
        facility: 'Harmony Wellness Hub',
        position: 'Head Wellness Coach',
        period: '2021–Present',
        isCurrent: true,
      ),
      WorkHistoryEntry(
        facility: 'FitLife Studio',
        position: 'Wellness Consultant',
        period: '2018–2021',
      ),
    ],
  ),
  EmployeeDetailEntity(
    id: 'spec-6',
    employeeCode: 'EMP-F001',
    fullName: 'Coach Duc Vo',
    avatarUrl:
        'https://api.dicebear.com/9.x/avataaars/'
        'svg?seed=Duc',
    role: EmployeeRole.therapist,
    status: EmployeeStatus.active,
    jobTitle: 'Personal Trainer',
    description:
        'NASM-certified personal trainer '
        'specializing in strength conditioning, '
        'HIIT, and athletic performance. '
        'Passionate about helping clients reach '
        'their peak physical form.',
    email: 'duc.vo@healytics.com',
    phone: '+84 907 654 321',
    dob: DateTime(1995, 2, 28),
    gender: EmployeeGender.male,
    startDate: DateTime(2022, 6, 1),
    employmentType: 'Full-time',
    rating: 4.7,
    reviewCount: 76,
    schedule: _weekdaySchedule,
    therapistProfile: const TherapistProfileEntity(
      level: 'Advanced',
      type: 'Personal Training',
      strengthLevel: 'Expert',
      skills: [
        'Strength Training',
        'HIIT',
        'Athletic Performance',
        'Mobility Work',
      ],
      deviceProficiency: [
        'TRX System',
        'Rowing Machine',
        'Cable Machine',
      ],
    ),
    workHistory: const [
      WorkHistoryEntry(
        facility: 'FitZone Gym',
        position: 'Senior Trainer',
        period: '2022–Present',
        isCurrent: true,
      ),
      WorkHistoryEntry(
        facility: 'GoldGym HCMC',
        position: 'Personal Trainer',
        period: '2019–2022',
      ),
    ],
  ),
  EmployeeDetailEntity(
    id: 'spec-8',
    employeeCode: 'EMP-P001',
    fullName: 'Dr. Tuan Phan',
    avatarUrl:
        'https://api.dicebear.com/9.x/avataaars/'
        'svg?seed=Tuan',
    role: EmployeeRole.doctor,
    status: EmployeeStatus.active,
    jobTitle: 'Psychologist',
    description:
        'Licensed clinical psychologist with '
        'extensive experience in cognitive '
        'behavioral therapy, anxiety & stress '
        'management, and mindfulness-based '
        'interventions.',
    email: 'tuan.phan@healytics.com',
    phone: '+84 909 111 222',
    dob: DateTime(1983, 8, 19),
    gender: EmployeeGender.male,
    startDate: DateTime(2019, 9, 1),
    employmentType: 'Full-time',
    rating: 5.0,
    reviewCount: 203,
    schedule: _weekdaySchedule,
    doctorProfile: const DoctorProfileEntity(
      title: 'PhD',
      medicalCredentials: [
        MedicalCredentialEntity(
          title: 'Licensed Clinical Psychologist',
          license: 'LIC-2019-PSY-008',
        ),
      ],
      experienceYears: 12,
      consultationFee: 800000,
      specializations: [
        'CBT',
        'Anxiety & Stress',
        'Mindfulness',
      ],
      education: [
        'PhD Clinical Psychology',
        'MA Psychology',
      ],
    ),
    workHistory: const [
      WorkHistoryEntry(
        facility: 'MindCare Clinic',
        position: 'Chief Psychologist',
        period: '2019–Present',
        isCurrent: true,
      ),
      WorkHistoryEntry(
        facility: 'National Mental Health',
        position: 'Senior Psychologist',
        period: '2014–2019',
      ),
    ],
  ),
  EmployeeDetailEntity(
    id: 'spec-9',
    employeeCode: 'EMP-PT001',
    fullName: 'Dr. Lan Bui',
    avatarUrl:
        'https://api.dicebear.com/9.x/avataaars/'
        'svg?seed=Lan',
    role: EmployeeRole.therapist,
    status: EmployeeStatus.active,
    jobTitle: 'Physical Therapist',
    description:
        'Experienced physical therapist '
        'specializing in musculoskeletal '
        'rehabilitation, sports injuries, and '
        'post-surgical recovery programs.',
    email: 'lan.bui@healytics.com',
    phone: '+84 905 333 444',
    dob: DateTime(1991, 4, 7),
    gender: EmployeeGender.female,
    startDate: DateTime(2021, 3, 15),
    employmentType: 'Full-time',
    rating: 4.6,
    reviewCount: 57,
    schedule: _weekdaySchedule,
    therapistProfile: const TherapistProfileEntity(
      level: 'Senior',
      type: 'Physical Therapy',
      strengthLevel: 'Advanced',
      skills: [
        'Musculoskeletal Rehab',
        'Sports Injuries',
        'Post-Surgical Recovery',
        'Manual Therapy',
      ],
      deviceProficiency: [
        'Ultrasound Therapy',
        'TENS Machine',
        'Resistance Bands',
      ],
    ),
    workHistory: const [
      WorkHistoryEntry(
        facility: 'PhysioPlus Rehab',
        position: 'Senior Therapist',
        period: '2021–Present',
        isCurrent: true,
      ),
      WorkHistoryEntry(
        facility: 'FV Hospital Rehab',
        position: 'Physical Therapist',
        period: '2018–2021',
      ),
    ],
  ),
  EmployeeDetailEntity(
    id: 'spec-11',
    employeeCode: 'EMP-GP001',
    fullName: 'Dr. Bao Hoang',
    avatarUrl:
        'https://api.dicebear.com/9.x/avataaars/'
        'svg?seed=Bao',
    role: EmployeeRole.doctor,
    status: EmployeeStatus.active,
    jobTitle: 'General Physician',
    description:
        'Dedicated general physician providing '
        'comprehensive primary care, preventive '
        'health screenings, and chronic disease '
        'management at Healytics Medical.',
    email: 'bao.hoang@healytics.com',
    phone: '+84 908 555 666',
    dob: DateTime(1986, 12, 1),
    gender: EmployeeGender.male,
    startDate: DateTime(2018, 2, 10),
    employmentType: 'Full-time',
    rating: 4.8,
    reviewCount: 165,
    schedule: _weekdaySchedule,
    doctorProfile: const DoctorProfileEntity(
      title: 'MD',
      medicalCredentials: [
        MedicalCredentialEntity(
          title: 'General Practitioner License',
          license: 'LIC-2018-GP-011',
        ),
      ],
      experienceYears: 14,
      consultationFee: 450000,
      specializations: [
        'Primary Care',
        'Preventive Medicine',
        'Chronic Disease',
      ],
      education: [
        'Doctor of Medicine',
        'Board Certification – Family Medicine',
      ],
    ),
    workHistory: const [
      WorkHistoryEntry(
        facility: 'Healytics Medical',
        position: 'Senior Physician',
        period: '2018–Present',
        isCurrent: true,
      ),
      WorkHistoryEntry(
        facility: 'District 7 Polyclinic',
        position: 'Attending Physician',
        period: '2012–2018',
      ),
    ],
  ),

  // ─── Legacy IDs (order details etc.) ────────────
  EmployeeDetailEntity(
    id: 'emp-doctor-1',
    employeeCode: 'EMP-D010',
    fullName: 'Dr. Nguyen Van A',
    avatarUrl:
        'https://api.dicebear.com/9.x/avataaars/'
        'svg?seed=VanA',
    role: EmployeeRole.doctor,
    status: EmployeeStatus.active,
    jobTitle: 'Senior Doctor',
    description:
        'Experienced dermatologist specializing in '
        'advanced skin treatments, clinical '
        'research, and pediatric dermatology.',
    email: 'nguyen.vana@healytics.com',
    phone: '+84 901 234 567',
    dob: DateTime(1985, 3, 15),
    gender: EmployeeGender.male,
    startDate: DateTime(2022, 1, 10),
    employmentType: 'Full-time',
    rating: 4.8,
    reviewCount: 120,
    schedule: _weekdaySchedule,
    doctorProfile: const DoctorProfileEntity(
      title: 'MD, PhD',
      medicalCredentials: [
        MedicalCredentialEntity(
          title: 'Senior Doctor',
          license: 'LIC-2024-001',
        ),
      ],
      experienceYears: 10,
      consultationFee: 500000,
      specializations: [
        'Dermatology',
        'Cardiology',
        'Internal Medicine',
      ],
      education: ['Doctor of Medicine'],
    ),
    verificationDocuments: const [
      VerificationDocumentEntity(
        fieldKey: 'id_card',
        documents: [
          DocumentEntryEntity(
            name: 'Medical License',
            url:
                'https://pub-58a545087a6b4221b1b0'
                'dab10d8d3517.r2.dev/1770314552105-'
                'Gemini_Generated_Image_'
                'eq0jpneq0jpneq0j.png',
          ),
        ],
      ),
    ],
    workHistory: const [
      WorkHistoryEntry(
        facility: 'Glow Saigon Spa Retreat',
        position: 'Head of Dermatology',
        period: '2022–Present',
        isCurrent: true,
      ),
      WorkHistoryEntry(
        facility: 'Vinmec Central Park',
        position: 'Resident Doctor',
        period: '2018–2022',
      ),
    ],
  ),
  EmployeeDetailEntity(
    id: 'emp-therapist-1',
    employeeCode: 'EMP-T010',
    fullName: 'Tran Thi B',
    avatarUrl:
        'https://api.dicebear.com/9.x/avataaars/'
        'svg?seed=ThiB',
    role: EmployeeRole.therapist,
    status: EmployeeStatus.active,
    jobTitle: 'Senior Therapist',
    description:
        'Skilled therapist specializing in deep '
        'tissue massage, sports recovery, and '
        'rehabilitation.',
    email: 'tran.thib@healytics.com',
    phone: '+84 902 345 678',
    dob: DateTime(1990, 7, 22),
    gender: EmployeeGender.female,
    startDate: DateTime(2021, 6, 1),
    employmentType: 'Full-time',
    rating: 4.6,
    reviewCount: 85,
    schedule: _weekdaySchedule,
    therapistProfile: const TherapistProfileEntity(
      level: 'Senior',
      type: 'Physical Therapy',
      strengthLevel: 'Advanced',
      skills: [
        'Deep Tissue Massage',
        'Sports Recovery',
        'Rehabilitation',
        'Aromatherapy',
      ],
      deviceProficiency: [
        'Ultrasound Therapy',
        'TENS Machine',
        'Infrared Lamp',
      ],
    ),
    workHistory: const [
      WorkHistoryEntry(
        facility: 'Zen Wellness Center',
        position: 'Senior Therapist',
        period: '2021–Present',
        isCurrent: true,
      ),
      WorkHistoryEntry(
        facility: 'FV Hospital Rehab',
        position: 'Physical Therapist',
        period: '2019–2021',
      ),
    ],
  ),
];

// ─── Shared schedule template ──────────────────────

const List<WorkScheduleEntry> _weekdaySchedule = [
  WorkScheduleEntry(
    day: 'Monday',
    startTime: '09:00',
    endTime: '17:00',
    isWorking: true,
  ),
  WorkScheduleEntry(
    day: 'Tuesday',
    startTime: '09:00',
    endTime: '17:00',
    isWorking: true,
  ),
  WorkScheduleEntry(
    day: 'Wednesday',
    startTime: '09:00',
    endTime: '17:00',
    isWorking: true,
  ),
  WorkScheduleEntry(
    day: 'Thursday',
    startTime: '09:00',
    endTime: '17:00',
    isWorking: true,
  ),
  WorkScheduleEntry(
    day: 'Friday',
    startTime: '09:00',
    endTime: '12:00',
    isWorking: true,
  ),
  WorkScheduleEntry(
    day: 'Saturday',
    isWorking: false,
  ),
  WorkScheduleEntry(
    day: 'Sunday',
    isWorking: false,
  ),
];
