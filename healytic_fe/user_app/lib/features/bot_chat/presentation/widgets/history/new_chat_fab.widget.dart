import 'dart:math' as math;

import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Animated floating action button styled as a friendly chat-bot
/// icon.
///
/// Plays three layered animations on mount:
/// 1. **Entrance** – scales + rotates the button in from zero.
/// 2. **Pulse ring** – a soft, repeating glow ring that draws
///    attention to the FAB.
/// 3. **Idle bounce** – a gentle repeating vertical float that
///    keeps the button feeling alive.
///
/// All colours are derived from the active [ColorScheme].
class NewChatFab extends StatefulWidget {
  /// Callback fired when the FAB is tapped. If `null` the button
  /// still animates but does nothing on press.
  final VoidCallback? onPressed;

  /// Optional key applied to the inner tappable
  /// area so integration tests can hit-test it
  /// through the animation wrappers.
  final Key? tapKey;

  const NewChatFab({super.key, this.onPressed, this.tapKey});

  @override
  State<NewChatFab> createState() => _NewChatFabState();
}

class _NewChatFabState extends State<NewChatFab> with TickerProviderStateMixin {
  // ── Entrance ──────────────────────────────────────────────
  late final AnimationController _entranceCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final Animation<double> _entranceScale = CurvedAnimation(
    parent: _entranceCtrl,
    curve: Curves.elasticOut,
  );
  late final Animation<double> _entranceRotation = Tween<double>(
    begin: -0.25,
    end: 0.0,
  ).animate(CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutBack));

  // ── Pulse ring ────────────────────────────────────────────
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();
  late final Animation<double> _pulseScale = Tween<double>(
    begin: 1.0,
    end: 1.5,
  ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut));
  late final Animation<double> _pulseOpacity = Tween<double>(
    begin: 0.5,
    end: 0.0,
  ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut));

  // ── Idle bounce ───────────────────────────────────────────
  late final AnimationController _bounceCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);
  late final Animation<double> _bounceOffset = Tween<double>(
    begin: 0,
    end: -6,
  ).animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    // Delay entrance slightly so the page can settle first.
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _entranceCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _pulseCtrl.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fabColor = colorScheme.primary;
    final onFabColor = colorScheme.onPrimary;
    const double size = AppDimens.avatarLg;

    return ListenableBuilder(
      listenable: Listenable.merge([_entranceCtrl, _pulseCtrl, _bounceCtrl]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceOffset.value),
          child: ScaleTransition(
            scale: _entranceScale,
            child: RotationTransition(
              turns: _entranceRotation,
              child: SizedBox(
                width: size,
                height: size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // ── Pulse ring ──
                    Transform.scale(
                      scale: _pulseScale.value,
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: fabColor.withValues(
                            alpha: _pulseOpacity.value * 0.35,
                          ),
                        ),
                      ),
                    ),

                    // ── Main button ──
                    _ChatBotButton(
                      size: size,
                      fabColor: fabColor,
                      onFabColor: onFabColor,
                      onPressed: widget.onPressed,
                      tapKey: widget.tapKey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Inner chat-bot styled button
// ─────────────────────────────────────────────────────────────

class _ChatBotButton extends StatelessWidget {
  final double size;
  final Color fabColor;
  final Color onFabColor;
  final VoidCallback? onPressed;
  final Key? tapKey;

  const _ChatBotButton({
    required this.size,
    required this.fabColor,
    required this.onFabColor,
    this.onPressed,
    this.tapKey,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: tapKey,
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [fabColor, Color.lerp(fabColor, Colors.white, 0.25)!],
            ),
            boxShadow: [
              BoxShadow(
                color: fabColor.withValues(alpha: 0.45),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(child: _BotFaceIcon(color: onFabColor)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Cute chat-bot face drawn with CustomPaint
// ─────────────────────────────────────────────────────────────

class _BotFaceIcon extends StatelessWidget {
  final Color color;
  const _BotFaceIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimens.iconXxl,
      height: AppDimens.iconXxl,
      child: CustomPaint(painter: _BotFacePainter(color: color)),
    );
  }
}

class _BotFacePainter extends CustomPainter {
  final Color color;
  _BotFacePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // ── Head (rounded rect) ──
    final headRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy + size.height * 0.04),
        width: size.width * 0.78,
        height: size.height * 0.65,
      ),
      Radius.circular(size.width * 0.22),
    );
    canvas.drawRRect(headRect, strokePaint);

    // ── Antenna ──
    final antennaBase = Offset(cx, cy - size.height * 0.28);
    final antennaTip = Offset(cx, cy - size.height * 0.44);
    canvas.drawLine(antennaBase, antennaTip, strokePaint);
    canvas.drawCircle(antennaTip, size.width * 0.055, paint);

    // ── Eyes ──
    final eyeRadius = size.width * 0.065;
    final eyeY = cy - size.height * 0.02;
    canvas.drawCircle(Offset(cx - size.width * 0.16, eyeY), eyeRadius, paint);
    canvas.drawCircle(Offset(cx + size.width * 0.16, eyeY), eyeRadius, paint);

    // ── Smile (arc) ──
    final smileRect = Rect.fromCenter(
      center: Offset(cx, cy + size.height * 0.12),
      width: size.width * 0.32,
      height: size.height * 0.18,
    );
    canvas.drawArc(smileRect, 0, math.pi, false, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _BotFacePainter old) => old.color != color;
}
