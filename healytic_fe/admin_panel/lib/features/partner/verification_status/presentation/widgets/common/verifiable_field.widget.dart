import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// A wrapper widget that displays verification status for form fields.
///
/// Similar to [ReviewableField] on the admin side, but for the partner's
/// view context. Displays:
/// - Field title with verification status indicator (✓ or ⊘)
/// - The wrapped field content
/// - Admin feedback banner when revision is requested
class VerifiableField extends StatelessWidget {
  const VerifiableField({
    required this.fieldId,
    required this.title,
    required this.child,
    this.titleStyle,
    this.requiresUpdate = false,
    this.isEdited = false,
    this.adminFeedback,
    this.showVerifiedIndicator = true,
    this.compactMode = false,
    super.key,
  });

  /// Unique identifier for the field (e.g., 'business.brandName').
  final String fieldId;

  /// Label displayed above the field content.
  final String title;

  /// Custom style for the title text.
  final TextStyle? titleStyle;

  /// The field content to wrap.
  final Widget child;

  /// Whether this field requires an update/revision.
  final bool requiresUpdate;

  /// Whether the user has edited this field's value.
  final bool isEdited;

  /// Feedback message from admin (shown when [requiresUpdate] is true).
  final String? adminFeedback;

  /// Whether to show the verified checkmark when field is verified.
  final bool showVerifiedIndicator;

  /// Use smaller styling for compact layouts.
  final bool compactMode;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title row with status indicator
        Row(
          children: [
            Flexible(
              child: Tooltip(
                message: title,
                child: Text(
                  title,
                  style:
                      titleStyle ??
                      textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            AppDimens.horizontalSmall,
            _VerificationStatusIndicator(
              requiresUpdate: requiresUpdate,
              isEdited: isEdited,
              compactMode: compactMode,
            ),
          ],
        ),
        AppDimens.verticalExtraSmall,

        // The wrapped field content
        child,

        // Admin feedback banner (animated)
        _AdminFeedbackBanner(
          feedback: adminFeedback,
          isVisible: requiresUpdate && adminFeedback != null,
        ),
      ],
    );
  }
}

/// Displays verification status: checkmark (✓) for verified, warning for update needed.
class _VerificationStatusIndicator extends StatelessWidget {
  const _VerificationStatusIndicator({
    required this.requiresUpdate,
    this.isEdited = false,
    this.compactMode = false,
  });

  final bool requiresUpdate;
  final bool isEdited;
  final bool compactMode;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final semantics = Theme.of(context).extension<SemanticColors>();
    final successColor = semantics?.success ?? Colors.green;
    final warningColor = semantics?.warning ?? Colors.orange;

    final iconSize = compactMode ? 16.0 : 18.0;

    // Show EDITED badge when user has modified the field value
    if (isEdited) {
      return _StatusBadge(
        icon: Icons.edit,
        label: 'EDITED',
        color: colorScheme.primary,
        compactMode: compactMode,
      );
    }

    // Show UPDATE badge when field requires revision
    if (requiresUpdate) {
      return _StatusBadge(
        icon: Icons.error_outline,
        label: 'UPDATE',
        color: warningColor,
        compactMode: compactMode,
      );
    }

    return Icon(Icons.check_circle, size: iconSize, color: successColor);
  }
}

/// Small status badge with icon and label.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.icon,
    required this.label,
    required this.color,
    this.compactMode = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool compactMode;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final iconSize = compactMode ? 12.0 : 14.0;
    final fontSize = compactMode ? 9.0 : 10.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compactMode ? 6 : 8,
        vertical: compactMode ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated banner showing admin feedback when field requires update.
class _AdminFeedbackBanner extends StatelessWidget {
  const _AdminFeedbackBanner({required this.feedback, required this.isVisible});

  final String? feedback;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semantics = Theme.of(context).extension<SemanticColors>();
    final warningColor = semantics?.warning ?? Colors.orange;

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: isVisible && feedback != null && feedback!.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: warningColor.withValues(alpha: 0.08),
                  borderRadius: AppDimens.radiusSmall,
                  border: Border(
                    left: BorderSide(color: warningColor, width: 3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.format_quote,
                      size: 16,
                      color: warningColor.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feedback!,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
