import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:user_app/router/app_router.dart';
import 'package:user_app/core/services/ws/ws_client.dart';
import 'package:user_app/features/notifications/'
    'presentation/providers/notification.provider.dart';
import 'package:user_app/features/notifications/'
    'presentation/widgets/notification_toast.widget.dart';

final _log = Logger('NotificationToastListener');

/// Global listener that shows a premium toast banner
/// whenever a real-time notification arrives over
/// WebSocket.
///
/// **Placement:** Wrap [MaterialApp.router] with this
/// widget (same pattern as [GlobalErrorListener]) so
/// toasts appear on every screen, including screens
/// outside the bottom navigation shell.
///
/// ```dart
/// NotificationToastListener(
///   child: MaterialApp.router( ... ),
/// )
/// ```
class NotificationToastListener extends ConsumerWidget {
  const NotificationToastListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<WsNewNotificationEvent>>(
      latestNotificationEventProvider,
      (previous, next) {
        final event = next.value;
        if (event == null) return;

        // Avoid showing toast if the event is the same
        // as the previous one (stream replay).
        final prevEvent = previous?.value;
        if (prevEvent != null &&
            prevEvent.id == event.id) {
          return;
        }

        _log.fine(
          'Showing toast for notification: '
          '${event.id} — ${event.title}',
        );

        // Use the navigator's context (below the
        // Overlay) instead of the builder context.
        final navCtx =
            rootNavigatorKey.currentContext;
        if (navCtx == null) return;

        _showToast(navCtx, event);
      },
    );

    return child;
  }

  void _showToast(
    BuildContext context,
    WsNewNotificationEvent event,
  ) {
    final fToast = FToast();
    fToast.init(context);

    fToast.showToast(
      child: NotificationToast(
        title: event.title,
        body: event.body,
        type: event.type,
        onTap: () {
          fToast.removeCustomToast();
          // Navigate to /notifications tab
          if (context.mounted) {
            GoRouter.of(context).go('/notifications');
          }
        },
        onDismiss: () {
          fToast.removeCustomToast();
        },
      ),
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 4),
      positionedToastBuilder: (context, child, gravity) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _AnimatedToastEntry(child: child),
        );
      },
    );
  }
}

/// Wraps the toast widget with a slide-down + fade-in
/// entrance animation for a premium feel.
class _AnimatedToastEntry extends StatefulWidget {
  const _AnimatedToastEntry({required this.child});
  final Widget child;

  @override
  State<_AnimatedToastEntry> createState() =>
      _AnimatedToastEntryState();
}

class _AnimatedToastEntryState
    extends State<_AnimatedToastEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}
