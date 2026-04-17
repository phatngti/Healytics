import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';

/// Mock appointments matching the HTML reference design.
final List<AppointmentEntity> kMockAppointments = [
  AppointmentEntity(
    id: 'apt-pending-1',
    serviceName: 'Hot Stone Therapy',
    healthPartnerName: 'Glow Saigon Spa Retreat',
    healthPartnerId: 'vendor-spa-1',
    imageUrl:
        'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2'
        '?w=800&h=400&fit=crop',
    status: 'pending_payment',
    category: 'spa',
    specialistName: 'Dr Alexander Linda',
    address:
        '311 Vo Van Tan, Ward 14\n'
        'District 1, HCM City, VN',
    date: DateTime.now().add(const Duration(days: 2)),
    checkInTime: '9:00 AM',
    checkOutTime: '10:00 AM',
    duration: 'About 1 hour',
    distanceKm: 2.5,
    specialistId: 'emp-doctor-1',
    serviceId: 'svc-hot-stone',
    paymentUrl:
        'https://checkout.stripe.com/c/pay/cs_mock_123',
    paymentDeeplink: 'momo://app?action=payWithApp'
        '&amount=500000&isScanQR=false',
    paymentExpiresAt: DateTime.now().add(
      const Duration(minutes: 10),
    ),
  ),
  AppointmentEntity(
    id: 'apt-pending-2',
    serviceName: 'Hydrating Facial',
    healthPartnerName: 'Beauty Lab Saigon',
    healthPartnerId: 'vendor-beauty-1',
    imageUrl:
        'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881'
        '?w=800&h=400&fit=crop',
    status: 'pending_payment',
    category: 'beauty',
    specialistName: 'Dr Sofia Tran',
    address:
        '88 Le Thanh Ton, Ben Nghe\n'
        'District 1, HCM City, VN',
    date: DateTime.now().add(const Duration(days: 5)),
    checkInTime: '2:00 PM',
    checkOutTime: '3:00 PM',
    duration: 'About 1 hour',
    distanceKm: 4.2,
    specialistId: 'emp-doctor-1',
    serviceId: 'svc-hydrating-facial',
    paymentUrl:
        'https://checkout.stripe.com/c/pay/cs_mock_456',
    paymentDeeplink: 'momo://app?action=payWithApp'
        '&amount=350000&isScanQR=false',
    paymentExpiresAt: DateTime.now().add(
      const Duration(minutes: 7),
    ),
  ),
  AppointmentEntity(
    id: 'apt-1',
    serviceName: 'Swedish Relax',
    healthPartnerName: 'Glow Saigon Spa Retreat',
    healthPartnerId: 'vendor-spa-1',
    imageUrl:
        'https://images.unsplash.com/photo-1544161515-4ab6ce6db874'
        '?w=800&h=400&fit=crop',
    status: 'upcoming',
    category: 'spa',
    specialistName: 'Dr Alexander Linda',
    address:
        '311 Vo Van Tan, Ward 14\n'
        'District 1, HCM City, VN',
    date: DateTime(2026, 3, 9),
    checkInTime: '7:00 AM',
    checkOutTime: '7:30 AM',
    duration: 'About 1 hour',
    distanceKm: 2.5,
    specialistId: 'emp-doctor-1',
    serviceId: 'svc-swedish-relax',
  ),
  AppointmentEntity(
    id: 'apt-2',
    serviceName: 'Swedish Relax',
    healthPartnerName: 'Glow Saigon Spa Retreat',
    healthPartnerId: 'vendor-spa-1',
    imageUrl:
        'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2'
        '?w=800&h=400&fit=crop',
    status: 'upcoming',
    category: 'spa',
    specialistName: 'Dr Alexander Linda',
    address:
        '311 Vo Van Tan, Ward 14\n'
        'District 1, HCM City, VN',
    date: DateTime(2026, 3, 9),
    checkInTime: '7:00 AM',
    checkOutTime: '7:30 AM',
    duration: 'About 1 hour',
    distanceKm: 3.1,
    specialistId: 'emp-doctor-1',
    serviceId: 'svc-swedish-relax',
  ),
  AppointmentEntity(
    id: 'apt-3',
    serviceName: 'Deep Tissue Recovery',
    healthPartnerName: 'Zen Wellness Center',
    healthPartnerId: 'vendor-wellness-1',
    imageUrl:
        'https://images.unsplash.com/photo-1519823551278-64ac92734314'
        '?w=800&h=400&fit=crop',
    status: 'completed',
    category: 'wellness',
    specialistName: 'Dr Maria Chen',
    address:
        '45 Nguyen Hue, Ben Nghe\n'
        'District 1, HCM City, VN',
    date: DateTime(2026, 2, 20),
    checkInTime: '10:00 AM',
    checkOutTime: '11:30 AM',
    duration: 'About 1.5 hours',
    distanceKm: 1.8,
    specialistId: 'emp-therapist-1',
    serviceId: 'svc-deep-tissue',
    isReviewed: true,
  ),
  AppointmentEntity(
    id: 'apt-4',
    serviceName: 'Facial Rejuvenation',
    healthPartnerName: 'Beauty Lab Saigon',
    healthPartnerId: 'vendor-beauty-1',
    imageUrl:
        'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881'
        '?w=800&h=400&fit=crop',
    status: 'canceled',
    category: 'beauty',
    specialistName: 'Dr Sofia Tran',
    address:
        '88 Le Thanh Ton, Ben Nghe\n'
        'District 1, HCM City, VN',
    date: DateTime(2026, 2, 15),
    checkInTime: '2:00 PM',
    checkOutTime: '2:45 PM',
    duration: 'About 45 min',
    distanceKm: 4.2,
    specialistId: 'emp-doctor-1',
    serviceId: 'svc-facial-rejuv',
  ),
  AppointmentEntity(
    id: 'apt-5',
    serviceName: 'Sports Recovery Therapy',
    healthPartnerName: 'Zen Wellness Center',
    healthPartnerId: 'vendor-wellness-1',
    imageUrl:
        'https://images.unsplash.com/photo-1519824145371-296894a0daa9'
        '?w=800&h=400&fit=crop',
    status: 'upcoming',
    category: 'wellness',
    specialistName: 'Therapist Nguyen Linh',
    address:
        '45 Nguyen Hue, Ben Nghe\n'
        'District 1, HCM City, VN',
    date: DateTime(2026, 3, 22),
    checkInTime: '9:00 AM',
    checkOutTime: '10:00 AM',
    duration: 'About 1 hour',
    distanceKm: 2.1,
    specialistId: 'emp-therapist-1',
    serviceId: 'svc-sports-recovery',
  ),
  AppointmentEntity(
    id: 'apt-6',
    serviceName: 'Posture Correction',
    healthPartnerName: 'Zen Wellness Center',
    healthPartnerId: 'vendor-wellness-1',
    imageUrl:
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b'
        '?w=800&h=400&fit=crop',
    status: 'completed',
    category: 'wellness',
    specialistName: 'Therapist Nguyen Linh',
    address:
        '45 Nguyen Hue, Ben Nghe\n'
        'District 1, HCM City, VN',
    date: DateTime(2026, 3, 10),
    checkInTime: '3:00 PM',
    checkOutTime: '4:00 PM',
    duration: 'About 1 hour',
    distanceKm: 2.1,
    specialistId: 'emp-therapist-1',
    serviceId: 'svc-posture-correct',
    isReviewed: false,
  ),
];

