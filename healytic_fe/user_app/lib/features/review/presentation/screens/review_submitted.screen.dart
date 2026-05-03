import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:user_app/router/routes.dart';
import '../widgets/review_submitted/'
    'review_submitted_action_tile.widget.dart';
import '../widgets/review_submitted/'
    'review_submitted_hero.widget.dart';
import '../widgets/review_submitted/'
    'review_submitted_specialist_card.widget.dart';

/// Full-screen confirmation displayed after a
/// specialist review is submitted.
///
/// Shows a hero section, a specialist confirmation
/// card, and navigation action tiles. The bottom
/// navigation shell is suppressed.
class ReviewSubmittedScreen extends StatelessWidget {
  /// Display name of the reviewed specialist.
  final String specialistName;

  /// Optional avatar URL for the specialist.
  final String? specialistAvatarUrl;

  /// Star rating the user submitted (1–5).
  final int rating;

  const ReviewSubmittedScreen({
    super.key,
    required this.specialistName,
    this.specialistAvatarUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  /// Glassmorphic app bar — back arrow only.
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
  ) {
    final colors = Theme.of(context).colorScheme;

    return PreferredSize(
      preferredSize:
          const Size.fromHeight(kToolbarHeight),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 20,
            sigmaY: 20,
          ),
          child: AppBar(
            backgroundColor:
                colors.surface.withValues(alpha: 0.7),
            elevation: 0,
            leading: IconButton(
              onPressed: () =>
                  Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back,
                color: colors.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Scrollable body content with hero, specialist
  /// card, and action tiles.
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top +
            kToolbarHeight +
            24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).padding.bottom +
            32,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          ReviewSubmittedHero(
            specialistName: specialistName,
          ),
          const SizedBox(height: 48),
          ReviewSubmittedSpecialistCard(
            specialistName: specialistName,
            specialistAvatarUrl: specialistAvatarUrl,
            rating: rating,
          ),
          const SizedBox(height: 40),
          _buildActions(context),
        ],
      ),
    );
  }

  /// Navigation action tile list.
  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        ReviewSubmittedActionTile(
          icon: Icons.confirmation_number_outlined,
          title: 'Return to my bookings',
          subtitle:
              'View and manage all your upcoming '
              'appointments.',
          onTap: () =>
              const OrderApprovedRoute().go(context),
        ),
        const SizedBox(height: 16),
        ReviewSubmittedActionTile(
          icon: Icons.eco_outlined,
          title: 'Explore other specialist services',
          subtitle:
              'Discover more treatments and '
              'specialists.',
          onTap: () =>
              const HomeRoute().go(context),
        ),
      ],
    );
  }
}
