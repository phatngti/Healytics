import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/clinic_identity_card.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Description section with a multi-line text field,
/// summary card and an explicit edit action.
class DescriptionSectionWidget extends StatelessWidget {
  const DescriptionSectionWidget({
    required this.description,
    required this.showValidationErrors,
    required this.isDescriptionValid,
    required this.trimmedLength,
    required this.minLength,
    required this.maxLength,
    required this.onEdit,
    super.key,
  });

  final String description;
  final bool showValidationErrors;
  final bool isDescriptionValid;
  final int trimmedLength;
  final int minLength;
  final int maxLength;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasDescription = description.isNotEmpty;
    final isTooShort = trimmedLength < minLength;
    final isInvalid =
        showValidationErrors && (trimmedLength == 0 || isTooShort);

    return SectionCardWidget(
      title: 'About clinic',
      subtitle:
          'Write a concise, patient-friendly '
          'description that covers your '
          'positioning, specialties, and care '
          'experience.',
      trailing: FilledButton.tonalIcon(
        onPressed: onEdit,
        icon: Icon(
          hasDescription
              ? Icons.edit_outlined
              : Icons.add_rounded,
        ),
        label: Text(
          hasDescription
              ? 'Edit description'
              : 'Add description',
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(
              AppDimens.spaceLg + AppDimens.spaceXxs,
            ),
            decoration: BoxDecoration(
              color: hasDescription
                  ? colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.3)
                  : colorScheme
                      .surfaceContainerHigh
                      .withValues(alpha: 0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  AppDimens.spaceLg + AppDimens.spaceXxs,
                ),
              ),
              border: Border.all(
                color: isInvalid
                    ? colorScheme.error
                    : colorScheme.outlineVariant,
              ),
            ),
            child: hasDescription
                ? Text(
                    description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge,
                  )
                : Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.notes_rounded,
                        color: colorScheme
                            .onSurfaceVariant,
                      ),
                      AppDimens.verticalMediumSmall,
                      Text(
                        'No clinic description '
                        'added yet.',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: AppDimens.spaceXs +
                            AppDimens.spaceXxs,
                      ),
                      Text(
                        'Add a short profile summary '
                        'to explain specialties, '
                        'patient experience, and '
                        'care approach.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
          ),
          AppDimens.verticalMediumSmall,
          Row(
            children: [
              Icon(
                isDescriptionValid
                    ? Icons.check_circle_rounded
                    : Icons.edit_note_rounded,
                size: AppDimens.iconSmMd,
                color: isDescriptionValid
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              AppDimens.horizontalSmall,
              Text(
                isDescriptionValid
                    ? 'Description is ready '
                          'for publishing.'
                    : trimmedLength == 0
                    ? 'Description required. '
                          'Target $minLength-'
                          '$maxLength characters.'
                    : '$trimmedLength/$minLength '
                          'minimum characters',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: isDescriptionValid
                      ? colorScheme.primary
                      : colorScheme
                          .onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (isInvalid) ...[
            AppDimens.verticalSmall,
            Text(
              'Description must be at least '
              '$minLength characters.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
