import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';

/// Mock data for partner verification requests
/// matching the full status/priority model.
final List<PartnerVerificationEntity>
    partnerVerificationMockData = [
  PartnerVerificationEntity(
    id: PartnerVerificationId('SP-2023-001'),
    name: 'Hanoi Spa & Wellness',
    initials: 'HS',
    serviceTypes: ['Spa & Beauty', 'Massage Therapy'],
    submittedAt: DateTime.now().subtract(
      const Duration(hours: 2),
    ),
    priority: PartnerPriority.high,
    status: PartnerVerificationStatus.pending,
    isAccountActive: true,
    providerId: 'SP-2023-001',
    avatarColorStart: 0xFF6366F1,
    avatarColorEnd: 0xFF9333EA,
  ),
  PartnerVerificationEntity(
    id: PartnerVerificationId('GYM-2023-042'),
    name: 'Elite Fitness Center',
    initials: 'EF',
    serviceTypes: ['Fitness'],
    submittedAt: DateTime.now().subtract(
      const Duration(hours: 4),
    ),
    priority: PartnerPriority.normal,
    status: PartnerVerificationStatus.pending,
    isAccountActive: true,
    providerId: 'GYM-2023-042',
  ),
  PartnerVerificationEntity(
    id: PartnerVerificationId('SP-2023-003'),
    name: 'Lotus Massage',
    initials: 'LM',
    serviceTypes: ['Massage Therapy'],
    submittedAt: DateTime.now().subtract(
      const Duration(days: 1),
    ),
    priority: PartnerPriority.normal,
    status: PartnerVerificationStatus.pending,
    isAccountActive: true,
    providerId: 'SP-2023-003',
  ),
  PartnerVerificationEntity(
    id: PartnerVerificationId('SP-2023-019'),
    name: 'Royal Sauna & Bath',
    initials: 'RS',
    serviceTypes: ['Spa & Beauty'],
    submittedAt: DateTime.now().subtract(
      const Duration(days: 1),
    ),
    priority: PartnerPriority.high,
    status: PartnerVerificationStatus.requiredResubmit,
    isAccountActive: true,
    providerId: 'SP-2023-019',
    avatarColorStart: 0xFFF97316,
    avatarColorEnd: 0xFFDC2626,
  ),
  PartnerVerificationEntity(
    id: PartnerVerificationId('GYM-2023-011'),
    name: 'Ozone Gym',
    initials: 'OZ',
    serviceTypes: ['Fitness'],
    submittedAt: DateTime.now().subtract(
      const Duration(days: 2),
    ),
    priority: PartnerPriority.normal,
    status: PartnerVerificationStatus.approved,
    isAccountActive: true,
    providerId: 'GYM-2023-011',
  ),
  PartnerVerificationEntity(
    id: PartnerVerificationId('SP-2023-000'),
    name: 'Fake Clinic',
    initials: 'FC',
    serviceTypes: ['Dental'],
    submittedAt: DateTime.now().subtract(
      const Duration(days: 3),
    ),
    priority: PartnerPriority.normal,
    status: PartnerVerificationStatus.rejected,
    isAccountActive: false,
    providerId: 'SP-2023-000',
  ),
];
