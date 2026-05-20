// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RevenueFilter)
const revenueFilterProvider = RevenueFilterProvider._();

final class RevenueFilterProvider
    extends $NotifierProvider<RevenueFilter, RevenueFilterState> {
  const RevenueFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'revenueFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$revenueFilterHash();

  @$internal
  @override
  RevenueFilter create() => RevenueFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RevenueFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RevenueFilterState>(value),
    );
  }
}

String _$revenueFilterHash() => r'b4919ddcee7199438fcac26878000c4be0d5a861';

abstract class _$RevenueFilter extends $Notifier<RevenueFilterState> {
  RevenueFilterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<RevenueFilterState, RevenueFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RevenueFilterState, RevenueFilterState>,
              RevenueFilterState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(revenue)
const revenueProvider = RevenueProvider._();

final class RevenueProvider
    extends
        $FunctionalProvider<
          AsyncValue<RevenueState>,
          RevenueState,
          FutureOr<RevenueState>
        >
    with $FutureModifier<RevenueState>, $FutureProvider<RevenueState> {
  const RevenueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'revenueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$revenueHash();

  @$internal
  @override
  $FutureProviderElement<RevenueState> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RevenueState> create(Ref ref) {
    return revenue(ref);
  }
}

String _$revenueHash() => r'6733f38a8a785d5c62e11e801f5b006710c8a505';
