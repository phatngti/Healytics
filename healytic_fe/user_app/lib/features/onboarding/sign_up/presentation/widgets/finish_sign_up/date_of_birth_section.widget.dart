import 'package:flutter/material.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/utils/form_validators.dart';

/// Form section for selecting the user's date of birth
/// during sign-up.
///
/// Includes a date picker field and a helper note about
/// minimum age requirements and privacy.
class DateOfBirthSection extends StatelessWidget {
  /// Creates a [DateOfBirthSection].
  const DateOfBirthSection({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(
          color: Theme.of(context)
              .textTheme
              .titleMedium
              ?.color
              ?.withAlpha(700),
          fontWeight: FontWeight.bold,
        );

    final captionStyle = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(
          color: Theme.of(context)
              .textTheme
              .bodySmall
              ?.color
              ?.withAlpha(700),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 1.0,
      children: [
        Text('Date of Birth', style: titleStyle),
        AppDimens.verticalSmall,
        FormFieldBuilders.buildDateField(
          context,
          fieldKey: 'date_of_birth',
          label: 'Select your birthday',
          validator: FormValidators.dateOfBirth,
        ),
        AppDimens.verticalSmall,
        Text(
          'To sign up, you must be at least 16 years. '
          "Your birthday won't be shared with others.",
          style: captionStyle,
        ),
      ],
    );
  }
}
