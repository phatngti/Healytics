import 'package:admin_panel/features/partner/employee/domain/therapist_level.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee.provider.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpaTherapistFields extends ConsumerStatefulWidget {
  final String? initialTherapistLevel;
  final double? initialCommissionRate;
  final String? initialHealthCheckDate;
  final List<String> initialSkills;
  final List<String> initialDeviceProficiency;

  const SpaTherapistFields({
    super.key,
    this.initialTherapistLevel,
    this.initialCommissionRate,
    this.initialHealthCheckDate,
    this.initialSkills = const [],
    this.initialDeviceProficiency = const [],
  });

  @override
  ConsumerState<SpaTherapistFields> createState() => _SpaTherapistFieldsState();
}

class _SpaTherapistFieldsState extends ConsumerState<SpaTherapistFields> {
  static List<String> get _therapistLevels =>
      TherapistLevel.values.map((e) => e.displayName).toList();

  late Future<Map<String, String>> _spaSkillsFuture;
  late Future<Map<String, String>> _deviceProficiencyFuture;

  @override
  void initState() {
    super.initState();
    _spaSkillsFuture = ref.read(employeeProvider.notifier).getSpaSkills();
    _deviceProficiencyFuture = ref
        .read(employeeProvider.notifier)
        .getDeviceProficiency();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final initialLevel =
        TherapistLevel.fromApiValue(
          widget.initialTherapistLevel,
        )?.displayName ??
        widget.initialTherapistLevel ??
        _therapistLevels.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDimens.verticalMedium,
        Row(
          children: [
            Expanded(
              child: FormFieldBuilders.buildDropdownField(
                context,
                label: 'Therapist Level',
                items: _therapistLevels,
                fieldKey: 'therapist_level',
                initialValue: initialLevel,
              ),
            ),
            AppDimens.horizontalLarge,
            Expanded(
              child: FormFieldBuilders.buildTextField(
                context,
                fieldKey: 'commission_rate',
                label: 'Commission Rate',
                hintText: '0',
                keyboardType: TextInputType.number,
                suffixIcon: Icon(
                  Icons.percent,
                  color: colorScheme.onSurfaceVariant,
                ),
                initialValue: widget.initialCommissionRate?.toString(),
              ),
            ),
          ],
        ),
        AppDimens.verticalMedium,
        FormFieldBuilders.buildDateField(
          context,
          fieldKey: 'health_check_date',
          label: 'Last Health Check',
          hintText: 'Select date',
        ),
        AppDimens.verticalMedium,
        FutureBuilder<Map<String, String>>(
          future: _spaSkillsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return FormFieldBuilders.buildMultiSelectChipField(
              context,
              fieldKey: 'spa_skills',
              label: 'Skill Set',
              availableOptions: snapshot.data ?? {},
              searchHint: 'Search spa skills...',
              allowCreate: true,
              width: double.infinity,
              initialValue: widget.initialSkills,
            );
          },
        ),
        AppDimens.verticalMedium,
        FutureBuilder<Map<String, String>>(
          future: _deviceProficiencyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return FormFieldBuilders.buildMultiSelectPopoverField(
              context,
              fieldKey: 'device_proficiency',
              label: 'Device Proficiency',
              items: snapshot.data ?? {},
              searchHint: 'Search device proficiency...',
              initialValue: widget.initialDeviceProficiency,
            );
          },
        ),
      ],
    );
  }
}
