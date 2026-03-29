import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/orders/presentation/providers/service_manual.provider.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/facilities_carousel.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/pre_service_guide.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/procedure_timeline.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/review_card.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/service_hero_image.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/service_manual_header.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/service_rules.widget.dart';

/// Service manual detail screen showing pre-service
/// guidelines, rules, procedure timeline, facilities,
/// and review.
class ServiceManualScreen extends HookConsumerWidget {
  const ServiceManualScreen({
    super.key,
    required this.appointmentId,
  });

  /// The appointment whose manual is displayed.
  final String appointmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncManual = ref.watch(
      serviceManualProvider(appointmentId),
    );

    return Scaffold(
      body: switch (asyncManual) {
        AsyncData(:final value) when value != null =>
          _Content(
            serviceName: value.serviceName,
            vendorName: value.vendorName,
            imageUrl: value.imageUrl,
            guidelines: value.preServiceGuidelines,
            rules: value.serviceRules,
            steps: value.procedureSteps,
            facilities: value.facilities,
            review: value.review,
          ),
        AsyncData() => const Center(
            child: Text('Manual not found'),
          ),
        AsyncError(:final error) => Center(
            child: Text('Error: $error'),
          ),
        _ => const Center(
            child: CircularProgressIndicator(),
          ),
      },
    );
  }
}

// ─── Main scrollable content ───────────────────────

class _Content extends StatelessWidget {
  const _Content({
    required this.serviceName,
    required this.vendorName,
    required this.imageUrl,
    required this.guidelines,
    required this.rules,
    required this.steps,
    required this.facilities,
    required this.review,
  });

  final String serviceName;
  final String vendorName;
  final String imageUrl;
  final List<String> guidelines;
  final List rules;
  final List steps;
  final List facilities;
  final dynamic review;

  @override
  Widget build(BuildContext context) {
    final hPad = AppDimens.horizontalPadding(context);
    final bottom = AppDimens.bottomScrollPadding(context);
    final colors = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        ServiceManualHeader(
          serviceName: serviceName,
          vendorName: vendorName,
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            hPad,
            AppDimens.spaceSm,
            hPad,
            bottom + 68,
          ),
          sliver: SliverList.list(
            children: [
              ServiceHeroImage(imageUrl: imageUrl),
              SizedBox(
                height: AppDimens.sectionSpacing(
                  context,
                ),
              ),
              PreServiceGuide(guidelines: guidelines),
              _sectionDivider(colors),
              ServiceRules(rules: rules.cast()),
              _sectionDivider(colors),
              ProcedureTimeline(steps: steps.cast()),
              _sectionDivider(colors),
              FacilitiesCarousel(
                facilities: facilities.cast(),
              ),
              _sectionDivider(colors),
              ManualReviewCard(review: review),
            ],
          ),
        ),
      ],
    );
  }

  /// Thin divider to separate major sections.
  Widget _sectionDivider(ColorScheme colors) {
    return Padding(
      padding: AppDimens.paddingVerticalMedium,
      child: Divider(
        height: AppDimens.borderWidth,
        color: colors.outlineVariant.withValues(
          alpha: 0.3,
        ),
      ),
    );
  }
}
