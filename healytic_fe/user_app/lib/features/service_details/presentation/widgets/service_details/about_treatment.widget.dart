import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// "About Treatment" section with a title, clamped
/// description, and an animated **Show more / Show
/// less** toggle.
///
/// The text is limited to [collapsedMaxLines] when
/// collapsed. If the description fits within that limit
/// the toggle is hidden automatically.
///
/// Text measurement is cached in state and only
/// recomputed when the data or constraints change.
class AboutTreatment extends StatefulWidget {
  const AboutTreatment({
    super.key,
    required this.description,
    this.title = 'About Treatment',
    this.collapsedMaxLines = 3,
  });

  /// Section heading.
  final String title;

  /// Full description text.
  final String description;

  /// Maximum visible lines when collapsed.
  final int collapsedMaxLines;

  @override
  State<AboutTreatment> createState() => _AboutTreatmentState();
}

class _AboutTreatmentState extends State<AboutTreatment>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  /// Cached overflow result – avoids running
  /// [TextPainter] on every build during animations.
  bool? _isOverflowing;

  /// The last constraint width used for measurement.
  double? _lastMeasuredWidth;

  @override
  void didUpdateWidget(covariant AboutTreatment old) {
    super.didUpdateWidget(old);
    if (old.description != widget.description ||
        old.collapsedMaxLines != widget.collapsedMaxLines) {
      _isOverflowing = null;
      _lastMeasuredWidth = null;
    }
  }

  /// Measures whether the description overflows the
  /// given [maxWidth] at [collapsedMaxLines].
  bool _measureOverflow(double maxWidth, TextStyle? style) {
    if (_isOverflowing != null && _lastMeasuredWidth == maxWidth) {
      return _isOverflowing!;
    }
    final textSpan = TextSpan(text: widget.description, style: style);
    final painter = TextPainter(
      text: textSpan,
      maxLines: widget.collapsedMaxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    _isOverflowing = painter.didExceedMaxLines;
    _lastMeasuredWidth = maxWidth;
    painter.dispose();
    return _isOverflowing!;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final descriptionStyle = textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
      height: 1.6,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        AppDimens.verticalSmall,

        // Use LayoutBuilder to detect whether
        // the text actually overflows.
        LayoutBuilder(
          builder: (context, constraints) {
            final isOverflowing = _measureOverflow(
              constraints.maxWidth,
              descriptionStyle,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: Text(
                    widget.description,
                    style: descriptionStyle,
                    maxLines: _expanded ? null : widget.collapsedMaxLines,
                    overflow: _expanded ? null : TextOverflow.ellipsis,
                  ),
                ),

                // Only show the toggle when
                // the text actually overflows.
                if (isOverflowing) ...[
                  AppDimens.verticalExtraSmall,
                  GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Text(
                      _expanded ? 'Show less' : 'Show more',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
