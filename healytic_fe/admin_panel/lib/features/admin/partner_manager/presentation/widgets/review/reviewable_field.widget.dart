import 'package:admin_panel/features/admin/partner_manager/domain/field_feedback.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/review_feedback.provider.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A wrapper widget that adds field-level feedback controls to any content.
///
/// Displays accept (check) and edit (revision) buttons next to the child
/// content. The edit button toggles a feedback popover for entering revision
/// notes.
class ReviewableField extends ConsumerStatefulWidget {
  const ReviewableField({
    required this.fieldId,
    required this.child,
    required this.title,
    this.titleStyle,
    this.compactMode = false,
    this.readOnly = false,
    super.key,
  });

  /// Unique identifier for the field (e.g., 'business.brandName')
  final String fieldId;

  /// Optional title displayed above the field content
  final String title;

  /// Custom style for the title text
  final TextStyle? titleStyle;

  /// The field content to wrap
  final Widget child;

  /// Use smaller buttons for compact layouts
  final bool compactMode;

  /// When true, hides feedback controls (view-only mode)
  final bool readOnly;

  @override
  ConsumerState<ReviewableField> createState() => _ReviewableFieldState();
}

class _ReviewableFieldState extends ConsumerState<ReviewableField> {
  final _overlayController = OverlayPortalController();
  final _feedbackController = TextEditingController();
  final _linkKey = GlobalKey();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _handleAccept() {
    ref.read(reviewFeedbackProvider.notifier).acceptField(widget.fieldId);
  }

  void _handleEditToggle() {
    if (_overlayController.isShowing) {
      _overlayController.hide();
    } else {
      // Pre-populate with existing note if any
      final existing = ref
          .read(reviewFeedbackProvider.notifier)
          .getFeedback(widget.fieldId);
      _feedbackController.text = existing?.note ?? '';
      _overlayController.show();
    }
  }

  void _handleSaveFeedback() {
    final note = _feedbackController.text.trim();
    if (note.isNotEmpty) {
      ref
          .read(reviewFeedbackProvider.notifier)
          .requestRevision(widget.fieldId, note);
    }
    _overlayController.hide();
  }

