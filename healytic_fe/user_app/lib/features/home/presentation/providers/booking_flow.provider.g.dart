// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_flow.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod notifier managing the booking flow state
/// across all 3 wizard steps.
///
/// Uses [keepAlive] so state persists across screen
/// navigation (Step 1 → Step 2 → Step 3).

@ProviderFor(BookingFlow)
const bookingFlowProvider = BookingFlowProvider._();

/// Riverpod notifier managing the booking flow state
/// across all 3 wizard steps.
///
/// Uses [keepAlive] so state persists across screen
/// navigation (Step 1 → Step 2 → Step 3).
final class BookingFlowProvider
    extends $NotifierProvider<BookingFlow, BookingFlowState> {
  /// Riverpod notifier managing the booking flow state
  /// across all 3 wizard steps.
  ///
  /// Uses [keepAlive] so state persists across screen
  /// navigation (Step 1 → Step 2 → Step 3).
  const BookingFlowProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingFlowProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingFlowHash();

  @$internal
  @override
  BookingFlow create() => BookingFlow();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingFlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingFlowState>(value),
    );
  }
}

String _$bookingFlowHash() => r'a5680832026509dd97aa0e27faa715c808321764';

/// Riverpod notifier managing the booking flow state
/// across all 3 wizard steps.
///
/// Uses [keepAlive] so state persists across screen
/// navigation (Step 1 → Step 2 → Step 3).

abstract class _$BookingFlow extends $Notifier<BookingFlowState> {
  BookingFlowState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BookingFlowState, BookingFlowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookingFlowState, BookingFlowState>,
              BookingFlowState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
