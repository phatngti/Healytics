import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/home/domain/entities/'
    'ai_recommendation.entity.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/orders/domain/entities/'
    'appointment.entity.dart';

/// Mock categories for development and testing.
final List<HomeCategory> kMockCategories = [
  HomeCategory(
    id: 'root-nutrition',
    name: 'Nutrition',
    slug: 'nutrition-domain',
    icon: Symbols.medical_services,
    categoryType: 'primary',
    children: [
      HomeCategory(
        id: 'cat-6',
        name: 'Traditional Medicine',
        slug: 'traditional-medicine',
        parentId: 'root-nutrition',
        parentName: 'Nutrition',
        icon: Symbols.medical_services,
        categoryType: 'primary',
      ),
    ],
  ),
  HomeCategory(
    id: 'root-exercise',
    name: 'Exercise',
    slug: 'exercise-domain',
    icon: Symbols.fitness_center,
    categoryType: 'tertiary',
    children: [
      HomeCategory(
        id: 'cat-3',
        name: 'Fitness & Yoga',
        slug: 'fitness-training',
        parentId: 'root-exercise',
        parentName: 'Exercise',
        icon: Symbols.fitness_center,
        categoryType: 'tertiary',
      ),
      HomeCategory(
        id: 'cat-5',
        name: 'Rehabilitation Massage',
        slug: 'physical-therapy',
        parentId: 'root-exercise',
        parentName: 'Exercise',
        icon: Symbols.accessibility_new,
        categoryType: 'tertiary',
      ),
    ],
  ),
  HomeCategory(
    id: 'root-mental-therapy',
    name: 'Mental Therapy',
    slug: 'mental-therapy-domain',
    icon: Symbols.psychology,
    categoryType: 'error',
    children: [
      HomeCategory(
        id: 'cat-4',
        name: 'Mental Wellness',
        slug: 'mental-health',
        parentId: 'root-mental-therapy',
        parentName: 'Mental Therapy',
        icon: Symbols.psychology,
        categoryType: 'error',
      ),
    ],
  ),
  HomeCategory(
    id: 'root-spa-beauty',
    name: 'Spa & Beauty',
    slug: 'spa-beauty-domain',
    icon: Symbols.spa,
    categoryType: 'secondary',
    children: [
      HomeCategory(
        id: 'cat-1',
        name: 'Spa',
        slug: 'spa-treatments',
        parentId: 'root-spa-beauty',
        parentName: 'Spa & Beauty',
        icon: Symbols.spa,
        categoryType: 'primary',
      ),
      HomeCategory(
        id: 'cat-2',
        name: 'Relaxation Massage',
        slug: 'wellness-programs',
        parentId: 'root-spa-beauty',
        parentName: 'Spa & Beauty',
        icon: Symbols.self_improvement,
        categoryType: 'secondary',
      ),
    ],
  ),
];

/// Mock service tags for development and testing.
final List<ServiceTag> kMockServiceTags = [
  const ServiceTag(
    id: 'tag-1',
    name: 'Deep Tissue Massage',
    description: 'Therapeutic massage for muscle tension',
    colorValue: 0xFF6366F1,
    usage: 24,
    sortOrder: 1,
  ),
  const ServiceTag(
    id: 'tag-2',
    name: 'Swedish Massage',
    description: 'Relaxing full-body massage',
    colorValue: 0xFF8B5CF6,
    usage: 18,
    sortOrder: 2,
  ),
  const ServiceTag(
    id: 'tag-3',
    name: 'Hot Stone Therapy',
    description: 'Heated stone relaxation therapy',
    colorValue: 0xFFEC4899,
    usage: 12,
    sortOrder: 3,
  ),
  const ServiceTag(
    id: 'tag-4',
    name: 'Aromatherapy',
    description: 'Essential oil treatments',
    colorValue: 0xFF10B981,
    usage: 15,
    sortOrder: 4,
  ),
  const ServiceTag(
    id: 'tag-5',
    name: 'Sports Massage',
    description: 'Athletic recovery massage',
    colorValue: 0xFFF59E0B,
    usage: 9,
    sortOrder: 5,
  ),
  const ServiceTag(
    id: 'tag-6',
    name: 'Facial Treatment',
    description: 'Skincare and facial therapy',
    colorValue: 0xFF06B6D4,
    usage: 21,
    sortOrder: 6,
  ),
];

