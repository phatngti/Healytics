import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/massage_therapist_fields.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/spa_therapist_fields.dart';

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
  TherapistType _selectedTherapistType = TherapistType.massage;

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
                  label: TherapistType.spa.displayName,
                  description: 'General wellness',
                  icon: Icons.spa_outlined,
                  isSelected: _selectedTherapistType == TherapistType.spa,
                  onTap: () {
                    setState(() {
                      _selectedTherapistType = TherapistType.spa;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _TherapistTypeOption(
                  label: TherapistType.massage.displayName,
                  description: 'Deep tissue',
                  icon: Icons.self_improvement_outlined,
                  isSelected: _selectedTherapistType == TherapistType.massage,
                  onTap: () {
                    setState(() {
                      _selectedTherapistType = TherapistType.massage;
                    });
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
            const SpaTherapistFields()
          else
            const MassageTherapistFields(),
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
