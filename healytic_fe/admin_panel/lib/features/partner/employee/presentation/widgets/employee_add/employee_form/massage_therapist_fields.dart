import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class MassageTherapistFields extends StatefulWidget {
  final String? initialStrengthLevel;

  const MassageTherapistFields({super.key, this.initialStrengthLevel});

  @override
  State<MassageTherapistFields> createState() => _MassageTherapistFieldsState();
}

class _MassageTherapistFieldsState extends State<MassageTherapistFields> {
  late String _selectedStrength;

  @override
  void initState() {
    super.initState();
    _selectedStrength = widget.initialStrengthLevel ?? 'MEDIUM';
  }

  static const List<String> _therapistLevels = ['Junior', 'Senior', 'Master'];

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
                      label: 'Soft',
                      isSelected: _selectedStrength == 'SOFT',
                      isEnabled: formEnabled,
                      onTap: () {
                        if (formEnabled) {
                          setState(() {
                            _selectedStrength = 'SOFT';
                          });
                        }
                      },
                    ),
                    _StrengthButton(
                      label: 'Medium',
                      isSelected: _selectedStrength == 'MEDIUM',
                      isEnabled: formEnabled,
                      onTap: () {
                        if (formEnabled) {
                          setState(() {
                            _selectedStrength = 'MEDIUM';
                          });
                        }
                      },
                    ),
                    _StrengthButton(
                      label: 'Strong',
                      isSelected: _selectedStrength == 'STRONG',
                      isEnabled: formEnabled,
                      onTap: () {
                        if (formEnabled) {
                          setState(() {
                            _selectedStrength = 'STRONG';
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
                  ? colorScheme.primaryContainer.withOpacity(0.5)
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
                          : colorScheme.onSurfaceVariant.withOpacity(0.5)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
