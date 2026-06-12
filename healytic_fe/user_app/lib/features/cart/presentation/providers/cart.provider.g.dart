// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Global cart state notifier.
///
/// Uses `keepAlive: true` so the cart badge count
/// survives navigation and the state persists while
/// the app is open. Data is re-fetched from the
/// backend on [build].

@ProviderFor(CartNotifier)
const cartProvider = CartNotifierProvider._();

/// Global cart state notifier.
///
/// Uses `keepAlive: true` so the cart badge count
/// survives navigation and the state persists while
/// the app is open. Data is re-fetched from the
/// backend on [build].
final class CartNotifierProvider
    extends $AsyncNotifierProvider<CartNotifier, CartState> {
  /// Global cart state notifier.
  ///
  /// Uses `keepAlive: true` so the cart badge count
  /// survives navigation and the state persists while
  /// the app is open. Data is re-fetched from the
  /// backend on [build].
  const CartNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartNotifierHash();

  @$internal
  @override
  CartNotifier create() => CartNotifier();
}

String _$cartNotifierHash() => r'3ec2500cb62cfd1caea26d167459dda0f2850221';

/// Global cart state notifier.
///
/// Uses `keepAlive: true` so the cart badge count
/// survives navigation and the state persists while
/// the app is open. Data is re-fetched from the
/// backend on [build].

abstract class _$CartNotifier extends $AsyncNotifier<CartState> {
  FutureOr<CartState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<CartState>, CartState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CartState>, CartState>,
              AsyncValue<CartState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Lightweight provider for the cart badge count.
///
/// Used by [HomeHeader] to show the cart icon badge
/// without pulling the full [CartState].

@ProviderFor(cartBadgeCount)
const cartBadgeCountProvider = CartBadgeCountProvider._();

/// Lightweight provider for the cart badge count.
///
/// Used by [HomeHeader] to show the cart icon badge
/// without pulling the full [CartState].

final class CartBadgeCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Lightweight provider for the cart badge count.
  ///
  /// Used by [HomeHeader] to show the cart icon badge
  /// without pulling the full [CartState].
  const CartBadgeCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartBadgeCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartBadgeCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return cartBadgeCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$cartBadgeCountHash() => r'de06986c8dc5e59ab83135f3d915cb70f26be2a6';

/// Fetches vouchers available for a specific
/// service and clinic combination.
///
/// Scoped per item so each cart entry shows
/// only relevant vouchers in its picker.

@ProviderFor(availableVouchersForItem)
const availableVouchersForItemProvider = AvailableVouchersForItemFamily._();

/// Fetches vouchers available for a specific
/// service and clinic combination.
///
/// Scoped per item so each cart entry shows
/// only relevant vouchers in its picker.

final class AvailableVouchersForItemProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VoucherEntity>>,
          List<VoucherEntity>,
          FutureOr<List<VoucherEntity>>
        >
    with
        $FutureModifier<List<VoucherEntity>>,
        $FutureProvider<List<VoucherEntity>> {
  /// Fetches vouchers available for a specific
  /// service and clinic combination.
  ///
  /// Scoped per item so each cart entry shows
  /// only relevant vouchers in its picker.
  const AvailableVouchersForItemProvider._({
    required AvailableVouchersForItemFamily super.from,
    required ({String serviceId, String clinicId}) super.argument,
  }) : super(
         retry: null,
         name: r'availableVouchersForItemProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$availableVouchersForItemHash();

  @override
  String toString() {
    return r'availableVouchersForItemProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<VoucherEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<VoucherEntity>> create(Ref ref) {
    final argument = this.argument as ({String serviceId, String clinicId});
    return availableVouchersForItem(
      ref,
      serviceId: argument.serviceId,
      clinicId: argument.clinicId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableVouchersForItemProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$availableVouchersForItemHash() =>
    r'b82cd8b041ac718769fd9bb3a6e7c30dcaf4ece7';

/// Fetches vouchers available for a specific
/// service and clinic combination.
///
/// Scoped per item so each cart entry shows
/// only relevant vouchers in its picker.

final class AvailableVouchersForItemFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<VoucherEntity>>,
          ({String serviceId, String clinicId})
        > {
  const AvailableVouchersForItemFamily._()
    : super(
        retry: null,
        name: r'availableVouchersForItemProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches vouchers available for a specific
  /// service and clinic combination.
  ///
  /// Scoped per item so each cart entry shows
  /// only relevant vouchers in its picker.

  AvailableVouchersForItemProvider call({
    required String serviceId,
    required String clinicId,
  }) => AvailableVouchersForItemProvider._(
    argument: (serviceId: serviceId, clinicId: clinicId),
    from: this,
  );

  @override
  String toString() => r'availableVouchersForItemProvider';
}
