import 'package:admin_panel/features/common/widgets/input/multi_select_chip_field.dart';
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
          // Skill Set Section using the common widget
          AppMultiSelectChipField(
            fieldKey: 'skill_set',
            label: 'SKILL SET (MULTI-SELECT)',
            labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            availableOptions: widget.availableSkills,
            initialValue: widget.initialSkills,
            searchHint: 'Search skills...',
            helperText: 'Type to search existing skills or create new ones.',
            allowCreate: true,
          ),
          const SizedBox(height: 24),
          // Performable Services Section with FormBuilder
          _buildPerformableServicesField(context),
        ],
      ),
    );
  }

  Widget _buildPerformableServicesField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  field.errorText ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!isSelected),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Colors.green.shade300
                  : colorScheme.outlineVariant,
            ),
            color: isSelected ? Colors.green.shade50.withAlpha(50) : null,
          ),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: onChanged,
                activeColor: Colors.green.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      service.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${service.price.toStringAsFixed(2)} • ${service.duration} min',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
