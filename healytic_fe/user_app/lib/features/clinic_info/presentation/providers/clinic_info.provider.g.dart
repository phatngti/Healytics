// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_info.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches clinic info by [clinicId].
///
/// Uses a family parameter so each clinic ID gets
/// its own cached async state.

@ProviderFor(clinicInfo)
const clinicInfoProvider = ClinicInfoFamily._();

/// Fetches clinic info by [clinicId].
///
/// Uses a family parameter so each clinic ID gets
/// its own cached async state.

final class ClinicInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<ClinicInfoEntity>,
          ClinicInfoEntity,
          FutureOr<ClinicInfoEntity>
        >
    with $FutureModifier<ClinicInfoEntity>, $FutureProvider<ClinicInfoEntity> {
  /// Fetches clinic info by [clinicId].
  ///
  /// Uses a family parameter so each clinic ID gets
  /// its own cached async state.
  const ClinicInfoProvider._({
    required ClinicInfoFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'clinicInfoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clinicInfoHash();

  @override
  String toString() {
    return r'clinicInfoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ClinicInfoEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ClinicInfoEntity> create(Ref ref) {
    final argument = this.argument as String;
    return clinicInfo(ref, clinicId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ClinicInfoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clinicInfoHash() => r'23ef174900568f4109d454d0fde2cabbb196aa03';

/// Fetches clinic info by [clinicId].
///
/// Uses a family parameter so each clinic ID gets
/// its own cached async state.

final class ClinicInfoFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ClinicInfoEntity>, String> {
  const ClinicInfoFamily._()
    : super(
        retry: null,
        name: r'clinicInfoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches clinic info by [clinicId].
  ///
  /// Uses a family parameter so each clinic ID gets
  /// its own cached async state.

  ClinicInfoProvider call({required String clinicId}) =>
      ClinicInfoProvider._(argument: clinicId, from: this);

  @override
  String toString() => r'clinicInfoProvider';
}
