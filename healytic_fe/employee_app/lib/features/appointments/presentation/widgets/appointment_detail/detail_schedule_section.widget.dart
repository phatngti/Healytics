import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'detail_section_header.widget.dart';

/// Schedule section with calendar icon, formatted date,
/// and indented time range.
class DetailScheduleSection extends StatelessWidget {
  /// Appointment date.
  final DateTime date;

  /// Check-in time string (e.g. "10:00").
  final String checkInTime;

  /// Check-out time string (e.g. "11:30").
  final String checkOutTime;

  const DetailScheduleSection({
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailSectionHeader(title: 'Schedule'),
        AppDimens.verticalSmall,
        _DateRow(
          date: date,
          iconColor: cs.primary,
          textStyle: tt.bodyMedium,
        ),
        // Indented time range below calendar icon
        Padding(
          padding: const EdgeInsets.only(
            left: AppDimens.iconMd + AppDimens.spaceSm,
            top: AppDimens.spaceXs,
          ),
          child: Text(
            '$checkInTime – $checkOutTime',
            style: tt.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

/// Date row with calendar icon.
class _DateRow extends StatelessWidget {
  final DateTime date;
  final Color iconColor;
  final TextStyle? textStyle;

  const _DateRow({
    required this.date,
    required this.iconColor,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: AppDimens.iconMd,
          color: iconColor,
        ),
        AppDimens.horizontalSmall,
        Text(
          DateFormat('EEEE, MMM d, y').format(date),
          style: textStyle?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
