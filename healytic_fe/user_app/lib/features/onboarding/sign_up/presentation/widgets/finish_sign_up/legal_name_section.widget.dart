import 'package:flutter/material.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/utils/form_validators.dart';

/// Form section for collecting the user's legal first
/// and last name during sign-up.
///
/// Displays two text fields with full-name validation and
/// a helper note about government ID matching.
class LegalNameSection extends StatelessWidget {
  /// Creates a [LegalNameSection].
  const LegalNameSection({super.key});

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
        Text('Legal name', style: titleStyle),
        AppDimens.verticalSmall,
        FormFieldBuilders.buildTextField(
          context,
          fieldKey: 'first_name',
          label: 'First name',
          uppercaseLabel: false,
          validator: (value) => FormValidators.fullName(
            value,
            fieldName: 'First name',
          ),
        ),
        AppDimens.verticalSmall,
        FormFieldBuilders.buildTextField(
          context,
          fieldKey: 'last_name',
          label: 'Last name',
          uppercaseLabel: false,
          validator: (value) => FormValidators.fullName(
            value,
            fieldName: 'Last name',
          ),
        ),
        AppDimens.verticalSmall,
        Text(
          'Make sure the matches the name on your '
          'government ID. This is required for '
          'identity verification.',
          style: captionStyle,
        ),
      ],
    );
  }
}
