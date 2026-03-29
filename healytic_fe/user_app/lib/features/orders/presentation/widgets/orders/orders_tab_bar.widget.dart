import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/orders/presentation/providers/appointment.provider.dart';

/// Horizontal tab bar for switching between
/// Upcoming / Completed / Canceled appointment lists.
class OrdersTabBar extends HookConsumerWidget {
  const OrdersTabBar({super.key});

  static const _tabs = ['Upcoming', 'Completed', 'Canceled'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedTabProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: AppDimens.paddingHorizontalMedium,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: colors.outlineVariant),
          ),
        ),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final isActive = selected == i;
            return Expanded(
              child: InkWell(
                onTap: () => ref
                    .read(selectedTabProvider.notifier)
                    .select(i),
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: AppDimens.spaceMd,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: AppDimens.borderWidthThick,
                        color: isActive
                            ? colors.primary
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  child: Text(
                    _tabs[i],
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isActive
                          ? colors.primary
                          : colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
