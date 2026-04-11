import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:user_app/core/services/ws/ws_client.dart';
import 'package:user_app/features/partner_chat/'
    'presentation/providers/'
    'chat_message_event.provider.dart';
import 'package:user_app/features/partner_chat/'
    'presentation/widgets/'
    'chat_message_toast.widget.dart';
import 'package:user_app/router/app_router.dart';

final _log = Logger('ChatMessageToastListener');

/// Global listener that shows a chat-styled toast
/// whenever a new message arrives over the `/user-chat`
/// WebSocket and the user is not viewing that
/// conversation.
///
/// **Placement:** Wrap alongside
/// [NotificationToastListener] inside the
/// [MaterialApp.router] builder.
class ChatMessageToastListener extends ConsumerWidget {
  const ChatMessageToastListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<WsNewMessageEvent>>(
      latestChatMessageEventProvider,
      (previous, next) {
        final event = next.value;
        if (event == null) return;

        final prevEvent = previous?.value;
        if (prevEvent != null &&
            prevEvent.id == event.id) {
          return;
        }

        _log.fine(
          'Chat toast: ${event.senderName} '
          '— ${event.content}',
        );

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
    WsNewMessageEvent event,
  ) {
    final fToast = FToast();
    fToast.init(context);

    final safeTop =
        MediaQuery.of(context).padding.top;

    fToast.showToast(
      child: ChatMessageToast(
        senderName: event.senderName ?? 'Partner',
        messageContent: event.content,
        senderAvatar: event.senderAvatar,
        onTap: () {
          fToast.removeCustomToast();
          if (context.mounted) {
            GoRouter.of(context).push(
              '/partner_chat'
              '?partnerAccountId=${event.senderId}'
              '&partnerName='
              '${Uri.encodeComponent(
                event.senderName ?? 'Partner',
              )}',
            );
          }
        },
        onDismiss: () {
          fToast.removeCustomToast();
        },
      ),
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 4),
      positionedToastBuilder:
          (context, child, gravity) {
        return Positioned(
          top: safeTop,
          left: 0,
          right: 0,
          child: _AnimatedToastEntry(child: child),
        );
      },
    );
  }
}

/// Slide-down + fade-in entrance animation matching
/// the existing [NotificationToastListener] style.
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