/// Mock category filters.
const List<AppointmentCategory>
    kMockAppointmentCategories = [
  AppointmentCategory(
    id: 'cat-all',
    name: 'All',
    iconSlug: 'check_circle_outline',
  ),
  AppointmentCategory(
    id: 'cat-spa',
    name: 'Spa',
    iconSlug: 'spa',
  ),
  AppointmentCategory(
    id: 'cat-wellness',
    name: 'Wellness',
    iconSlug: 'self_improvement',
  ),
  AppointmentCategory(
    id: 'cat-beauty',
    name: 'Beauty',
    iconSlug: 'face',
  ),
];

/// Mock recommended services.
const List<RecommendedServiceEntity>
    kMockRecommendedServices = [
  RecommendedServiceEntity(
    id: 'rec-1',
    name: 'Relaxation Massage',
    description:
        'Based on your stress levels and preference',
    imageUrl:
        'https://images.unsplash.com/photo-1544161515-4ab6ce6db874'
        '?w=400&h=400&fit=crop',
    price: r'$89',
    duration: '60 min',
  ),
  RecommendedServiceEntity(
    id: 'rec-2',
    name: 'Aroma Therapy',
    description:
        'Essential oils to boost your mood',
    imageUrl:
        'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108'
        '?w=400&h=400&fit=crop',
    price: r'$65',
    duration: '45 min',
  ),
];
