import 'package:common/widgets/button/button.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Displays rating stats, personal info, and action
/// buttons for an employee.
class EmployeeStatsActionsSection extends StatelessWidget {
  /// Average rating from reviews.
  final double rating;

  /// Total number of reviews received.
  final int reviewCount;

  /// Gender string (e.g. 'MALE', 'FEMALE').
  final String? gender;

  /// Date of birth ISO string for age calculation.
  final String? dateOfBirth;

  /// Whether the parent form is in editing mode.
  final bool isEditing;

  /// Callback when Edit button is pressed.
  final VoidCallback? onEdit;

  /// Callback when Deactivate button is pressed.
  final VoidCallback? onDeactivate;

  /// Whether the Deactivate action is currently submitting.
  final bool isDeactivating;

  const EmployeeStatsActionsSection({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.gender,
    this.dateOfBirth,
    this.isEditing = false,
    this.onEdit,
    this.onDeactivate,
    this.isDeactivating = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rating
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'RATING',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppDimens.horizontalExtraSmall,
                    _StarRow(rating: rating),
                  ],
                ),
              ],
            ),
            Container(
              width: 1,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: colorScheme.outlineVariant,
            ),
            // Personal
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'PERSONAL',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  _personalLabel,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        AppDimens.verticalMedium,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              onPressed: onEdit,
              buttonType: ButtonType.outline,
              child: const Text('Edit Profile'),
            ),
            AppDimens.horizontalMediumSmall,
            AppButton(
              onPressed: isDeactivating ? null : onDeactivate,
              buttonType: ButtonType.elevated,
              isLoading: isDeactivating,
              customStyle: OutlinedButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).extension<SemanticColors>()!.error!.withAlpha(25),
                foregroundColor: Theme.of(
                  context,
                ).extension<SemanticColors>()!.error,
                side: BorderSide(
                  color: Theme.of(
                    context,
                  ).extension<SemanticColors>()!.error!.withAlpha(50),
                ),
              ),
              child: const Text('Deactivate'),
            ),
          ],
        ),
      ],
    );
  }

  String get _personalLabel {
    final parts = <String>[];

    if (gender != null && gender!.isNotEmpty) {
      parts.add(_formatGender(gender!));
    }

    final age = _computeAge();
    if (age != null) {
      parts.add('$age yrs');
    }

    return parts.isNotEmpty ? parts.join(' • ') : 'N/A';
  }

  String _formatGender(String g) {
    final lower = g.toLowerCase();
    if (lower == 'male') return 'Male';
    if (lower == 'female') return 'Female';
    return g;
  }

  int? _computeAge() {
    if (dateOfBirth == null || dateOfBirth!.isEmpty) {
      return null;
    }
    final dob = DateTime.tryParse(dateOfBirth!);
    if (dob == null) return null;

    final now = DateTime.now();
    var age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }
}

class _StarRow extends StatelessWidget {
  final double rating;

  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    final warningColor = Theme.of(context).extension<SemanticColors>()!.warning;

    return Row(
      children: List.generate(5, (index) {
        final starValue = index + 1;
        IconData icon;
        if (rating >= starValue) {
          icon = Icons.star;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, size: 18, color: warningColor);
      }),
    );
  }
}
