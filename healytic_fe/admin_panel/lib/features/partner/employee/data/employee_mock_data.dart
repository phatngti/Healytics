import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';

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

/// Mock description text for employee testing.
const String employeeMockDescription = '''
Here is a detailed description for the mock employee.
- Highly experienced in their field.
- Certified by international boards.
- Friendly and professional demeanor.
- Available for consultations and treatments.
''';

/// Mock device proficiency options for spa therapist testing.
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

/// Mock spa skills options for spa therapist testing.
const Map<String, String> employeeMockSpaSkills = {
  'facial_treatment': 'Facial Treatment',
  'body_scrub': 'Body Scrub',
  'body_wrap': 'Body Wrap',
  'aromatherapy': 'Aromatherapy',
  'manicure_pedicure': 'Manicure & Pedicure',
  'waxing': 'Waxing',
  'skin_care': 'Skin Care',
};
