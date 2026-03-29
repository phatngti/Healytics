import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';
import 'package:user_app/features/orders/presentation/providers/appointment.provider.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/appointment_card.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/recommendation_card.widget.dart';

/// Scrollable list of filtered appointments followed
/// by a recommendations carousel.
///
/// Refresh is triggered at the screen level by
/// [OrdersPage], so this widget only watches data.
class AppointmentList extends ConsumerWidget {
  const AppointmentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFiltered =
        ref.watch(filteredAppointmentsProvider);
    final asyncRecs =
        ref.watch(appointmentRecommendationsProvider);
    final hPad =
        AppDimens.horizontalPadding(context);

    return switch (asyncFiltered) {
      AsyncData(:final value) =>
        value.isEmpty
            ? const _EmptyState()
            : ListView(
                padding: EdgeInsets.fromLTRB(
                  hPad,
                  AppDimens.spaceXxl,
                  hPad,
                  AppDimens.spaceXxl,
                ),
                children: [
                  _VendorHeader(
                    appointments: value,
                  ),
                  ...value.map(
                    (apt) => Padding(
                      padding: EdgeInsets.only(
                        bottom: AppDimens.spaceLg,
                      ),
                      child: AppointmentCard(
                        appointment: apt,
                      ),
                    ),
                  ),
                  AppDimens.verticalSmall,
                  _RecommendationsSection(
                    asyncRecs: asyncRecs,
                  ),
                ],
              ),
      AsyncError(:final error) =>
        Center(child: Text('Error: $error')),
      _ => const Center(
        child: CircularProgressIndicator(),
      ),
    };
  }
}

// ─── Empty state ───────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_busy_rounded,
            // 64dp — one-off illustration-size icon
            size: 64,
            color: theme.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.4),
          ),
          AppDimens.verticalMedium,
          Text(
            'No appointments found',
            style:
                theme.textTheme.titleMedium?.copyWith(
              color:
                  theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Vendor header ─────────────────────────────────

class _VendorHeader extends StatelessWidget {
  const _VendorHeader({required this.appointments});
  final List<AppointmentEntity> appointments;

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppDimens.spaceLg,
      ),
      child: Text(
        appointments.first.vendorName,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ─── Recommendations section ───────────────────────

class _RecommendationsSection extends StatelessWidget {
  const _RecommendationsSection({
    required this.asyncRecs,
  });

  final AsyncValue<List<RecommendedServiceEntity>>
      asyncRecs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return switch (asyncRecs) {
      AsyncData(:final value)
          when value.isNotEmpty =>
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            AppDimens.verticalSmall,
            Text(
              'Recommend For You',
              style: theme.textTheme.titleLarge
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppDimens.verticalMedium,
            SizedBox(
              height: 124,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: value.length,
                separatorBuilder: (_, __) =>
                    AppDimens.horizontalMedium,
                itemBuilder: (context, index) {
                  return RecommendationCard(
                    service: value[index],
                    isLast:
                        index == value.length - 1,
                  );
                },
              ),
            ),
            AppDimens.verticalLarge,
          ],
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
