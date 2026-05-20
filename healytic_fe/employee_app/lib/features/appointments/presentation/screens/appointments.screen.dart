import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/entities/employee_appointment.entity.dart';
import '../widgets/appointments/appointment_tab_view.widget.dart';
import '../widgets/appointments/segmented_tab_control.widget.dart';

/// Main appointments screen with segmented tab
/// control for Upcoming, Doing, Completed, Canceled.
class AppointmentsScreen extends HookConsumerWidget {
  const AppointmentsScreen({super.key});

  static const _tabs = [
    (
      status: EmployeeAppointmentStatus.upcoming,
      label: 'Upcoming',
    ),
    (
      status: EmployeeAppointmentStatus.inProgress,
      label: 'Doing',
    ),
    (
      status: EmployeeAppointmentStatus.completed,
      label: 'Completed',
    ),
    (
      status: EmployeeAppointmentStatus.canceled,
      label: 'Canceled',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20, 24, 20, 0,
              ),
              child: Text(
                'My Appointments',
                style: tt.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SegmentedTabControl(
                labels: _tabs
                    .map((t) => t.label)
                    .toList(),
                selectedIndex: selectedIndex.value,
                onChanged: (i) =>
                    selectedIndex.value = i,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 250,
                ),
                child: AppointmentTabView(
                  key: ValueKey(
                    _tabs[selectedIndex.value].status,
                  ),
                  status:
                      _tabs[selectedIndex.value].status,
                  label:
                      _tabs[selectedIndex.value].label,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
