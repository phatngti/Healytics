import 'package:admin_panel/features/admin/partner_manager/datasource/partner_verification_remote.datasource.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:common/widgets/table/helper.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// Data source for the partner verification table
class PartnerTableSource {
  static Future<int> getTotalRows(WidgetRef ref) async {
    final dataSource = ref.read(partnerVerificationRemoteDataSourceProvider);
    return dataSource.getTotalRows();
  }

  static Future<List<DataRow>> getData(
    BuildContext context,
    WidgetRef ref,
    SetRowSelectionCallback setRowSelection,
    int startingAt,
    int count,
  ) async {
    final dataSource = ref.read(partnerVerificationRemoteDataSourceProvider);
    final partners = await dataSource.getPartnerVerifications(
      startingAt: startingAt,
      count: count,
      sortedBy: 'submittedAt',
      sortedAsc: false,
    );

    final rows = partners.map((partner) {
      final isHighPriority = partner.priority == PartnerPriority.high;
      final isNotPending = partner.status != PartnerVerificationStatus.pending;

      return DataRow(
        key: ValueKey<String>(partner.id.value),
        color: WidgetStateProperty.resolveWith<Color?>((states) {
          if (isHighPriority &&
              partner.status == PartnerVerificationStatus.pending) {
            return _getDangerColor(context).withValues(alpha: 0.05);
          }
          return null;
        }),
        onSelectChanged: isNotPending
            ? null
            : (value) {
                if (value != null) {
                  setRowSelection(ValueKey<String>(partner.id.value), value);
                }
              },
        cells: [
          // Provider Details
          DataCell(_buildProviderDetails(context, partner)),
          // Business Type
          DataCell(_buildServiceTypes(context, partner.serviceTypes)),
          // Submitted Date
          DataCell(_buildSubmittedDate(context, partner)),
          // Status
          DataCell(_buildStatusBadge(context, partner.status)),
          // Actions
          DataCell(_buildActionButton(context, partner)),
        ],
      );
    }).toList();

    return rows;
  }

  static Widget _buildProviderDetails(
    BuildContext context,
    PartnerVerificationEntity partner,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        // Avatar
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: AppDimens.radiusExtraSmall,
            gradient: partner.avatarColorStart != null
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(partner.avatarColorStart!),
                      Color(
                        partner.avatarColorEnd ?? partner.avatarColorStart!,
                      ),
                    ],
                  )
                : null,
            color: partner.avatarColorStart == null
                ? colorScheme.surfaceContainerHighest
                : null,
          ),
          child: Center(
            child: Text(
              partner.initials,
              style: textTheme.labelSmall?.copyWith(
                color: partner.avatarColorStart != null
                    ? Colors.white
                    : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        AppDimens.horizontalMediumSmall,
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                partner.name,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'ID: ${partner.providerId ?? partner.id.value}',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  if (partner.isEmailVerified) ...[
                    AppDimens.horizontalSmall,
                    Icon(
                      Icons.verified,
                      size: 14,
                      color: _getSuccessColor(context),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildServiceTypes(
    BuildContext context,
    List<String> serviceTypes,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: serviceTypes.map((type) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: AppDimens.radiusExtraSmall,
          ),
          child: Text(
            type,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  static Widget _buildSubmittedDate(
    BuildContext context,
    PartnerVerificationEntity partner,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isHighPriority = partner.priority == PartnerPriority.high;

    final formattedDate = DateFormat(
      'MMM dd, yyyy',
    ).format(partner.submittedAt);
    final timeAgo = _getTimeAgo(partner.submittedAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          formattedDate,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          timeAgo,
          style: textTheme.labelSmall?.copyWith(
            color: isHighPriority
                ? _getDangerColor(context)
                : colorScheme.onSurfaceVariant,
            fontWeight: isHighPriority ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  static Widget _buildStatusBadge(
    BuildContext context,
    PartnerVerificationStatus status,
  ) {
    final semantics = Theme.of(context).extension<SemanticColors>();

    Color badgeColor;
    String label;
    IconData? icon;

    switch (status) {
      case PartnerVerificationStatus.pending:
        badgeColor = semantics?.warning ?? Colors.orange;
        label = 'Pending';
      case PartnerVerificationStatus.approved:
        badgeColor = semantics?.success ?? Colors.green;
        label = 'Active';
      case PartnerVerificationStatus.rejected:
        badgeColor = semantics?.error ?? Colors.red;
        label = 'Rejected';
        icon = Icons.block;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: badgeColor),
          ] else
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badgeColor,
              ),
            ),
          AppDimens.horizontalExtraSmall,
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildActionButton(
    BuildContext context,
    PartnerVerificationEntity partner,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPending = partner.status == PartnerVerificationStatus.pending;

    return IconButton(
      onPressed: () {
        ReviewApplicationRoute(partnerId: partner.id.value).go(context);
      },
      icon: Icon(isPending ? Icons.edit_document : Icons.visibility, size: 20),
      style:
          IconButton.styleFrom(
            foregroundColor: colorScheme.onSurfaceVariant,
            backgroundColor: Colors.transparent,
          ).copyWith(
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.white;
              }
              return colorScheme.onSurfaceVariant;
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return colorScheme.primary;
              }
              return Colors.transparent;
            }),
          ),
      tooltip: isPending ? 'Review Application' : 'View Details',
    );
  }

  static String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  static Color _getDangerColor(BuildContext context) {
    return Theme.of(context).extension<SemanticColors>()?.error ?? Colors.red;
  }

  static Color _getSuccessColor(BuildContext context) {
    return Theme.of(context).extension<SemanticColors>()?.success ??
        Colors.green;
  }
}
