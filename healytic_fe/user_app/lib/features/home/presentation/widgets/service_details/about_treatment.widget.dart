import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// "About Treatment" section with a title, clamped description,
/// and an animated **Show more / Show less** toggle.
///
/// The text is limited to [collapsedMaxLines] when collapsed.
/// If the description fits within that limit the toggle is
/// hidden automatically.
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
            final textSpan = TextSpan(
              text: widget.description,
              style: descriptionStyle,
            );

            final textPainter = TextPainter(
              text: textSpan,
              maxLines: widget.collapsedMaxLines,
              textDirection: TextDirection.ltr,
            )..layout(maxWidth: constraints.maxWidth);

            final isOverflowing = textPainter.didExceedMaxLines;

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
