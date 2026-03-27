import 'package:admin_panel/features/admin/category/domain/category.entity.dart';

/// Mock data for categories - used by CategoryRemoteDataSourceMock
final List<CategoryEntity> categoryMockData = [
  CategoryEntity(
    id: CategoryId('1'),
    name: 'Home Cleaning',
    description:
        'Comprehensive deep cleaning services for residential homes including kitchens and bathrooms.',
    iconName: 'cleaning_services',
    colorValue: 0xFF6366F1, // indigo-500
    serviceCount: 15,
    isVisible: true,
    sortOrder: 0,
  ),
  CategoryEntity(
    id: CategoryId('2'),
    name: 'Plumbing',
    description:
        'Repairs and installation for pipes, faucets, and emergency leaks.',
    iconName: 'plumbing',
    colorValue: 0xFF3B82F6, // blue-500
    serviceCount: 8,
    isVisible: false,
    sortOrder: 1,
  ),
  CategoryEntity(
    id: CategoryId('3'),
    name: 'Electrical',
    description:
        'Wiring, electrical system maintenance, and lighting installations.',
    iconName: 'bolt',
    colorValue: 0xFFF59E0B, // amber-500
    serviceCount: 22,
    isVisible: true,
    sortOrder: 2,
  ),
  CategoryEntity(
    id: CategoryId('4'),
    name: 'Painting',
    description:
        'Interior and exterior painting services for all building types.',
    iconName: 'format_paint',
    colorValue: 0xFFF43F5E, // rose-500
    serviceCount: 5,
    isVisible: true,
    sortOrder: 3,
  ),
  CategoryEntity(
    id: CategoryId('5'),
    name: 'Gardening',
    description: 'Lawn care, landscaping, and seasonal garden maintenance.',
    iconName: 'yard',
    colorValue: 0xFF22C55E, // green-500
    serviceCount: 9,
    isVisible: false,
    sortOrder: 4,
  ),
  CategoryEntity(
    id: CategoryId('6'),
    name: 'Spa & Wellness',
    description:
        'Relaxation and wellness services including massage and aromatherapy.',
    iconName: 'spa',
    colorValue: 0xFFEC4899, // pink-500
    serviceCount: 18,
    isVisible: true,
    sortOrder: 5,
  ),
];
