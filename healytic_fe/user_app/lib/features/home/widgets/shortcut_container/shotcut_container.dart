import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShortcutContainer extends StatelessWidget {
  const ShortcutContainer({
    super.key,
    required this.floatingCardTop,
    required this.floatingCardHeight,
    required this.colors,
    required this.theme,
  });

  final double floatingCardTop;
  final double floatingCardHeight;
  final ColorScheme colors;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: floatingCardTop,
      left: 20,
      right: 20,
      child: Container(
        constraints: BoxConstraints(minHeight: floatingCardHeight),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .2),
              blurRadius: 20,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: theme.inputDecorationTheme.fillColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(5),
                      child: IconTheme(
                        data: theme.iconTheme,
                        child: SvgPicture.asset(
                          "assets/icons/appointment_icon.svg",
                        ),
                      ),
                    ),
                    Text("Appointment", style: theme.textTheme.bodySmall!),
                  ],
                ),
              ),
              SizedBox(
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: theme.inputDecorationTheme.fillColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(5),
                      child: IconTheme(
                        data: theme.iconTheme,
                        child: SvgPicture.asset("assets/icons/coupon.svg"),
                      ),
                    ),
                    Text("Coupon code", style: theme.textTheme.bodySmall!),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
