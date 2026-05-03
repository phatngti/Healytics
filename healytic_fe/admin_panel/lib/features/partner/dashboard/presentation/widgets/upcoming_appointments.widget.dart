import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/table/helper.dart';
import 'package:common/widgets/table/table.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/upcoming_appointment.entity.dart';
import 'dashboard_constants.dart';
import 'dashboard_section_header.widget.dart';

/// Data table displaying the next upcoming
/// appointments.
class UpcomingAppointmentsWidget extends StatelessWidget {
  const UpcomingAppointmentsWidget({super.key, required this.appointments});

  final List<UpcomingAppointment> appointments;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rowsPerPage = appointments.length.clamp(1, 5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionHeader(
          title: 'Upcoming Appointments',
          icon: Icons.calendar_today_rounded,
        ),
        ClipRect(
          child: SizedBox(
            height: _tableHeight(rowsPerPage),
            child: AppTable(
              columns: _UpcomingAppointmentsTableColumns.columns.dataColumns(
                context,
              ),
              getTotalRows: () async => appointments.length,
              getData: (setRowSelection, startingAt, count) =>
                  _UpcomingAppointmentsTableSource.getData(
                    theme,
                    appointments,
                    startingAt,
                    count,
                  ),
              defaultRowsPerPage: rowsPerPage,
              buttons: [
                AppButton(
                  onPressed: () {},
                  buttonType: ButtonType.link,
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Calculates table height based on row count.
  double _tableHeight(int rowsPerPage) {
    if (appointments.isEmpty) {
      return DashboardSizes.tableMinHeight;
    }
    return DashboardSizes.tableOverhead +
        (rowsPerPage * DashboardSizes.tableRowHeight);
  }
}

class _UpcomingAppointmentsTableColumns {
  static const TableColumns columns = TableColumns(
    columns: [
      TableColumnData(label: 'Patient', size: ColumnSize.L),
      TableColumnData(label: 'Service', size: ColumnSize.L),
      TableColumnData(label: 'Staff', size: ColumnSize.L),
      TableColumnData(label: 'Time', size: ColumnSize.S),
      TableColumnData(label: 'Status', size: ColumnSize.S),
    ],
  );
}

class _UpcomingAppointmentsTableSource {
  static Future<List<DataRow>> getData(
    ThemeData theme,
    List<UpcomingAppointment> appointments,
    int startingAt,
    int count,
  ) async {
    final visibleAppointments = appointments.skip(startingAt).take(count);

    return visibleAppointments.map((appointment) {
      return DataRow(
        key: ValueKey<String>(appointment.id),
        cells: [
          DataCell(
            _TablePrimaryCell(
              title: appointment.patientName,
              subtitle: appointment.id.toUpperCase(),
            ),
          ),
          DataCell(
            Text(
              appointment.serviceName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: AppDimens.fontWeightSemiBold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              appointment.employeeName,
              style: theme.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            _TablePrimaryCell(
              title: DateFormat('HH:mm').format(appointment.scheduledAt),
              subtitle: _formatDateLabel(appointment.scheduledAt),
            ),
          ),
          DataCell(
            Align(
              alignment: Alignment.centerLeft,
              child: _StatusChip(status: appointment.status),
            ),
          ),
        ],
      );
    }).toList();
  }

  static String _formatDateLabel(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) return 'Today';
    if (date == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    }
    return DateFormat('MMM d').format(dateTime);
  }
}

class _TablePrimaryCell extends StatelessWidget {
  const _TablePrimaryCell({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: AppDimens.fontWeightSemiBold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppDimens.spaceXxs.verticalSpace,
        Text(
          subtitle,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (color, bgColor) = switch (status) {
      'confirmed' => (
        DashboardColors.confirmed,
        DashboardColors.confirmed.withValues(alpha: 0.1),
      ),
      'pending' => (
        DashboardColors.pending,
        DashboardColors.pending.withValues(alpha: 0.1),
      ),
      _ => (
        theme.colorScheme.onSurfaceVariant,
        theme.colorScheme.surfaceContainerHighest,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceXs + 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: AppDimens.fontWeightSemiBold,
        ),
      ),
    );
  }
}
