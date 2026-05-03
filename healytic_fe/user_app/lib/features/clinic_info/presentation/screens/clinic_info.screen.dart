import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';
import 'package:user_app/features/clinic_info/presentation/providers/clinic_info.provider.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_reviews/review_tab_content.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/clinic_collapsing_header.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/clinic_floating_header.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/clinic_pinned_tab_bar.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/shop_tab_content.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_products/product_tab_content.widget.dart';
import 'package:user_app/router/routes.dart';

/// Full-screen clinic profile view with a collapsing
/// toolbar that pins the tab bar on scroll.
///
/// Uses [NestedScrollView] to co-ordinate the outer
/// scroll (header collapse) with the inner scroll
/// (each tab's content).
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

/// Tab labels matching the design spec.
const _kTabLabels = ['Shop', 'Services', 'Reviews'];

/// Main scrollable body with collapsing toolbar.
///
/// Manages a [ScrollController] + [ValueNotifier]
/// pair to drive the floating header blur transition.
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
  final _showBlur = ValueNotifier<bool>(false);

  /// Cached expanded height — set in
  /// [didChangeDependencies] when layout info
  /// is available.
  double _expandedHeight = 0;

  /// Scroll threshold for blur activation.
  double _blurThreshold = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _kTabCount, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _computeLayout();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _showBlur.dispose();
    super.dispose();
  }

  /// Pre-compute expanded height and blur threshold
  /// from screen dimensions.
  ///
  /// Note: SliverAppBar internally computes
  /// maxExtent = topPad + expandedHeight, so we
  /// must NOT include topPad here.
  void _computeLayout() {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final coverHeight = screenWidth * 9 / 25;
    // Logo extends 44px below cover (72 - 28 overlap).
    final logoExtension = screenWidth * 2 / 25;
    final statsHeight = screenWidth * 2 / 25;
    final breathing = screenWidth * 1 / 25;

    _expandedHeight = coverHeight + logoExtension + statsHeight + breathing;

    // Blur activates when cover is mostly gone.
    _blurThreshold = coverHeight * 0.5;
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

    return Scaffold(
      body: Stack(
        children: [
          // ── Main scrollable content ──
          NotificationListener<ScrollNotification>(
            onNotification: _onScrollNotification,
            child: NestedScrollView(
              headerSliverBuilder: _buildHeaderSlivers,
              body: TabBarView(
                controller: _tabController,
                children: [
                  ShopTabContent(clinic: widget.clinic),
                  ProductTabContent(clinicId: widget.clinicId),
                  ReviewTabContent(clinicId: widget.clinicId),
                ],
              ),
            ),
          ),

          // ── Floating top bar ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: RepaintBoundary(
              child: ClinicFloatingHeader(
                clinicName: widget.clinic.name,
                logoUrl: widget.clinic.logoImageUrl,
                showBlur: _showBlur,
                onBack: _handleBack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle scroll notifications to toggle the
  /// floating header blur state.
  ///
  /// Only reacts to the outer scrollable
  /// (depth == 0) so inner tab scrolling does
  /// not toggle blur.
  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    if (notification is ScrollUpdateNotification) {
      final offset = notification.metrics.pixels;
      final shouldBlur = offset > _blurThreshold;
      if (_showBlur.value != shouldBlur) {
        _showBlur.value = shouldBlur;
      }
    }
    return false;
  }

  /// Build the collapsing header slivers:
  /// 1. SliverAppBar with flexible space
  /// 2. Pinned TabBar
  List<Widget> _buildHeaderSlivers(
    BuildContext context,
    bool innerBoxIsScrolled,
  ) {
    return [
      SliverAppBar(
        expandedHeight: _expandedHeight,
        pinned: true,
        floating: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: kToolbarHeight,
        flexibleSpace: LayoutBuilder(
          builder: (context, constraints) {
            final collapseProgress = _computeCollapseProgress(constraints);
            return ClinicCollapsingHeader(
              clinic: widget.clinic,
              collapseProgress: collapseProgress,
              expandedHeight: _expandedHeight,
            );
          },
        ),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: ClinicPinnedTabBarDelegate(
          tabController: _tabController,
          tabLabels: _kTabLabels,
        ),
      ),
    ];
  }

  /// Compute how much the header has collapsed.
  /// Returns 0.0 (expanded) to 1.0 (collapsed).
  ///
  /// SliverAppBar internally:
  ///   maxExtent = topPad + expandedHeight
  ///   minExtent = topPad (toolbarHeight=0)
  ///   range = expandedHeight
  double _computeCollapseProgress(BoxConstraints constraints) {
    final topPad = MediaQuery.paddingOf(context).top;
    final minHeight = topPad + kToolbarHeight;
    final current = constraints.maxHeight;

    final expandableRange = _expandedHeight - kToolbarHeight;
    if (expandableRange <= 0) return 0.0;

    final expanded = current - minHeight;
    return (1.0 - expanded / expandableRange).clamp(0.0, 1.0);
  }
}
