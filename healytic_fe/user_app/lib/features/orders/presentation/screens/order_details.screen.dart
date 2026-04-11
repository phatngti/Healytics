import 'dart:ui';

import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';
import 'package:user_app/features/orders/presentation/providers/appointment.provider.dart';
import 'package:user_app/features/orders/presentation/widgets/order_details/check_in_out_card.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/order_details/detail_row.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/order_details/hero_image.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/order_details/service_header.widget.dart';
import 'package:user_app/router/routes.dart';

/// Appointment detail screen matching the
/// "Appointment Details Minimalist V2" HTML reference.
class OrderDetailsScreen extends HookConsumerWidget {
  const OrderDetailsScreen({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAppt = ref.watch(appointmentByIdProvider(appointmentId));

    return Scaffold(
      body: switch (asyncAppt) {
        AsyncData(:final value) when value != null => _Content(
          appointment: value,
        ),
        AsyncData() => const Center(child: Text('Appointment not found')),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

// ─── Main content ──────────────────────────────────

class _Content extends StatelessWidget {
  const _Content({required this.appointment});

  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final hPad = AppDimens.horizontalPadding(context);

    return CustomScrollView(
      slivers: [
        const _SliverHeader(),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppDimens.verticalSmall,
                HeroImage(imageUrl: appointment.imageUrl),
                AppDimens.verticalLarge,
                ServiceHeader(appointment: appointment),
                AppDimens.verticalLarge,
                CheckInOutCard(appointment: appointment),
                AppDimens.verticalExtraLarge,
                DetailRow(
                  icon: Symbols.local_hospital,
                  title: 'Doctor or Therapist',
                  subtitle: appointment.specialistName,
                  onTap: appointment.specialistId != null
                      ? () => EmployeeDetailRoute(
                          employeeId: appointment.specialistId!,
                        ).push(context)
                      : null,
                ),
                SizedBox(height: AppDimens.spaceXxl + AppDimens.spaceXs),
                DetailRow(
                  icon: Symbols.storefront,
                  title: 'Service manual',
                  subtitle:
                      'Instructions and service'
                      ' rules',
                  onTap: () => ServiceManualRoute(
                    appointmentId: appointment.id,
                  ).push(context),
                ),
                SizedBox(height: AppDimens.spaceXxl + AppDimens.spaceXs),
                DetailRow(
                  icon: Symbols.chat_bubble,
                  title: 'Message your services',
                  subtitle: appointment.healthPartnerName,
                  onTap: () => PartnerChatRoute(
                    partnerAccountId: appointment.healthPartnerId,
                    partnerName: appointment.healthPartnerName,
                  ).push(context),
                ),
                AppDimens.verticalExtraLarge,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Pinned header ─────────────────────────────────

class _SliverHeader extends StatelessWidget {
  const _SliverHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SliverAppBar(
      pinned: true,
      centerTitle: true,
      backgroundColor: colors.surface.withValues(
        alpha: 0.8,
      ),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () =>
            Navigator.of(context).maybePop(),
      ),
      title: Text(
        'Appointment Details',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12,
            sigmaY: 12,
          ),
          child: const SizedBox.expand(),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(
          AppDimens.borderWidth,
        ),
        child: Divider(
          height: AppDimens.borderWidth,
          thickness: AppDimens.borderWidth,
          color: colors.outlineVariant.withValues(
            alpha: 0.3,
          ),
        ),
      ),
    );
  }
}
