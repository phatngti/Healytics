import 'package:admin_panel/features/partner/service_tags/domain/service_tag.entity.dart';

/// Mock data for service tags - used by ServiceTagRemoteDataSourceMock
final List<ServiceTagEntity> mockServiceTags = [
  ServiceTagEntity(
    id: ServiceTagId('1'),
    name: 'High Priority',
    description: 'Urgent issues requiring immediate admin attention',
    colorValue: 0xFFEF4444, // red-500
    usage: 142,
    isActive: true,
    sortOrder: 0,
  ),
  ServiceTagEntity(
    id: ServiceTagId('2'),
    name: 'Bug Report',
    description: 'Technical glitches and software malfunctions',
    colorValue: 0xFFF59E0B, // amber-500
    usage: 89,
    isActive: true,
    sortOrder: 1,
  ),
  ServiceTagEntity(
    id: ServiceTagId('3'),
    name: 'Consultation',
    description: 'Pre-sales questions and general advice',
    colorValue: 0xFF6366F1, // indigo-500
    usage: 234,
    isActive: true,
    sortOrder: 2,
  ),
  ServiceTagEntity(
    id: ServiceTagId('4'),
    name: 'Maintenance',
    description: 'Scheduled system updates and checks',
    colorValue: 0xFF06B6D4, // cyan-500
    usage: 56,
    isActive: false,
    sortOrder: 3,
  ),
  ServiceTagEntity(
    id: ServiceTagId('5'),
    name: 'Access Request',
    description: 'Permissions and account access inquiries',
    colorValue: 0xFFA855F7, // purple-500
    usage: 11,
    isActive: true,
    sortOrder: 4,
  ),
];
