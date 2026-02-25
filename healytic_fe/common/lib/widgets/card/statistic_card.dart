import 'package:common/utils/demensions.dart';
import 'package:common/utils/responsive.dart';
import 'package:flutter/material.dart';

/// A responsive card widget that displays a key metric with a label,
/// value, and percentage change indicator.
///
/// The card auto-sizes for mobile (fills available width) and uses
/// proportional widths on tablet and web. The change value is colored
/// green (primary) for positive and red (error) for negative values.
///
/// ```dart
/// StatisticCard(
///   label: 'Revenue',
///   value: '\$12,500',
///   change: 8.5, // +8.5% shown in primary color
/// )
/// ```
class StatisticCard extends StatelessWidget {
  /// Creates a [StatisticCard].
  ///
  /// - [label] — Descriptive label text (e.g. "Total Users").
  /// - [value] — The metric value displayed prominently (e.g. "1,234").
  /// - [change] — Percentage change; positive shows "+", negative shows "-".
  /// - [positiveColor] — Override color for positive change (defaults to primary).
  /// - [negativeColor] — Override color for negative change (defaults to error).
  const StatisticCard({
    super.key,
    required this.label,
    required this.value,
    required this.change,
    this.positiveColor,
    this.negativeColor,
  });

  /// Descriptive label for the metric.
  final String label;

  /// The formatted metric value.
  final String value;

  /// The percentage change value. Positive values are prefixed with "+".
  final double change;

  /// Color for positive change values. Defaults to [ColorScheme.primary].
  final Color? positiveColor;

  /// Color for negative change values. Defaults to [ColorScheme.error].
  final Color? negativeColor;

  @override
  Widget build(BuildContext context) {
    final width = responsive<double?>(
      context,
      mobile: null, // fill available space
      tablet: screenWidth(context) * 0.2,
      web: screenWidth(context) * 0.15,
    );

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: AppDimens.responsiveRadius(context),
      ),
      padding: AppDimens.responsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
              fontSize: AppDimens.responsiveFontSize(
                context,
                mobile: AppDimens.fontSizeMedium,
                web: AppDimens.fontSizeLarge,
              ),
            ),
          ),
          AppDimens.verticalSmall,
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: AppDimens.fontWeightBold,
              fontSize: AppDimens.responsiveFontSize(
                context,
                mobile: AppDimens.fontSizeExtraExtraLarge,
                web: AppDimens.fontSizeExtraExtraExtraExtraLarge,
              ),
            ),
          ),
          AppDimens.verticalSmall,
          Text(
            '${change < 0 ? "-${change.toString()}" : "+${change.toString()}"}%',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: change < 0
                  ? (negativeColor ?? Theme.of(context).colorScheme.error)
                  : (positiveColor ?? Theme.of(context).colorScheme.primary),
              fontSize: AppDimens.responsiveFontSize(
                context,
                mobile: AppDimens.fontSizeMedium,
                web: AppDimens.fontSizeLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
