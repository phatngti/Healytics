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


/// Full-screen service detail view composed from smaller
/// widgets matching the new HTML design spec.
///
/// Fetches data via [serviceDetailsProvider] and renders
/// loading / error / data states.
class ServiceDetailsScreen extends ConsumerWidget {
  const ServiceDetailsScreen({super.key, this.serviceId = 'service-laser-co2'});

  /// The identifier used to fetch service detail data.
  final String serviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetails = ref.watch(
      serviceDetailsProvider(serviceId: serviceId),
    );

    return asyncDetails.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text('Failed to load details: $error'))),
      data: (details) => _ServiceDetailsBody(
        details: details,
        serviceId: serviceId,
      ),
    );
  }
}

/// The main scrollable body rendered once data is
/// available. Uses [CustomScrollView] with slivers so
/// that off-screen sections are built lazily.
class _ServiceDetailsBody extends StatefulWidget {
  const _ServiceDetailsBody({
    required this.details,
    required this.serviceId,
  });

  final ServiceDetailsEntity details;
  final String serviceId;

  @override
  State<_ServiceDetailsBody> createState() =>
      _ServiceDetailsBodyState();
}

class _ServiceDetailsBodyState extends State<_ServiceDetailsBody> {
  final _scrollController = ScrollController();
  final _showBlur = ValueNotifier<bool>(false);

  /// Cached scroll threshold – recomputed only when
  /// MediaQuery values change (orientation / resize).
  double _blurThreshold = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cacheScrollThreshold();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _showBlur.dispose();
    super.dispose();
  }

  /// Pre-compute the scroll offset at which the header
  /// leaves the hero area and needs a blur backdrop.
  void _cacheScrollThreshold() {
    final screenH = MediaQuery.sizeOf(context).height;
    final topPad = MediaQuery.paddingOf(context).top;
    final heroH = screenH * 0.35;
    final headerH =
        topPad + AppDimens.spaceMd + AppDimens.ctaButtonMd + AppDimens.spaceMd;
    _blurThreshold = heroH - headerH;
  }

  void _onScroll() {
    final shouldBlur = _scrollController.offset > _blurThreshold;
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
          // ── Scrollable content (lazy slivers) ──
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Hero carousel
              SliverToBoxAdapter(
                child: HeroImageCarousel(
                  images: details.images,
                  categoryLabel: details.categoryLabel,
                  title: details.title,
                ),
              ),

              // Main content – rounded top overlap
              SliverToBoxAdapter(
                child: Transform.translate(
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
                      0,
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

                        // Feature tags
                        if (details.featureTags.isNotEmpty) ...[
                          AppDimens.verticalLarge,
                          FeatureTagsRow(tags: details.featureTags),
                        ],

                        // About treatment
                        if (details.description.isNotEmpty) ...[
                          AppDimens.verticalLargeExtra,
                          AboutTreatment(description: details.description),
                        ],

                        // Facility tour
                        if (details.facilityImages.isNotEmpty) ...[
                          AppDimens.verticalLargeExtra,
                          FacilityTourSection(images: details.facilityImages),
                        ],

                        // Clinic card
                        if (details.clinic.name.isNotEmpty) ...[
                          AppDimens.verticalLargeExtra,
                          ClinicCard(
                            clinicName: details.clinic.name,
                            address: details.clinic.address,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // ── Lazy sections (built on scroll) ──
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppDimens.verticalLargeExtra,

                      // Reviews
                      _ReviewsSectionLoader(
                        serviceId: widget.serviceId,
                        rating: details.rating,
                      ),
                      AppDimens.verticalLargeExtra,

                      // Recommended services
                      RecommendedServicesSection(serviceId: widget.serviceId),
                      AppDimens.verticalLargeExtra,

                      // Bottom spacing for booking bar
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Fixed header bar ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: RepaintBoundary(
              child: _FloatingHeaderBar(
                onBack: _handleBack,
                showBlur: _showBlur,
              ),
            ),
          ),

          // ── Bottom action bar ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: RepaintBoundary(
              child: _BottomActionBar(
                price: details.price,
                onPressed: () {
                  ServiceSpecialistRoute(
                    serviceId: widget.serviceId,
                  ).push(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fixed floating header with back, favorite and share
/// buttons.
///
/// Blur backdrop activates only when the header scrolls
/// past the hero image area (controlled by [showBlur]).
/// Uses a cached zero-blur filter to avoid allocations.
class _FloatingHeaderBar extends StatelessWidget {
  const _FloatingHeaderBar({required this.onBack, required this.showBlur});

  final VoidCallback onBack;

  /// Whether the blurred backdrop should be visible.
  final ValueNotifier<bool> showBlur;

  /// Cached identity filter – avoids allocating a new
  /// [ImageFilter] on every rebuild when blur is off.
  static final _noBlur = ImageFilter.blur();

  /// Active blur filter for the header backdrop.
  static final _activeBlur = ImageFilter.blur(sigmaX: 12, sigmaY: 12);

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return ValueListenableBuilder<bool>(
      valueListenable: showBlur,
      builder: (context, blur, child) {
        return ClipRect(
          child: BackdropFilter(
            filter: blur ? _activeBlur : _noBlur,
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
    );
  }
}

/// Circular icon button for the floating header.
///
/// Uses a simple semi-transparent background instead of
/// its own [BackdropFilter] — the parent header already
/// applies one shared blur pass for the entire bar.
class _GlassCircleButton extends StatelessWidget {
  const _GlassCircleButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
    );
  }
}


/// Fixed bottom bar with price and "Select Specialist"
/// CTA. Uses a blurred backdrop matching the header.
class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.price,
    required this.onPressed,
  });

  final String price;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final bottomPad =
        MediaQuery.paddingOf(context).bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 16,
          sigmaY: 16,
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            AppDimens.spaceXxl,
            AppDimens.spaceLg,
            AppDimens.spaceXxl,
            bottomPad + AppDimens.spaceLg,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surface
                    .withValues(alpha: 0.8)
                : Colors.white
                    .withValues(alpha: 0.8),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? colorScheme.outlineVariant
                    : colorScheme.outlineVariant
                        .withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Price',
                    style:
                        textTheme.labelSmall?.copyWith(
                      color:
                          colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    price,
                    style:
                        textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              AppDimens.horizontalMedium,
              Expanded(
                child: Material(
                  color: colorScheme.primary,
                  borderRadius:
                      AppDimens.radiusMediumSmall,
                  elevation: 4,
                  shadowColor: colorScheme.primary
                      .withValues(alpha: 0.3),
                  child: InkWell(
                    onTap: onPressed,
                    borderRadius:
                        AppDimens.radiusMediumSmall,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            'Select Specialist',
                            style: textTheme.labelLarge
                                ?.copyWith(
                              color: colorScheme
                                  .onPrimary,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                          AppDimens.horizontalSmall,
                          Icon(
                            Icons.arrow_forward,
                            size: AppDimens.iconSm,
                            color:
                                colorScheme.onPrimary,
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

/// Loads reviews from [serviceReviewsProvider]
/// and renders [ReviewsSection] once available.
class _ReviewsSectionLoader extends ConsumerWidget {
  const _ReviewsSectionLoader({required this.serviceId, required this.rating});

  final String serviceId;
  final double rating;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReviews = ref.watch(
      serviceReviewsProvider(serviceId: serviceId),
    );

    return asyncReviews.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (reviews) => ReviewsSection(
        reviews: reviews,
        rating: rating,
        serviceId: serviceId,
      ),
    );
  }
}
