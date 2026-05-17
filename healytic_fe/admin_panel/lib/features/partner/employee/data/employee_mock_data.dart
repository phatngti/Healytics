import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_gender.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_status.dart';
import 'package:admin_panel/features/partner/employee/domain/employment_type.dart';
import 'package:admin_panel/features/partner/employee/domain/massage_strength_level.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_level.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';

// ============================================================================
// Static Mock Constants
// ============================================================================

/// Mock work schedule data for employee testing.
const List<EmployeeSchedule> employeeMockWorkSchedule = [
  EmployeeSchedule(day: 'Monday', start: '09:00', end: '17:00'),
  EmployeeSchedule(day: 'Tuesday', start: '09:00', end: '17:00'),
  EmployeeSchedule(day: 'Wednesday', start: '09:00', end: '17:00'),
  EmployeeSchedule(day: 'Thursday', start: '09:00', end: '17:00'),
  EmployeeSchedule(day: 'Friday', start: '09:00', end: '17:00'),
  EmployeeSchedule(
    day: 'Saturday',
    start: '10:00',
    end: '14:00',
    isWorking: true,
  ),
  EmployeeSchedule(day: 'Sunday', start: '', end: '', isWorking: false),
];

/// Mock avatar paths for employee testing.
const List<String> employeeMockAvatarPaths = [
  '/Volumes/WD850X/Users/.gemini/antigravity/brain/777fe12d-6f03-4b1b-b8da-6785a5653f32/uploaded_image_0_1767531765300.png',
  '/Volumes/WD850X/Users/.gemini/antigravity/brain/777fe12d-6f03-4b1b-b8da-6785a5653f32/uploaded_image_1_1767531765300.png',
  '/Volumes/WD850X/Users/.gemini/antigravity/brain/777fe12d-6f03-4b1b-b8da-6785a5653f32/uploaded_image_2_1767531765300.png',
  '/Volumes/WD850X/Users/.gemini/antigravity/brain/777fe12d-6f03-4b1b-b8da-6785a5653f32/uploaded_image_3_1767531765300.png',
  '/Volumes/WD850X/Users/.gemini/antigravity/brain/777fe12d-6f03-4b1b-b8da-6785a5653f32/uploaded_image_4_1767531765300.png',
];

/// Mock PDF URL for employee documents testing.
const String employeeMockPdfUrl =
    'https://pub-58a545087a6b4221b1b0dab10d8d3517.r2.dev/main%20(3).pdf';

/// Mock documents list for employee testing.
const List<String> employeeMockDocuments = [employeeMockPdfUrl];

/// Mock work history entries for employee testing.
const List<WorkHistoryEntry> employeeMockWorkHistory = [
  WorkHistoryEntry(
    facility: 'Glow Saigon Spa Retreat',
    position: 'Head of Dermatology',
    period: '2022–Present',
  ),
  WorkHistoryEntry(
    facility: 'Lotus Wellness Center',
    position: 'Senior Therapist',
    period: '2019–2022',
  ),
  WorkHistoryEntry(
    facility: 'Harmony Health Clinic',
    position: 'Junior Therapist',
    period: '2016–2019',
  ),
];

/// Mock description text for employee testing.
const String employeeMockDescription = '''
Here is a detailed description for the mock employee.
- Highly experienced in their field.
- Certified by international boards.
- Friendly and professional demeanor.
- Available for consultations and treatments.
''';

