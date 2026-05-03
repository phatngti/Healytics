// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_list.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppointmentList)
const appointmentListProvider = AppointmentListFamily._();

final class AppointmentListProvider
    extends
        $AsyncNotifierProvider<
          AppointmentList,
          List<EmployeeAppointmentEntity>
        > {
  const AppointmentListProvider._({
    required AppointmentListFamily super.from,
    required EmployeeAppointmentStatus? super.argument,
  }) : super(
         retry: null,
         name: r'appointmentListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$appointmentListHash();

  @override
  String toString() {
    return r'appointmentListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AppointmentList create() => AppointmentList();

  @override
  bool operator ==(Object other) {
    return other is AppointmentListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$appointmentListHash() => r'87067c8a4f4524904e6a187a7a3a2e8277ba40e1';

final class AppointmentListFamily extends $Family
    with
        $ClassFamilyOverride<
          AppointmentList,
          AsyncValue<List<EmployeeAppointmentEntity>>,
          List<EmployeeAppointmentEntity>,
          FutureOr<List<EmployeeAppointmentEntity>>,
          EmployeeAppointmentStatus?
        > {
  const AppointmentListFamily._()
    : super(
        retry: null,
        name: r'appointmentListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AppointmentListProvider call({EmployeeAppointmentStatus? status}) =>
      AppointmentListProvider._(argument: status, from: this);

  @override
  String toString() => r'appointmentListProvider';
}

abstract class _$AppointmentList
    extends $AsyncNotifier<List<EmployeeAppointmentEntity>> {
  late final _$args = ref.$arg as EmployeeAppointmentStatus?;
  EmployeeAppointmentStatus? get status => _$args;

  FutureOr<List<EmployeeAppointmentEntity>> build({
    EmployeeAppointmentStatus? status,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(status: _$args);
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<EmployeeAppointmentEntity>>,
              List<EmployeeAppointmentEntity>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<EmployeeAppointmentEntity>>,
                List<EmployeeAppointmentEntity>
              >,
              AsyncValue<List<EmployeeAppointmentEntity>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
