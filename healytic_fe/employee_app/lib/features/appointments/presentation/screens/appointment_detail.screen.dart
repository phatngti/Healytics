import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/employee_appointment_impl.repository.dart';
import '../../domain/entities/employee_appointment.entity.dart';
import '../widgets/appointment_detail/detail_action_bar.widget.dart';
import '../widgets/appointment_detail/detail_info_card.widget.dart';
import '../widgets/appointments/appointment_status_badge.widget.dart';

/// Full-screen detail view for a single appointment.
///
/// Fetches data by [appointmentId], shows loading/error,
/// then delegates to [_DetailBody] for the design.
class AppointmentDetailScreen extends ConsumerWidget {
  /// The appointment ID to look up.
  final String appointmentId;

  const AppointmentDetailScreen({
    required this.appointmentId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repoFuture = ref
        .read(employeeAppointmentRepositoryProvider)
        .getById(appointmentId);

    return FutureBuilder<EmployeeAppointmentEntity?>(
      future: repoFuture,
      builder: (context, snap) {
        if (snap.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final appt = snap.data;
        if (appt == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Appointment not found'),
            ),
          );
        }
        return _DetailBody(appointment: appt);
      },
    );
  }
}

/// Composition shell: centered header + scrollable
/// content + fixed bottom action bar.
class _DetailBody extends StatelessWidget {
  final EmployeeAppointmentEntity appointment;
  const _DetailBody({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final hPad = AppDimens.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointment Detail',
          style: tt.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: hPad,
          vertical: AppDimens.spaceLg,
        ),
        children: [
          // Status & price row
          _StatusPriceRow(appointment: appointment),
          AppDimens.verticalMedium,
          // Main detail card
          DetailInfoCard(appointment: appointment),
        ],
      ),
      // Fixed bottom action bar
      bottomNavigationBar: DetailActionBar(
        appointment: appointment,
      ),
    );
  }
}

/// Row displaying the status badge and price.
class _StatusPriceRow extends StatelessWidget {
  final EmployeeAppointmentEntity appointment;
  const _StatusPriceRow({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        AppointmentStatusBadge(
          status: appointment.status,
        ),
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
    );
  }
}
