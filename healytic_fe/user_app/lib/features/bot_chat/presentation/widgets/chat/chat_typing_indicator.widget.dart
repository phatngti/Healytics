import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// Three-dot pulsing typing indicator.
///
/// Displayed while the bot is processing a response.
/// Uses a repeating animation to bounce three dots
/// in sequence.
class ChatTypingIndicator extends StatefulWidget {
  const ChatTypingIndicator({super.key});

  @override
  State<ChatTypingIndicator> createState() => _ChatTypingIndicatorState();
}

class _ChatTypingIndicatorState extends State<ChatTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceSm,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(18),
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, _buildDot),
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int i) {
    final colorScheme = Theme.of(context).colorScheme;
    final delay = i * 0.3;
    final t = (_controller.value - delay).clamp(0.0, 1.0);
    final bounce = (1 - (2 * t - 1).abs()) * 0.4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Transform.translate(
        offset: Offset(0, -bounce * 6),
        child: Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.onSurfaceVariant.withValues(
              alpha: 0.25 + bounce * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