  @override
  Widget build(BuildContext context) {
    final feedbackMap = ref.watch(reviewFeedbackProvider);
    final feedback = feedbackMap[widget.fieldId];
    final status = feedback?.status ?? FieldFeedbackStatus.pending;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // In readOnly mode, skip feedback controls entirely
    if (widget.readOnly) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: widget.title,
            child: Text(
              widget.title,
              style:
                  widget.titleStyle ??
                  textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppDimens.verticalExtraSmall,
          widget.child,
        ],
      );
    }

    // Build feedback controls widget
    Widget feedbackControls = OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (context) => _buildFeedbackPopover(context),
      child: _FieldFeedbackControls(
        key: _linkKey,
        status: status,
        compactMode: widget.compactMode,
        onAccept: _handleAccept,
        onEditToggle: _handleEditToggle,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Tooltip(
                message: widget.title,
                child: Text(
                  widget.title,
                  style:
                      widget.titleStyle ??
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
            feedbackControls,
          ],
        ),
        AppDimens.verticalExtraSmall,
        widget.child,
      ],
    );
  }

  Widget _buildFeedbackPopover(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semantics = Theme.of(context).extension<SemanticColors>();
    final warningColor = semantics?.warning ?? Colors.orange;

    // Get position of the link (edit button)
    final renderBox = _linkKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return const SizedBox.shrink();

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenSize = MediaQuery.of(context).size;

    // Estimated popover height (header + textarea + button + padding)
    const popoverHeight = 180.0;
    const popoverWidth = 288.0;
    const gap = 8.0;

    // Check if there's enough space below the button
    final spaceBelow = screenSize.height - (position.dy + size.height + gap);
    final spaceAbove = position.dy - gap;
    final showAbove = spaceBelow < popoverHeight && spaceAbove > popoverHeight;

    // Calculate horizontal position (prefer right-aligned, but ensure it fits)
    final rightOffset = screenSize.width - position.dx - size.width;
    final adjustedRight = rightOffset.clamp(
      8.0,
      screenSize.width - popoverWidth - 8,
    );

    return Stack(
      children: [
        // Tap barrier to dismiss popup
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _overlayController.hide(),
            child: const SizedBox.expand(),
          ),
        ),
        // Popover
        Positioned(
          top: showAbove ? null : position.dy + size.height + gap,
          bottom: showAbove ? screenSize.height - position.dy + gap : null,
          right: adjustedRight,
          child: Material(
            elevation: 8,
            borderRadius: AppDimens.radiusSmall,
            shadowColor: colorScheme.shadow.withValues(alpha: 0.2),
            child: Container(
              width: 288,
              padding: AppDimens.paddingAllMediumSmall,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: AppDimens.radiusSmall,
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'REVISION NOTE',
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 0.5,
                        ),
                      ),
                      InkWell(
                        onTap: () => _overlayController.hide(),
                        borderRadius: BorderRadius.circular(12),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  AppDimens.verticalSmall,

                  // Textarea
                  TextField(
                    controller: _feedbackController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Describe the issue...',
                      hintStyle: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: AppDimens.radiusSmall,
                        borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppDimens.radiusSmall,
                        borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: AppDimens.radiusSmall,
                        borderSide: BorderSide(color: warningColor, width: 1),
                      ),
                      contentPadding: AppDimens.paddingAllSmall,
                      isDense: true,
                    ),
                    style: textTheme.bodySmall,
                  ),
                  AppDimens.verticalSmall,

                  // Save button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _handleSaveFeedback,
                      style: TextButton.styleFrom(
                        backgroundColor: warningColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppDimens.radiusExtraSmall,
                        ),
                        textStyle: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Save Feedback'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The accept/edit button controls for field feedback
class _FieldFeedbackControls extends StatelessWidget {
  const _FieldFeedbackControls({
    required this.status,
    required this.onAccept,
    required this.onEditToggle,
    this.compactMode = false,
    super.key,
  });

  final FieldFeedbackStatus status;
  final VoidCallback onAccept;
  final VoidCallback onEditToggle;
  final bool compactMode;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final semantics = Theme.of(context).extension<SemanticColors>();
    final successColor = semantics?.success ?? Colors.green;
    final warningColor = semantics?.warning ?? Colors.orange;

    final buttonSize = compactMode ? 28.0 : 32.0;
    final iconSize = compactMode ? 16.0 : 18.0;

    final isAccepted = status == FieldFeedbackStatus.accepted;
    final isRevisionRequested = status == FieldFeedbackStatus.revisionRequested;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Accept button
        _FeedbackButton(
          icon: Icons.check,
          size: buttonSize,
          iconSize: iconSize,
          isActive: isAccepted,
          activeColor: successColor,
          inactiveColor: colorScheme.onSurfaceVariant,
          onTap: onAccept,
          tooltip: 'Accept',
        ),
        const SizedBox(width: 4),
        // Edit button
        _FeedbackButton(
          icon: Icons.edit,
          size: buttonSize,
          iconSize: iconSize,
          isActive: isRevisionRequested,
          activeColor: warningColor,
          inactiveColor: colorScheme.onSurfaceVariant,
          onTap: onEditToggle,
          tooltip: 'Request Edit',
          showRing: isRevisionRequested,
        ),
      ],
    );
  }
}

/// Individual feedback button with hover and active states
class _FeedbackButton extends StatefulWidget {
  const _FeedbackButton({
    required this.icon,
    required this.size,
    required this.iconSize,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
    required this.tooltip,
    this.showRing = false,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;
  final String tooltip;
  final bool showRing;

  @override
  State<_FeedbackButton> createState() => _FeedbackButtonState();
}

class _FeedbackButtonState extends State<_FeedbackButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Determine colors based on state
    Color iconColor;
    Color backgroundColor;
    BoxBorder? border;

    if (widget.isActive) {
      iconColor = widget.activeColor;
      backgroundColor = widget.activeColor.withValues(alpha: 0.1);
      border = widget.showRing
          ? Border.all(
              color: widget.activeColor.withValues(alpha: 0.3),
              width: 1,
            )
          : null;
    } else if (_isHovered) {
      iconColor = widget.activeColor;
      backgroundColor = colorScheme.surfaceContainerHighest;
      border = null;
    } else {
      iconColor = widget.inactiveColor.withValues(alpha: 0.5);
      backgroundColor = Colors.transparent;
      border = null;
    }

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: border,
            ),
            child: Center(
              child: Icon(widget.icon, size: widget.iconSize, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}
