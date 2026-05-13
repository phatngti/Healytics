import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/massage_therapist_fields.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/spa_therapist_fields.dart';
import 'package:common/utils/demensions.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Form fields specific to therapists
class TherapistFieldsCard extends StatefulWidget {
  final TherapistType? initialTherapistType;
  final String? initialTherapistLevel;
  final double? initialCommissionRate;
  final String? initialHealthCheckDate;
  final List<String> initialSkills;
  final List<String> initialDeviceProficiency;
  final String? initialStrengthLevel;

  /// Called when the therapist type toggle
  /// changes between Spa and Massage.
  final ValueChanged<TherapistType>? onTherapistTypeChanged;

  const TherapistFieldsCard({
    super.key,
    this.initialTherapistType,
    this.initialTherapistLevel,
    this.initialCommissionRate,
    this.initialHealthCheckDate,
    this.initialSkills = const [],
    this.initialDeviceProficiency = const [],
    this.initialStrengthLevel,
    this.onTherapistTypeChanged,
  });

  @override
  State<TherapistFieldsCard> createState() => _TherapistFieldsCardState();
}

class _TherapistFieldsCardState extends State<TherapistFieldsCard> {
  bool _isExpanded = true;
  late TherapistType _selectedTherapistType;

  @override
  void initState() {
    super.initState();
    _selectedTherapistType =
        widget.initialTherapistType ?? TherapistType.massage;
  }

  @override
  void didUpdateWidget(TherapistFieldsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextType = widget.initialTherapistType;
    if (nextType != null && nextType != oldWidget.initialTherapistType) {
      _selectedTherapistType = nextType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final formEnabled = FormBuilder.of(context)?.enabled ?? true;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(10),
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
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary.withAlpha(75),
                      ),
                    ),
                    child: Icon(
                      Icons.verified_outlined,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                  ),
                  AppDimens.horizontalMediumSmall,
                  Text(
                    'Skills & Services',
                    style: textTheme.titleMedium?.copyWith(
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
            firstChild: _buildContent(context, formEnabled),
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

  Widget _buildContent(BuildContext context, bool formEnabled) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: AppDimens.paddingAllLarge,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Therapist Type Selection
          Text(
            'Therapist Type'.toUpperCase(),
            style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppDimens.verticalSmall,
          Row(
            children: [
              Expanded(
                child: _TherapistTypeOption(
                  label: TherapistType.spa.displayName,
                  description: 'General wellness',
                  icon: Icons.spa_outlined,
                  isSelected: _selectedTherapistType == TherapistType.spa,
                  isEnabled: formEnabled,
                  onTap: () {
                    if (formEnabled) {
                      setState(() {
                        _selectedTherapistType = TherapistType.spa;
                      });
                      widget.onTherapistTypeChanged?.call(TherapistType.spa);
                    }
                  },
                ),
              ),
              AppDimens.horizontalMedium,
              Expanded(
                child: _TherapistTypeOption(
                  label: TherapistType.massage.displayName,
                  description: 'Deep tissue',
                  icon: Icons.self_improvement_outlined,
                  isSelected: _selectedTherapistType == TherapistType.massage,
                  isEnabled: formEnabled,
                  onTap: () {
                    if (formEnabled) {
                      setState(() {
                        _selectedTherapistType = TherapistType.massage;
                      });
                      widget.onTherapistTypeChanged?.call(
                        TherapistType.massage,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          // Hidden field to store therapist type in form
          FormBuilderField<String>(
            name: 'therapist_type',
            initialValue: _selectedTherapistType.apiValue,
            builder: (field) {
              // Update field when selection changes
              if (field.value != _selectedTherapistType.apiValue) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  field.didChange(_selectedTherapistType.apiValue);
                });
              }
              return const SizedBox.shrink();
            },
          ),

          if (_selectedTherapistType == TherapistType.spa)
            SpaTherapistFields(
              initialTherapistLevel: widget.initialTherapistLevel,
              initialCommissionRate: widget.initialCommissionRate,
              initialHealthCheckDate: widget.initialHealthCheckDate,
              initialSkills: widget.initialSkills,
              initialDeviceProficiency: widget.initialDeviceProficiency,
            )
          else
            MassageTherapistFields(
              initialTherapistLevel: widget.initialTherapistLevel,
              initialCommissionRate: widget.initialCommissionRate,
              initialHealthCheckDate: widget.initialHealthCheckDate,
              initialSkills: widget.initialSkills,
              initialStrengthLevel: widget.initialStrengthLevel,
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
  final bool isEnabled;
  final VoidCallback onTap;

  const _TherapistTypeOption({
    required this.label,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: isEnabled
          ? null
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: AppDimens.radiusMedium,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: AppDimens.radiusMedium,
        child: Container(
          padding: AppDimens.paddingAllMediumSmall,
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primaryContainer : null,
            borderRadius: AppDimens.radiusMedium,
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : (isEnabled
                        ? colorScheme.outlineVariant
                        : colorScheme.outlineVariant.withValues(alpha: 0.5)),
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
                      : (isEnabled
                            ? colorScheme.outlineVariant
                            : colorScheme.outlineVariant.withValues(
                                alpha: 0.5,
                              )),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: isSelected ? colorScheme.primary : colorScheme.outline,
                ),
              ),
              AppDimens.horizontalMediumSmall,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isEnabled
                            ? null
                            : colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      description,
                      style: textTheme.labelSmall?.copyWith(
                        color: isEnabled
                            ? null
                            : colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.5,
                              ),
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
