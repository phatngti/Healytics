// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_reviews.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tracks the active review filter pill ID.
/// Defaults to `'all'`.

@ProviderFor(ClinicReviewFilterNotifier)
const clinicReviewFilterProvider = ClinicReviewFilterNotifierProvider._();

/// Tracks the active review filter pill ID.
/// Defaults to `'all'`.
final class ClinicReviewFilterNotifierProvider
    extends $NotifierProvider<ClinicReviewFilterNotifier, String> {
  /// Tracks the active review filter pill ID.
  /// Defaults to `'all'`.
  const ClinicReviewFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clinicReviewFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clinicReviewFilterNotifierHash();

  @$internal
  @override
  ClinicReviewFilterNotifier create() => ClinicReviewFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$clinicReviewFilterNotifierHash() =>
    r'8e39757422aabe185a3686937984e39eecae9654';

/// Tracks the active review filter pill ID.
/// Defaults to `'all'`.

abstract class _$ClinicReviewFilterNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Manages paginated review loading with server-side
/// filtering.
///
/// Watches the active filter pill. When the filter
/// changes, reloads from page 1 using server-side
/// params (`starCount`, `hasMedia`).

@ProviderFor(ClinicReviewsPaginated)
const clinicReviewsPaginatedProvider = ClinicReviewsPaginatedFamily._();

/// Manages paginated review loading with server-side
/// filtering.
///
/// Watches the active filter pill. When the filter
/// changes, reloads from page 1 using server-side
/// params (`starCount`, `hasMedia`).
final class ClinicReviewsPaginatedProvider
    extends
        $AsyncNotifierProvider<
          ClinicReviewsPaginated,
          ClinicReviewsAccumulated
        > {
  /// Manages paginated review loading with server-side
  /// filtering.
  ///
  /// Watches the active filter pill. When the filter
  /// changes, reloads from page 1 using server-side
  /// params (`starCount`, `hasMedia`).
  const ClinicReviewsPaginatedProvider._({
    required ClinicReviewsPaginatedFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'clinicReviewsPaginatedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clinicReviewsPaginatedHash();

  @override
  String toString() {
    return r'clinicReviewsPaginatedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ClinicReviewsPaginated create() => ClinicReviewsPaginated();

  @override
  bool operator ==(Object other) {
    return other is ClinicReviewsPaginatedProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clinicReviewsPaginatedHash() =>
    r'89dd57521300c5475eeb5912a9a08f7ea73fe40a';

/// Manages paginated review loading with server-side
/// filtering.
///
/// Watches the active filter pill. When the filter
/// changes, reloads from page 1 using server-side
/// params (`starCount`, `hasMedia`).

final class ClinicReviewsPaginatedFamily extends $Family
    with
        $ClassFamilyOverride<
          ClinicReviewsPaginated,
          AsyncValue<ClinicReviewsAccumulated>,
          ClinicReviewsAccumulated,
          FutureOr<ClinicReviewsAccumulated>,
          String
        > {
  const ClinicReviewsPaginatedFamily._()
    : super(
        retry: null,
        name: r'clinicReviewsPaginatedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Manages paginated review loading with server-side
  /// filtering.
  ///
  /// Watches the active filter pill. When the filter
  /// changes, reloads from page 1 using server-side
  /// params (`starCount`, `hasMedia`).

  ClinicReviewsPaginatedProvider call({required String clinicId}) =>
      ClinicReviewsPaginatedProvider._(argument: clinicId, from: this);

  @override
  String toString() => r'clinicReviewsPaginatedProvider';
}

/// Manages paginated review loading with server-side
/// filtering.
///
/// Watches the active filter pill. When the filter
/// changes, reloads from page 1 using server-side
/// params (`starCount`, `hasMedia`).

abstract class _$ClinicReviewsPaginated
    extends $AsyncNotifier<ClinicReviewsAccumulated> {
  late final _$args = ref.$arg as String;
  String get clinicId => _$args;

  FutureOr<ClinicReviewsAccumulated> build({required String clinicId});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(clinicId: _$args);
    final ref =
        this.ref
            as $Ref<
              AsyncValue<ClinicReviewsAccumulated>,
              ClinicReviewsAccumulated
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ClinicReviewsAccumulated>,
                ClinicReviewsAccumulated
              >,
              AsyncValue<ClinicReviewsAccumulated>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
