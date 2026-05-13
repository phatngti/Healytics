import 'package:admin_panel/features/partner/employee/domain/massage_strength_level.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_level.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class MassageTherapistFields extends StatefulWidget {
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
  State<MassageTherapistFields> createState() => _MassageTherapistFieldsState();
}

class _MassageTherapistFieldsState extends State<MassageTherapistFields> {
  late String _selectedStrength;

  @override
  void initState() {
    super.initState();
    _selectedStrength =
        widget.initialStrengthLevel ?? MassageStrengthLevel.medium.apiValue;
  }

  static List<String> get _therapistLevels =>
      TherapistLevel.values.map((e) => e.displayName).toList();

  static const Map<String, String> _massageSkills = {
    'swedish_massage': 'Swedish Massage',
    'deep_tissue': 'Deep Tissue',
    'hot_stone': 'Hot Stone',
    'thai_massage': 'Thai Massage',
    'shiatsu': 'Shiatsu',
    'reflexology': 'Reflexology',
    'sports_massage': 'Sports Massage',
    'trigger_point': 'Trigger Point',
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formEnabled = FormBuilder.of(context)?.enabled ?? true;
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Massage Strength',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
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
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    _StrengthButton(
                      label: MassageStrengthLevel.soft.displayName,
                      isSelected:
                          _selectedStrength ==
                          MassageStrengthLevel.soft.apiValue,
                      isEnabled: formEnabled,
                      onTap: () {
                        if (formEnabled) {
                          setState(() {
                            _selectedStrength =
                                MassageStrengthLevel.soft.apiValue;
                          });
                        }
                      },
                    ),
                    _StrengthButton(
                      label: MassageStrengthLevel.medium.displayName,
                      isSelected:
                          _selectedStrength ==
                          MassageStrengthLevel.medium.apiValue,
                      isEnabled: formEnabled,
                      onTap: () {
                        if (formEnabled) {
                          setState(() {
                            _selectedStrength =
                                MassageStrengthLevel.medium.apiValue;
                          });
                        }
                      },
                    ),
                    _StrengthButton(
                      label: MassageStrengthLevel.strong.displayName,
                      isSelected:
                          _selectedStrength ==
                          MassageStrengthLevel.strong.apiValue,
                      isEnabled: formEnabled,
                      onTap: () {
                        if (formEnabled) {
                          setState(() {
                            _selectedStrength =
                                MassageStrengthLevel.strong.apiValue;
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
                builder: (field) {
                  // Update field when selection changes
                  if (field.value != _selectedStrength) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      field.didChange(_selectedStrength);
                    });
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
        AppDimens.verticalMedium,
        FormFieldBuilders.buildDateField(
          context,
          fieldKey: 'health_check_date',
          label: 'Last Health Check',
          hintText: 'Select date',
        ),
        AppDimens.verticalMedium,
        FormFieldBuilders.buildMultiSelectChipField(
          context,
          fieldKey: 'massage_skills',
          label: 'Skill Set',
          availableOptions: _massageSkills,
          searchHint: 'Search massage skills...',
          allowCreate: true,
          width: double.infinity,
          initialValue: widget.initialSkills,
        ),
      ],
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
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer.withValues(alpha: 0.5)
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? colorScheme.primary
                    : (isEnabled
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurfaceVariant.withValues(
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
