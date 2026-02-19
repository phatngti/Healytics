import 'dart:ui';

import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/home/domain/entities/service_details.entity.dart';
import 'package:user_app/features/home/presentation/providers/service_details.provider.dart';
import 'package:user_app/router/routes.dart';

import '../widgets/service_details/about_treatment.widget.dart';
import '../widgets/service_details/clinic_card.widget.dart';
import '../widgets/service_details/facility_tour_section.widget.dart';
import '../widgets/service_details/feature_tags_row.widget.dart';
import '../widgets/service_details/hero_image_carousel.widget.dart';
import '../widgets/service_details/rating_price_row.widget.dart';
import '../widgets/service_details/recommended_services_section.widget.dart';
import '../widgets/service_details/reviews_section.widget.dart';
import '../widgets/service_details/specialist_section.widget.dart';

/// Full-screen service detail view composed from smaller widgets
/// matching the new HTML design spec.
///
/// Fetches data via [serviceDetailsProvider] and renders
/// loading / error / data states.
class ServiceDetailsScreen extends ConsumerWidget {
  const ServiceDetailsScreen({super.key, this.serviceId = 'service-laser-co2'});

  /// The identifier used to fetch service detail data.
  final String serviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetails = ref.watch(serviceDetailsProvider(serviceId));

    return asyncDetails.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text('Failed to load details: $error'))),
      data: (details) => _ServiceDetailsBody(details: details),
    );
  }
}

/// The main scrollable body rendered once data is available.
class _ServiceDetailsBody extends StatefulWidget {
  const _ServiceDetailsBody({required this.details});

  final ServiceDetailsEntity details;

  @override
  State<_ServiceDetailsBody> createState() => _ServiceDetailsBodyState();
}

class _ServiceDetailsBodyState extends State<_ServiceDetailsBody> {
  final _scrollController = ScrollController();
  final _showBlur = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _showBlur.dispose();
    super.dispose();
  }

  /// Hero height minus header height gives the
  /// scroll offset at which the header leaves the
  /// hero area and needs a blur backdrop.
  void _onScroll() {
    final screenH = MediaQuery.sizeOf(context).height;
    final topPad = MediaQuery.paddingOf(context).top;
    final heroH = screenH * 0.35;
    // header occupies topPad + spaceMd + button + spaceMd
    final headerH =
        topPad + AppDimens.spaceMd + AppDimens.ctaButtonMd + AppDimens.spaceMd;
    final threshold = heroH - headerH;
    final shouldBlur = _scrollController.offset > threshold;
    if (_showBlur.value != shouldBlur) {
      _showBlur.value = shouldBlur;
    }
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      const HomeRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hPad = AppDimens.horizontalPadding(context);
    final details = widget.details;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // ── Scrollable content ──
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Hero carousel
                HeroImageCarousel(
                  images: details.images,
                  categoryLabel: details.categoryLabel,
                  title: details.title,
                ),

                // Main content – rounded top overlapping hero
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(
                      hPad,
                      AppDimens.spaceXxxl,
                      hPad,
                      120,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating + Price
                        RatingPriceRow(
                          rating: details.rating,
                          reviewCount: details.reviewCount,
                          price: details.price,
                          isVerified: details.isVerified,
                        ),
                        AppDimens.verticalLarge,

                        // Feature tags
                        FeatureTagsRow(tags: details.featureTags),
                        AppDimens.verticalLargeExtra,

                        // About treatment
                        AboutTreatment(description: details.description),
                        AppDimens.verticalLargeExtra,

                        // Facility tour
                        FacilityTourSection(images: details.facilityImages),
                        AppDimens.verticalLargeExtra,

                        // Clinic card
                        ClinicCard(
                          clinicName: details.clinic.name,
                          address: details.clinic.address,
                        ),
                        AppDimens.verticalLargeExtra,

                        // Specialist section
                        SpecialistSection(
                          specialists: details.specialists,
                          daySchedules: details.daySchedules,
                        ),
                        AppDimens.verticalLargeExtra,

                        // Reviews
                        ReviewsSection(
                          reviews: details.reviews,
                          rating: details.rating,
                          serviceId: details.id,
                        ),
                        AppDimens.verticalLargeExtra,

                        // Recommended services
                        RecommendedServicesSection(serviceId: details.id),
                        AppDimens.verticalLargeExtra,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Fixed header bar ──
          _FloatingHeaderBar(onBack: _handleBack, showBlur: _showBlur),

          // ── Bottom booking bar ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomBookingBar(
              price: details.price,
              onConfirm: () {
                // TODO: implement booking action
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Fixed floating header with back, favorite and share buttons.
///
/// Blur backdrop activates only when the header scrolls past
/// the hero image area (controlled by [showBlur]).
class _FloatingHeaderBar extends StatelessWidget {
  const _FloatingHeaderBar({required this.onBack, required this.showBlur});

  final VoidCallback onBack;

  /// Whether the blurred backdrop should be visible.
  final ValueNotifier<bool> showBlur;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ValueListenableBuilder<bool>(
        valueListenable: showBlur,
        builder: (context, blur, child) {
          return ClipRect(
            child: BackdropFilter(
              filter: blur
                  ? ImageFilter.blur(sigmaX: 12, sigmaY: 12)
                  : ImageFilter.blur(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.fromLTRB(
                  AppDimens.spaceXxl,
                  topPad + AppDimens.spaceMd,
                  AppDimens.spaceXxl,
                  AppDimens.spaceMd,
                ),
                color: blur ? const Color(0x33000000) : Colors.transparent,
                child: child,
              ),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _GlassCircleButton(icon: Icons.arrow_back, onTap: onBack),
            Row(
              children: [
                _GlassCircleButton(icon: Icons.favorite_border, onTap: () {}),
                AppDimens.horizontalMediumSmall,
                _GlassCircleButton(icon: Icons.ios_share, onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Glassmorphic circular icon button for the floating header.
///
/// Dark semi-transparent background with white icon so that
/// buttons remain visible on both light and dark themes.
class _GlassCircleButton extends StatelessWidget {
  const _GlassCircleButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: AppDimens.ctaButtonMd,
            height: AppDimens.ctaButtonMd,
            decoration: const BoxDecoration(
              color: Color(0x4D000000),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 30)],
            ),
            child: Icon(icon, size: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// Fixed bottom bar with total price and confirm booking button.
class _BottomBookingBar extends StatelessWidget {
  const _BottomBookingBar({required this.price, required this.onConfirm});

  final String price;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            AppDimens.spaceXxl,
            AppDimens.spaceLg,
            AppDimens.spaceXxl,
            bottomPad + AppDimens.spaceLg,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surface.withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.8),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? colorScheme.outlineVariant
                    : colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Row(
            children: [
              // Price column
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Price',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    price,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              AppDimens.horizontalMedium,
              // Confirm button
              Expanded(
                child: Material(
                  color: colorScheme.primary,
                  borderRadius: AppDimens.radiusMediumSmall,
                  elevation: 4,
                  shadowColor: colorScheme.primary.withValues(alpha: 0.3),
                  child: InkWell(
                    onTap: onConfirm,
                    borderRadius: AppDimens.radiusMediumSmall,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Confirm Booking',
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          AppDimens.horizontalSmall,
                          Icon(
                            Icons.check_circle,
                            size: AppDimens.iconSm,
                            color: colorScheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
