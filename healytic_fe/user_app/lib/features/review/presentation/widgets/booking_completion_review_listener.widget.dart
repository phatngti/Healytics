import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';
import 'package:user_app/core/providers/ws.provider.dart';
import 'package:user_app/core/services/ws/ws_client.dart';
import 'package:user_app/features/orders/data/provider/appointment.provider.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';
import 'package:user_app/router/app_router.dart';
import 'package:user_app/router/routes.dart';

final _log = Logger('BookingCompletionReviewListener');

/// Global listener that opens the treatment review flow
/// as soon as the backend marks a user booking completed.
class BookingCompletionReviewListener extends ConsumerStatefulWidget {
  const BookingCompletionReviewListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<BookingCompletionReviewListener> createState() =>
      _BookingCompletionReviewListenerState();
}

class _BookingCompletionReviewListenerState
    extends ConsumerState<BookingCompletionReviewListener> {
  StreamSubscription<String?>? _tokenSub;
  StreamSubscription<BookingStatusChangeEvent>? _eventSub;
  String _previousToken = '';
  final Set<String> _handledEventIds = {};
  final Set<String> _handledBookingIds = {};

  @override
  void initState() {
    super.initState();

    final authSessionStore = ref.read(authSessionStoreProvider);
    final wsService = ref.read(wsServiceProvider);

    _eventSub = wsService.bookingEvents.onBookingStatusChanged.listen((event) {
      unawaited(_handleStatusEvent(event));
    });

    _syncWithToken(Store.tryGet(StoreKey.accessToken));
    _tokenSub = authSessionStore.watchAccessToken().listen(_syncWithToken);
  }

  @override
  void dispose() {
    unawaited(_tokenSub?.cancel());
    unawaited(_eventSub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  void _syncWithToken(String? token) {
    final wsService = ref.read(wsServiceProvider);
    final currentToken = (token ?? '').trim();

    if (currentToken.isEmpty) {
      if (wsService.bookingEvents.status != WsConnectionStatus.disconnected) {
        _log.info('Disconnecting /booking-events WS because token is empty');
        wsService.bookingEvents.disconnect();
      }
      _previousToken = '';
      return;
    }

    final shouldReconnect =
        _previousToken.isNotEmpty && _previousToken != currentToken;
    _previousToken = currentToken;

    if (shouldReconnect) {
      _log.info('Reconnecting /booking-events WS after token change');
      wsService.bookingEvents.disconnect();
    }

    _log.info('Connecting /booking-events WS namespace');
    wsService.connectBookingEvents();
  }

  Future<void> _handleStatusEvent(BookingStatusChangeEvent event) async {
    if (event.status != PublicBookingStatus.completed) return;
    if (!_handledEventIds.add(event.eventId)) return;
    if (!_handledBookingIds.add(event.bookingId)) return;

    final appointment = await _fetchAppointment(event.bookingId);
    if (!mounted) return;

    if (appointment == null) {
      _handledBookingIds.remove(event.bookingId);
      _log.warning(
        'Completed booking ${event.bookingId} was not found for review',
      );
      return;
    }

    if (appointment.isReviewed) {
      return;
    }

    _openReview(appointment);
  }

  Future<AppointmentEntity?> _fetchAppointment(String bookingId) async {
    final repo = ref.read(appointmentRepositoryProvider);

    for (var attempt = 0; attempt < 3; attempt += 1) {
      final appointment = await repo.getAppointmentById(bookingId);
      if (appointment != null) return appointment;

      if (attempt < 2) {
        await Future<void>.delayed(const Duration(milliseconds: 350));
      }
    }

    return null;
  }

  void _openReview(AppointmentEntity appointment) {
    final context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) return;

    final router = GoRouter.of(context);
    final currentUri = router.routerDelegate.currentConfiguration.uri;
    if (currentUri.path == '/review_treatment' &&
        currentUri.queryParameters['appointment-id'] == appointment.id) {
      return;
    }

    ReviewTreatmentRoute(
      appointmentId: appointment.id,
      serviceName: appointment.serviceName,
      vendorName: appointment.healthPartnerName,
    ).push<void>(context);
  }
}
