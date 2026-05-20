import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Expandable "About Clinic" section with a Read
/// More toggle.
class AboutClinicSection extends StatefulWidget {
  const AboutClinicSection({super.key, required this.description});

  final String description;

  @override
  State<AboutClinicSection> createState() => _AboutClinicSectionState();
}

class _AboutClinicSectionState extends State<AboutClinicSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hPad = AppDimens.horizontalPadding(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ABOUT CLINIC',
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.description,
            maxLines: _expanded ? null : 3,
            overflow: _expanded ? null : TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
              fontSize: 11,
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft,
            ),
            child: Text(
              _expanded ? 'Show Less' : 'Read More',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
