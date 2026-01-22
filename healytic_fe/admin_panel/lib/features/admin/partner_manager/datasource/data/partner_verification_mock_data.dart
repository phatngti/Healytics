import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';

/// Mock data for partner verification requests matching the HTML design
final List<PartnerVerificationEntity> partnerVerificationMockData = [
  PartnerVerificationEntity(
    id: PartnerVerificationId('SP-2023-001'),
    name: 'Hanoi Spa & Wellness',
    initials: 'HS',
    serviceTypes: ['Spa', 'Massage'],
    submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
    priority: PartnerPriority.high,
    status: PartnerVerificationStatus.pending,
    isEmailVerified: true,
    providerId: 'SP-2023-001',
    avatarColorStart: 0xFF6366F1, // Indigo
    avatarColorEnd: 0xFF9333EA, // Purple
  ),
  PartnerVerificationEntity(
    id: PartnerVerificationId('GYM-2023-042'),
    name: 'Elite Fitness Center',
    initials: 'EF',
    serviceTypes: ['Gym', 'Yoga'],
    submittedAt: DateTime.now().subtract(const Duration(hours: 4)),
    priority: PartnerPriority.normal,
    status: PartnerVerificationStatus.pending,
    isEmailVerified: false,
    providerId: 'GYM-2023-042',
  ),
  PartnerVerificationEntity(
    id: PartnerVerificationId('SP-2023-003'),
    name: 'Lotus Massage',
    initials: 'LM',
    serviceTypes: ['Massage'],
    submittedAt: DateTime.now().subtract(const Duration(days: 1)),
    priority: PartnerPriority.normal,
    status: PartnerVerificationStatus.pending,
    isEmailVerified: false,
    providerId: 'SP-2023-003',
  ),
  PartnerVerificationEntity(
    id: PartnerVerificationId('SP-2023-019'),
    name: 'Royal Sauna & Bath',
    initials: 'RS',
    serviceTypes: ['Sauna', 'Therapy'],
    submittedAt: DateTime.now().subtract(const Duration(days: 1)),
    priority: PartnerPriority.high,
    status: PartnerVerificationStatus.pending,
    isEmailVerified: true,
    providerId: 'SP-2023-019',
    avatarColorStart: 0xFFF97316, // Orange
    avatarColorEnd: 0xFFDC2626, // Red
  ),
  PartnerVerificationEntity(
    id: PartnerVerificationId('GYM-2023-011'),
    name: 'Ozone Gym',
    initials: 'OZ',
    serviceTypes: ['Gym'],
    submittedAt: DateTime.now().subtract(const Duration(days: 2)),
    priority: PartnerPriority.normal,
    status: PartnerVerificationStatus.approved,
    isEmailVerified: false,
    providerId: 'GYM-2023-011',
  ),
  PartnerVerificationEntity(
    id: PartnerVerificationId('SP-2023-000'),
    name: 'Fake Clinic',
    initials: 'FC',
    serviceTypes: ['Clinic'],
    submittedAt: DateTime.now().subtract(const Duration(days: 3)),
    priority: PartnerPriority.normal,
    status: PartnerVerificationStatus.rejected,
    isEmailVerified: false,
    providerId: 'SP-2023-000',
  ),
];