/// All mock products for development and testing.
///
/// Includes both `service` and `physical` types.
final List<HomeProduct> kMockProducts = [
  const HomeProduct(
    id: 'prod-1',
    name: 'Deep Tissue Massage',
    slug: 'deep-tissue-massage',
    imageUrl:
        'https://images.unsplash.com/photo-1544161515-4ab6ce6db874'
        '?w=400&h=300&fit=crop',
    category: 'Spa',
    duration: '60 min',
    price: '850000 VND',
    rating: '4.9',
    vendorName: 'Spa Harmony',
    location: 'District 1, Ho Chi Minh City',
    staffAvatars: [],
    type: 'service',
  ),
  const HomeProduct(
    id: 'prod-2',
    name: 'Yoga & Meditation',
    slug: 'yoga-meditation',
    imageUrl:
        'https://images.unsplash.com/photo-1506126613408-eca07ce68773'
        '?w=400&h=300&fit=crop',
    category: 'Wellness',
    duration: '45 min',
    price: '450000 VND',
    rating: '4.8',
    vendorName: 'Zen Studio',
    location: 'Thao Dien, Thu Duc City',
    staffAvatars: [],
    type: 'service',
  ),
  const HomeProduct(
    id: 'prod-3',
    name: 'Personal Training',
    slug: 'personal-training',
    imageUrl:
        'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b'
        '?w=400&h=300&fit=crop',
    category: 'Fitness',
    duration: '50 min',
    price: '600000 VND',
    rating: '4.7',
    vendorName: 'FitLife Center',
    location: 'District 7, Ho Chi Minh City',
    staffAvatars: [],
    type: 'service',
  ),
  const HomeProduct(
    id: 'prod-4',
    name: 'Aromatherapy Oil Set',
    slug: 'aromatherapy-oil-set',
    imageUrl:
        'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108'
        '?w=400&h=300&fit=crop',
    category: 'Wellness',
    duration: '',
    price: '350000 VND',
    rating: '4.6',
    vendorName: 'Nature Bliss',
    location: 'Binh Thanh District',
    staffAvatars: [],
    type: 'physical',
  ),
  const HomeProduct(
    id: 'prod-5',
    name: 'Hot Stone Therapy',
    slug: 'hot-stone-therapy',
    imageUrl:
        'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2'
        '?w=400&h=300&fit=crop',
    category: 'Spa',
    duration: '90 min',
    price: '1200000 VND',
    rating: '5.0',
    vendorName: 'Royal Spa',
    location: 'District 3, Ho Chi Minh City',
    staffAvatars: [],
    type: 'service',
  ),
  const HomeProduct(
    id: 'prod-6',
    name: 'Herbal Wellness Tea',
    slug: 'herbal-wellness-tea',
    imageUrl:
        'https://images.unsplash.com/photo-1556679343-c7306c1976bc'
        '?w=400&h=300&fit=crop',
    category: 'Wellness',
    duration: '',
    price: '180000 VND',
    rating: '4.5',
    vendorName: 'Tea Garden',
    location: 'Phu Nhuan District',
    staffAvatars: [],
    type: 'physical',
  ),
];

/// Mock recommended products (non-service items).
final List<HomeProduct> kMockRecommendedProducts = kMockProducts
    .where((p) => p.type != 'service')
    .toList();

/// Mock premium treatments (service items).
final List<HomeProduct> kMockPremiumTreatments = kMockProducts
    .where((p) => p.type == 'service')
    .toList();

/// Mock featured specialists for the home page.
final List<HomeSpecialist> kMockFeaturedSpecialists =
    const [
  HomeSpecialist(
    id: 'spec-1',
    name: 'Dr. Anna Nguyen',
    specialty: 'Spa Therapist',
    avatarUrl:
        'https://api.dicebear.com/9.x/avataaars/svg'
        '?seed=Anna',
    rating: 4.9,
    soldCount: 124,
    clinicName: 'Healytics Spa & Wellness',
  ),
  HomeSpecialist(
    id: 'spec-4',
    name: 'Dr. Hoa Le',
    specialty: 'Wellness Coach',
    avatarUrl:
        'https://api.dicebear.com/9.x/avataaars/svg'
        '?seed=Hoa',
    rating: 4.8,
    soldCount: 98,
    clinicName: 'Harmony Wellness Hub',
  ),
  HomeSpecialist(
    id: 'spec-6',
    name: 'Coach Duc Vo',
    specialty: 'Personal Trainer',
    avatarUrl:
        'https://api.dicebear.com/9.x/avataaars/svg'
        '?seed=Duc',
    rating: 4.7,
    soldCount: 76,
    clinicName: 'FitZone Gym',
  ),
  HomeSpecialist(
    id: 'spec-8',
    name: 'Dr. Tuan Phan',
    specialty: 'Psychologist',
    avatarUrl:
        'https://api.dicebear.com/9.x/avataaars/svg'
        '?seed=Tuan',
    rating: 5.0,
    soldCount: 203,
    clinicName: 'MindCare Clinic',
  ),
  HomeSpecialist(
    id: 'spec-9',
    name: 'Dr. Lan Bui',
    specialty: 'Physical Therapist',
    avatarUrl:
        'https://api.dicebear.com/9.x/avataaars/svg'
        '?seed=Lan',
    rating: 4.6,
    soldCount: 57,
    clinicName: 'PhysioPlus Rehab',
  ),
  HomeSpecialist(
    id: 'spec-11',
    name: 'Dr. Bao Hoang',
    specialty: 'General Physician',
    avatarUrl:
        'https://api.dicebear.com/9.x/avataaars/svg'
        '?seed=Bao',
    rating: 4.8,
    soldCount: 165,
    clinicName: 'Healytics Medical',
  ),
];

