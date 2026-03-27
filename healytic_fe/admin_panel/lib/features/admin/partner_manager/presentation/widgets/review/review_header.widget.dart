import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Header widget for the review application page with breadcrumb and status
class ReviewHeader extends StatelessWidget {
  const ReviewHeader({
    required this.brandName,
    required this.status,
    required this.submittedAt,
    super.key,
  });

  final String brandName;
  final PartnerVerificationStatus status;
  final DateTime submittedAt;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semantics = Theme.of(context).extension<SemanticColors>();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb Navigation
          _buildBreadcrumb(context, colorScheme, textTheme),
          AppDimens.verticalSmall,

          // Title Row
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      brandName,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    AppDimens.horizontalMedium,
                    _buildStatusBadge(context, semantics),
                  ],
                ),
              ),
              _buildSubmittedDate(context, colorScheme, textTheme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Row(
      children: [
        InkWell(
          onTap: () => const PartnerManagerRoute().go(context),
          borderRadius: AppDimens.radiusExtraSmall,
          child: Text(
            'Admin Portal',
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            Icons.chevron_right,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        InkWell(
          onTap: () => const PartnerManagerRoute().go(context),
          borderRadius: AppDimens.radiusExtraSmall,
          child: Text(
            'Provider Verification',
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            Icons.chevron_right,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          'Detail View',
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, SemanticColors? semantics) {
    Color badgeColor;
    String label;

    switch (status) {
      case PartnerVerificationStatus.pending:
        badgeColor = semantics?.warning ?? Colors.orange;
        label = 'PENDING REVIEW';
      case PartnerVerificationStatus.approved:
        badgeColor = semantics?.success ?? Colors.green;
        label = 'APPROVED';
      case PartnerVerificationStatus.rejected:
        badgeColor = semantics?.error ?? Colors.red;
        label = 'REJECTED';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == PartnerVerificationStatus.pending) ...[
            _AnimatedDot(color: badgeColor),
            AppDimens.horizontalSmall,
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmittedDate(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          AppDimens.horizontalSmall,
          Text(
            'Submitted:',
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppDimens.horizontalExtraSmall,
          Text(
            DateFormat('MMM dd, yyyy').format(submittedAt),
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated pulsing dot for pending status
class _AnimatedDot extends StatefulWidget {
  const _AnimatedDot({required this.color});

  final Color color;

  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 8,
      height: 8,
      child: Stack(
        children: [
          FadeTransition(
            opacity: Tween<double>(begin: 0.75, end: 0).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOut),
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 1, end: 2).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeOut),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
