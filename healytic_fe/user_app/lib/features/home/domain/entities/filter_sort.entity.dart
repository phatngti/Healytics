enum ServiceListSort {
  defaultOrder('default', 'Default'),
  priceAsc('price_asc', 'Price ↑'),
  priceDesc('price_desc', 'Price ↓'),
  ratingDesc('rating_desc', 'Top rated'),
  latest('latest', 'Latest');

  const ServiceListSort(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

enum SpecialistListSort {
  defaultOrder('default', 'Default'),
  ratingDesc('rating_desc', 'Top rated'),
  experienceDesc('experience_desc', 'Experience'),
  reviewsDesc('reviews_desc', 'Reviews');

  const SpecialistListSort(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

enum RecentActivitySort {
  defaultOrder('default', 'Default'),
  dateDesc('date_desc', 'Newest'),
  dateAsc('date_asc', 'Oldest');

  const RecentActivitySort(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

class ServiceListFilter {
  const ServiceListFilter({
    this.sort = ServiceListSort.defaultOrder,
    this.minPrice,
    this.maxPrice,
    this.categoryId,
    this.clinicId,
    this.provinceId,
    this.districtId,
    this.wardId,
  });

  final ServiceListSort sort;
  final num? minPrice;
  final num? maxPrice;
  final String? categoryId;
  final String? clinicId;
  final String? provinceId;
  final String? districtId;
  final String? wardId;

  bool get hasFilters =>
      minPrice != null ||
      maxPrice != null ||
      _hasText(categoryId) ||
      _hasText(clinicId) ||
      _hasText(provinceId) ||
      _hasText(districtId) ||
      _hasText(wardId);

  bool get isActive => hasFilters || sort != ServiceListSort.defaultOrder;

  ServiceListFilter withSort(ServiceListSort value) {
    return ServiceListFilter(
      sort: value,
      minPrice: minPrice,
      maxPrice: maxPrice,
      categoryId: categoryId,
      clinicId: clinicId,
      provinceId: provinceId,
      districtId: districtId,
      wardId: wardId,
    );
  }
}

class SpecialistListFilter {
  const SpecialistListFilter({
    this.sort = SpecialistListSort.defaultOrder,
    this.role,
    this.clinicId,
    this.provinceId,
    this.districtId,
    this.wardId,
    this.minExperienceYears,
  });

  final SpecialistListSort sort;
  final String? role;
  final String? clinicId;
  final String? provinceId;
  final String? districtId;
  final String? wardId;
  final int? minExperienceYears;

  bool get hasFilters =>
      _hasText(role) ||
      _hasText(clinicId) ||
      _hasText(provinceId) ||
      _hasText(districtId) ||
      _hasText(wardId) ||
      minExperienceYears != null;

  bool get isActive => hasFilters || sort != SpecialistListSort.defaultOrder;

  SpecialistListFilter withSort(SpecialistListSort value) {
    return SpecialistListFilter(
      sort: value,
      role: role,
      clinicId: clinicId,
      provinceId: provinceId,
      districtId: districtId,
      wardId: wardId,
      minExperienceYears: minExperienceYears,
    );
  }
}

class RecentActivityFilter {
  const RecentActivityFilter({
    this.sort = RecentActivitySort.defaultOrder,
    this.status,
    this.categoryId,
    this.clinicId,
    this.fromDate,
    this.toDate,
  });

  final RecentActivitySort sort;
  final String? status;
  final String? categoryId;
  final String? clinicId;
  final DateTime? fromDate;
  final DateTime? toDate;

  bool get hasFilters =>
      _hasText(status) ||
      _hasText(categoryId) ||
      _hasText(clinicId) ||
      fromDate != null ||
      toDate != null;

  bool get isActive => hasFilters || sort != RecentActivitySort.defaultOrder;

  RecentActivityFilter withSort(RecentActivitySort value) {
    return RecentActivityFilter(
      sort: value,
      status: status,
      categoryId: categoryId,
      clinicId: clinicId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}

bool _hasText(String? value) => value != null && value.trim().isNotEmpty;
