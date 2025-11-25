import 'package:flutter/material.dart';
import 'package:user_app/features/home/widgets/custom_header/circular_container.dart';
import 'package:user_app/features/home/widgets/custom_header/custom_curved_edges.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({
    super.key,
    required this.theme,
    required this.headerHeight,
    required this.child,
  });

  final ThemeData theme;
  final double headerHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomCurvedEdges(headerHeight: headerHeight),
      child: Container(
        color: theme.colorScheme.primary,
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: headerHeight,
          child: Stack(
            children: [
              Positioned(
                top: -150,
                right: -250,
                child: CircularContainer(
                  backgroundColor: Colors.white.withValues(alpha: .1),
                ),
              ),
              Positioned(
                top: 100,
                right: -300,
                child: CircularContainer(
                  backgroundColor: Colors.white.withValues(alpha: .1),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
