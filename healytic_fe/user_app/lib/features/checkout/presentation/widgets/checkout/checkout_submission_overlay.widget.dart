import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/checkout/presentation/providers/checkout.provider.dart';

/// Semi-transparent overlay shown while the booking
/// is being processed (submitting or polling).
class CheckoutSubmissionOverlay extends StatelessWidget {
  /// The current checkout state used to determine
  /// the overlay message.
  final CheckoutState state;

  const CheckoutSubmissionOverlay({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final message = switch (state.submissionStatus) {
      CheckoutSubmissionStatus.polling =>
        'Processing your booking...',
      CheckoutSubmissionStatus.awaitingMoMoPayment =>
        'Opening MoMo. Complete payment in the app...',
      CheckoutSubmissionStatus.verifyingPayment =>
        'Verifying your payment...',
      _ => 'Submitting...',
    };

    return Container(
      color: colorScheme.scrim
          .withValues(alpha: 0.4),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.cardPadding(context)
                * 2,
            vertical: AppDimens.sectionSpacing(context),
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(
              AppDimens.cardRadius(context),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow
                    .withValues(alpha: 0.1),
                blurRadius: AppDimens.spaceXxl,
                offset: const Offset(
                  0,
                  AppDimens.spaceSm,
                ),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: colorScheme.primary,
              ),
              AppDimens.verticalMedium,
              Text(
                message,
                style:
                    textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
