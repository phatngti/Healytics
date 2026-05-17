import 'dart:developer' as developer;

import 'package:admin_panel/features/partner/employee/domain/massage_strength_level.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_level.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee.provider.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Massage therapist-specific form fields including
/// therapist level, commission, strength, and skills.
class MassageTherapistFields extends ConsumerStatefulWidget {
  final String? initialTherapistLevel;
  final double? initialCommissionRate;
  final String? initialHealthCheckDate;
  final List<String> initialSkills;
  final String? initialStrengthLevel;

  const MassageTherapistFields({
    super.key,
    this.initialTherapistLevel,
    this.initialCommissionRate,
    this.initialHealthCheckDate,
    this.initialSkills = const [],
    this.initialStrengthLevel,
  });

  @override
  ConsumerState<MassageTherapistFields> createState() =>
      _MassageTherapistFieldsState();
}

class _MassageTherapistFieldsState
    extends ConsumerState<MassageTherapistFields> {
  late String _selectedStrength;
  late Future<Map<String, String>> _skillsFuture;

  /// Mutable copy of available options so we can add
  /// newly created skills without re-fetching.
  Map<String, String> _availableSkills = {};

  @override
  void initState() {
    super.initState();
    _selectedStrength =
        widget.initialStrengthLevel ??
        MassageStrengthLevel.medium.apiValue;
    _skillsFuture = _loadSkills();
  }

  Future<Map<String, String>> _loadSkills() async {
    final skills = await ref
        .read(employeeProvider.notifier)
        .getMassageSkills();
    _availableSkills = Map.of(skills);
    return _availableSkills;
  }

  static List<String> get _therapistLevels =>
      TherapistLevel.values
          .map((e) => e.displayName)
          .toList();

  /// Called when the chip selection changes.
  /// Checks if a newly typed entry already exists
  /// (by key or label) before calling the create API.
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


  /// Calls the API to create a new massage skill.
  /// On success, adds it to the local options map
  /// so it appears immediately in the chip field.
  Future<void> _persistNewSkill(String name) async {
    try {
      final result = await ref
          .read(employeeProvider.notifier)
          .createMassageSkill(name);
      setState(() {
        _availableSkills.addAll(result);
      });
      developer.log(
        'Created massage skill: $name',
        name: 'MassageTherapistFields',
      );
    } catch (e) {
      developer.log(
        'Failed to create skill: $e',
        name: 'MassageTherapistFields',
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
    final formEnabled =
        FormBuilder.of(context)?.enabled ?? true;
    final initialLevel =
        TherapistLevel.fromApiValue(
          widget.initialTherapistLevel,
        )?.displayName ??
        widget.initialTherapistLevel;

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
        _buildStrengthSelector(
          colorScheme,
          formEnabled,
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
          future: _skillsFuture,
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
              fieldKey: 'massage_skills',
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
      ],
    );
  }

  Widget _buildStrengthSelector(
    ColorScheme colorScheme,
    bool formEnabled,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: 'Massage Strength'.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          AppDimens.verticalMediumSmall,
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: formEnabled
                  ? colorScheme.surface
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                _StrengthButton(
                  label: MassageStrengthLevel
                      .soft.displayName,
                  isSelected:
                      _selectedStrength ==
                      MassageStrengthLevel.soft.apiValue,
                  isEnabled: formEnabled,
                  onTap: () {
                    if (formEnabled) {
                      setState(() {
                        _selectedStrength =
                            MassageStrengthLevel
                                .soft.apiValue;
                      });
                    }
                  },
                ),
                _StrengthButton(
                  label: MassageStrengthLevel
                      .medium.displayName,
                  isSelected:
                      _selectedStrength ==
                      MassageStrengthLevel
                          .medium.apiValue,
                  isEnabled: formEnabled,
                  onTap: () {
                    if (formEnabled) {
                      setState(() {
                        _selectedStrength =
                            MassageStrengthLevel
                                .medium.apiValue;
                      });
                    }
                  },
                ),
                _StrengthButton(
                  label: MassageStrengthLevel
                      .strong.displayName,
                  isSelected:
                      _selectedStrength ==
                      MassageStrengthLevel
                          .strong.apiValue,
                  isEnabled: formEnabled,
                  onTap: () {
                    if (formEnabled) {
                      setState(() {
                        _selectedStrength =
                            MassageStrengthLevel
                                .strong.apiValue;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          // Hidden field to store strength level in form
          FormBuilderField<String>(
            name: 'strength_level',
            initialValue: _selectedStrength,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Massage strength is required';
              }
              return null;
            },
            builder: (field) {
              if (field.value != _selectedStrength) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) {
                  field.didChange(_selectedStrength);
                });
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _StrengthButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  const _StrengthButton({
    required this.label,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Material(
        color: colorScheme.surface.withAlpha(0),
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer
                      .withValues(alpha: 0.5)
                  : null,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surface.withAlpha(0),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? colorScheme.primary
                        : (isEnabled
                              ? colorScheme
                                    .onSurfaceVariant
                              : colorScheme
                                    .onSurfaceVariant
                                    .withValues(
                                      alpha: 0.5,
                                    )),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
