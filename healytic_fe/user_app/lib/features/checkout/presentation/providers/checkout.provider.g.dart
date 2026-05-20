// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the booking parameters set by the service
/// details screen before navigating to checkout.
///
/// Reset to `null` when the checkout flow completes
/// or is cancelled.

@ProviderFor(BookingParamsNotifier)
const bookingParamsProvider = BookingParamsNotifierProvider._();

/// Holds the booking parameters set by the service
/// details screen before navigating to checkout.
///
/// Reset to `null` when the checkout flow completes
/// or is cancelled.
final class BookingParamsNotifierProvider
    extends $NotifierProvider<BookingParamsNotifier, BookingParams?> {
  /// Holds the booking parameters set by the service
  /// details screen before navigating to checkout.
  ///
  /// Reset to `null` when the checkout flow completes
  /// or is cancelled.
  const BookingParamsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingParamsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingParamsNotifierHash();

  @$internal
  @override
  BookingParamsNotifier create() => BookingParamsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingParams? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingParams?>(value),
    );
  }
}

String _$bookingParamsNotifierHash() =>
    r'b0a39d601da24d7e4ed215d070a279b8768fd108';

/// Holds the booking parameters set by the service
/// details screen before navigating to checkout.
///
/// Reset to `null` when the checkout flow completes
/// or is cancelled.

abstract class _$BookingParamsNotifier extends $Notifier<BookingParams?> {
  BookingParams? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BookingParams?, BookingParams?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookingParams?, BookingParams?>,
              BookingParams?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Notifier managing checkout screen interactions.
///
/// Builds [CheckoutData] directly from [BookingParams]
/// set by the service details screen — no remote fetch.

@ProviderFor(CheckoutNotifier)
const checkoutProvider = CheckoutNotifierProvider._();

/// Notifier managing checkout screen interactions.
///
/// Builds [CheckoutData] directly from [BookingParams]
/// set by the service details screen — no remote fetch.
final class CheckoutNotifierProvider
    extends $AsyncNotifierProvider<CheckoutNotifier, CheckoutState> {
  /// Notifier managing checkout screen interactions.
  ///
  /// Builds [CheckoutData] directly from [BookingParams]
  /// set by the service details screen — no remote fetch.
  const CheckoutNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutNotifierHash();

  @$internal
  @override
  CheckoutNotifier create() => CheckoutNotifier();
}

String _$checkoutNotifierHash() => r'8b61ddce3c8ef441f63a8b92ed0f632ffc6cceb3';

/// Notifier managing checkout screen interactions.
///
/// Builds [CheckoutData] directly from [BookingParams]
/// set by the service details screen — no remote fetch.

abstract class _$CheckoutNotifier extends $AsyncNotifier<CheckoutState> {
  FutureOr<CheckoutState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<CheckoutState>, CheckoutState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CheckoutState>, CheckoutState>,
              AsyncValue<CheckoutState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
