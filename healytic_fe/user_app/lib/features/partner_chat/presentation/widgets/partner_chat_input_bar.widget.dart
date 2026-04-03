import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// Chat input bar for partner conversations.
///
/// Minimal design with expandable text field and a
/// send button that animates from a placeholder when
/// text is entered.
///
/// [onSend] fires with the current text when the send
/// button is pressed.
/// [onTypingChanged] fires when typing status changes
/// (used for typing indicators).
class PartnerChatInputBar extends StatefulWidget {
  final ValueChanged<String>? onSend;
  final ValueChanged<bool>? onTypingChanged;

  /// When false, the text field and send button are
  /// disabled (e.g. WS connection unavailable).
  final bool enabled;

  const PartnerChatInputBar({
    super.key,
    this.onSend,
    this.onTypingChanged,
    this.enabled = true,
  });

  @override
  State<PartnerChatInputBar> createState() =>
      _PartnerChatInputBarState();
}

class _PartnerChatInputBarState
    extends State<PartnerChatInputBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final nonEmpty =
        _controller.text.trim().isNotEmpty;
    if (nonEmpty != _hasText) {
      setState(() => _hasText = nonEmpty);
      widget.onTypingChanged?.call(nonEmpty);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (!widget.enabled) return;
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
            color: colorScheme.outlineVariant
                .withValues(alpha: 0.25),
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
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              // Text field
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 40,
                  ),
                  child: TextField(
                    controller: _controller,
                    enabled: widget.enabled,
                    maxLines: 5,
                    minLines: 1,
                    textCapitalization:
                        TextCapitalization.sentences,
                    style:
                        textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: textTheme.bodyMedium
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant
                            .withValues(alpha: 0.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: colorScheme
                              .outlineVariant
                              .withValues(
                                  alpha: 0.3),
                        ),
                      ),
                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: colorScheme
                              .outlineVariant
                              .withValues(
                                  alpha: 0.3),
                        ),
                      ),
                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: colorScheme.primary
                              .withValues(
                                  alpha: 0.5),
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(
                        horizontal:
                            AppDimens.spaceMd,
                        vertical: AppDimens.spaceSm,
                      ),
                      isDense: true,
                    ),
                    onSubmitted: (_) =>
                        _handleSend(),
                  ),
                ),
              ),
              SizedBox(width: AppDimens.spaceXs),

              // Send button
              AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 200,
                ),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(
                  scale: anim,
                  child: child,
                ),
                child: _hasText
                    ? _CircleButton(
                        key: const ValueKey('send'),
                        icon: Icons.send_rounded,
                        color:
                            colorScheme.onPrimary,
                        backgroundColor:
                            colorScheme.primary,
                        onTap: _handleSend,
                      )
                    : _CircleButton(
                        key: const ValueKey(
                          'placeholder',
                        ),
                        icon:
                            Icons.send_rounded,
                        color: colorScheme
                            .onSurfaceVariant
                            .withValues(
                                alpha: 0.3),
                        onTap: null,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const _CircleButton({
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
          padding: EdgeInsets.all(
            AppDimens.spaceSm,
          ),
          child: Icon(
            icon,
            color: color,
            size: AppDimens.iconLg,
          ),
        ),
      ),
    );
  }
}
