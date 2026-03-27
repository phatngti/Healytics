import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Displays performable services / specializations
/// based on [EmployeeEntity] type.
class EmployeeServicesSection extends StatelessWidget {
  /// The employee entity to derive services from.
  final EmployeeEntity employee;

  /// Whether the parent form is in editing mode.
  final bool isEditing;

  const EmployeeServicesSection({
    super.key,
    required this.employee,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final services = _getServices();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PERFORMABLE SERVICES',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
            ),
            if (services.isNotEmpty)
              Text(
                'Showing ${services.length}',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
          ],
        ),
        AppDimens.verticalMedium,
        if (services.isEmpty)
          Text(
            'No services assigned',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount =
                  constraints.maxWidth >= 600
                      ? 3
                      : (constraints.maxWidth >= 400
                          ? 2
                          : 1);
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: services.map((service) {
                  final itemWidth = (constraints.maxWidth -
                          12 * (crossAxisCount - 1)) /
                      crossAxisCount;
                  return SizedBox(
                    width: itemWidth,
                    child: _ServiceItem(
                      name: service.name,
                      subtitle: service.subtitle,
                    ),
                  );
                }).toList(),
              );
            },
          ),
      ],
    );
  }

  List<_ServiceData> _getServices() {
    return switch (employee) {
      DoctorEntity e => e.specializations
          .map(
            (s) => _ServiceData(
              name: _capitalize(s),
              subtitle: e.consultationFee != null
                  ? '\$${e.consultationFee!.toStringAsFixed(0)}'
                  : null,
            ),
          )
          .toList(),
      SpaTherapistEntity e => e.skills
          .map((s) => _ServiceData(name: s))
          .toList(),
      MassageTherapistEntity e => e.skills
          .map((s) => _ServiceData(name: s))
          .toList(),
      _ => [],
    };
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

class _ServiceData {
  final String name;
  final String? subtitle;

  const _ServiceData({required this.name, this.subtitle});
}

class _ServiceItem extends StatelessWidget {
  final String name;
  final String? subtitle;

  const _ServiceItem({
    required this.name,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.timer,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
