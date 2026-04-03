import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';
import 'package:user_app/features/clinic_info/presentation/providers/clinic_info.provider.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/about_clinic_section.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/certifications_section.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/clinic_bottom_bar.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/clinic_facility_grid.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/clinic_hero_section.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/clinic_stats_actions.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/featured_services_grid.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/specialists_section.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/trust_metrics_bar.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_products/product_tab_content.widget.dart';
import 'package:user_app/router/routes.dart';

/// Full-screen clinic profile view composed from
/// smaller section widgets matching the HTML design.
class ClinicInfoScreen extends ConsumerWidget {
  const ClinicInfoScreen({super.key, required this.clinicId});

  final String clinicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncClinic = ref.watch(clinicInfoProvider(clinicId: clinicId));

    return asyncClinic.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text('Failed to load clinic: $error'))),
      data: (clinic) => _ClinicInfoBody(clinic: clinic, clinicId: clinicId),
    );
  }
}

/// Number of tabs in the clinic info screen.
const _kTabCount = 3;

/// Tab labels matching the HTML design.
const _kTabLabels = ['Shop', 'Product', 'Categories'];

class _ClinicInfoBody extends StatefulWidget {
  const _ClinicInfoBody({required this.clinic, required this.clinicId});

  final ClinicInfoEntity clinic;
  final String clinicId;

  @override
  State<_ClinicInfoBody> createState() => _ClinicInfoBodyState();
}

class _ClinicInfoBodyState extends State<_ClinicInfoBody>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _kTabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          Column(
            children: [
              // ── Hero + Stats (always visible) ──
              Expanded(
                flex: 0,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top padding for status bar
                      SizedBox(height: MediaQuery.paddingOf(context).top),
                      // Back button spacer
                      const SizedBox(height: 48),
                      // Hero section
                      ClinicHeroSection(
                        name: widget.clinic.name,
                        address: widget.clinic.address,
                        isVerified: widget.clinic.isVerified,
                        coverImageUrl: widget.clinic.coverImageUrl,
                        logoImageUrl: widget.clinic.logoImageUrl,
                        galleryCount: widget.clinic.gallery.length,
                      ),
                      // Stats + actions
                      ClinicStatsActions(
                        rating: widget.clinic.rating,
                        reviewCount: widget.clinic.reviewCount,
                        followersLabel: widget.clinic.followersLabel,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Tab Bar ──
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: colorScheme.primary,
                  unselectedLabelColor: colorScheme.onSurfaceVariant,
                  labelStyle: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  indicatorColor: colorScheme.primary,
                  indicatorWeight: 2,
                  tabs: _kTabLabels.map((l) => Tab(text: l)).toList(),
                ),
              ),

              // ── Tab Content ──
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 0: Shop (existing profile)
                    _ShopTabContent(clinic: widget.clinic),

                    // Tab 1: Product (new)
                    ProductTabContent(clinicId: widget.clinicId),

                    // Tab 2: Categories (placeholder)
                    const _CategoriesPlaceholder(),
                  ],
                ),
              ),
            ],
          ),

          // ── Fixed top bar ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TopBar(
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  const HomeRoute().go(context);
                }
              },
            ),
          ),

          // ── Bottom action bar ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClinicBottomBar(onBook: () {}),
          ),
        ],
      ),
    );
  }
}

/// Shop tab — existing clinic profile sections.
class _ShopTabContent extends StatelessWidget {
  const _ShopTabContent({required this.clinic});

  final ClinicInfoEntity clinic;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        AppDimens.verticalLarge,

        // Trust metrics
        TrustMetricsBar(metrics: clinic.trustMetrics),
        AppDimens.verticalLarge,

        // Certifications
        if (clinic.certifications.isNotEmpty) ...[
          CertificationsSection(certifications: clinic.certifications),
          AppDimens.verticalLarge,
        ],

        // Specialists
        if (clinic.specialists.isNotEmpty) ...[
          SpecialistsSection(specialists: clinic.specialists),
          AppDimens.verticalLarge,
        ],

        // Facility tour
        if (clinic.facilityImages.isNotEmpty) ...[
          ClinicFacilityGrid(images: clinic.facilityImages),
          AppDimens.verticalLarge,
        ],

        // About
        if (clinic.description != null && clinic.description!.isNotEmpty) ...[
          AboutClinicSection(description: clinic.description!),
          AppDimens.verticalLarge,
        ],

        // Featured services
        if (clinic.featuredServices.isNotEmpty)
          FeaturedServicesGrid(
            services: clinic.featuredServices,
            onServiceTap: (serviceId) {
              ServiceDetailsRoute(serviceId: serviceId).push(context);
            },
          ),
      ],
    );
  }
}

/// Placeholder for the Categories tab.
class _CategoriesPlaceholder extends StatelessWidget {
  const _CategoriesPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Text(
        'Categories coming soon',
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimens.spaceSm,
        topPad + AppDimens.spaceXs,
        AppDimens.spaceSm,
        AppDimens.spaceXs,
      ),
      child: Row(
        children: [
          _CircleButton(icon: Icons.arrow_back, onTap: onBack),
          const Spacer(),
          _CircleButton(icon: Icons.share, onTap: () {}),
          const SizedBox(width: 8),
          _CircleButton(icon: Icons.more_vert, onTap: () {}),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.white),
      ),
    );
  }
}
