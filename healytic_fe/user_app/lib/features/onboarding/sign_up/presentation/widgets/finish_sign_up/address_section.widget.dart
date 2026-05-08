import 'package:flutter/material.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/utils/form_validators.dart';

/// Form section for collecting the user's mailing address
/// during sign-up.
///
/// Includes street, ward, district, city/province, and a
/// disabled country field defaulting to "Vietnam".
class AddressSection extends StatelessWidget {
  /// Creates an [AddressSection].
  const AddressSection({super.key});

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

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 1.0,
        children: [
          Text('Address', style: titleStyle),
          AppDimens.verticalSmall,
          FormFieldBuilders.buildTextField(
            context,
            fieldKey: 'street_address',
            label: 'Street Address',
            uppercaseLabel: false,
            validator: (value) =>
                FormValidators.requiredField(
              value,
              fieldName: 'street address',
            ),
          ),
          AppDimens.verticalSmall,
          FormFieldBuilders.buildTextField(
            context,
            fieldKey: 'ward',
            label: 'Ward',
            uppercaseLabel: false,
            validator: (value) =>
                FormValidators.requiredField(
              value,
              fieldName: 'ward',
            ),
          ),
          AppDimens.verticalSmall,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'district',
                  label: 'District',
                  uppercaseLabel: false,
                  validator: (value) =>
                      FormValidators.requiredField(
                    value,
                    fieldName: 'district',
                  ),
                ),
              ),
              AppDimens.horizontalSmall,
              Expanded(
                child: FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'city_or_province',
                  label: 'City or Province',
                  uppercaseLabel: false,
                  validator: (value) =>
                      FormValidators.requiredField(
                    value,
                    fieldName: 'city or province',
                  ),
                ),
              ),
            ],
          ),
          AppDimens.verticalSmall,
          FormFieldBuilders.buildTextField(
            context,
            fieldKey: 'country',
            label: 'Country',
            uppercaseLabel: false,
            enabled: false,
            initialValue: 'Vietnam',
          ),
          AppDimens.verticalSmall,
          Text(
            'Please provide your correct address '
            'for direction purposes.',
            style: captionStyle,
          ),
        ],
      ),
    );
  }
}
