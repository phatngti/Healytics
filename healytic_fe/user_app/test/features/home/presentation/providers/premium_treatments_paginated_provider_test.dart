import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/home/data/provider/home.provider.dart'
    as data_provider;
import 'package:user_app/features/home/domain/entities/'
    'ai_recommendation.entity.dart';
import 'package:user_app/features/home/domain/entities/filter_sort.entity.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/home/domain/repositories/home.repository.dart';
import 'package:user_app/features/home/presentation/providers/home.provider.dart';
import 'package:user_app/features/orders/domain/entities/'
    'appointment.entity.dart';

void main() {
  test('home premium treatments appends four-card batches', () async {
    final repository = _FakeHomeRepository(
      List.generate(9, (index) => _product('home-service-$index')),
    );
    final container = ProviderContainer(
      overrides: [
        data_provider.homeRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final firstPage = await container.read(
      homePremiumTreatmentsPaginatedProvider.future,
    );

    expect(firstPage.products.length, 4);
    expect(firstPage.hasMore, isTrue);
    expect(firstPage.offset, 4);
    expect(repository.requests, const [_PageRequest(limit: 5, offset: 0)]);

    await container
        .read(homePremiumTreatmentsPaginatedProvider.notifier)
        .loadMore();

    final secondPage = container
        .read(homePremiumTreatmentsPaginatedProvider)
        .requireValue;
    expect(secondPage.products.length, 8);
    expect(secondPage.hasMore, isTrue);
    expect(secondPage.offset, 8);
    expect(repository.requests, const [
      _PageRequest(limit: 5, offset: 0),
      _PageRequest(limit: 5, offset: 4),
    ]);

    await container
        .read(homePremiumTreatmentsPaginatedProvider.notifier)
        .loadMore();

    final finalPage = container
        .read(homePremiumTreatmentsPaginatedProvider)
        .requireValue;
    expect(finalPage.products.length, 9);
    expect(finalPage.hasMore, isFalse);
    expect(finalPage.offset, 9);
    expect(repository.requests, const [
      _PageRequest(limit: 5, offset: 0),
      _PageRequest(limit: 5, offset: 4),
      _PageRequest(limit: 5, offset: 8),
    ]);
  });

  test('premium treatments appends pages until the final page', () async {
    final repository = _FakeHomeRepository(
      List.generate(25, (index) => _product('service-$index')),
    );
    final container = ProviderContainer(
      overrides: [
        data_provider.homeRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final firstPage = await container.read(
      premiumTreatmentsPaginatedProvider.future,
    );

    expect(firstPage.products.length, 12);
    expect(firstPage.hasMore, isTrue);
    expect(firstPage.offset, 12);
    expect(repository.requests, const [_PageRequest(limit: 13, offset: 0)]);

    await container
        .read(premiumTreatmentsPaginatedProvider.notifier)
        .loadMore();

    final secondPage = container
        .read(premiumTreatmentsPaginatedProvider)
        .requireValue;
    expect(secondPage.products.length, 24);
    expect(secondPage.hasMore, isTrue);
    expect(secondPage.offset, 24);
    expect(repository.requests, const [
      _PageRequest(limit: 13, offset: 0),
      _PageRequest(limit: 13, offset: 12),
    ]);

    await container
        .read(premiumTreatmentsPaginatedProvider.notifier)
        .loadMore();

    final finalPage = container
        .read(premiumTreatmentsPaginatedProvider)
        .requireValue;
    expect(finalPage.products.length, 25);
    expect(finalPage.hasMore, isFalse);
    expect(finalPage.offset, 25);
    expect(repository.requests, const [
      _PageRequest(limit: 13, offset: 0),
      _PageRequest(limit: 13, offset: 12),
      _PageRequest(limit: 13, offset: 24),
    ]);
  });
}

class _FakeHomeRepository implements HomeRepository {
  _FakeHomeRepository(this.products);

  final List<HomeProduct> products;
  final List<_PageRequest> requests = [];

  @override
  Future<List<HomeProduct>> getPremiumTreatments({
    ServiceListFilter? filter,
    int? limit,
    int? offset,
  }) async {
    final start = offset ?? 0;
    final end = limit == null ? products.length : start + limit;
    requests.add(_PageRequest(limit: limit, offset: offset));
    return products.sublist(start, end.clamp(start, products.length));
  }

  @override
  Future<List<HomeCategory>> getCategories() async => [];

  @override
  Future<List<HomeSpecialist>> getFeaturedSpecialists() async => [];

  @override
  Future<List<AiRecommendation>> getRecommendedProducts({
    required String userId,
    int topK = 5,
  }) async => [];

  @override
  Future<List<AppointmentEntity>> getRecentActivity({
    int limit = 5,
    RecentActivityFilter? filter,
  }) async => [];

  @override
  Future<List<ServiceTag>> getServiceTags() async => [];
}

class _PageRequest {
  const _PageRequest({required this.limit, required this.offset});

  final int? limit;
  final int? offset;

  @override
  bool operator ==(Object other) {
    return other is _PageRequest &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(limit, offset);

  @override
  String toString() => '_PageRequest(limit: $limit, offset: $offset)';
}

HomeProduct _product(String id) {
  return HomeProduct(
    id: id,
    name: id,
    slug: id,
    imageUrl: '',
    category: 'Spa',
    duration: '30 min',
    price: '100',
    priceAmount: 100,
  );
}
