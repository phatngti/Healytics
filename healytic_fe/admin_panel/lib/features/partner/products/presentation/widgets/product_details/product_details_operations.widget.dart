import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Data class representing an assigned staff member
class AssignedStaff {
  final String name;
  final String role;
  final String? imageUrl;
  final String? initials;

  const AssignedStaff({
    required this.name,
    required this.role,
    this.imageUrl,
    this.initials,
  });
}

class ProductDetailsOperationsCard extends StatelessWidget {
  final Product product;

  const ProductDetailsOperationsCard({super.key, required this.product});

  // Mock data for assigned staff - replace with actual data from product
  static const List<AssignedStaff> _mockAssignedStaff = [
    AssignedStaff(
      name: 'Sarah M.',
      role: 'Senior Esthetician',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDHbeB0I-YAGNjRcUP1kIwr3ZUvFLgyxeXGu2kzwQz7ESQff19pkup36d3U2t565s9bWSUoBUB8hhWYM2lgXOjTqc1Ig4wl6zP7cWEA40O46E0JHzXkn-W_js-IaECoPF4rV2DE6PX3EiZbGzyuUcTq3cyU1jtbnkYco2CeF1bO_6CSsRSsXIjac1wu2IYKyJhQiMQGaFDZWH2kVz0T6HOBXAcvQocO6QmAEdgpl1QH6VIcLOIKEd1v089kQUCndN01a-ZljTpsU4Gt',
    ),
    AssignedStaff(name: 'John D.', role: 'Associate', initials: 'JD'),
    AssignedStaff(name: 'Emily R.', role: 'Junior Therapist', initials: 'ER'),
    AssignedStaff(
      name: 'Michael B.',
      role: 'Massage Specialist',
      initials: 'MB',
    ),
    AssignedStaff(name: 'Lisa T.', role: 'Skin Care Expert', initials: 'LT'),
  ];

  // Number of staff to show before "View More"
  static const int _maxVisibleStaff = 2;

  void _showAssignedStaffDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _AssignedStaffDialog(
        staffList: _mockAssignedStaff,
        serviceName: product.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleStaff = _mockAssignedStaff.take(_maxVisibleStaff).toList();
    final remainingCount = _mockAssignedStaff.length - _maxVisibleStaff;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: AppDimens.paddingAllMediumLarge,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month, color: theme.colorScheme.primary),
                AppDimens.horizontalSmall,
                Text(
                  'OPERATIONS SUMMARY',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: AppDimens.paddingAllMediumLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle(context, 'Assigned Staff'),
                    if (remainingCount > 0)
                      TextButton.icon(
                        onPressed: () => _showAssignedStaffDialog(context),
                        icon: Icon(
                          Icons.visibility_outlined,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        label: Text(
                          'View All (${_mockAssignedStaff.length})',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                  ],
                ),
                AppDimens.verticalMediumSmall,
                // Show limited staff list
                ...visibleStaff.map(
                  (staff) => Padding(
                    padding: EdgeInsets.only(
                      bottom: staff != visibleStaff.last ? 8 : 0,
                    ),
                    child: _buildStaffItem(
                      context,
                      staff.name,
                      staff.role,
                      staff.imageUrl,
                      initials: staff.initials,
                    ),
                  ),
                ),
                // Show "View More" hint if there are more staff
                if (remainingCount > 0) ...[
                  AppDimens.verticalSmall,
                  InkWell(
                    onTap: () => _showAssignedStaffDialog(context),
                    borderRadius: AppDimens.radiusSmall,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: AppDimens.radiusSmall,
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.group_outlined,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          AppDimens.horizontalSmall,
                          Text(
                            '+$remainingCount more staff assigned',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1),
                ),

                // Grid Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildGridStat(
                        context,
                        'Duration',
                        '${product.duration ?? 60} min',
                      ),
                    ),
                    AppDimens.horizontalMediumSmall,
                    Expanded(
                      child: _buildGridStat(
                        context,
                        'Buffer',
                        '${product.buffer ?? 15} min',
                      ),
                    ),
                    AppDimens.horizontalMediumSmall,
                    Expanded(
                      child: _buildGridStat(
                        context,
                        'Max Capacity',
                        '${product.capacity ?? 1} Client',
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1),
                ),

                _buildSectionTitle(context, 'Resources'),
                AppDimens.verticalSmall,
                Container(
                  padding: AppDimens.paddingAllSmall,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: AppDimens.radiusSmall,
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.meeting_room,
                            size: 18,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          AppDimens.horizontalSmall,
                          Text(
                            'Standard Room',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        child: Text(
                          'x1',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1),
                ),

                _buildSectionTitle(context, 'Availability'),
                AppDimens.verticalSmall,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.date_range,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    AppDimens.horizontalSmall,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Business Hours',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Mon-Fri, 9am-5pm',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStaffItem(
    BuildContext context,
    String name,
    String role,
    String? imageUrl, {
    String? initials,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: AppDimens.paddingAllSmall,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: imageUrl == null
                  ? theme.colorScheme.secondaryContainer
                  : null,
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: imageUrl == null
                ? Text(
                    initials ?? '',
                    style: TextStyle(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          AppDimens.horizontalMediumSmall,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                role,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridStat(BuildContext context, String title, String value) {
    final theme = Theme.of(context);
    return Container(
      padding: AppDimens.paddingAllSmall,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppDimens.verticalExtraSmall,
          Text(
            value,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog widget to display all assigned staff members
class _AssignedStaffDialog extends StatelessWidget {
  final List<AssignedStaff> staffList;
  final String serviceName;

  const _AssignedStaffDialog({
    required this.staffList,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppDimens.radiusMedium),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: AppDimens.paddingAllMediumLarge,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: AppDimens.paddingAllSmall,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: AppDimens.radiusSmall,
                    ),
                    child: Icon(
                      Icons.group,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  AppDimens.horizontalMediumSmall,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assigned Staff',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          serviceName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Staff count badge
            Padding(
              padding:
                  AppDimens.paddingHorizontalMediumLarge +
                  AppDimens.paddingVerticalMediumSmall,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: AppDimens.radiusMediumLarge,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${staffList.length} staff members assigned',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Staff list
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: AppDimens.paddingHorizontalMediumLarge,
                itemCount: staffList.length,
                separatorBuilder: (context, index) => AppDimens.verticalSmall,
                itemBuilder: (context, index) {
                  final staff = staffList[index];
                  return _buildDialogStaffItem(context, staff);
                },
              ),
            ),

            // Footer with close button
            Padding(
              padding: AppDimens.paddingAllMediumLarge,
              child: FilledButton.tonal(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogStaffItem(BuildContext context, AssignedStaff staff) {
    final theme = Theme.of(context);

    return Container(
      padding: AppDimens.paddingAllMediumSmall,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: staff.imageUrl == null
                  ? theme.colorScheme.secondaryContainer
                  : null,
              image: staff.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(staff.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: staff.imageUrl == null
                ? Text(
                    staff.initials ?? '',
                    style: TextStyle(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                : null,
          ),
          AppDimens.horizontalMedium,
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  staff.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.work_outline,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    AppDimens.horizontalExtraSmall,
                    Text(
                      staff.role,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
