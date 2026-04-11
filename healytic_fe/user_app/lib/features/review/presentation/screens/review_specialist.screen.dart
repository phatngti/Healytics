import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:user_app/router/routes.dart';
import '../providers/review_specialist.provider.dart';
import '../widgets/review_bottom_action.widget.dart';
import '../widgets/review_rating_card.widget.dart';
import '../widgets/review_recommend_card.widget.dart';
import '../widgets/review_specialist_hero.widget.dart';

/// Screen where users submit a review for a
/// specialist after a completed appointment.
class ReviewSpecialistScreen extends ConsumerWidget {
  const ReviewSpecialistScreen({
    super.key,
    required this.appointmentId,
    required this.specialistId,
    required this.specialistName,
    required this.specialistRole,
    this.specialistAvatarUrl,
    required this.facilityId,
    required this.facilityName,
    this.facilityAddress,
  });

  /// ID of the appointment being reviewed.
  final String appointmentId;

  /// ID of the specialist being reviewed.
  final String specialistId;

  /// Display name of the specialist.
  final String specialistName;

  /// Role or title of the specialist.
  final String specialistRole;

  /// Optional avatar URL for the specialist.
  final String? specialistAvatarUrl;

  /// ID of the facility — forwarded to facility review.
  final String facilityId;

  /// Name of the facility — forwarded.
  final String facilityName;

  /// Address of the facility — forwarded.
  final String? facilityAddress;

  /// Tags available for specialist review.
  static const _availableTags = [
    'Professional',
    'Attentive',
    'Knowledgeable',
    'Patient',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      reviewSpecialistProvider,
    );
    final notifier = ref.read(
      reviewSpecialistProvider.notifier,
    );

    // Navigate to Thank You screen on success.
    ref.listen(
      reviewSpecialistProvider,
      (prev, next) {
        if (next.isSubmitted &&
            !(prev?.isSubmitted ?? false)) {
          ReviewFacilityRoute(
            appointmentId: appointmentId,
            facilityId: facilityId,
            facilityName: facilityName,
            facilityAddress: facilityAddress,
            specialistName: specialistName,
            specialistAvatarUrl:
                specialistAvatarUrl,
            specialistRating: next.rating,
          ).push(context);
        }
      },
    );

    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          _buildBody(context, state, notifier),
          _buildFooter(state, notifier),
        ],
      ),
    );
  }

  /// Glassmorphic app bar with blur.
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
  ) {
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
            backgroundColor: Theme.of(context)
                .colorScheme
                .surface
                .withValues(alpha: 0.7),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () =>
                  Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface,
              ),
            ),
            title: Text(
              'Review Specialist',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  /// Scrollable body content.
  Widget _buildBody(
    BuildContext context,
    ReviewSpecialistState state,
    ReviewSpecialistNotifier notifier,
  ) {
    // Extract first name for card title.
    final firstName = specialistName.split(' ').last;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top +
            kToolbarHeight +
            24,
        left: 24,
        right: 24,
        bottom: 150,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          ReviewSpecialistHero(
            name: specialistName,
            role: specialistRole,
            avatarUrl: specialistAvatarUrl,
          ),
          const SizedBox(height: 40),
          ReviewRatingCard(
            title: 'Rate your session with '
                'Dr. $firstName.',
            hintText: 'Describe your experience... '
                '(Optional)',
            currentRating: state.rating,
            onRatingChanged: notifier.setRating,
            comment: state.comment,
            onCommentChanged: notifier.setComment,
            availableTags: _availableTags,
            selectedTags: state.selectedTags,
            onTagToggled: notifier.toggleTag,
          ),
          const SizedBox(height: 32),
          ReviewRecommendCard(
            wouldRecommend: state.wouldRecommend,
            onChanged: (_) =>
                notifier.toggleRecommend(),
          ),
        ],
      ),
    );
  }

  /// Fixed bottom submit button.
  Widget _buildFooter(
    ReviewSpecialistState state,
    ReviewSpecialistNotifier notifier,
  ) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ReviewBottomAction(
        label: 'Submit Review',
        showArrow: false,
        isLoading: state.isSubmitting,
        onPressed: () {
          notifier.submitReview(
            appointmentId: appointmentId,
            specialistId: specialistId,
          );
        },
      ),
    );
  }
}
