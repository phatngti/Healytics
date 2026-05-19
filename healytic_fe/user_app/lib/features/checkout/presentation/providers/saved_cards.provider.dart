import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/checkout/data/provider/checkout.provider.dart';
import 'package:user_app/features/checkout/domain/entities/payment_card.entity.dart';

/// Fetches the current user's saved Stripe cards.
final savedPaymentCardsProvider =
    FutureProvider.autoDispose<List<SavedPaymentCard>>((ref) {
      return ref.read(checkoutRepositoryProvider).listSavedPaymentCards();
    });

/// Imperative card actions shared by checkout and
/// profile card management screens.
final savedPaymentCardsControllerProvider =
    Provider<SavedPaymentCardsController>((ref) {
      return SavedPaymentCardsController(ref);
    });

class SavedPaymentCardsController {
  final Ref _ref;

  const SavedPaymentCardsController(this._ref);

  Future<SavedPaymentCard> addCard({bool setDefault = false}) async {
    final repo = _ref.read(checkoutRepositoryProvider);
    final setupIntent = await repo.createStripeSetupIntent();

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        setupIntentClientSecret: setupIntent.clientSecret,
        merchantDisplayName: 'Healytics',
        style: ThemeMode.system,
      ),
    );
    await Stripe.instance.presentPaymentSheet();

    final card = await repo.confirmStripeSetupIntent(
      setupIntentId: setupIntent.setupIntentId,
      setDefault: setDefault,
    );
    _ref.invalidate(savedPaymentCardsProvider);
    return card;
  }

  Future<SavedPaymentCard> setDefault(String cardId) async {
    final card = await _ref
        .read(checkoutRepositoryProvider)
        .setDefaultPaymentCard(cardId);
    _ref.invalidate(savedPaymentCardsProvider);
    return card;
  }

  Future<List<SavedPaymentCard>> delete(String cardId) async {
    final cards = await _ref
        .read(checkoutRepositoryProvider)
        .deletePaymentCard(cardId);
    _ref.invalidate(savedPaymentCardsProvider);
    return cards;
  }
}
