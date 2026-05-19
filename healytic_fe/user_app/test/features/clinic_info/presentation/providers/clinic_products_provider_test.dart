import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';
import 'package:user_app/features/clinic_info/presentation/providers/clinic_products.provider.dart';

void main() {
  test('product filters default empty, apply, and reset', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(clinicProductFilterProvider).hasActiveFilters,
      isFalse,
    );

    container
        .read(clinicProductFilterProvider.notifier)
        .apply(
          const ClinicProductFilters(
            minPrice: 100000,
            maxPrice: 500000,
            minDuration: 30,
            maxDuration: 90,
            discountOnly: true,
          ),
        );

    final applied = container.read(clinicProductFilterProvider);
    expect(applied.minPrice, 100000);
    expect(applied.maxPrice, 500000);
    expect(applied.minDuration, 30);
    expect(applied.maxDuration, 90);
    expect(applied.discountOnly, isTrue);
    expect(applied.hasActiveFilters, isTrue);

    container.read(clinicProductFilterProvider.notifier).reset();

    expect(
      container.read(clinicProductFilterProvider).hasActiveFilters,
      isFalse,
    );
  });

  test('price sort toggles between ascending and descending', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(clinicProductSortProvider.notifier);

    notifier.togglePrice();
    expect(
      container.read(clinicProductSortProvider),
      ClinicProductSort.priceAsc,
    );

    notifier.togglePrice();
    expect(
      container.read(clinicProductSortProvider),
      ClinicProductSort.priceDesc,
    );
  });
}
