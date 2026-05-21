import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/'
    'network_image_auto.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:user_app/features/employee/'
    'presentation/providers/'
    'employee_services.provider.dart';
import 'package:user_app/features/booking/domain/'
    'entities/booking.entity.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/router/routes.dart';

/// Displays a 2-column grid of service cards
/// offered by the given employee.
class ExploreServicesSection extends ConsumerWidget {
  const ExploreServicesSection({super.key, required this.employeeId});

  /// Employee ID used to fetch services.
  final String employeeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final hPad = AppDimens.horizontalPadding(context);
    final titleGap = AppDimens.titleGap(context);
    final contentPad = AppDimens.contentPadding(context);
    final section = AppDimens.sectionSpacing(context);
    final servicesAsync = ref.watch(employeeServicesProvider(employeeId));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore Services',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: titleGap),
          servicesAsync.when(
            loading: () => _LoadingGrid(contentPad: contentPad),
            error: (_, __) => const _EmptyState(),
            data: (services) {
              if (services.isEmpty) {
                return const _EmptyState();
              }
              return _ServiceGrid(
                services: services,
                contentPad: contentPad,
                employeeId: employeeId,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── 2-column service grid ────────────────────────

class _ServiceGrid extends StatelessWidget {
  const _ServiceGrid({
    required this.services,
    required this.contentPad,
    required this.employeeId,
  });

  final List<BookingService> services;
  final double contentPad;
  final String employeeId;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: contentPad,
        crossAxisSpacing: contentPad,
        childAspectRatio: 0.68,
      ),
      padding: EdgeInsets.zero,
      itemCount: services.length,
      itemBuilder: (context, index) =>
          _ServiceCard(service: services[index], employeeId: employeeId),
    );
  }
}

// ─── Service card ─────────────────────────────────

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.employeeId});

  final BookingService service;
  final String employeeId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardRad = AppDimens.cardRadius(context);
    final contentPad = AppDimens.contentPadding(context);

    return Semantics(
      key: keys.employeePage.serviceBookButton(service.id),
      button: true,
      label: service.title,
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(cardRad),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => EmployeeBookingRoute(
            employeeId: employeeId,
            serviceId: service.id,
          ).push(context),
          borderRadius: BorderRadius.circular(cardRad),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(cardRad),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.05),
                  blurRadius: AppDimens.spaceXl,
                  offset: Offset(0, AppDimens.spaceXs),
                ),
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.03),
                  blurRadius: AppDimens.spaceSmMd,
                  offset: Offset(0, AppDimens.spaceXxs),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CardImage(service: service),
                Expanded(
                  child: _CardContent(
                    service: service,
                    contentPad: contentPad,
                    employeeId: employeeId,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Card image section ───────────────────────────

class _CardImage extends StatelessWidget {
  const _CardImage({required this.service});

  final BookingService service;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardRad = AppDimens.cardRadius(context);
    final imageUrl = service.imageUrl;

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(cardRad)),
        child: imageUrl != null && imageUrl.isNotEmpty
            ? NetworkImageAuto(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_) => _ImageFallback(colorScheme: colorScheme),
                errorWidget: (_) => _ImageFallback(colorScheme: colorScheme),
              )
            : _ImageFallback(colorScheme: colorScheme),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Symbols.spa,
        color: colorScheme.onSurfaceVariant,
        size: AppDimens.iconXxl,
      ),
    );
  }
}

// ─── Card content section ─────────────────────────

class _CardContent extends StatelessWidget {
  const _CardContent({
    required this.service,
    required this.contentPad,
    required this.employeeId,
  });

  final BookingService service;
  final double contentPad;
  final String employeeId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        contentPad,
        AppDimens.spaceSm,
        contentPad,
        AppDimens.spaceSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            service.title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppDimens.spaceXxs),
          _InfoRow(icon: Symbols.schedule, text: service.duration),
          if (service.clinicName != null && service.clinicName!.isNotEmpty) ...[
            SizedBox(height: AppDimens.spaceXxs),
            _InfoRow(icon: Symbols.storefront, text: service.clinicName!),
          ],
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  service.price,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: AppDimens.ctaButtonSm,
                width: AppDimens.ctaButtonSm,
                child: IconButton.filled(
                  onPressed: () => EmployeeBookingRoute(
                    employeeId: employeeId,
                    serviceId: service.id,
                  ).push(context),
                  tooltip: 'View details',
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Symbols.arrow_forward,
                    size: AppDimens.iconSm,
                    color: colorScheme.onPrimary,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Reusable icon + text row ─────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: AppDimens.iconXs, color: colorScheme.onSurfaceVariant),
        SizedBox(width: AppDimens.spaceXs),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ─── Loading placeholders ─────────────────────────

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid({required this.contentPad});

  final double contentPad;

  @override
  Widget build(BuildContext context) {
    final cardRad = AppDimens.cardRadius(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: contentPad,
        crossAxisSpacing: contentPad,
        childAspectRatio: 0.68,
      ),
      padding: EdgeInsets.zero,
      itemCount: 4,
      itemBuilder: (_, __) =>
          _LoadingPlaceholder(cardRad: cardRad, contentPad: contentPad),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder({required this.cardRad, required this.contentPad});

  final double cardRad;
  final double contentPad;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(cardRad),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(cardRad),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(contentPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: AppDimens.spaceLg,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: AppDimens.radiusExtraSmall,
                    ),
                  ),
                  SizedBox(height: AppDimens.spaceSm),
                  Container(
                    height: AppDimens.spaceMd,
                    width: AppDimens.avatarLg,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: AppDimens.radiusExtraSmall,
                    ),
                  ),
                  SizedBox(height: AppDimens.spaceSm),
                  Container(
                    height: AppDimens.spaceMd,
                    width: AppDimens.avatarMd,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: AppDimens.radiusExtraSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.spaceXxl),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.spa,
              size: AppDimens.avatarMd,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: AppDimens.spaceSm),
            Text(
              'No services available',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
