import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';
import 'package:user_app/features/profile/presentation/providers/profile.provider.dart';
import 'package:common/utils/demensions.dart';

import '../widgets/specialists_section.widget.dart';
import '../widgets/feature_banner.widget.dart';
import '../widgets/home_header.widget.dart';
import '../widgets/quick_actions_section.widget.dart';
import '../widgets/recent_activity_section.widget.dart';
import '../widgets/premium_treatments_section.widget.dart';
import '../widgets/recommend_section.widget.dart';

class HomeUpdatePage extends HookConsumerWidget {
  const HomeUpdatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(currentUserDisplayNameProvider);
    final accountMe = ref.watch(accountMeProvider);
    final displayName = accountMe.value?.displayName ?? userName ?? '';
    final avatarUrl = accountMe.value?.avatarUrl;

    // Adaptive values from AppDimens — scales per MobileSize tier.
    final hPadding = AppDimens.horizontalPadding(context);
    final bottomPadding = AppDimens.bottomScrollPadding(context);
    final sectionGap = AppDimens.sectionSpacing(context);

    return Scaffold(
      body: SafeArea(
        // Clamp text scale to prevent layout breaks on extreme
        // system font sizes (0.8× – 1.3×).
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(
              context,
            ).textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.3),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(userName: displayName, avatarUrl: avatarUrl),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppDimens.verticalSmall,
                      const QuickActionsSection(),
                      SizedBox(height: sectionGap),
                      const RecommendSection(),
                      SizedBox(height: sectionGap),
                      const RecentActivitySection(),
                      SizedBox(height: sectionGap),
                      const FeatureBanner(),
                      SizedBox(height: sectionGap),
                      const SpecialistsSection(),
                      SizedBox(height: sectionGap),
                      const PremiumTreatmentsSection(),
                      SizedBox(height: sectionGap),
                    ],
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
