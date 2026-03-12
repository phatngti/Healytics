// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_manual.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches the service manual for a given
/// [appointmentId].

@ProviderFor(serviceManual)
const serviceManualProvider = ServiceManualFamily._();

/// Fetches the service manual for a given
/// [appointmentId].

final class ServiceManualProvider
    extends
        $FunctionalProvider<
          AsyncValue<ServiceManualEntity?>,
          ServiceManualEntity?,
          FutureOr<ServiceManualEntity?>
        >
    with
        $FutureModifier<ServiceManualEntity?>,
        $FutureProvider<ServiceManualEntity?> {
  /// Fetches the service manual for a given
  /// [appointmentId].
  const ServiceManualProvider._({
    required ServiceManualFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'serviceManualProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serviceManualHash();

  @override
  String toString() {
    return r'serviceManualProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ServiceManualEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ServiceManualEntity?> create(Ref ref) {
    final argument = this.argument as String;
    return serviceManual(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceManualProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serviceManualHash() => r'2b9eeac4fa90dfa1ba6d56d57bbbefd98f06ccbc';

/// Fetches the service manual for a given
/// [appointmentId].

final class ServiceManualFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ServiceManualEntity?>, String> {
  const ServiceManualFamily._()
    : super(
        retry: null,
        name: r'serviceManualProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches the service manual for a given
  /// [appointmentId].

  ServiceManualProvider call(String appointmentId) =>
      ServiceManualProvider._(argument: appointmentId, from: this);

  @override
  String toString() => r'serviceManualProvider';
}
