import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/widgets/main_screen_layout.widget.dart';
import 'package:user_app/features/orders/presentation/providers/appointment.provider.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/appointment_list.widget.dart';
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
    // Silently re-fetch appointments on every
    // screen access; only re-renders when data
    // has actually changed.
    useEffect(() {
      ref.read(appointmentsProvider.notifier).silentRefresh();
      return null;
    }, const []);

    return const MainScreenLayout(title: 'Appointments', body: _Body());
  }
}

class _Body extends StatelessWidget {
  const _Body();

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
