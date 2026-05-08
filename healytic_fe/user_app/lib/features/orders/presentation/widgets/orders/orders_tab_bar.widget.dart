import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/orders/presentation/providers/appointment.provider.dart';

/// Horizontal tab bar for switching between
/// Upcoming / Completed / Canceled appointment lists.
class OrdersTabBar extends HookConsumerWidget {
  const OrdersTabBar({super.key});

  static const _tabs = ['Pending', 'Upcoming', 'Completed', 'Canceled'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedTabProvider);
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: AppDimens.paddingHorizontalMedium,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final isActive = selected == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => ref.read(selectedTabProvider.notifier).select(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? cs.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: cs.shadow.withValues(alpha: 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      _tabs[i],
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isActive ? cs.primary : cs.onSurfaceVariant,
                      ),
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
