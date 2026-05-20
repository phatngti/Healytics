/// Enum representing all form field keys used across
/// employee add/edit forms.
///
/// Centralises string literals to prevent typos and
/// enable IDE auto-complete.
enum EmployeeFormField {
  // ── Personal info ──────────────────────────────
  firstName('first_name'),
  lastName('last_name'),
  emailAddress('email_address'),
  password('password'),
  phoneNumber('phone_number'),
  avatarUrl('avatar_url'),
  dateOfBirth('date_of_birth'),
  gender('gender'),

  // ── Emergency contact ──────────────────────────
  emergencyContactName('emergency_contact_name'),
  emergencyContactPhone('emergency_contact_phone'),

  // ── Professional role ──────────────────────────
  employeeRole('employee_role'),
  employeeId('employee_id'),
  employmentType('employment_type'),
  startDate('start_date'),
  jobTitle('job_title'),
  description('description'),

  // ── Doctor-specific ────────────────────────────
  medicalTitlePrefix('medical_title_'),
  medicalLicensePrefix('medical_license_'),
  specializations('specializations'),
  education('education'),
  certifications('certifications'),
  experienceYears('experience_years'),
  consultationFee('consultation_fee'),

  // ── Therapist-specific ─────────────────────────
  therapistType('therapist_type'),
  therapistLevel('therapist_level'),
  commissionRate('commission_rate'),
  healthCheckDate('health_check_date'),
  spaSkills('spa_skills'),
  deviceProficiency('device_proficiency'),
  massageSkills('massage_skills'),
  strengthLevel('strength_level'),

  // ── Documents ──────────────────────────────────
  verificationDocuments('verification_documents'),

  // ── Work history ───────────────────────────────
  workHistory('work_history');

  const EmployeeFormField(this.key);

  /// The string key used in `FormBuilder` values map.
  final String key;
}
