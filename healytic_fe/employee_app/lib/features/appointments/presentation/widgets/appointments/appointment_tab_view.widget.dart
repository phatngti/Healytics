import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../domain/entities/employee_appointment.entity.dart';
import '../../providers/appointment_list.provider.dart';
import 'appointment_card.widget.dart';
import 'empty_appointments.widget.dart';

/// Displays a filtered list of appointments by status.
///
/// Includes pull-to-refresh, loading, error, and
/// empty-state handling.
class AppointmentTabView extends ConsumerWidget {
  /// The status filter for this tab.
  final EmployeeAppointmentStatus status;

  /// Human-readable label for empty state messaging.
  final String label;

  const AppointmentTabView({
    required this.status,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(
      appointmentListProvider(status: status),
    );

    return data.when(
      data: (list) {
        if (list.isEmpty) {
          return EmptyAppointments(
            statusLabel: label,
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(
            appointmentListProvider(status: status),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            itemCount: list.length,
            itemBuilder: (_, i) => Padding(
              padding: EdgeInsets.only(
                bottom: i < list.length - 1 ? 16 : 0,
              ),
              child: AppointmentCard(
                appointment: list[i],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => _ErrorView(
        onRetry: () => ref.invalidate(
          appointmentListProvider(status: status),
        ),
      ),
    );
  }
}

/// Error state with retry action.
class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: cs.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load',
            style: tt.bodyLarge,
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
