import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:common/widgets/toast.dart';
import '../../data/repositories/employee_appointment_impl.repository.dart';
import '../../domain/entities/employee_appointment.entity.dart';
import '../providers/appointment_action.provider.dart';
import '../widgets/appointments/appointment_status_badge.widget.dart';
import '../../../../theme/app_theme.dart';

class AppointmentDetailScreen extends ConsumerWidget {
  final String appointmentId;
  const AppointmentDetailScreen({required this.appointmentId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repoFuture = ref
        .read(employeeAppointmentRepositoryProvider)
        .getById(appointmentId);
    return FutureBuilder<EmployeeAppointmentEntity?>(
      future: repoFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final appt = snap.data;
        if (appt == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Appointment not found')),
          );
        }
        return _DetailBody(appointment: appt);
      },
    );
  }
}

class _DetailBody extends ConsumerWidget {
  final EmployeeAppointmentEntity appointment;
  const _DetailBody({required this.appointment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status
          Row(
            children: [
              AppointmentStatusBadge(status: appointment.status),
              const Spacer(),
              if (appointment.price != null)
                Text(
                  NumberFormat.currency(
                    locale: 'vi_VN',
                    symbol: '₫',
                    decimalDigits: 0,
                  ).format(appointment.price),
                  style: tt.titleMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          // Service
          _Section(
            title: 'Service',
            children: [
              _DetailRow(label: 'Service', value: appointment.serviceName),
              _DetailRow(label: 'Category', value: appointment.category),
              _DetailRow(label: 'Duration', value: appointment.duration),
            ],
          ),
          const SizedBox(height: 16),
          // Customer
          _Section(
            title: 'Customer',
            children: [
              _DetailRow(label: 'Name', value: appointment.customerName),
            ],
          ),
          const SizedBox(height: 16),
          // Schedule
          _Section(
            title: 'Schedule',
            children: [
              _DetailRow(
                label: 'Date',
                value: DateFormat('EEEE, MMM d, y').format(appointment.date),
              ),
              _DetailRow(
                label: 'Time',
                value:
                    '${appointment.checkInTime} – ${appointment.checkOutTime}',
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Location
          _Section(
            title: 'Location',
            children: [
              _DetailRow(label: 'Clinic', value: appointment.clinicName),
              _DetailRow(label: 'Address', value: appointment.address),
            ],
          ),
          if (appointment.notes != null) ...[
            const SizedBox(height: 16),
            _Section(
              title: 'Notes',
              children: [Text(appointment.notes!, style: tt.bodyMedium)],
            ),
          ],
          const SizedBox(height: 32),
          // Action buttons
          _ActionButtons(appointment: appointment),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: tt.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: tt.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  final EmployeeAppointmentEntity appointment;
  const _ActionButtons({required this.appointment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final actionState = ref.watch(appointmentActionProvider);
    final isLoading = actionState.isLoading;

    return switch (appointment.status) {
      EmployeeAppointmentStatus.upcoming => Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isLoading ? null : () => _startService(context, ref),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Service'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isLoading ? null : () => _cancel(context, ref),
              icon: Icon(Icons.cancel_outlined, color: cs.error),
              label: Text('Cancel', style: TextStyle(color: cs.error)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: cs.error),
              ),
            ),
          ),
        ],
      ),
      EmployeeAppointmentStatus.inProgress => SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: isLoading ? null : () => _complete(context, ref),
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Complete Service'),
          style: FilledButton.styleFrom(
            backgroundColor:
                Theme.of(context).extension<SemanticColors>()?.success ??
                cs.primary,
          ),
        ),
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Future<void> _startService(BuildContext context, WidgetRef ref) async {
    final ok = await ref
        .read(appointmentActionProvider.notifier)
        .startService(appointment.id);
    if (context.mounted) {
      if (ok) {
        AppToast.success(context, 'Service started');
        context.pop();
      } else {
        AppToast.error(context, 'Failed to start');
      }
    }
  }

  Future<void> _complete(BuildContext context, WidgetRef ref) async {
    final ok = await ref
        .read(appointmentActionProvider.notifier)
        .completeService(appointment.id);
    if (context.mounted) {
      if (ok) {
        AppToast.success(context, 'Service completed');
        context.pop();
      } else {
        AppToast.error(context, 'Failed to complete');
      }
    }
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Appointment?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;
    final ok = await ref
        .read(appointmentActionProvider.notifier)
        .cancelAppointment(appointment.id);
    if (context.mounted) {
      if (ok) {
        AppToast.success(context, 'Appointment canceled');
        context.pop();
      } else {
        AppToast.error(context, 'Failed to cancel');
      }
    }
  }
}
