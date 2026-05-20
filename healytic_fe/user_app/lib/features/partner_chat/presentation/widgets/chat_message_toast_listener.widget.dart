import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:user_app/core/services/ws/ws_client.dart';
import 'package:user_app/core/widgets/root_overlay_toast.dart';
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
  const ChatMessageToastListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<WsNewMessageEvent>>(latestChatMessageEventProvider, (
      previous,
      next,
    ) {
      final event = next.value;
      if (event == null) return;

      final prevEvent = previous?.value;
      if (prevEvent != null && prevEvent.id == event.id) {
        return;
      }

      _log.fine(
        'Chat toast: ${event.senderName} '
        '— ${event.content}',
      );

      final navCtx = rootNavigatorKey.currentContext;
      if (navCtx == null) return;

      _showToast(navCtx, event);
    });

    return child;
  }

  void _showToast(BuildContext context, WsNewMessageEvent event) {
    final shown = RootOverlayToast.show(
      builder: (dismiss) {
        return ChatMessageToast(
          senderName: event.senderName ?? 'Partner',
          messageContent: event.content,
          senderAvatar: event.senderAvatar,
          onTap: () {
            dismiss();
            if (context.mounted) {
              GoRouter.of(context).push(
                '/partner_chat'
                '?partnerAccountId=${event.senderId}'
                '&partnerName='
                '${Uri.encodeComponent(event.senderName ?? 'Partner')}',
              );
            }
          },
          onDismiss: dismiss,
        );
      },
    );

    if (!shown) {
      _log.fine('Skipped chat toast because root overlay is unavailable');
    }
  }
}