/// Mock AI-recommended services for development.
final List<AiRecommendation> kMockAiRecommendations =
    const [
  AiRecommendation(
    serviceId: 'prod-1',
    name: 'Deep Tissue Massage',
    imageUrl:
        'https://images.unsplash.com/photo-1544161515-4ab6ce6db874'
        '?w=400&h=300&fit=crop',
    badge: 'Popular',
    bookedCount: 124,
    price: '850,000 VND',
    priceAmount: 850000,
    currency: 'VND',
    rating: 4.9,
    totalReviews: 87,
    location: 'District 1, Ho Chi Minh City',
    staffName: 'Dr. Anna Nguyen',
    slots: ['09:00', '10:30', '14:00'],
  ),
  AiRecommendation(
    serviceId: 'prod-5',
    name: 'Hot Stone Therapy',
    imageUrl:
        'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2'
        '?w=400&h=300&fit=crop',
    badge: 'Top Rated',
    bookedCount: 98,
    price: '1,200,000 VND',
    priceAmount: 1200000,
    currency: 'VND',
    rating: 5.0,
    totalReviews: 63,
    location: 'District 3, Ho Chi Minh City',
    staffName: 'Dr. Hoa Le',
    slots: ['08:00', '11:00', '15:30'],
  ),
  AiRecommendation(
    serviceId: 'prod-2',
    name: 'Yoga & Meditation',
    imageUrl:
        'https://images.unsplash.com/photo-1506126613408-eca07ce68773'
        '?w=400&h=300&fit=crop',
    bookedCount: 76,
    price: '450,000 VND',
    priceAmount: 450000,
    currency: 'VND',
    rating: 4.8,
    totalReviews: 42,
    location: 'Thao Dien, Thu Duc City',
    slots: ['07:00', '16:00'],
  ),
];

/// Mock recent activities for the home dashboard.
final List<AppointmentEntity> kMockRecentActivities = [
  AppointmentEntity(
    id: 'appt-pending-1',
    serviceName: 'Hot Stone Therapy',
    healthPartnerName: 'Glow Saigon Spa Retreat',
    healthPartnerId: 'hp-3',
    imageUrl: '',
    status: 'pending_payment',
    category: 'Spa',
    specialistName: 'Dr. Anna Nguyen',
    address: 'District 1, HCMC',
    date: DateTime.now(),
    checkInTime: '14:00',
    checkOutTime: '15:00',
    duration: '60 min',
  ),
  AppointmentEntity(
    id: 'appt-1',
    serviceName: 'Aromatherapy',
    healthPartnerName: 'Spa Harmony',
    healthPartnerId: 'hp-1',
    imageUrl: '',
    status: 'completed',
    category: 'Spa',
    specialistName: 'Dr. Anna Nguyen',
    address: 'District 1, HCMC',
    date: DateTime.now().subtract(
      const Duration(days: 1),
    ),
    checkInTime: '15:00',
    checkOutTime: '16:00',
    duration: '60 min',
  ),
  AppointmentEntity(
    id: 'appt-2',
    serviceName: 'Wellness Consult',
    healthPartnerName: 'Harmony Wellness Hub',
    healthPartnerId: 'hp-2',
    imageUrl: '',
    status: 'upcoming',
    category: 'Wellness',
    specialistName: 'Dr. Hoa Le',
    address: 'Thao Dien, Thu Duc',
    date: DateTime.now().add(
      const Duration(days: 1),
    ),
    checkInTime: '10:00',
    checkOutTime: '11:00',
    duration: '60 min',
  ),
];
