import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/manual_section_card.widget.dart';

/// Displays the "Pre-Service Guidelines" section
/// with a bulleted list of guideline strings.
class PreServiceGuide extends StatelessWidget {
  const PreServiceGuide({
    super.key,
    required this.guidelines,
  });

  /// List of guideline text strings.
  final List<String> guidelines;

  @override
  Widget build(BuildContext context) {
    return ManualSectionCard(
      title: 'Pre-Service Guidelines',
      child: Column(
        children: guidelines
            .map((text) => _BulletItem(text: text))
            .toList(),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: AppDimens.spaceMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '•',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.6,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
