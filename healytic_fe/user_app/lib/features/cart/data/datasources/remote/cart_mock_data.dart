import 'package:user_app/features/cart/domain/entities/cart_item.entity.dart';
import 'package:user_app/features/cart/domain/entities/voucher.entity.dart';

/// Mock cart items with specialist and slot data.
///
/// Used by [CartRemoteDataSourceMock] for UI
/// development while the backend API is being built.
final kMockCartItems = <CartItemEntity>[
  CartItemEntity(
    id: 'cart-001',
    serviceId: 'svc-001',
    serviceName: 'Swedish Relax',
    serviceImageUrl: 'https://picsum.photos/seed/swedish/200',
    price: '500.000đ',
    priceAmount: 500000,
    clinicId: 'clinic-001',
    clinicName: 'Spa An Nhien',
    clinicAddress: '123 Dien Bien Phu, Q1, HCM',
    clinicImageUrl: 'https://picsum.photos/seed/clinic1/100',
    specialistId: 'emp-001',
    specialistName: 'Dr. Nguyen Van A',
    specialistPosition: 'Senior Therapist',
    slotTime: DateTime(2026, 11, 21, 10, 0),
    createdAt: DateTime(2026, 11, 21, 10, 0),
  ),
  CartItemEntity(
    id: 'cart-002',
    serviceId: 'svc-002',
    serviceName: 'Herbal Hot Stone',
    serviceImageUrl: 'https://picsum.photos/seed/hotstone/200',
    price: '500.000đ',
    priceAmount: 500000,
    clinicId: 'clinic-001',
    clinicName: 'Spa An Nhien',
    clinicAddress: '123 Dien Bien Phu, Q1, HCM',
    clinicImageUrl: 'https://picsum.photos/seed/clinic1/100',
    specialistId: 'emp-002',
    specialistName: 'Dr. Tran Thi B',
    specialistPosition: 'Lead Dermatologist',
    slotTime: DateTime(2026, 11, 22, 14, 30),
    createdAt: DateTime(2026, 11, 22, 14, 30),
  ),
];

/// Mock vouchers scoped by service / clinic.
///
/// Used by [CartRemoteDataSourceMock] to populate
/// the voucher picker bottom sheet.
final kMockVouchers = <VoucherEntity>[
  VoucherEntity(
    id: 'v-001',
    code: 'RELAX10',
    label: '10% off Swedish Relax',
    discountPercent: 10,
    maxDiscount: 100000,
    expiresAt: DateTime(2026, 12, 31),
    serviceId: 'svc-001',
    clinicId: 'clinic-001',
  ),
  VoucherEntity(
    id: 'v-002',
    code: 'SAVE5',
    label: '5% off all services',
    discountPercent: 5,
    expiresAt: DateTime(2026, 12, 31),
    clinicId: 'clinic-001',
  ),
  VoucherEntity(
    id: 'v-003',
    code: 'HOTSTONE15',
    label: '15% off Herbal Hot Stone',
    discountPercent: 15,
    maxDiscount: 150000,
    expiresAt: DateTime(2027, 1, 15),
    serviceId: 'svc-002',
    clinicId: 'clinic-001',
  ),
  VoucherEntity(
    id: 'v-004',
    code: 'WELCOME20',
    label: '20% new customer welcome',
    discountPercent: 20,
    maxDiscount: 200000,
    expiresAt: DateTime(2027, 3, 1),
  ),
];
