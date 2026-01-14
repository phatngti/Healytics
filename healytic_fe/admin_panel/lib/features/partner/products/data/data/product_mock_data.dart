import 'package:admin_panel/features/partner/products/domain/category.entity.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';

// Default mock product for fallback
final Product productMockDefault = Product(
  id: const ProductId('default'),
  name: 'Swedish Relaxation Massage',
  description:
      'A classic massage technique designed to relax the entire body. This is accomplished by rubbing the muscles with long gliding strokes in the direction of blood returning to the heart. Swedish massage is exceptionally beneficial for increasing the level of oxygen in the blood, decreasing muscle toxins, and improving circulation and flexibility.',
  basePrice: 99.99,
  salePrice: 79.99,
  productType: 'service',
  status: 'active',
  category: const CategoryEntity(
    id: 'cat-massage',
    name: 'Massage Therapy',
    slug: 'massage-therapy',
  ),
  onlineStore: true,
  images: [
    'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=800',
    'https://images.unsplash.com/photo-1519823551278-64ac92734fb1?w=800',
  ],
  duration: 60,
  buffer: 15,
  capacity: 1,
  leadTime: 24,
  staffAllocation: 'any',
);

// Map of specific ID to mock product
final Map<String, Product> productMockData = {
  'mock-id-0': Product(
    id: const ProductId('mock-id-0'),
    name: 'Deep Tissue Massage',
    description:
        'A therapeutic massage technique that focuses on realigning deeper layers of muscles and connective tissue. Ideal for chronic aches and pains, stiff neck and upper back, low back pain, leg muscle tightness, and sore shoulders. Our certified therapists use slow, deliberate strokes that focus pressure on layers of muscles, tendons, or other tissues deep under your skin.',
    basePrice: 150.00,
    salePrice: 120.00,
    productType: 'service',
    status: 'active',
    category: const CategoryEntity(
      id: 'cat-massage',
      name: 'Massage Therapy',
      slug: 'massage-therapy',
    ),
    onlineStore: true,
    images: [
      'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=800',
      'https://images.unsplash.com/photo-1519823551278-64ac92734fb1?w=800',
      'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2?w=800',
    ],
    duration: 90,
    buffer: 15,
    capacity: 1,
    leadTime: 24,
    staffAllocation: 'specific',
  ),
  'mock-id-1': Product(
    id: const ProductId('mock-id-1'),
    name: 'Aromatherapy Session',
    description:
        'Experience the healing power of essential oils in our signature aromatherapy session. This holistic treatment combines gentle massage techniques with carefully selected pure essential oils to promote relaxation, improve mood, and enhance overall well-being. Perfect for stress relief and mental clarity.',
    basePrice: 120.00,
    salePrice: null,
    productType: 'service',
    status: 'active',
    category: const CategoryEntity(
      id: 'cat-wellness',
      name: 'Wellness',
      slug: 'wellness',
    ),
    onlineStore: true,
    images: [
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
      'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=800',
    ],
    duration: 60,
    buffer: 10,
    capacity: 1,
    leadTime: 12,
    staffAllocation: 'any',
  ),
  'mock-id-2': Product(
    id: const ProductId('mock-id-2'),
    name: 'Hot Stone Therapy',
    description:
        'Indulge in the ultimate relaxation experience with our hot stone therapy. Smooth, heated basalt stones are placed on key points of your body while your therapist uses traditional massage techniques. The warmth from the stones helps muscles relax, allowing for deeper pressure if desired. Benefits include improved circulation, stress relief, and muscle tension release.',
    basePrice: 180.00,
    salePrice: 150.00,
    productType: 'service',
    status: 'active',
    category: const CategoryEntity(
      id: 'cat-massage',
      name: 'Massage Therapy',
      slug: 'massage-therapy',
    ),
    onlineStore: true,
    images: [
      'https://images.unsplash.com/photo-1519823551278-64ac92734fb1?w=800',
      'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=800',
      'https://images.unsplash.com/photo-1515377905703-c4788e51af15?w=800',
      'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2?w=800',
    ],
    duration: 75,
    buffer: 20,
    capacity: 1,
    leadTime: 48,
    staffAllocation: 'specific',
  ),
  'mock-id-3': Product(
    id: const ProductId('mock-id-3'),
    name: 'Yoga Private Session',
    description:
        'One-on-one yoga instruction tailored to your experience level and goals. Whether you are a beginner looking to learn the basics or an advanced practitioner wanting to deepen your practice, our certified yoga instructors will create a personalized session just for you. Includes breathing exercises, asana practice, and relaxation techniques.',
    basePrice: 80.00,
    salePrice: null,
    productType: 'service',
    status: 'draft',
    category: const CategoryEntity(
      id: 'cat-fitness',
      name: 'Fitness & Yoga',
      slug: 'fitness-yoga',
    ),
    onlineStore: false,
    images: [
      'https://images.unsplash.com/photo-1575052814086-f385e2e2ad1b?w=800',
    ],
    duration: 60,
    buffer: 10,
    capacity: 1,
    leadTime: 6,
    staffAllocation: 'specific',
  ),
  'mock-id-4': Product(
    id: const ProductId('mock-id-4'),
    name: 'Facial Treatment Deluxe',
    description:
        'Our signature facial treatment designed to rejuvenate and refresh your skin. This comprehensive treatment includes deep cleansing, exfoliation, extraction, a customized mask, and hydrating serum application. Suitable for all skin types, this facial will leave your skin glowing and refreshed.',
    basePrice: 200.00,
    salePrice: 175.00,
    productType: 'service',
    status: 'active',
    category: const CategoryEntity(
      id: 'cat-skincare',
      name: 'Skincare',
      slug: 'skincare',
    ),
    onlineStore: true,
    images: [
      'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800',
      'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=800',
    ],
    duration: 90,
    buffer: 15,
    capacity: 1,
    leadTime: 24,
    staffAllocation: 'any',
  ),
};
