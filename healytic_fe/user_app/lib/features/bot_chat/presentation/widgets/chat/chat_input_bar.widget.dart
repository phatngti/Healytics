import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';

/// Telegram-style input bar: clean, minimal, with an
/// attachment button, expandable text field, and a send
/// button that morphs from a mic icon.
///
/// [onSend] fires with the current text when the send
/// button is pressed and the field is non-empty.
class ChatInputBar extends StatefulWidget {
  final ValueChanged<String>? onSend;

  const ChatInputBar({super.key, this.onSend});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final nonEmpty = _controller.text.trim().isNotEmpty;
    if (nonEmpty != _hasText) {
      setState(() => _hasText = nonEmpty);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend?.call(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.25),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.spaceSm,
            vertical: AppDimens.spaceXs,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Attachment
              _CircleIconButton(
                icon: Icons.attach_file_rounded,
                color: colorScheme.onSurfaceVariant,
                onTap: () {},
              ),
              SizedBox(width: AppDimens.spaceXs),

              // Text field
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 40),
                  child: TextField(
                    key: keys.chatPage.messageInput,
                    controller: _controller,
                    maxLines: 5,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceMd,
                        vertical: AppDimens.spaceSm,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppDimens.spaceXs),

              // Send / Mic toggle
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: _hasText
                    ? _CircleIconButton(
                        key: keys.chatPage.sendButton,
                        icon: Icons.send_rounded,
                        color: colorScheme.onPrimary,
                        backgroundColor: colorScheme.primary,
                        onTap: _handleSend,
                      )
                    : _CircleIconButton(
                        key: const ValueKey('mic'),
                        icon: Icons.mic_rounded,
                        color: colorScheme.onSurfaceVariant,
                        onTap: () {},
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple circular icon button used for attach, mic,
/// and send actions.
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const _CircleIconButton({
    super.key,
    required this.icon,
    required this.color,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(AppDimens.spaceSm),
          child: Icon(icon, color: color, size: AppDimens.iconLg),
        ),
      ),
    );
  }
}
