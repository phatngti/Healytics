// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_preview_cache.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// In-memory cache of [EmployeePreview] data keyed
/// by employee ID.
///
/// Callers seed this cache before navigating to
/// [EmployeeDetailScreen] so the screen can render
/// an instant partial header while the full detail
/// loads in the background.

@ProviderFor(EmployeePreviewCache)
const employeePreviewCacheProvider = EmployeePreviewCacheProvider._();

/// In-memory cache of [EmployeePreview] data keyed
/// by employee ID.
///
/// Callers seed this cache before navigating to
/// [EmployeeDetailScreen] so the screen can render
/// an instant partial header while the full detail
/// loads in the background.
final class EmployeePreviewCacheProvider
    extends
        $NotifierProvider<EmployeePreviewCache, Map<String, EmployeePreview>> {
  /// In-memory cache of [EmployeePreview] data keyed
  /// by employee ID.
  ///
  /// Callers seed this cache before navigating to
  /// [EmployeeDetailScreen] so the screen can render
  /// an instant partial header while the full detail
  /// loads in the background.
  const EmployeePreviewCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeePreviewCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeePreviewCacheHash();

  @$internal
  @override
  EmployeePreviewCache create() => EmployeePreviewCache();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, EmployeePreview> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, EmployeePreview>>(value),
    );
  }
}

String _$employeePreviewCacheHash() =>
    r'c43b4ccdb25c020d20d3c1280d32dd9f2a089a4b';

/// In-memory cache of [EmployeePreview] data keyed
/// by employee ID.
///
/// Callers seed this cache before navigating to
/// [EmployeeDetailScreen] so the screen can render
/// an instant partial header while the full detail
/// loads in the background.

abstract class _$EmployeePreviewCache
    extends $Notifier<Map<String, EmployeePreview>> {
  Map<String, EmployeePreview> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<Map<String, EmployeePreview>, Map<String, EmployeePreview>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, EmployeePreview>,
                Map<String, EmployeePreview>
              >,
              Map<String, EmployeePreview>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
