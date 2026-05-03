// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_impl.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(revenueRepository)
const revenueRepositoryProvider = RevenueRepositoryProvider._();

final class RevenueRepositoryProvider
    extends
        $FunctionalProvider<
          RevenueRepository,
          RevenueRepository,
          RevenueRepository
        >
    with $Provider<RevenueRepository> {
  const RevenueRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'revenueRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$revenueRepositoryHash();

  @$internal
  @override
  $ProviderElement<RevenueRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RevenueRepository create(Ref ref) {
    return revenueRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RevenueRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RevenueRepository>(value),
    );
  }
}

String _$revenueRepositoryHash() => r'19708ff0e1a40712f2bbd4bb7bc68985e56bb607';
