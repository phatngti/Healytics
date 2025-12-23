import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/authenticate/presentation/provider/authenticate.provider.dart';
import 'package:user_app/utils/demensions.dart';

import 'widgets/explore_services_section.dart';
import 'widgets/feature_banner.dart';
import 'widgets/home_header.dart';
import 'widgets/quick_actions_section.dart';
import 'widgets/recent_activity_section.dart';
import 'widgets/premium_treatments_section.dart';
import 'widgets/recommend_section.dart';

class HomeUpdatePage extends HookConsumerWidget {
  const HomeUpdatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(authenticateProvider);
    final userName = asyncState.value?.authenticate?.basicInfo?.name ?? 'Sarah';
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable main content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    HomeHeader(userName: userName),

                    // Main Content
                    Padding(
                      padding: AppDimens.paddingAllMedium,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppDimens.verticalSmall,

                          // Quick Actions
                          const QuickActionsSection(),

                          AppDimens.verticalLarge,

                          // Recommend For You
                          const RecommendSection(),

                          AppDimens.verticalLarge,

                          // Recent Activity
                          const RecentActivitySection(),

                          AppDimens.verticalLarge,

                          // Feature Banner
                          const FeatureBanner(),

                          AppDimens.verticalLarge,

                          // Explore Services
                          const ExploreServicesSection(),

                          AppDimens.verticalLarge,

                          // Premium Treatments
                          const PremiumTreatmentsSection(),

                          AppDimens.verticalLarge,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
