import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/cart/presentation/providers/cart.provider.dart';
import 'package:user_app/features/checkout/domain/entities/checkout.entity.dart'
    as checkout;
import 'package:user_app/features/checkout/domain/entities/payment_card.entity.dart';
import 'package:user_app/features/checkout/presentation/providers/checkout.provider.dart';
import 'package:user_app/features/checkout/presentation/providers/momo_launcher.dart';
import 'package:user_app/features/checkout/presentation/providers/saved_cards.provider.dart';
import 'package:user_app/features/checkout/presentation/widgets/checkout_bottom_bar.widget.dart';
import 'package:user_app/features/checkout/presentation/widgets/checkout/checkout_submission_overlay.widget.dart';
import 'package:user_app/features/checkout/presentation/widgets/order_items_section.widget.dart';
import 'package:user_app/features/checkout/presentation/widgets/payment_details_section.widget.dart';
import 'package:user_app/features/checkout/presentation/widgets/payment_method_section.widget.dart';
import 'package:user_app/features/checkout/presentation/widgets/saved_cards_section.widget.dart';
import 'package:user_app/features/checkout/presentation/widgets/vouchers_section.widget.dart';
import 'package:user_app/router/routes.dart';

/// Main checkout screen composing all section widgets.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  /// Listens for the app returning to the foreground
  /// after the user visits MoMo.
  AppLifecycleListener? _lifecycleListener;
  StreamSubscription<Uri>? _moMoReturnSubscription;
  String? _activeMoMoBookingId;
  bool _moMoReturnHandled = false;

  @override
  void dispose() {
    _lifecycleListener?.dispose();
    _moMoReturnSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutAsync = ref.watch(checkoutProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Listen for submission status changes.
    ref.listen<AsyncValue<CheckoutState>>(
      checkoutProvider,
      (prev, next) =>
          _handleSubmissionChange(context, ref, prev?.value, next.value),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
        ),
        title: Text(
          'Checkout',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: colorScheme.surface.withValues(alpha: 0.9),
      ),
      body: checkoutAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (state) => _CheckoutBody(state: state),
      ),
    );
  }

  void _handleSubmissionChange(
    BuildContext context,
    WidgetRef ref,
    CheckoutState? prev,
    CheckoutState? next,
  ) {
    if (prev == null || next == null) return;
    if (prev.submissionStatus == next.submissionStatus) {
      return;
    }

    switch (next.submissionStatus) {
      case CheckoutSubmissionStatus.failed:
        _disposeMoMoReturnHandlers();
        ToastContext.showToast(
          context,
          ToastType.error,
          next.errorMessage ?? 'Checkout failed. Please try again.',
        );
        ref.read(checkoutProvider.notifier).resetSubmission();

      case CheckoutSubmissionStatus.success:
        _disposeMoMoReturnHandlers();
        unawaited(_removeCheckedOutCartItem(ref, next));
        _showSuccessDialog(context, next);

      case CheckoutSubmissionStatus.awaitingMoMoPayment:
        _launchMoMoAndListen(context, ref, next);

      case CheckoutSubmissionStatus.awaitingStripePayment:
        _confirmStripePayment(context, ref, next);

      default:
        break;
    }
  }

  Future<void> _removeCheckedOutCartItem(
    WidgetRef ref,
    CheckoutState state,
  ) async {
    final cartItemId = state.bookingParams?.cartItemId;
    if (cartItemId == null || cartItemId.isEmpty) return;

    try {
      await ref.read(cartProvider.notifier).removeItem(cartItemId);
    } catch (_) {
      // Checkout has already succeeded. Keep the booking success path intact;
      // the cart can be refreshed or manually edited if cleanup fails.
    }
  }

  /// Launches MoMo and registers an
  /// [AppLifecycleListener] to trigger payment
  /// verification when the user returns.
  void _launchMoMoAndListen(
    BuildContext context,
    WidgetRef ref,
    CheckoutState state,
  ) {
    final bookingId = state.booking?.id;
    if (bookingId == null) return;

    _startMoMoReturnListener(bookingId);

    launchMoMoPayment(deeplink: state.moMoDeeplink, payUrl: state.moMoPayUrl);

    // Dispose any previous lifecycle listener before creating.
    _disposeLifecycleListener();

    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        if (_moMoReturnHandled) return;
        unawaited(_verifyMoMoAfterResumeFallback(bookingId));
      },
    );
  }

  /// Confirms a Stripe payment on-device using the
  /// client secret from the PaymentIntent.
  Future<void> _confirmStripePayment(
    BuildContext context,
    WidgetRef ref,
    CheckoutState state,
  ) async {
    final clientSecret = state.stripeClientSecret;
    final bookingId = state.booking?.id;

    if (clientSecret == null || bookingId == null) {
      ref.read(checkoutProvider.notifier).resetSubmission();
      return;
    }

    try {
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
      );

      // On-device confirmation succeeded — verify
      // via webhook polling.
      if (!context.mounted) return;
      ref.read(checkoutProvider.notifier).verifyStripePayment(bookingId);
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        // User dismissed the payment sheet.
        ref.read(checkoutProvider.notifier).resetSubmission();
        return;
      }

      if (!context.mounted) return;
      ToastContext.showToast(
        context,
        ToastType.error,
        e.error.localizedMessage ?? 'Payment failed',
      );
      ref.read(checkoutProvider.notifier).resetSubmission();
    }
  }

  void _disposeLifecycleListener() {
    _lifecycleListener?.dispose();
    _lifecycleListener = null;
  }

  void _startMoMoReturnListener(String bookingId) {
    _disposeMoMoReturnHandlers();
    _activeMoMoBookingId = bookingId;
    _moMoReturnHandled = false;

    final appLinks = AppLinks();
    _moMoReturnSubscription = appLinks.uriLinkStream.listen(
      _handleMoMoReturnUri,
    );
  }

  void _handleMoMoReturnUri(Uri uri) {
    if (_moMoReturnHandled || !_isMoMoReturnUri(uri)) return;

    final bookingId = uri.queryParameters['bookingId'];
    if (bookingId == null ||
        bookingId.isEmpty ||
        bookingId != _activeMoMoBookingId) {
      return;
    }

    _moMoReturnHandled = true;
    _disposeMoMoReturnHandlers();

    final resultCode = uri.queryParameters['resultCode'];
    if (resultCode == null || resultCode == '0') {
      ref
          .read(checkoutProvider.notifier)
          .verifyMoMoPayment(bookingId, returnParams: uri.queryParameters);
      return;
    }

    if (!mounted) return;
    ToastContext.showToast(
      context,
      ToastType.error,
      uri.queryParameters['message'] ?? 'MoMo payment was cancelled or failed.',
    );
    ref.read(checkoutProvider.notifier).resetSubmission();
  }

  bool _isMoMoReturnUri(Uri uri) {
    return uri.scheme == 'healytics' &&
        uri.host == 'payment' &&
        uri.path == '/momo/success';
  }

  Future<void> _verifyMoMoAfterResumeFallback(String bookingId) async {
    // Android can deliver the lifecycle resume before app_links emits the
    // intent URI. Give the deeplink stream a chance to hand us MoMo's signed
    // return payload before falling back to status polling.
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted || _moMoReturnHandled) return;

    final latestUri = await AppLinks().getLatestLink();
    if (!mounted || _moMoReturnHandled) return;

    if (latestUri != null && _isMoMoReturnUri(latestUri)) {
      _handleMoMoReturnUri(latestUri);
      if (_moMoReturnHandled) return;
    }

    _moMoReturnHandled = true;
    _disposeMoMoReturnHandlers();
    await ref.read(checkoutProvider.notifier).verifyMoMoPayment(bookingId);
  }

  void _disposeMoMoReturnHandlers() {
    _disposeLifecycleListener();
    _moMoReturnSubscription?.cancel();
    _moMoReturnSubscription = null;
    _activeMoMoBookingId = null;
  }

  void _showSuccessDialog(BuildContext context, CheckoutState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final booking = state.booking;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppDimens.radiusMedium),
        icon: Icon(
          Icons.check_circle_rounded,
          color: colorScheme.primary,
          size: AppDimens.avatarMd,
        ),
        title: Text(
          'Booking Confirmed!',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Text(
          state.selectedPayment == checkout.PaymentMethodType.payLater
              ? 'Your booking has been confirmed. '
                    'Payment is due at the clinic.'
              : booking?.paymentUrl != null
              ? 'Your booking has been created. '
                    'Please proceed to payment.'
              : 'Your booking has been created '
                    'successfully.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              const OrderApprovedRoute().go(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

/// Thin composition shell for the checkout content.
class _CheckoutBody extends ConsumerWidget {
  final CheckoutState state;

  const _CheckoutBody({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = state.checkoutData;
    final summary = data.summary;
    final notifier = ref.read(checkoutProvider.notifier);
    final AsyncValue<List<SavedPaymentCard>> cardsAsync =
        state.selectedPayment == checkout.PaymentMethodType.card
        ? ref.watch(savedPaymentCardsProvider)
        : const AsyncValue<List<SavedPaymentCard>>.data([]);
    _syncSelectedCard(ref, state, cardsAsync);
    final hPad = AppDimens.horizontalPadding(context);
    final section = AppDimens.sectionSpacing(context);
    final bottomBar = AppDimens.adaptive(
      context,
      small: 130,
      medium: 135,
      large: 140,
    );

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.fromLTRB(hPad, section, hPad, bottomBar),
          children: [
            OrderItemsSection(items: data.items),
            SizedBox(height: section),
            VouchersSection(
              shopVoucher: data.shopVoucher,
              platformVoucher: data.platformVoucher,
              coinBalance: data.coinBalance,
              coinValue: data.coinValue,
              useCoins: state.useCoins,
              onCoinsToggled: notifier.toggleCoins,
            ),
            SizedBox(height: section),
            PaymentMethodSection(
              methods: data.paymentMethods,
              selectedType: state.selectedPayment,
              onSelected: notifier.selectPaymentMethod,
            ),
            if (state.selectedPayment == checkout.PaymentMethodType.card) ...[
              SizedBox(height: section),
              SavedCardsSection(
                cardsAsync: cardsAsync,
                selectedCardId: state.selectedCardId,
                onSelected: notifier.selectSavedCard,
                onAddCard: () => _addCard(context, ref),
              ),
            ],
            SizedBox(height: section),
            PaymentDetailsSection(
              subtotal: summary.subtotal,
              shopDiscount: summary.shopDiscount,
              platformVoucher: summary.platformVoucher,
              coinsUsed: summary.coinsUsed,
              useCoins: state.useCoins,
            ),
            SizedBox(height: section),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: CheckoutBottomBar(
            total: state.effectiveTotal,
            saved: state.effectiveSaved,
            onConfirm: state.isSubmitting
                ? () {}
                : () => notifier.confirmBooking(),
          ),
        ),
        if (state.isSubmitting ||
            state.submissionStatus ==
                CheckoutSubmissionStatus.awaitingMoMoPayment ||
            state.submissionStatus ==
                CheckoutSubmissionStatus.awaitingStripePayment)
          Positioned.fill(child: CheckoutSubmissionOverlay(state: state)),
      ],
    );
  }

  Future<void> _addCard(BuildContext context, WidgetRef ref) async {
    try {
      final cards =
          ref.read(savedPaymentCardsProvider).asData?.value ?? const [];
      final card = await ref
          .read(savedPaymentCardsControllerProvider)
          .addCard(setDefault: cards.isEmpty);
      ref.read(checkoutProvider.notifier).selectSavedCard(card.id);
      if (!context.mounted) return;
      ToastContext.showToast(context, ToastType.success, 'Card added.');
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) return;
      if (!context.mounted) return;
      ToastContext.showToast(
        context,
        ToastType.error,
        e.error.localizedMessage ?? 'Failed to add card.',
      );
    } catch (e) {
      if (!context.mounted) return;
      ToastContext.showToast(context, ToastType.error, '$e');
    }
  }

  void _syncSelectedCard(
    WidgetRef ref,
    CheckoutState state,
    AsyncValue<List<SavedPaymentCard>> cardsAsync,
  ) {
    if (state.selectedPayment != checkout.PaymentMethodType.card) return;
    final cards = cardsAsync.asData?.value;
    if (cards == null) return;

    final selectedExists = cards.any((card) => card.id == state.selectedCardId);
    if (cards.isEmpty && state.selectedCardId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(checkoutProvider.notifier).selectSavedCard(null);
      });
      return;
    }

    if (cards.isNotEmpty && !selectedExists) {
      final defaultCard = cards.firstWhere(
        (card) => card.isDefault,
        orElse: () => cards.first,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(checkoutProvider.notifier).selectSavedCard(defaultCard.id);
      });
    }
  }
}