/// Mock device proficiency options for spa therapists.
const Map<String, String> employeeMockDeviceProficiency = {
  'laser_co2_fractional': 'CO2 Fractional Laser',
  'laser_nd_yag': 'Nd:YAG Laser',
  'laser_pico': 'Picosecond Laser',
  'laser_diode': 'Diode Laser',
  'ipl_therapy': 'IPL Therapy',
  'hifu_lifting': 'HIFU Technology',
  'rf_microneedling': 'RF Microneedling',
  'radio_frequency_face': 'Facial Radio Frequency',
  'radio_frequency_body': 'Body Radio Frequency',
  'galvanic_ion': 'Galvanic Ion',
  'ultrasonic_scrubber': 'Ultrasonic Scrubber',
  'hydro_dermabrasion': 'Hydro Dermabrasion',
  'microdermabrasion': 'Diamond Microdermabrasion',
  'oxygen_jet_peel': 'Oxygen Jet Peel',
  'led_phototherapy': 'LED Phototherapy',
  'high_frequency_wand': 'High Frequency Wand',
  'electroporation': 'Electroporation',
  'cryolipolysis': 'Cryolipolysis',
  'ultrasonic_cavitation': 'Ultrasonic Cavitation',
  'ems_sculpting': 'EMS Muscle Sculpting',
  'pressotherapy': 'Pressotherapy',
  'skin_analyzer': 'Digital Skin Analyzer',
};

/// Mock spa skills options for spa therapists.
const Map<String, String> employeeMockSpaSkills = {
  'facial_treatment': 'Facial Treatment',
  'body_scrub': 'Body Scrub',
  'body_wrap': 'Body Wrap',
  'aromatherapy': 'Aromatherapy',
  'manicure_pedicure': 'Manicure & Pedicure',
  'waxing': 'Waxing',
  'skin_care': 'Skin Care',
};

/// Mock massage skills options for massage therapists.
const Map<String, String> employeeMockMassageSkills = {
  'swedish_massage': 'Swedish Massage',
  'deep_tissue': 'Deep Tissue',
  'hot_stone': 'Hot Stone',
  'thai_massage': 'Thai Massage',
  'shiatsu': 'Shiatsu',
  'reflexology': 'Reflexology',
  'sports_massage': 'Sports Massage',
  'trigger_point': 'Trigger Point',
};

// ============================================================================
// Mock Entity Factory Functions
// ============================================================================

/// Builds a common-field map for mock employee entities.
///
/// Generates role-appropriate names, avatar, contact info,
/// and document URLs based on [idSuffix] and [role].
Map<String, dynamic> getMockCommonFields(String idSuffix, String role) {
  final imageIndex = idSuffix.hashCode.abs() % employeeMockAvatarPaths.length;
  final avatarUrl = employeeMockAvatarPaths[imageIndex];

  return {
    'fullName': 'Mock $role Name $idSuffix',
    'displayName': 'Mock $role $idSuffix',
    'avatar': avatarUrl,
    'role': role.toUpperCase(),
    'employeeCode': 'EMP-${idSuffix.hashCode.abs() % 10000}',
    'position': role == 'Doctor' ? 'Specialist Doctor' : '$role Therapist',
    'rating': 4.5,
    'reviewCount': 100,
    'status': EmployeeStatusType.active.apiValue,
    'email': 'mock.$role.$idSuffix@example.com',
    'phone': '0901234567',
    'address': '123 Mock Street, District 1',
    'city': 'Ho Chi Minh City',
    'state': 'Ho Chi Minh',
    'country': 'Vietnam',
    'description': employeeMockDescription,
    'dateOfBirth': '1990-05-15',
    'gender': EmployeeGender.female.apiValue,
    'employmentType': EmploymentType.fullTime.displayName,
    'startDate': '2023-01-01',
    'emergencyContactName': 'Tran Thi B',
    'emergencyContactPhone': '0987654321',
  };
}

