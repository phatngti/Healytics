import 'package:flutter_riverpod/legacy.dart';
import 'package:user_app/features/home/domain/entities/filter_sort.entity.dart';

final bookingServiceFilterProvider = StateProvider<ServiceListFilter>(
  (ref) => const ServiceListFilter(),
);

final premiumTreatmentFilterProvider = StateProvider<ServiceListFilter>(
  (ref) => const ServiceListFilter(),
);

final recommendationFilterProvider = StateProvider<ServiceListFilter>(
  (ref) => const ServiceListFilter(),
);

final specialistListFilterProvider = StateProvider<SpecialistListFilter>(
  (ref) => const SpecialistListFilter(),
);

final recentActivityFilterProvider = StateProvider<RecentActivityFilter>(
  (ref) => const RecentActivityFilter(),
);
