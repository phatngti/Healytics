import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// Typing indicator showing the partner's name with
/// animated dots.
class PartnerChatTypingIndicator extends StatefulWidget {
  final String? partnerName;

  const PartnerChatTypingIndicator({
    super.key,
    this.partnerName,
  });

  @override
  State<PartnerChatTypingIndicator> createState() =>
      _PartnerChatTypingIndicatorState();
}

class _PartnerChatTypingIndicatorState
    extends State<PartnerChatTypingIndicator>
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
    final textTheme = Theme.of(context).textTheme;
    final name =
        widget.partnerName ?? 'Partner';

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppDimens.spaceSm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Small avatar
            CircleAvatar(
              radius: 12,
              backgroundColor:
                  colorScheme.primaryContainer,
              child: Icon(
                Icons.storefront_rounded,
                size: 12,
                color:
                    colorScheme.onPrimaryContainer,
              ),
            ),
            SizedBox(width: AppDimens.spaceXs),

            // Typing bubble
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.spaceSm,
              ),
              decoration: BoxDecoration(
                color: colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$name is typing',
                    style: textTheme.bodySmall
                        ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(
                    width: AppDimens.spaceXs,
                  ),
                  // Animated dots
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: List.generate(
                          3,
                          (i) {
                            final delay = i * 0.2;
                            final t = (_controller
                                        .value -
                                    delay)
                                .clamp(0.0, 1.0);
                            final scale =
                                0.5 +
                                    0.5 *
                                        (1 -
                                            (2 * t -
                                                    1)
                                                .abs());
                            return Padding(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 1,
                              ),
                              child: Transform.scale(
                                scale: scale,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration:
                                      BoxDecoration(
                                    color: colorScheme
                                        .onSurfaceVariant
                                        .withValues(
                                      alpha:
                                          0.4 *
                                              scale,
                                    ),
                                    shape: BoxShape
                                        .circle,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
