import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/utils/demensions.dart';

/// Terms of service agreement text and the "Agree &
/// Continue" submit button for the sign-up form.
///
/// Displays tappable links for Terms of Service and
/// Privacy Policy. The button is disabled when
/// [isEnabled] is `false` and shows a spinner when
/// [isLoading] is `true`.
class TermsAndSubmitSection extends StatelessWidget {
  /// Creates a [TermsAndSubmitSection].
  const TermsAndSubmitSection({
    super.key,
    required this.isEnabled,
    required this.isLoading,
    required this.onSubmit,
  });

  /// Whether the submit button should be enabled.
  final bool isEnabled;

  /// Whether the submit button shows a loading spinner.
  final bool isLoading;

  /// Callback invoked when the user taps the submit
  /// button.
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 1.0,
      children: [
        _TermsRichText(),
        AppDimens.verticalMedium,
        SizedBox(
          width: double.infinity,
          child: AppButton(
            buttonType: ButtonType.elevated,
            onPressed: isEnabled ? onSubmit : null,
            isLoading: isLoading,
            customStyle: ElevatedButton.styleFrom(
              padding: AppDimens.paddingAllMedium,
              shape: RoundedRectangleBorder(
                borderRadius: AppDimens.radiusSmall,
              ),
              textStyle: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            child: const Text('Agree & Continue'),
          ),
        ),
      ],
    );
  }
}

/// Rich text block with tappable Terms of Service and
/// Privacy Policy links.
class _TermsRichText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bodyColor = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.color
        ?.withAlpha(200);

    final linkStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(
          color: Theme.of(context)
              .colorScheme
              .primary
              .withAlpha(700),
          fontWeight: FontWeight.bold,
        );

    final bodyStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: bodyColor);

    return Text.rich(
      textAlign: TextAlign.left,
      TextSpan(
        text: 'By selecting "Agree & Continue", '
            'I agree to Healytic',
        style: bodyStyle,
        children: [
          TextSpan(
            text: 'Terms of Service, '
                'Payment Terms of Service ',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Handle Terms of Service tap
              },
          ),
          TextSpan(
            text: 'and acknowledge the ',
            style: bodyStyle,
          ),
          TextSpan(
            text: 'Privacy Policy.',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                log('Privacy Policy tapped');
              },
          ),
        ],
      ),
    );
  }
}
