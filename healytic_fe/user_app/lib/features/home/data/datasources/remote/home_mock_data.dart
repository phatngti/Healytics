import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';

/// Mock categories for development and testing.
final List<HomeCategory> kMockCategories = [
  const HomeCategory(
    id: 'cat-1',
    name: 'Spa',
    slug: 'spa-treatments',
    icon: Symbols.spa,
    categoryType: 'primary',
  ),
  const HomeCategory(
    id: 'cat-2',
    name: 'Wellness',
    slug: 'wellness-programs',
    icon: Symbols.self_improvement,
    categoryType: 'secondary',
  ),
  const HomeCategory(
    id: 'cat-3',
    name: 'Fitness',
    slug: 'fitness-training',
    icon: Symbols.fitness_center,
    categoryType: 'tertiary',
  ),
  const HomeCategory(
    id: 'cat-4',
    name: 'Mental Health',
    slug: 'mental-health',
    icon: Symbols.psychology,
    categoryType: 'error',
  ),
  const HomeCategory(
    id: 'cat-5',
    name: 'Therapy',
    slug: 'physical-therapy',
    icon: Symbols.accessibility_new,
    categoryType: 'tertiary',
  ),
  const HomeCategory(
    id: 'cat-6',
    name: 'Medical',
    slug: 'medical-services',
    icon: Symbols.medical_services,
    categoryType: 'primary',
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

/// Mock products for development and testing.
///
/// Includes both `service` and `physical` types so
/// [HomeNotifier] can correctly split recommended vs premium.
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
