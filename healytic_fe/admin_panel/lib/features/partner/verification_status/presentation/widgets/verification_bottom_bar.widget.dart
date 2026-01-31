import 'dart:ui';

import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Fixed bottom bar with status display and action buttons.
///
/// Displays the current verification status, a cancel button, and
/// a primary resubmit button.
class VerificationBottomBar extends StatelessWidget {
  /// Creates a new [VerificationBottomBar].
  const VerificationBottomBar({
    required this.status,
    required this.onCancel,
    required this.onResubmit,
    this.isLoading = false,
    super.key,
  });

  /// The current verification status.
  final VerificationRevisionStatus status;

  /// Whether a submission is in progress.
  final bool isLoading;

  /// Callback when cancel is pressed.
  final VoidCallback onCancel;

  /// Callback when resubmit is pressed.
  final VoidCallback onResubmit;

  String get _statusText {
    switch (status) {
      case VerificationRevisionStatus.pending:
        return 'Pending Review';
      case VerificationRevisionStatus.underReview:
        return 'Under Review';
      case VerificationRevisionStatus.revisionRequested:
        return 'Awaiting Revision';
      case VerificationRevisionStatus.approved:
        return 'Approved';
      case VerificationRevisionStatus.rejected:
        return 'Rejected';
    }
  }

  Color _statusColor(BuildContext context) {
    final semanticColors = Theme.of(context).extension<SemanticColors>();

    switch (status) {
      case VerificationRevisionStatus.pending:
      case VerificationRevisionStatus.underReview:
        return semanticColors?.info ?? Colors.blue;
      case VerificationRevisionStatus.revisionRequested:
        return semanticColors?.warning ?? Colors.orange;
      case VerificationRevisionStatus.approved:
        return semanticColors?.success ?? Colors.green;
      case VerificationRevisionStatus.rejected:
        return semanticColors?.error ?? Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.8),
            border: Border(
              top: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Row(
                  children: [
                    // Status display (hidden on mobile)
                    Expanded(
                      child: MediaQuery.of(context).size.width > 600
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'STATUS',
                                  style: textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    color: colorScheme.outline,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _statusText,
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _statusColor(context),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                    // Action buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Cancel button
                        SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: isLoading ? null : onCancel,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Resubmit button
                        SizedBox(
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: isLoading ? null : onResubmit,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: isLoading
                                ? SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorScheme.onPrimary,
                                    ),
                                  )
                                : const Icon(Icons.send, size: 18),
                            label: Text(
                              isLoading
                                  ? 'Submitting...'
                                  : 'Resubmit Application',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
