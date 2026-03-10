import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/manual_section_card.widget.dart';

/// Displays the "Hướng dẫn trước dịch vụ" section
/// with a bulleted list of guidelines.
class PreServiceGuide extends StatelessWidget {
  const PreServiceGuide({super.key, required this.guidelines});

  /// List of guideline text strings.
  final List<String> guidelines;

  @override
  Widget build(BuildContext context) {
    return ManualSectionCard(
      icon: Symbols.checklist,
      title: 'Hướng dẫn trước dịch vụ',
      child: Column(
        children: guidelines.map((text) => _BulletItem(text: text)).toList(),
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
      padding: EdgeInsets.only(bottom: AppDimens.spaceMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 7),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
