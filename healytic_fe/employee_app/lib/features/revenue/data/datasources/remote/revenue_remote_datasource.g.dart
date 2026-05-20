// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(revenueRemoteDatasource)
const revenueRemoteDatasourceProvider = RevenueRemoteDatasourceProvider._();

final class RevenueRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          RevenueRemoteDatasource,
          RevenueRemoteDatasource,
          RevenueRemoteDatasource
        >
    with $Provider<RevenueRemoteDatasource> {
  const RevenueRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'revenueRemoteDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$revenueRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<RevenueRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RevenueRemoteDatasource create(Ref ref) {
    return revenueRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RevenueRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RevenueRemoteDatasource>(value),
    );
  }
}

String _$revenueRemoteDatasourceHash() =>
    r'bab3c7e8d1301c6a0840ee7bf39d5f20d76aa565';
