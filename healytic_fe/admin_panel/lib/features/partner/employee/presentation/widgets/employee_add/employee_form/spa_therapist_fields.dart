import 'dart:developer' as developer;

import 'package:admin_panel/features/partner/employee/domain/therapist_level.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee.provider.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Spa therapist-specific form fields including
/// therapist level, commission, skills, and device
/// proficiency.
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
  ConsumerState<SpaTherapistFields> createState() =>
      _SpaTherapistFieldsState();
}

class _SpaTherapistFieldsState
    extends ConsumerState<SpaTherapistFields> {
  static List<String> get _therapistLevels =>
      TherapistLevel.values
          .map((e) => e.displayName)
          .toList();

  late Future<Map<String, String>> _spaSkillsFuture;
  late Future<Map<String, String>>
      _deviceProficiencyFuture;

  /// Mutable copy so newly created skills appear
  /// immediately without re-fetching.
  Map<String, String> _availableSkills = {};

  @override
  void initState() {
    super.initState();
    _spaSkillsFuture = _loadSpaSkills();
    _deviceProficiencyFuture = ref
        .read(employeeProvider.notifier)
        .getDeviceProficiency();
  }

  Future<Map<String, String>> _loadSpaSkills() async {
    final skills = await ref
        .read(employeeProvider.notifier)
        .getSpaSkills();
    _availableSkills = Map.of(skills);
    return _availableSkills;
  }

  /// Detects newly typed entries and persists them
  /// to the partner's spa skill catalog. Skips entries
  /// that already exist (by key or label).
  void _onSkillsChanged(List<String> selected) {
    for (final entry in selected) {
      if (_isExistingSkill(entry)) continue;
      _persistNewSkill(entry);
    }
  }

  /// Returns true if [value] matches any existing
  /// skill key or label (case-insensitive).
  bool _isExistingSkill(String value) {
    if (_availableSkills.containsKey(value)) return true;
    final lower = value.toLowerCase();
    return _availableSkills.values.any(
      (label) => label.toLowerCase() == lower,
    );
  }


  /// Calls the API to create a new spa skill.
  Future<void> _persistNewSkill(String name) async {
    try {
      final result = await ref
          .read(employeeProvider.notifier)
          .createSpaSkill(name);
      setState(() {
        _availableSkills.addAll(result);
      });
      developer.log(
        'Created spa skill: $name',
        name: 'SpaTherapistFields',
      );
    } catch (e) {
      developer.log(
        'Failed to create spa skill: $e',
        name: 'SpaTherapistFields',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to create skill: $name'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
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
                isRequired: true,
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
                initialValue:
                    widget.initialCommissionRate
                        ?.toString(),
                isRequired: true,
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
          isRequired: true,
        ),
        AppDimens.verticalMedium,
        FutureBuilder<Map<String, String>>(
          future: _spaSkillsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return FormFieldBuilders
                .buildMultiSelectChipField(
              context,
              fieldKey: 'spa_skills',
              label: 'Skill Set',
              availableOptions: _availableSkills,
              searchHint: 'Search or create skills...',
              helperText:
                  'Select existing skills or type a '
                  'new name and press Enter to create.',
              allowCreate: true,
              width: double.infinity,
              initialValue: widget.initialSkills,
              isRequired: true,
              onChanged: _onSkillsChanged,
            );
          },
        ),
        AppDimens.verticalMedium,
        FutureBuilder<Map<String, String>>(
          future: _deviceProficiencyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return FormFieldBuilders
                .buildMultiSelectPopoverField(
              context,
              fieldKey: 'device_proficiency',
              label: 'Device Proficiency',
              items: snapshot.data ?? {},
              searchHint:
                  'Search device proficiency...',
              initialValue:
                  widget.initialDeviceProficiency,
              isRequired: true,
            );
          },
        ),
      ],
    );
  }
}
