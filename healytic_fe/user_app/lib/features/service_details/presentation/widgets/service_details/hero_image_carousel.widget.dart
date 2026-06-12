import 'dart:async';

import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Hero image carousel with auto-advancing pages,
/// gradient overlay, category badge, and title.
///
/// Pauses auto-advance when the app is backgrounded
/// to avoid wasted timer ticks.
class HeroImageCarousel extends StatefulWidget {
  const HeroImageCarousel({
    super.key,
    required this.images,
    required this.categoryLabel,
    required this.title,
  });

  /// Network URLs for the carousel images.
  final List<String> images;

  /// Category badge text shown above the title.
  final String categoryLabel;

  /// Hero title overlaid on the image.
  final String title;

  @override
  State<HeroImageCarousel> createState() => _HeroImageCarouselState();
}

class _HeroImageCarouselState extends State<HeroImageCarousel>
    with WidgetsBindingObserver {
  late final PageController _pageController;
  Timer? _autoAdvanceTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addObserver(this);
    _startAutoAdvance();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _autoAdvanceTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      _startAutoAdvance();
    }
  }

  void _startAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    if (widget.images.length <= 1) return;
    _autoAdvanceTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % widget.images.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final dpr = MediaQuery.devicePixelRatioOf(context);

    // Pre-compute cache dimensions for images
    final heroHeight = screenHeight * 0.35;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cacheW = (screenWidth * dpr).round();
    final cacheH = (heroHeight * dpr).round();

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image pages
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  widget.images[index],
                  fit: BoxFit.cover,
                  cacheWidth: cacheW,
                  cacheHeight: cacheH,
                  errorBuilder: (_, __, ___) => ColoredBox(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Center(
                      child: Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
                // Gradient overlay
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0x99000000), // 60%
                        Color(0x1A000000), // 10%
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: SizedBox.expand(),
                ),
              ],
            ),
          ),

          // Dot indicators – bottom-right
          Positioned(
            bottom: 112,
            right: AppDimens.spaceXxl,
            child: Row(
              children: List.generate(
                widget.images.length,
                (i) => Padding(
                  padding: EdgeInsets.only(left: i == 0 ? 0 : 6),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _currentPage
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Category badge + title – bottom-left
          Positioned(
            bottom: 40,
            left: AppDimens.spaceXxl,
            right: AppDimens.spaceXxl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.8),
                    borderRadius: AppDimens.radiusPill,
                  ),
                  child: Text(
                    widget.categoryLabel.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                AppDimens.verticalSmall,
                // Title
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    shadows: const [
                      Shadow(blurRadius: 8, color: Color(0x66000000)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