/// Creates a mock [DoctorEntity] with rich data.
DoctorEntity createMockDoctor(EmployeeId id) {
  final common = getMockCommonFields(id.value, 'Doctor');
  return DoctorEntity(
    id: id,
    employeeCode: common['employeeCode'],
    fullName: common['fullName'],
    displayName: common['displayName'],
    avatar: common['avatar'],
    role: EmployeeRoleType.doctor.apiValue,
    position: 'Senior Doctor',
    rating: common['rating'],
    reviewCount: common['reviewCount'],
    status: common['status'],
    email: common['email'],
    phone: common['phone'],
    address: common['address'],
    city: common['city'],
    state: common['state'],
    country: common['country'],
    description: common['description'],
    dateOfBirth: common['dateOfBirth'],
    gender: common['gender'],
    employmentType: common['employmentType'],
    startDate: common['startDate'],
    emergencyContactName: common['emergencyContactName'],
    emergencyContactPhone: common['emergencyContactPhone'],
    jobTitle: 'Dermatologist',
    medicalTitles: ['BS CKI', 'Thạc sĩ Y khoa'],
    medicalLicenses: ['MED-LICENSE-${id.value}', 'MED-LICENSE-ALT-${id.value}'],
    experienceYears: 12,
    consultationFee: 500000.0,
    specializations: ['Dermatology', 'Cosmetic Surgery', 'Laser Treatments'],
    education: [
      'MD - University of Medicine and Pharmacy',
      'PhD - Dermatological Research Institute',
    ],
    certifications: [
      'Board Certified Dermatologist',
      'Advanced Laser Safety Officer',
    ],
    workSchedule: employeeMockWorkSchedule,
    workHistory: employeeMockWorkHistory,
  );
}

/// Creates a mock [SpaTherapistEntity] with rich data.
SpaTherapistEntity createMockSpaTherapist(EmployeeId id) {
  final common = getMockCommonFields(id.value, 'Spa');
  return SpaTherapistEntity(
    id: id,
    employeeCode: common['employeeCode'],
    fullName: common['fullName'],
    displayName: common['displayName'],
    avatar: common['avatar'],
    role: EmployeeRoleType.therapist.apiValue,
    position: TherapistType.spa.displayName,
    rating: common['rating'],
    reviewCount: common['reviewCount'],
    status: common['status'],
    email: common['email'],
    phone: common['phone'],
    address: common['address'],
    city: common['city'],
    state: common['state'],
    country: common['country'],
    description: common['description'],
    dateOfBirth: common['dateOfBirth'],
    gender: common['gender'],
    employmentType: common['employmentType'],
    startDate: common['startDate'],
    emergencyContactName: common['emergencyContactName'],
    emergencyContactPhone: common['emergencyContactPhone'],
    jobTitle: 'Senior Spa Therapist',
    therapistLevel: TherapistLevel.senior.displayName,
    commissionRate: 15.0,
    healthCheckDate: DateTime.now()
        .subtract(const Duration(days: 30))
        .toIso8601String(),
    skills: ['Facial', 'Body Wrap', 'Aromatherapy', 'Skin Care'],
    deviceProficiency: ['Laser Machine', 'HIFU Device', 'Skin Analyzer'],
    workSchedule: employeeMockWorkSchedule,
    workHistory: employeeMockWorkHistory,
  );
}

/// Creates a mock [MassageTherapistEntity] with rich data.
MassageTherapistEntity createMockMassageTherapist(EmployeeId id) {
  final common = getMockCommonFields(id.value, 'Massage');
  return MassageTherapistEntity(
    id: id,
    employeeCode: common['employeeCode'],
    fullName: common['fullName'],
    displayName: common['displayName'],
    avatar: common['avatar'],
    role: EmployeeRoleType.therapist.apiValue,
    position: TherapistType.massage.displayName,
    rating: common['rating'],
    reviewCount: common['reviewCount'],
    status: common['status'],
    email: common['email'],
    phone: common['phone'],
    address: common['address'],
    city: common['city'],
    state: common['state'],
    country: common['country'],
    description: common['description'],
    dateOfBirth: common['dateOfBirth'],
    gender: common['gender'],
    employmentType: common['employmentType'],
    startDate: common['startDate'],
    emergencyContactName: common['emergencyContactName'],
    emergencyContactPhone: common['emergencyContactPhone'],
    jobTitle: 'Master Massage Therapist',
    therapistLevel: TherapistLevel.master.displayName,
    strengthLevel: MassageStrengthLevel.strong.displayName,
    commissionRate: 20.0,
    healthCheckDate: DateTime.now()
        .subtract(const Duration(days: 15))
        .toIso8601String(),
    skills: ['Thai Massage', 'Shiatsu', 'Deep Tissue', 'Reflexology'],
    workSchedule: employeeMockWorkSchedule,
    workHistory: employeeMockWorkHistory,
  );
}
