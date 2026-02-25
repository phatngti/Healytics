import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';

/// The bottom text-input bar containing an attachment button,
/// expandable text field, microphone button, and send button.
///
/// Uses [AppButton] from the common package for all interactive
/// elements and [AppDimens] for responsive dimensions.
///
/// [onSend] fires with the current text when the send button is
/// pressed and the field is non-empty.
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
    _controller.addListener(() {
      final nonEmpty = _controller.text.trim().isNotEmpty;
      if (nonEmpty != _hasText) {
        setState(() => _hasText = nonEmpty);
      }
    });
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
    final inputBarRadius = AppDimens.adaptive(
      context,
      small: 24,
      medium: 26,
      large: 28,
    );

    return Container(
      padding: EdgeInsets.all(AppDimens.spaceSm),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(inputBarRadius),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: AppDimens.borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: AppDimens.spaceLg,
            offset: Offset(0, AppDimens.spaceXs),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attachment button — uses AppButton.text
          AppButton(
            buttonType: ButtonType.text,
            onPressed: () {},
            customStyle: TextButton.styleFrom(
              padding: EdgeInsets.all(AppDimens.spaceSmMd),
              minimumSize: Size(AppDimens.ctaButtonMd, AppDimens.ctaButtonMd),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const CircleBorder(),
            ),
            child: Icon(
              Icons.add_circle_outline,
              color: colorScheme.onSurfaceVariant,
              size: AppDimens.iconLg,
            ),
          ),

          // Text field — raw TextField (AppTextField needs FormBuilder)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimens.spaceXs),
              child: TextField(
                controller: _controller,
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Type your symptoms...',
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceXs,
                    vertical: AppDimens.spaceSm,
                  ),
                  isDense: true,
                ),
              ),
            ),
          ),

          // Mic button — uses AppButton.text
          AppButton(
            buttonType: ButtonType.text,
            onPressed: () {},
            customStyle: TextButton.styleFrom(
              padding: EdgeInsets.all(AppDimens.spaceSmMd),
              minimumSize: Size(AppDimens.ctaButtonMd, AppDimens.ctaButtonMd),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const CircleBorder(),
            ),
            child: Icon(
              Icons.mic,
              color: colorScheme.onSurfaceVariant,
              size: AppDimens.iconLg,
            ),
          ),

          // Send button — uses AppButton.elevated
          AppButton(
            buttonType: ButtonType.elevated,
            onPressed: _hasText ? _handleSend : null,
            primaryColor: colorScheme.primary,
            onPrimaryColor: colorScheme.onPrimary,
            customStyle: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(AppDimens.spaceSmMd),
              minimumSize: Size(AppDimens.ctaButtonMd, AppDimens.ctaButtonMd),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const CircleBorder(),
              elevation: _hasText ? 3 : 0,
              shadowColor: colorScheme.primary.withValues(alpha: 0.4),
            ),
            child: Icon(Icons.send, size: AppDimens.iconMd),
          ),
        ],
      ),
    );
  }
}
