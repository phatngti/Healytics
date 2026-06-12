import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';
import 'package:user_app/features/home/domain/entities/ai_recommendation.entity.dart';
import 'package:user_app/features/home/domain/entities/filter_sort.entity.dart';
import 'package:user_app/features/home/domain/entities/filter_sort_helpers.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';

void main() {
  test('filters and sorts service products', () {
    final products = [
      _product('a', price: 300, rating: '4.0', categoryId: 'spa'),
      _product('b', price: 100, rating: '5.0', categoryId: 'therapy'),
      _product('c', price: 200, rating: '4.5', categoryId: 'spa'),
    ];

    final result = filterServiceProducts(
      products,
      const ServiceListFilter(
        minPrice: 150,
        categoryId: 'spa',
        sort: ServiceListSort.priceAsc,
      ),
    );

    expect(result.map((item) => item.id), ['c', 'a']);
  });

  test('filters recommendations locally by recommender fields', () {
    final items = [
      _recommendation('a', price: 200, rating: 4.2, category: 'Spa'),
      _recommendation('b', price: 100, rating: 4.9, category: 'Therapy'),
    ];

    final result = filterRecommendations(
      items,
      const ServiceListFilter(
        categoryId: 'therapy',
        sort: ServiceListSort.ratingDesc,
      ),
    );

    expect(result.single.serviceId, 'b');
  });

  test('filters specialists by role and experience', () {
    final specialists = [
      _employee('a', EmployeeRole.doctor, experienceYears: 2, rating: 4),
      _employee('b', EmployeeRole.therapist, experienceYears: 6, rating: 5),
      _employee('c', EmployeeRole.doctor, experienceYears: 8, rating: 3),
    ];

    final result = filterSpecialistsLocally(
      specialists,
      const SpecialistListFilter(
        role: 'DOCTOR',
        minExperienceYears: 5,
        sort: SpecialistListSort.experienceDesc,
      ),
    );

    expect(result.map((item) => item.id), ['c']);
  });

  test('filters recent activities by status and date range', () {
    final items = [
      _appointment('a', 'completed', DateTime(2026, 5, 1)),
      _appointment('b', 'scheduled', DateTime(2026, 5, 15)),
      _appointment('c', 'completed', DateTime(2026, 5, 20)),
    ];

    final result = filterRecentActivitiesLocally(
      items,
      RecentActivityFilter(
        status: 'completed',
        fromDate: DateTime(2026, 5, 10),
        sort: RecentActivitySort.dateDesc,
      ),
    );

    expect(result.map((item) => item.id), ['c']);
  });
}

HomeProduct _product(
  String id, {
  required num price,
  required String rating,
  required String categoryId,
}) {
  return HomeProduct(
    id: id,
    name: id,
    slug: id,
    imageUrl: '',
    category: categoryId,
    categoryId: categoryId,
    duration: '30 min',
    price: '$price',
    priceAmount: price,
    rating: rating,
    vendorName: 'clinic',
    location: 'District 1',
  );
}

AiRecommendation _recommendation(
  String id, {
  required double price,
  required double rating,
  required String category,
}) {
  return AiRecommendation(
    serviceId: id,
    name: id,
    priceAmount: price,
    rating: rating,
    category: category,
    vendorName: 'clinic',
    location: 'District 1',
  );
}

EmployeeDetailEntity _employee(
  String id,
  EmployeeRole role, {
  required int experienceYears,
  required double rating,
}) {
  return EmployeeDetailEntity(
    id: id,
    employeeCode: id,
    fullName: id,
    role: role,
    status: EmployeeStatus.active,
    email: '$id@example.com',
    rating: rating,
    reviewCount: 0,
    clinicId: 'clinic',
    clinicName: 'Clinic',
    location: 'District 1',
    experienceYears: experienceYears,
  );
}

AppointmentEntity _appointment(String id, String status, DateTime date) {
  return AppointmentEntity(
    id: id,
    serviceName: id,
    healthPartnerName: 'Clinic',
    healthPartnerId: 'clinic',
    imageUrl: '',
    status: status,
    category: 'spa',
    specialistName: '',
    address: '',
    date: date,
    checkInTime: '09:00',
    checkOutTime: '',
    duration: '',
  );
}
