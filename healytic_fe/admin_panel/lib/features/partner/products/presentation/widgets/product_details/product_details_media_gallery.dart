import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class ProductDetailsMediaGalleryCard extends StatefulWidget {
  final Product product;

  const ProductDetailsMediaGalleryCard({super.key, required this.product});

  @override
  State<ProductDetailsMediaGalleryCard> createState() =>
      _ProductDetailsMediaGalleryCardState();
}

class _ProductDetailsMediaGalleryCardState
    extends State<ProductDetailsMediaGalleryCard>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  List<String> get displayImages => widget.product.images.isNotEmpty
      ? widget.product.images
      : [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAFrGiK3bbApZSlrvn_eBzRvdi7zyrVdOWKZR-kn3Yn_2UO4xxBGNxNtSOM0fMXZvVi9508tENJ9rZUJ4isxnANOdrEfulRu1B95hhIE4J9GPmU1GbPgu1zEQpt4fTw7TAjeu1vZTRghaK-6utoEJdVQhv6QZdqbaxxgkU7KtGnIaUfQ-L6HxWcAvmGuhhuY-A82us6k5doqzNtrL-h3tNNPBTsmP6o7FRSVsxTXkfV4kIsd9iyjp4J9bWiHtq2dkQvzv9TpUB-2Vp7',
        ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectImage(int index) {
    if (index != _selectedIndex) {
      _animationController.reset();
      setState(() {
        _selectedIndex = index;
      });
      _animationController.forward();
    }
  }

  void _navigateImage(int direction) {
    final newIndex = (_selectedIndex + direction) % displayImages.length;
    _selectImage(newIndex < 0 ? displayImages.length - 1 : newIndex);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mainImage = displayImages[_selectedIndex];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: AppDimens.paddingAllMediumLarge,
            decoration: BoxDecoration(
              borderRadius: AppDimens.radiusMediumSmall,
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: Text(
              'Media Gallery',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: AppDimens.paddingAllMediumLarge,
            child: Column(
              children: [
                // Main Image with Navigation Arrows
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    children: [
                      // Animated Main Image
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Opacity(
                              opacity: _fadeAnimation.value,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: AppDimens.radiusSmall,
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  border: Border.all(
                                    color: theme.colorScheme.outlineVariant,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.shadow
                                          .withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: AppDimens.radiusSmall,
                                  child: Image.network(
                                    mainImage,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Center(
                                          child: Icon(
                                            Icons.broken_image_outlined,
                                            size: 48,
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Navigation Arrows
                      if (displayImages.length > 1) ...[
                        Positioned(
                          left: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: _NavigationButton(
                              icon: Icons.chevron_left_rounded,
                              onPressed: () => _navigateImage(-1),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: _NavigationButton(
                              icon: Icons.chevron_right_rounded,
                              onPressed: () => _navigateImage(1),
                            ),
                          ),
                        ),
                      ],
                      // Image Counter
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.shadow.withValues(
                              alpha: 0.6,
                            ),
                            borderRadius: AppDimens.radiusMedium,
                          ),
                          child: Text(
                            '${_selectedIndex + 1} / ${displayImages.length}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onInverseSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AppDimens.verticalMedium,
                // Thumbnails with animation
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: displayImages.length,
                    separatorBuilder: (_, __) =>
                        AppDimens.horizontalMediumSmall,
                    itemBuilder: (context, index) {
                      final imageUrl = displayImages[index];
                      final isSelected = index == _selectedIndex;

                      return _ThumbnailItem(
                        imageUrl: imageUrl,
                        isSelected: isSelected,
                        onTap: () => _selectImage(index),
                      );
                    },
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

class _NavigationButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _NavigationButton({required this.icon, required this.onPressed});

  @override
  State<_NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<_NavigationButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: _isHovered
              ? theme.colorScheme.surface.withValues(alpha: 0.95)
              : theme.colorScheme.surface.withValues(alpha: 0.8),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(
                alpha: _isHovered ? 0.2 : 0.1,
              ),
              blurRadius: _isHovered ? 12 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: theme.colorScheme.surface.withValues(alpha: 0),
          child: InkWell(
            onTap: widget.onPressed,
            customBorder: const CircleBorder(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(_isHovered ? 10 : 8),
              child: Icon(
                widget.icon,
                size: _isHovered ? 28 : 24,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThumbnailItem extends StatefulWidget {
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThumbnailItem({
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ThumbnailItem> createState() => _ThumbnailItemState();
}

class _ThumbnailItemState extends State<_ThumbnailItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _borderAnimation = Tween<double>(
      begin: 1.0,
      end: 2.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_ThumbnailItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.isSelected
                  ? _scaleAnimation.value
                  : (_isHovered ? 1.05 : 1.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: widget.isSelected
                        ? theme.colorScheme.primary
                        : (_isHovered
                              ? theme.colorScheme.primary.withValues(alpha: 0.5)
                              : theme.colorScheme.outlineVariant),
                    width: widget.isSelected ? _borderAnimation.value : 1.5,
                  ),
                  boxShadow: widget.isSelected || _isHovered
                      ? [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: widget.isSelected ? 0.3 : 0.15,
                            ),
                            blurRadius: widget.isSelected ? 12 : 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: AppDimens.radiusSmall,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      // Selection overlay
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: widget.isSelected
                            ? 0.0
                            : (_isHovered ? 0.1 : 0.0),
                        child: Container(color: theme.colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
