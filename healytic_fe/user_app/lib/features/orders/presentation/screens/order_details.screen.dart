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
        const _SliverBackButton(),
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
                  subtitle: appointment.providerName,
                  onTap: appointment.providerId != null
                      ? () => EmployeeDetailRoute(
                          employeeId: appointment.providerId!,
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
                  subtitle: appointment.vendorName,
                  onTap: () => PartnerChatRoute(
                    partnerAccountId:
                        appointment.vendorAccountId ??
                            '',
                    partnerName:
                        appointment.vendorName,
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

// ─── Sliver back button ────────────────────────────

class _SliverBackButton extends StatelessWidget {
  const _SliverBackButton();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppDimens.spaceSm,
            top: AppDimens.spaceXs,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: 'Go back',
              icon: Icon(Icons.arrow_back, size: AppDimens.iconLg),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
      ),
    );
  }
}
