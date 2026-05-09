import 'package:common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Model class for service data
class ServiceItem {
  final String name;
  final double price;
  final int duration;

  const ServiceItem({
    required this.name,
    required this.price,
    required this.duration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceItem &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class EmployeeSkillsServicesCard extends StatefulWidget {
  /// List of available skills for selection
  final List<String> availableSkills;

  /// List of available services for selection
  final List<ServiceItem> availableServices;

  /// Initial selected skills
  final List<String>? initialSkills;

  /// Initial selected services
  final List<String>? initialServices;

  const EmployeeSkillsServicesCard({
    super.key,
    this.availableSkills = const [
      'Deep Tissue',
      'Aromatherapy',
      'Hot Stone',
      'Swedish Massage',
      'Sports Massage',
      'Reflexology',
      'Shiatsu',
      'Thai Massage',
    ],
    this.availableServices = const [
      ServiceItem(name: '60min Deep Tissue', price: 120.00, duration: 60),
      ServiceItem(name: '90min Aromatherapy', price: 150.00, duration: 90),
      ServiceItem(name: 'Hot Stone Therapy', price: 160.00, duration: 75),
      ServiceItem(name: 'Sports Recovery', price: 135.00, duration: 60),
    ],
    this.initialSkills,
    this.initialServices,
  });

  @override
  State<EmployeeSkillsServicesCard> createState() =>
      _EmployeeSkillsServicesCardState();
}

class _EmployeeSkillsServicesCardState
    extends State<EmployeeSkillsServicesCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                      color: colorScheme.primaryContainer,
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
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: AppDimens.paddingAllLarge,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skill Set Section using the common widget
          FormFieldBuilders.buildMultiSelectChipField(
            context,
            fieldKey: 'skill_set',
            label: 'SKILL SET (MULTI-SELECT)',
            labelStyle: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            availableOptions: {
              for (var skill in widget.availableSkills) skill: skill,
            },
            initialValue: widget.initialSkills,
            searchHint: 'Search skills...',
            helperText: 'Type to search existing skills or create new ones.',
            allowCreate: true,
          ),
          AppDimens.verticalLarge,
          // Performable Services Section with FormBuilder
          _buildPerformableServicesField(context),
        ],
      ),
    );
  }

  Widget _buildPerformableServicesField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FormBuilderField<List<String>>(
      name: 'performable_services',
      initialValue: widget.initialServices ?? [],
      builder: (FormFieldState<List<String>> field) {
        final selectedServices = field.value ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PERFORMABLE SERVICES',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            AppDimens.verticalMediumSmall,
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  field.errorText ?? '',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 64,
                ),
                itemCount: widget.availableServices.length,
                itemBuilder: (context, index) {
                  final service = widget.availableServices[index];
                  final isSelected = selectedServices.contains(service.name);
                  return _buildServiceCheckbox(
                    context,
                    service: service,
                    isSelected: isSelected,
                    onChanged: (value) {
                      final currentServices = field.value ?? [];
                      List<String> newList;
                      if (value == true) {
                        newList = [...currentServices, service.name];
                      } else {
                        newList = currentServices
                            .where((s) => s != service.name)
                            .toList();
                      }
                      field.didChange(newList);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildServiceCheckbox(
    BuildContext context, {
    required ServiceItem service,
    required bool isSelected,
    required ValueChanged<bool?> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;

    return Material(
      color: colorScheme.surface,
      child: InkWell(
        onTap: () => onChanged(!isSelected),
        borderRadius: AppDimens.radiusSmall,
        child: Container(
          padding: AppDimens.paddingAllMediumSmall,
          decoration: BoxDecoration(
            borderRadius: AppDimens.radiusSmall,
            border: Border.all(
              color: isSelected
                  ? semanticColors.success ?? colorScheme.primary
                  : colorScheme.outlineVariant,
            ),
            color: isSelected ? semanticColors.success?.withAlpha(25) : null,
          ),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: onChanged,
                activeColor: semanticColors.success,
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimens.radiusExtraSmall,
                ),
              ),
              AppDimens.horizontalSmall,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      service.name,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${service.price.toStringAsFixed(2)} • ${service.duration} min',
                      style: textTheme.bodySmall?.copyWith(
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
