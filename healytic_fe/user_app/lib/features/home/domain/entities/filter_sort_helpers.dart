import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';
import 'package:user_app/features/home/domain/entities/ai_recommendation.entity.dart';
import 'package:user_app/features/home/domain/entities/filter_sort.entity.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';

List<HomeProduct> filterServiceProducts(
  List<HomeProduct> products,
  ServiceListFilter? filter,
) {
  final active = filter ?? const ServiceListFilter();
  final list = products.where((item) {
    if (active.minPrice != null && item.priceAmount < active.minPrice!) {
      return false;
    }
    if (active.maxPrice != null && item.priceAmount > active.maxPrice!) {
      return false;
    }
    if (!_matches(active.categoryId, item.categoryId) &&
        !_matches(active.categoryId, item.category)) {
      return false;
    }
    if (!_matches(active.clinicId, item.clinicId) &&
        !_matches(active.clinicId, item.vendorName)) {
      return false;
    }
    if (!_matchesAny([
      active.provinceId,
      active.districtId,
      active.wardId,
    ], item.location)) {
      return false;
    }
    return true;
  }).toList();

  if (active.sort != ServiceListSort.defaultOrder &&
      active.sort != ServiceListSort.latest) {
    list.sort((a, b) => _compareServices(a, b, active.sort));
  }
  return list;
}

List<AiRecommendation> filterRecommendations(
  List<AiRecommendation> items,
  ServiceListFilter filter,
) {
  final list = items.where((item) {
    if (filter.minPrice != null && item.priceAmount < filter.minPrice!) {
      return false;
    }
    if (filter.maxPrice != null && item.priceAmount > filter.maxPrice!) {
      return false;
    }
    if (!_matches(filter.categoryId, item.category)) return false;
    if (!_matches(filter.clinicId, item.vendorName)) return false;
    if (!_matchesAny([
      filter.provinceId,
      filter.districtId,
      filter.wardId,
    ], item.location)) {
      return false;
    }
    return true;
  }).toList();

  if (filter.sort != ServiceListSort.defaultOrder &&
      filter.sort != ServiceListSort.latest) {
    list.sort(
      (a, b) => switch (filter.sort) {
        ServiceListSort.priceAsc => a.priceAmount.compareTo(b.priceAmount),
        ServiceListSort.priceDesc => b.priceAmount.compareTo(a.priceAmount),
        ServiceListSort.ratingDesc => b.rating.compareTo(a.rating),
        _ => 0,
      },
    );
  }
  return list;
}

List<EmployeeDetailEntity> filterSpecialistsLocally(
  List<EmployeeDetailEntity> items,
  SpecialistListFilter filter,
) {
  final list = items.where((item) {
    if (!_matches(filter.role, item.role.name)) return false;
    if (!_matches(filter.clinicId, item.clinicId) &&
        !_matches(filter.clinicId, item.clinicName)) {
      return false;
    }
    if (!_matchesAny([
      filter.provinceId,
      filter.districtId,
      filter.wardId,
    ], item.location ?? '')) {
      return false;
    }
    if (filter.minExperienceYears != null &&
        (item.experienceYears ?? 0) < filter.minExperienceYears!) {
      return false;
    }
    return true;
  }).toList();

  if (filter.sort != SpecialistListSort.defaultOrder) {
    list.sort(
      (a, b) => switch (filter.sort) {
        SpecialistListSort.ratingDesc => b.rating.compareTo(a.rating),
        SpecialistListSort.experienceDesc => (b.experienceYears ?? 0).compareTo(
          a.experienceYears ?? 0,
        ),
        SpecialistListSort.reviewsDesc => b.reviewCount.compareTo(
          a.reviewCount,
        ),
        _ => 0,
      },
    );
  }
  return list;
}

List<AppointmentEntity> filterRecentActivitiesLocally(
  List<AppointmentEntity> items,
  RecentActivityFilter filter,
) {
  final list = items.where((item) {
    if (!_matches(filter.status, item.status)) return false;
    if (!_matches(filter.categoryId, item.category)) return false;
    if (!_matches(filter.clinicId, item.healthPartnerId) &&
        !_matches(filter.clinicId, item.healthPartnerName)) {
      return false;
    }
    if (filter.fromDate != null &&
        item.date.isBefore(_dateOnly(filter.fromDate!))) {
      return false;
    }
    if (filter.toDate != null &&
        item.date.isAfter(
          _dateOnly(filter.toDate!).add(const Duration(days: 1)),
        )) {
      return false;
    }
    return true;
  }).toList();

  if (filter.sort != RecentActivitySort.defaultOrder) {
    list.sort(
      (a, b) => switch (filter.sort) {
        RecentActivitySort.dateAsc => a.date.compareTo(b.date),
        RecentActivitySort.dateDesc => b.date.compareTo(a.date),
        _ => 0,
      },
    );
  }
  return list;
}

int _compareServices(HomeProduct a, HomeProduct b, ServiceListSort sort) {
  return switch (sort) {
    ServiceListSort.priceAsc => a.priceAmount.compareTo(b.priceAmount),
    ServiceListSort.priceDesc => b.priceAmount.compareTo(a.priceAmount),
    ServiceListSort.ratingDesc => _rating(
      b.rating,
    ).compareTo(_rating(a.rating)),
    _ => 0,
  };
}

bool _matches(String? needle, String? haystack) {
  final value = needle?.trim().toLowerCase();
  if (value == null || value.isEmpty) return true;
  return (haystack ?? '').toLowerCase().contains(value);
}

bool _matchesAny(List<String?> needles, String haystack) {
  final active = needles.where((value) => value?.trim().isNotEmpty ?? false);
  if (active.isEmpty) return true;
  final lower = haystack.toLowerCase();
  return active.any((value) => lower.contains(value!.trim().toLowerCase()));
}

double _rating(String value) => double.tryParse(value) ?? 0;

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
