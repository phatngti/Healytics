import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Alert banner displayed when revision is requested.
///
/// Shows a warning-styled banner with admin feedback details.
class RevisionAlertBanner extends StatelessWidget {
  /// Creates a new [RevisionAlertBanner].
  const RevisionAlertBanner({
    required this.title,
    required this.message,
    this.adminFeedback,
    super.key,
  });

  /// The banner title (e.g., "Action Required: Revision Requested").
  final String title;

  /// The detailed message explaining what needs to be revised.
  final String message;

  /// Optional admin feedback quote.
  final String? adminFeedback;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();

    // Use warning color from semantic colors or fallback to orange
    final warningColor = semanticColors?.warning ?? Colors.orange;
    final warningContainerColor = warningColor.withValues(alpha: 0.1);
    final warningBorderColor = warningColor.withValues(alpha: 0.2);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: warningContainerColor,
        border: Border.all(color: warningBorderColor),
        borderRadius: AppDimens.radiusMedium,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning icon
          Icon(Icons.warning_rounded, color: warningColor, size: 28),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: warningColor.withValues(alpha: 0.9),
                  ),
                ),
                AppDimens.verticalSmall,
                // Message
                Text(
                  message,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                // Admin feedback quote
                if (adminFeedback != null) ...[
                  AppDimens.verticalMedium,
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: warningColor.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Admin Feedback: "$adminFeedback"',
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: warningColor.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
