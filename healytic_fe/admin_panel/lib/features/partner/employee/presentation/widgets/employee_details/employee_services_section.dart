import 'package:admin_panel/features/partner/employee/domain/employee_assigned_service.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee_details.provider.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Displays partner-assigned services for an employee.
class EmployeeServicesSection extends ConsumerWidget {
  /// The employee entity used to query assigned services.
  final EmployeeEntity employee;

  /// Whether the parent form is in editing mode.
  final bool isEditing;

  const EmployeeServicesSection({
    super.key,
    required this.employee,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final servicesAsync = ref.watch(
      employeeAssignedServicesProvider(employee.id),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        servicesAsync.when(
          data: (services) => _SectionHeader(count: services.length),
          loading: () => const _SectionHeader(),
          error: (_, _) => const _SectionHeader(),
        ),
        AppDimens.verticalMedium,
        servicesAsync.when(
          data: (services) {
            if (services.isEmpty) {
              return Text(
                'No services assigned',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth >= 600
                    ? 3
                    : (constraints.maxWidth >= 400 ? 2 : 1);
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: services.map((service) {
                    final itemWidth =
                        (constraints.maxWidth - 12 * (crossAxisCount - 1)) /
                        crossAxisCount;
                    return SizedBox(
                      width: itemWidth,
                      child: _ServiceItem(service: service),
                    );
                  }).toList(),
                );
              },
            );
          },
          loading: () => const _LoadingState(),
          error: (error, _) => _ErrorState(
            onRetry: () =>
                ref.invalidate(employeeAssignedServicesProvider(employee.id)),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final int? count;

  const _SectionHeader({this.count});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'PERFORMABLE SERVICES',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        if (count != null && count! > 0)
          Text(
            'Showing $count',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
          ),
        ),
        AppDimens.horizontalSmall,
        Text(
          'Loading assigned services',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            'Unable to load assigned services',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colorScheme.error),
          ),
        ),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final EmployeeAssignedServiceEntity service;

  const _ServiceItem({required this.service});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final price = _formatPrice(
      service.salePrice ?? service.basePrice,
      service.currency,
    );
    final oldPrice = service.salePrice == null
        ? null
        : _formatPrice(service.basePrice, service.currency);
    final subtitleParts = <String>[
      if (service.categoryName?.isNotEmpty ?? false) service.categoryName!,
      if (service.durationMinutes != null) '${service.durationMinutes} min',
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.medical_services_outlined,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitleParts.isNotEmpty)
                  Text(
                    subtitleParts.join(' - '),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                AppDimens.verticalExtraSmall,
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        price,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (oldPrice != null) ...[
                      AppDimens.horizontalExtraSmall,
                      Flexible(
                        child: Text(
                          oldPrice,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                decoration: TextDecoration.lineThrough,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                AppDimens.verticalExtraSmall,
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _StatusChip(status: service.status),
                    if (service.isPrimary) const _PrimaryChip(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double value, String currency) {
    if (currency.toUpperCase() == 'VND') {
      return NumberFormat.currency(
        locale: 'vi_VN',
        symbol: 'VND ',
        decimalDigits: 0,
      ).format(value);
    }
    return NumberFormat.currency(
      symbol: '$currency ',
      decimalDigits: 0,
    ).format(value);
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withAlpha(120),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PrimaryChip extends StatelessWidget {
  const _PrimaryChip();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withAlpha(120),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'PRIMARY',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
