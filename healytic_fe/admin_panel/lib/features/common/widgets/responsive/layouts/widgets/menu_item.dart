import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class HoverContainer extends StatefulWidget {
  final VoidCallback? onTap;
  final String label;
  final IconData icon;
  final bool isSelected;
  const HoverContainer({
    super.key,
    this.onTap,
    required this.label,
    required this.icon,
    this.isSelected = false,
  });

  @override
  State<HoverContainer> createState() => _HoverContainerState();
}

class _HoverContainerState extends State<HoverContainer> {
  // 1. This variable tracks the "Mouse In" state
  bool _isHovering = false;

  // active color
  Color get _activeColor => Theme.of(context).colorScheme.primaryContainer;

  // inactive color
  Color get _inactiveColor => Theme.of(context).colorScheme.surface;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // 2. Mouse enters the container -> Set Active
      onEnter: (_) => setState(() => _isHovering = true),

      // 3. Mouse leaves the container -> Set Inactive
      onExit: (_) => setState(() => _isHovering = false),

      // Optional: Change cursor to indicate it's clickable
      cursor: SystemMouseCursors.click,

      child: GestureDetector(
        onTap: widget.onTap,

        // 4. AnimatedContainer handles the color switch smoothly
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200), // Smooth transition
          curve: Curves.easeInOut,
          padding: AppDimens.paddingAllSmall,
          decoration: BoxDecoration(
            // LOGIC: If hovering, use Blue; if not, Transparent
            color: _isHovering
                ? _activeColor // ACTIVE COLOR
                : widget.isSelected
                ? _activeColor // SELECTED COLOR
                : _inactiveColor, // INACTIVE COLOR

            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(widget.icon, fontWeight: FontWeight.w300),
              AppDimens.horizontalMedium,
              Text(
                widget.label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
