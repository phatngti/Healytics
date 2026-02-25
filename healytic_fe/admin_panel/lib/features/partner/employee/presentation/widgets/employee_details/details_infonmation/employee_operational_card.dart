import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

import '../employee_schedule_section.dart';
import '../employee_services_section.dart';

class EmployeeOperationalCard extends StatelessWidget {
  final bool isEditing;

  const EmployeeOperationalCard({super.key, this.isEditing = false});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withAlpha(128),
              border: Border(
                bottom: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Operational',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppDimens.paddingAllLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EmployeeServicesSection(isEditing: isEditing),
                AppDimens.verticalExtraLarge,
                EmployeeScheduleSection(isEditing: isEditing),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
