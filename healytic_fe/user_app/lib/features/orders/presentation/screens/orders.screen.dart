import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/widgets/main_screen_layout.widget.dart';
import 'package:user_app/features/orders/presentation/providers/appointment.provider.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/appointment_list.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/calendar/appointment_calendar.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/calendar/calendar_agenda_list.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/category_filters.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/orders_tab_bar.widget.dart';

/// Main appointment list screen, matching the
/// "Appointment List V1" HTML design reference.
///
/// Uses [MainScreenLayout] for consistent
/// header/background across navigation tabs.
class OrdersPage extends HookConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(bookingStatusRealtimeProvider);

    // Silently re-fetch appointments on every
    // screen access; only re-renders when data
    // has actually changed.
    useEffect(() {
      ref.read(filteredAppointmentsProvider.notifier).silentRefresh();
      return null;
    }, const []);

    return MainScreenLayout(
      title: 'Appointments',
      actions: [_LayoutToggleButton()],
      body: const _Body(),
    );
  }
}

/// Switches between card and calendar layouts
/// based on [selectedViewLayoutProvider].
class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(selectedViewLayoutProvider);

    return switch (layout) {
      AppointmentViewLayout.card => const _CardBody(),
      AppointmentViewLayout.calendar => const _CalendarBody(),
    };
  }
}

/// Card layout: tab bar + category filters +
/// appointment list (existing view).
class _CardBody extends StatelessWidget {
  const _CardBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        OrdersTabBar(),
        CategoryFilters(),
        Expanded(child: AppointmentList()),
      ],
    );
  }
}

/// Calendar layout: monthly calendar with
/// appointment markers + scrollable agenda list.
class _CalendarBody extends StatelessWidget {
  const _CalendarBody();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(children: [AppointmentCalendar(), CalendarAgendaList()]),
    );
  }
}

// ─── Layout toggle ─────────────────────────────────

/// Maps [AppointmentViewLayout] values to their
/// corresponding Material icons.
const _layoutIcons = {
  AppointmentViewLayout.card: Icons.view_agenda_outlined,
  AppointmentViewLayout.calendar: Icons.calendar_today_outlined,
};

/// App-bar action that opens a popup menu for
/// switching between appointment layout views.
class _LayoutToggleButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(selectedViewLayoutProvider);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PopupMenuButton<AppointmentViewLayout>(
      icon: Icon(_layoutIcons[current], color: colors.onSurfaceVariant),
      tooltip: 'Change layout',
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colors.surfaceContainer,
      onSelected: (layout) =>
          ref.read(selectedViewLayoutProvider.notifier).select(layout),
      itemBuilder: (_) => AppointmentViewLayout.values
          .map(
            (layout) => PopupMenuItem(
              value: layout,
              child: Row(
                children: [
                  Icon(
                    _layoutIcons[layout],
                    size: 20,
                    color: layout == current
                        ? colors.primary
                        : colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      layout.label,
                      style: textTheme.bodyMedium?.copyWith(
                        color: layout == current
                            ? colors.primary
                            : colors.onSurface,
                        fontWeight: layout == current
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (layout == current)
                    Icon(Icons.check_rounded, size: 18, color: colors.primary),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
