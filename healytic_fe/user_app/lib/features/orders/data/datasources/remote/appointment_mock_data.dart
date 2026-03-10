import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';

/// Mock appointments matching the HTML reference design.
final List<AppointmentEntity> kMockAppointments = [
  AppointmentEntity(
    id: 'apt-1',
    serviceName: 'Swedish Relax',
    vendorName: 'Glow Saigon Spa Retreat',
    imageUrl:
        'https://images.unsplash.com/photo-1544161515-4ab6ce6db874'
        '?w=800&h=400&fit=crop',
    status: 'upcoming',
    category: 'spa',
    providerName: 'Dr Alexander Linda',
    address:
        '311 Vo Van Tan, Ward 14\n'
        'District 1, HCM City, VN',
    date: DateTime(2026, 3, 9),
    checkInTime: '7:00 AM',
    checkOutTime: '7:30 AM',
    duration: 'About 1 hour',
  ),
  AppointmentEntity(
    id: 'apt-2',
    serviceName: 'Swedish Relax',
    vendorName: 'Glow Saigon Spa Retreat',
    imageUrl:
        'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2'
        '?w=800&h=400&fit=crop',
    status: 'upcoming',
    category: 'spa',
    providerName: 'Dr Alexander Linda',
    address:
        '311 Vo Van Tan, Ward 14\n'
        'District 1, HCM City, VN',
    date: DateTime(2026, 3, 9),
    checkInTime: '7:00 AM',
    checkOutTime: '7:30 AM',
    duration: 'About 1 hour',
  ),
  AppointmentEntity(
    id: 'apt-3',
    serviceName: 'Deep Tissue Recovery',
    vendorName: 'Zen Wellness Center',
    imageUrl:
        'https://images.unsplash.com/photo-1519823551278-64ac92734314'
        '?w=800&h=400&fit=crop',
    status: 'completed',
    category: 'wellness',
    providerName: 'Dr Maria Chen',
    address:
        '45 Nguyen Hue, Ben Nghe\n'
        'District 1, HCM City, VN',
    date: DateTime(2026, 2, 20),
    checkInTime: '10:00 AM',
    checkOutTime: '11:30 AM',
    duration: 'About 1.5 hours',
  ),
  AppointmentEntity(
    id: 'apt-4',
    serviceName: 'Facial Rejuvenation',
    vendorName: 'Beauty Lab Saigon',
    imageUrl:
        'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881'
        '?w=800&h=400&fit=crop',
    status: 'canceled',
    category: 'beauty',
    providerName: 'Dr Sofia Tran',
    address:
        '88 Le Thanh Ton, Ben Nghe\n'
        'District 1, HCM City, VN',
    date: DateTime(2026, 2, 15),
    checkInTime: '2:00 PM',
    checkOutTime: '2:45 PM',
    duration: 'About 45 min',
  ),
];

/// Mock category filters.
const List<AppointmentCategory> kMockAppointmentCategories = [
  AppointmentCategory(
    id: 'cat-all',
    name: 'All',
    iconSlug: 'check_circle_outline',
  ),
  AppointmentCategory(id: 'cat-spa', name: 'Spa', iconSlug: 'spa'),
  AppointmentCategory(
    id: 'cat-wellness',
    name: 'Wellness',
    iconSlug: 'self_improvement',
  ),
  AppointmentCategory(id: 'cat-beauty', name: 'Beauty', iconSlug: 'face'),
];

/// Mock recommended services.
const List<RecommendedServiceEntity> kMockRecommendedServices = [
  RecommendedServiceEntity(
    id: 'rec-1',
    name: 'Relaxation Massage',
    description: 'Based on your stress levels and preference',
    imageUrl:
        'https://images.unsplash.com/photo-1544161515-4ab6ce6db874'
        '?w=400&h=400&fit=crop',
    price: r'$89',
    duration: '60 min',
  ),
  RecommendedServiceEntity(
    id: 'rec-2',
    name: 'Aroma Therapy',
    description: 'Essential oils to boost your mood',
    imageUrl:
        'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108'
        '?w=400&h=400&fit=crop',
    price: r'$65',
    duration: '45 min',
  ),
];
