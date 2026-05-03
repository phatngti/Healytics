import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/entities/employee_appointment.entity.dart';
import '../providers/appointment_list.provider.dart';
import '../widgets/appointments/appointment_card.widget.dart';
import '../widgets/appointments/empty_appointments.widget.dart';

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Appointments',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: false,
          bottom: TabBar(
            labelStyle: Theme.of(context).textTheme.labelLarge,
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Canceled'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TabView(
              status: EmployeeAppointmentStatus.upcoming,
              label: 'upcoming',
            ),
            _TabView(
              status: EmployeeAppointmentStatus.completed,
              label: 'completed',
            ),
            _TabView(
              status: EmployeeAppointmentStatus.canceled,
              label: 'canceled',
            ),
          ],
        ),
      ),
    );
  }
}

class _TabView extends ConsumerWidget {
  final EmployeeAppointmentStatus status;
  final String label;
  const _TabView({required this.status, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(appointmentListProvider(status: status));
    return data.when(
      data: (list) {
        if (list.isEmpty) return EmptyAppointments(statusLabel: label);
        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(appointmentListProvider(status: status)),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: list.length,
            itemBuilder: (_, i) => AppointmentCard(appointment: list[i]),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextButton(
              onPressed: () =>
                  ref.invalidate(appointmentListProvider(status: status)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
