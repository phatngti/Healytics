import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:user_app/router/routes.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';

/// 2×2 grid showing practice details:
/// Certificates, Reviews, Consultation/Strength,
/// and Employment Status.
class EmployeePracticeDetailsGrid extends StatelessWidget {
  const EmployeePracticeDetailsGrid({super.key, required this.employee});

  final EmployeeDetailEntity employee;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final hPad = AppDimens.horizontalPadding(context);
    final section = AppDimens.sectionSpacing(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Practice Details',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          AppDimens.verticalMedium,
          _GridRow(
            spacing: section,
            left: _DetailCard(
              icon: Symbols.description,
              iconColor: colorScheme.tertiary,
              iconBgColor: colorScheme.tertiaryContainer.withValues(alpha: 0.4),
              label: _certificateLabel,
              onTap: () => _openCertificates(context),
            ),
            right: _DetailCard(
              icon: Symbols.star_rate,
              iconColor: colorScheme.secondaryContainer,
              iconBgColor: colorScheme.secondary.withValues(alpha: 0.1),
              label:
                  'Reviews: '
                  '${employee.rating.toStringAsFixed(1)}'
                  ' (${employee.reviewCount})',
            ),
          ),
          AppDimens.verticalLarge,
        ],
      ),
    );
  }

  String get _certificateLabel {
    final count = employee.certificates.length;
    if (count == 0) return 'Documents';
    return 'Documents ($count)';
  }

  void _openCertificates(BuildContext context) {
    CertificatesListRoute(
      employeeName: employee.displayName,
      employeeId: employee.id,
    ).push<void>(context);
  }
}

/// A row of two equally-sized children with spacing.
class _GridRow extends StatelessWidget {
  const _GridRow({
    required this.spacing,
    required this.left,
    required this.right,
  });

  final double spacing;
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: left),
          SizedBox(width: spacing),
          Expanded(child: right),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.label,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final radius = AppDimens.cardRadius(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimens.contentPadding(context)),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.04),
              blurRadius: AppDimens.spaceSm,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: AppDimens.avatarSm + 4,
              width: AppDimens.avatarSm + 4,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: AppDimens.iconSmMd),
            ),
            AppDimens.verticalExtraSmall,
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: AppDimens.fontSizeSmall - 2,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
