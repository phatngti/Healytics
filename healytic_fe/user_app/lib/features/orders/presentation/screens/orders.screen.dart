import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/appointment_list.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/category_filters.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/orders_tab_bar.widget.dart';

/// Main appointment list screen, matching the
/// "Appointment List V1" HTML design reference.
class OrdersPage extends HookConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Appointment'),
        centerTitle: true,
      ),
      body: const _Body(),
    );
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
