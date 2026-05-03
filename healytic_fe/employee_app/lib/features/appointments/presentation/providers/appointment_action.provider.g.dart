// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_action.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppointmentAction)
const appointmentActionProvider = AppointmentActionProvider._();

final class AppointmentActionProvider
    extends $AsyncNotifierProvider<AppointmentAction, void> {
  const AppointmentActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentActionHash();

  @$internal
  @override
  AppointmentAction create() => AppointmentAction();
}

String _$appointmentActionHash() => r'513f41508b770fa63e2f0e416224f65c13acf072';

abstract class _$AppointmentAction extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
