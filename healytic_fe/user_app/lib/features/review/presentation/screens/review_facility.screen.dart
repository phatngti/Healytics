import 'dart:developer';
import 'dart:ui';

import 'package:common/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:user_app/router/routes.dart';
import '../providers/review_facility.provider.dart';
import '../widgets/review_bottom_action.widget.dart';
import '../widgets/review_hero_title.widget.dart';
import '../widgets/review_photo_card.widget.dart';
import '../widgets/review_photo_grid.widget.dart';
import '../widgets/review_rating_card.widget.dart';

/// Screen where users submit a review for the
/// clinic facility after a completed appointment.
///
/// On successful submission, navigates to the
/// thank-you screen with the specialist info
/// passed through from the previous review step.
class ReviewFacilityScreen extends ConsumerWidget {
  const ReviewFacilityScreen({
    super.key,
    required this.appointmentId,
    required this.facilityId,
    required this.facilityName,
    this.facilityAddress,
    required this.specialistName,
    this.specialistAvatarUrl,
    required this.specialistRating,
  });

  /// ID of the appointment being reviewed.
  final String appointmentId;

  /// ID of the facility/clinic being reviewed.
  final String facilityId;

  /// Display name of the facility/clinic.
  final String facilityName;

  /// Address of the facility (optional).
  final String? facilityAddress;

  /// Specialist name — forwarded to thank-you.
  final String specialistName;

  /// Specialist avatar — forwarded to thank-you.
  final String? specialistAvatarUrl;

  /// Specialist rating — forwarded to thank-you.
  final int specialistRating;

  /// Tags available for facility review.
  static const _availableTags = [
    'Clean',
    'Comfortable',
    'Modern Equipment',
    'Easy to Find',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      reviewFacilityProvider,
    );
    final notifier = ref.read(
      reviewFacilityProvider.notifier,
    );

    // Show error toast if submission fails.
    ref.listen(
      reviewFacilityProvider,
      (prev, next) {
        if (next.errorMessage != null &&
            prev?.errorMessage !=
                next.errorMessage) {
          ToastContext.showToast(
            context,
            ToastType.error,
            next.errorMessage!,
          );
        }

        // Navigate to Thank You screen on success.
        if (next.isSubmitted &&
            !(prev?.isSubmitted ?? false)) {
          ReviewSubmittedRoute(
            specialistName: specialistName,
            specialistAvatarUrl:
                specialistAvatarUrl,
            rating: specialistRating,
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
              'Review Facility',
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

  /// Scrollable content area.
  Widget _buildBody(
    BuildContext context,
    ReviewFacilityState state,
    ReviewFacilityNotifier notifier,
  ) {
    final subtitle = facilityAddress != null
        ? 'at $facilityAddress'
        : '';

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
          ReviewHeroTitle(
            title: facilityName,
            subtitle: subtitle,
          ),
          const SizedBox(height: 40),
          ReviewRatingCard(
            title: 'How was the facility?',
            hintText: 'Describe the facility... '
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
          if (state.photoPaths.isEmpty)
            ReviewPhotoCard(
              onTap: () => _handleAddPhotos(
                context,
                notifier,
              ),
            )
          else
            ReviewPhotoGrid(
              imagePaths: state.photoPaths,
              onAddMore: () => _handleAddPhotos(
                context,
                notifier,
              ),
              onRemovePhoto: notifier.removePhoto,
            ),
        ],
      ),
    );
  }

  /// Fixed bottom submit button.
  Widget _buildFooter(
    ReviewFacilityState state,
    ReviewFacilityNotifier notifier,
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
            facilityId: facilityId,
          );
        },
      ),
    );
  }

  /// Opens the system image picker and adds the
  /// selected photos to the form state.
  Future<void> _handleAddPhotos(
    BuildContext context,
    ReviewFacilityNotifier notifier,
  ) async {
    try {
      final picker = ImagePicker();
      final images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        notifier.addPhotos(
          images.map((e) => e.path).toList(),
        );
      }
    } catch (e, s) {
      log(
        'Image picker error',
        error: e,
        stackTrace: s,
        name: 'ReviewFacilityScreen',
      );
    }
  }
}
