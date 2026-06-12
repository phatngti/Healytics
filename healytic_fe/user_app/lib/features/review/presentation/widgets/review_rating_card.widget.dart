import 'package:flutter/material.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';

import 'review_tags_selector.widget.dart';

class ReviewRatingCard extends StatelessWidget {
  final int currentRating;
  final ValueChanged<int> onRatingChanged;
  final String comment;
  final ValueChanged<String> onCommentChanged;
  final List<String> availableTags;
  final List<String> selectedTags;
  final ValueChanged<String> onTagToggled;

  /// Card heading — defaults to "How was your
  /// session?".
  final String title;

  /// Text area placeholder — defaults to
  /// "Tell us more... (Optional)".
  final String hintText;

  const ReviewRatingCard({
    super.key,
    required this.currentRating,
    required this.onRatingChanged,
    required this.comment,
    required this.onCommentChanged,
    required this.availableTags,
    required this.selectedTags,
    required this.onTagToggled,
    this.title = 'How was your session?',
    this.hintText = 'Tell us more... (Optional)',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.06),
            offset: const Offset(0, 16),
            blurRadius: 32,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildStars(colorScheme),
          const SizedBox(height: 32),
          _buildTextArea(colorScheme, context),
          const SizedBox(height: 32),
          ReviewTagsSelector(
            availableTags: availableTags,
            selectedTags: selectedTags,
            onTagToggled: onTagToggled,
          ),
        ],
      ),
    );
  }

  Widget _buildStars(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final isSelected = starValue <= currentRating;

        return GestureDetector(
          key: keys.reviewPage.star(starValue),
          onTap: () => onRatingChanged(starValue),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(
              isSelected ? Icons.star : Icons.star_border,
              size: 40,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextArea(ColorScheme colorScheme, BuildContext context) {
    return TextFormField(
      initialValue: comment,
      onChanged: onCommentChanged,
      maxLines: 4,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.15),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
