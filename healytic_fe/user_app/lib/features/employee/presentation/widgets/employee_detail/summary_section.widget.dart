import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Bio/summary section with "Show more / Show less"
/// toggle for long descriptions.
class EmployeeSummarySection extends StatefulWidget {
  const EmployeeSummarySection({
    super.key,
    required this.description,
    this.collapsedLines = 3,
  });

  final String description;

  /// Max lines shown when collapsed.
  final int collapsedLines;

  @override
  State<EmployeeSummarySection> createState() => _EmployeeSummarySectionState();
}

class _EmployeeSummarySectionState extends State<EmployeeSummarySection> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final hPad = AppDimens.horizontalPadding(context);
    final section = AppDimens.sectionSpacing(context);

    final bodyStyle = textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
      height: 1.6,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppDimens.verticalSmall,
          Text(
            widget.description,
            style: bodyStyle,
            maxLines: _showAll ? null : widget.collapsedLines,
            overflow: _showAll ? null : TextOverflow.ellipsis,
          ),
          AppDimens.verticalExtraSmall,
          GestureDetector(
            onTap: () => setState(() => _showAll = !_showAll),
            child: Text(
              _showAll ? 'Show less' : 'Show more',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
