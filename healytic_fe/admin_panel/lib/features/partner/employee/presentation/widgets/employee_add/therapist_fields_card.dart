import 'package:admin_panel/features/common/widgets/input/date_pick_field.dart';
import 'package:admin_panel/features/common/widgets/input/text_field.dart';
import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Form fields specific to therapists
class TherapistFieldsCard extends StatefulWidget {
  const TherapistFieldsCard({super.key});

  @override
  State<TherapistFieldsCard> createState() => _TherapistFieldsCardState();
}

class _TherapistFieldsCardState extends State<TherapistFieldsCard> {
  bool _isExpanded = true;
  String _selectedTherapistType = 'MASSAGE';
  String _selectedStrength = 'MEDIUM';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.purple.shade100),
                    ),
                    child: Icon(
                      Icons.verified_outlined,
                      size: 18,
                      color: Colors.purple.shade600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Skills & Services',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          AnimatedCrossFade(
            firstChild: _buildContent(context),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Therapist Type Selection
          Text(
            'Therapist Type',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _TherapistTypeOption(
                  label: 'Spa Therapist',
                  description: 'General wellness',
                  icon: Icons.spa_outlined,
                  isSelected: _selectedTherapistType == 'SPA',
                  onTap: () {
                    setState(() {
                      _selectedTherapistType = 'SPA';
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _TherapistTypeOption(
                  label: 'Massage Therapist',
                  description: 'Deep tissue',
                  icon: Icons.self_improvement_outlined,
                  isSelected: _selectedTherapistType == 'MASSAGE',
                  onTap: () {
                    setState(() {
                      _selectedTherapistType = 'MASSAGE';
                    });
                  },
                ),
              ),
            ],
          ),
          // Hidden field to store therapist type in form
          FormBuilderField<String>(
            name: 'therapist_type',
            initialValue: _selectedTherapistType,
            builder: (field) {
              // Update field when selection changes
              if (field.value != _selectedTherapistType) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  field.didChange(_selectedTherapistType);
                });
              }
              return const SizedBox.shrink();
            },
          ),
          AppDimens.verticalMedium,
          Row(
            children: [
              Expanded(
                child: FormFieldBuilders.buildDropdownField(
                  context,
                  label: 'Therapist Level',
                  items: ['Junior', 'Senior', 'Master'],
                  fieldKey: 'therapist_level',
                ),
              ),
              AppDimens.horizontalLarge,
              Expanded(
                child: AppTextField(
                  fieldKey: 'commission_rate',
                  label: 'Commission Rate',
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Text(
                      '%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppDimens.verticalMedium,
          // Massage Strength
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
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
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      _StrengthButton(
                        label: 'Soft',
                        isSelected: _selectedStrength == 'SOFT',
                        onTap: () {
                          setState(() {
                            _selectedStrength = 'SOFT';
                          });
                        },
                      ),
                      _StrengthButton(
                        label: 'Medium',
                        isSelected: _selectedStrength == 'MEDIUM',
                        onTap: () {
                          setState(() {
                            _selectedStrength = 'MEDIUM';
                          });
                        },
                      ),
                      _StrengthButton(
                        label: 'Strong',
                        isSelected: _selectedStrength == 'STRONG',
                        onTap: () {
                          setState(() {
                            _selectedStrength = 'STRONG';
                          });
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
                const SizedBox(height: 16),
                AppDatePickField(
                  fieldKey: 'health_check_date',
                  label: 'Last Health Check',
                  hintText: 'Select date',
                ),
              ],
            ),
          ),
          AppDimens.verticalMedium,
          AppTextField(
            fieldKey: 'skills',
            label: 'Skill Set',
            hintText: 'e.g. Deep Tissue, Hot Stone, Swedish (comma separated)',
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _TherapistTypeOption extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TherapistTypeOption({
    required this.label,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primaryContainer : null,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.surface
                      : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: isSelected ? colorScheme.primary : Colors.grey,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StrengthButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StrengthButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer.withOpacity(0.5)
                  : null,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected ? colorScheme.primary : Colors.transparent,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
