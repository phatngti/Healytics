import 'dart:developer';
import 'dart:ui';

import 'package:common/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:user_app/router/routes.dart';
import '../providers/review_treatment.provider.dart';
import '../widgets/review_bottom_action.widget.dart';
import '../widgets/review_hero_title.widget.dart';
import '../widgets/review_photo_card.widget.dart';
import '../widgets/review_photo_grid.widget.dart';
import '../widgets/review_rating_card.widget.dart';

/// Screen where users submit a review for a
/// completed appointment treatment.
///
/// On successful submission, navigates to the
/// specialist review screen using the appointment's
/// provider data (fetched automatically).
class ReviewTreatmentScreen extends ConsumerWidget {
  const ReviewTreatmentScreen({
    super.key,
    required this.appointmentId,
    required this.serviceName,
    required this.vendorName,
  });

  /// ID of the appointment being reviewed.
  final String appointmentId;

  /// Display name of the service.
  final String serviceName;

  /// Display name of the vendor / clinic.
  final String vendorName;

  /// Tags to present as quick-select options.
  static const _availableTags = [
    'On-time',
    'Great technique',
    'Relaxing',
    'Clean',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reviewTreatmentProvider);
    final notifier = ref.read(
      reviewTreatmentProvider.notifier,
    );

    // Navigate to specialist screen after successful
    // treatment review submission.
    ref.listen(
      reviewTreatmentProvider,
      (prev, next) {
        // Show error toast if submission fails.
        if (next.errorMessage != null &&
            prev?.errorMessage != next.errorMessage) {
          ToastContext.showToast(
            context,
            ToastType.error,
            next.errorMessage!,
          );
        }

        // Navigate when newly submitted.
        if (next.isSubmitted &&
            !(prev?.isSubmitted ?? false)) {
          final apt = next.appointment;
          ReviewSpecialistRoute(
            appointmentId: appointmentId,
            specialistId: apt?.providerId ?? '',
            specialistName:
                apt?.providerName ?? 'Your Specialist',
            specialistRole: 'Specialist',
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
              'Review Treatment',
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
    ReviewTreatmentState state,
    ReviewTreatmentNotifier notifier,
  ) {
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
            title: serviceName,
            subtitle: 'at $vendorName',
          ),
          const SizedBox(height: 40),
          ReviewRatingCard(
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
              onTap: () =>
                  _handleAddPhotos(context, notifier),
            )
          else
            ReviewPhotoGrid(
              imagePaths: state.photoPaths,
              onAddMore: () =>
                  _handleAddPhotos(context, notifier),
              onRemovePhoto: notifier.removePhoto,
            ),
        ],
      ),
    );
  }

  /// Fixed bottom action button.
  Widget _buildFooter(
    ReviewTreatmentState state,
    ReviewTreatmentNotifier notifier,
  ) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ReviewBottomAction(
        label: 'Next: Review Specialist',
        isLoading: state.isSubmitting,
        onPressed: () =>
            notifier.submitReview(appointmentId),
      ),
    );
  }

  /// Opens the system image picker and adds the
  /// selected photos to the form state.
  Future<void> _handleAddPhotos(
    BuildContext context,
    ReviewTreatmentNotifier notifier,
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
        name: 'ReviewTreatmentScreen',
      );
    }
  }
}
