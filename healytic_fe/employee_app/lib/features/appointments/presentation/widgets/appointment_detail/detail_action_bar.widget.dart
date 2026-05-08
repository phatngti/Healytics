import 'package:common/utils/demensions.dart';
import 'package:common/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../theme/app_theme.dart';
import '../../../domain/entities/employee_appointment.entity.dart';
import '../../providers/appointment_action.provider.dart';

/// Fixed bottom action bar for appointment details.
///
/// Renders status-appropriate action buttons with
/// pill-shaped design matching the HTML footer pattern.
class DetailActionBar extends ConsumerWidget {
  /// The current appointment entity.
  final EmployeeAppointmentEntity appointment;

  const DetailActionBar({
    required this.appointment,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttons = _buildButtons(context, ref);
    if (buttons == null) {
      return const SizedBox.shrink();
    }

    final cs = Theme.of(context).colorScheme;
    final safePad = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.92),
        border: Border(
          top: BorderSide(
            color: cs.outlineVariant
                .withValues(alpha: 0.3),
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimens.horizontalPadding(context),
        AppDimens.spaceLg,
        AppDimens.horizontalPadding(context),
        AppDimens.spaceLg + safePad,
      ),
      child: buttons,
    );
  }

  /// Returns status-specific action buttons or null.
  Widget? _buildButtons(
    BuildContext context,
    WidgetRef ref,
  ) {
    final actionState = ref.watch(
      appointmentActionProvider,
    );
    final isLoading = actionState.isLoading;

    return switch (appointment.status) {
      EmployeeAppointmentStatus.upcoming =>
        _UpcomingActions(
          appointment: appointment,
          isLoading: isLoading,
        ),
      EmployeeAppointmentStatus.inProgress =>
        _InProgressAction(
          appointment: appointment,
          isLoading: isLoading,
        ),
      _ => null,
    };
  }
}

/// Start + Cancel buttons for upcoming appointments.
class _UpcomingActions extends ConsumerWidget {
  final EmployeeAppointmentEntity appointment;
  final bool isLoading;

  const _UpcomingActions({
    required this.appointment,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context)
        .textTheme
        .labelSmall
        ?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary: Start Service
        SizedBox(
          width: double.infinity,
          height: AppDimens.touchTarget,
          child: FilledButton.icon(
            onPressed: isLoading
                ? null
                : () => _startService(context, ref),
            icon: const Icon(Icons.play_arrow),
            label: const Text('START SERVICE'),
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              textStyle: labelStyle,
            ),
          ),
        ),
        AppDimens.verticalMediumSmall,
        // Secondary: Cancel
        SizedBox(
          width: double.infinity,
          height: AppDimens.touchTarget,
          child: OutlinedButton.icon(
            onPressed: isLoading
                ? null
                : () => _cancel(context, ref),
            icon: Icon(
              Icons.cancel_outlined,
              color: cs.error,
            ),
            label: Text(
              'CANCEL',
              style: TextStyle(color: cs.error),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: cs.error),
              shape: const StadiumBorder(),
              textStyle: labelStyle,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _startService(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final ok = await ref
        .read(appointmentActionProvider.notifier)
        .startService(appointment.id);
    if (!context.mounted) return;
    if (ok) {
      AppToast.success(context, 'Service started');
      context.pop();
    } else {
      AppToast.error(context, 'Failed to start');
    }
  }

  Future<void> _cancel(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Appointment?'),
        content: const Text(
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;
    final ok = await ref
        .read(appointmentActionProvider.notifier)
        .cancelAppointment(appointment.id);
    if (!context.mounted) return;
    if (ok) {
      AppToast.success(
        context,
        'Appointment canceled',
      );
      context.pop();
    } else {
      AppToast.error(context, 'Failed to cancel');
    }
  }
}

/// Complete button for in-progress appointments.
class _InProgressAction extends ConsumerWidget {
  final EmployeeAppointmentEntity appointment;
  final bool isLoading;

  const _InProgressAction({
    required this.appointment,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: AppDimens.touchTarget,
      child: FilledButton.icon(
        onPressed: isLoading
            ? null
            : () => _complete(context, ref),
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('COMPLETE SERVICE'),
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context)
                  .extension<SemanticColors>()
                  ?.success ??
              cs.primary,
          shape: const StadiumBorder(),
          textStyle: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
        ),
      ),
    );
  }

  Future<void> _complete(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final ok = await ref
        .read(appointmentActionProvider.notifier)
        .completeService(appointment.id);
    if (!context.mounted) return;
    if (ok) {
      AppToast.success(context, 'Service completed');
      context.pop();
    } else {
      AppToast.error(context, 'Failed to complete');
    }
  }
}
