import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/employee_appointment.entity.dart';
import 'detail_customer_section.widget.dart';
import 'detail_location_section.widget.dart';
import 'detail_notes_section.widget.dart';
import 'detail_schedule_section.widget.dart';
import 'detail_service_section.widget.dart';

/// Card composing all detail sections with dividers.
///
/// Implements the HTML "Card-on-Surface" pattern with
/// rounded corners, subtle border, and soft shadow.
class DetailInfoCard extends StatelessWidget {
  /// The appointment entity to display.
  final EmployeeAppointmentEntity appointment;

  const DetailInfoCard({
    required this.appointment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pad = AppDimens.cardPadding(context);
    final radius = AppDimens.cardRadius(context);

    return Container(
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: cs.outlineVariant
              .withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: AppDimens.spaceSm,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service
          DetailServiceSection(
            serviceName: appointment.serviceName,
            category: appointment.category,
            duration: appointment.duration,
          ),
          _sectionDivider(cs),

          // Customer
          DetailCustomerSection(
            customerName: appointment.customerName,
            imageUrl: appointment.imageUrl,
          ),
          _sectionDivider(cs),

          // Schedule
          DetailScheduleSection(
            date: appointment.date,
            checkInTime: appointment.checkInTime,
            checkOutTime: appointment.checkOutTime,
          ),
          _sectionDivider(cs),

          // Location
          DetailLocationSection(
            clinicName: appointment.clinicName,
            address: appointment.address,
          ),

          // Notes (conditional)
          if (appointment.notes != null) ...[
            _sectionDivider(cs),
            DetailNotesSection(
              notes: appointment.notes!,
            ),
          ],
        ],
      ),
    );
  }

  /// Thin divider between card sections.
  Widget _sectionDivider(ColorScheme cs) {
    return Padding(
      padding: AppDimens.paddingVerticalMedium,
      child: Divider(
        height: AppDimens.borderWidth,
        thickness: AppDimens.borderWidth,
        color: cs.outlineVariant
            .withValues(alpha: 0.3),
      ),
    );
  }
}
