import 'dart:async';

import 'package:flutter/material.dart';

import '../../providers/booking_filter_predicates.dart';

/// Circular avatar that attempts to load a network image
/// and falls back to initials or a generic placeholder.
///
/// Behaviour:
/// 1. If [imageUrl] is non-null and non-empty, attempts
///    `Image.network` with a 5-second timeout.
/// 2. On error or timeout → shows initials derived from
///    [name] via [deriveInitials].
/// 3. If initials are empty → shows a generic person icon.
///
/// All colours are resolved from the current theme's
/// `colorScheme` — no `Color` literals.
///
/// _(Req 2.6, 2.7)_
class AvatarWithInitials extends StatefulWidget {
  /// Creates an avatar widget.
  const AvatarWithInitials({
    required this.name,
    this.imageUrl,
    this.radius = 20,
    super.key,
  });

  /// Full name used to derive initials.
  final String name;

  /// Optional network image URL.
  final String? imageUrl;

  /// Radius of the circular avatar.
  final double radius;

  @override
  State<AvatarWithInitials> createState() => _AvatarWithInitialsState();
}

class _AvatarWithInitialsState extends State<AvatarWithInitials> {
  bool _imageLoadFailed = false;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    _startTimeoutIfNeeded();
  }

  @override
  void didUpdateWidget(AvatarWithInitials oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _timeoutTimer?.cancel();
      _imageLoadFailed = false;
      _startTimeoutIfNeeded();
    }
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _startTimeoutIfNeeded() {
    final url = widget.imageUrl;
    if (url == null || url.isEmpty) return;
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && !_imageLoadFailed) {
        setState(() => _imageLoadFailed = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final url = widget.imageUrl;
    final hasUrl = url != null && url.isNotEmpty;

    if (hasUrl && !_imageLoadFailed) {
      return _buildNetworkAvatar(colorScheme, textTheme, url);
    }

    return _buildFallback(colorScheme, textTheme);
  }

  Widget _buildNetworkAvatar(
    ColorScheme colorScheme,
    TextTheme textTheme,
    String url,
  ) {
    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: colorScheme.surfaceContainerHighest,
      child: ClipOval(
        child: SizedBox.fromSize(
          size: Size.fromRadius(widget.radius),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) {
                _timeoutTimer?.cancel();
                return child;
              }
              return Center(
                child: SizedBox(
                  width: widget.radius,
                  height: widget.radius,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              _markFailed();
              return _buildFallbackContent(colorScheme, textTheme);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFallback(ColorScheme colorScheme, TextTheme textTheme) {
    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: colorScheme.surfaceContainerHighest,
      child: _buildFallbackContent(colorScheme, textTheme),
    );
  }

  Widget _buildFallbackContent(ColorScheme colorScheme, TextTheme textTheme) {
    final initials = deriveInitials(widget.name);
    if (initials.isEmpty) {
      return Icon(
        Icons.person,
        size: widget.radius,
        color: colorScheme.onSurfaceVariant,
      );
    }
    return Text(
      initials,
      style: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _markFailed() {
    if (!_imageLoadFailed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _imageLoadFailed = true);
        }
      });
    }
  }
}
