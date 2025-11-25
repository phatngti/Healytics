import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeBar extends StatelessWidget {
  const HomeBar({super.key, required this.theme, required this.widthScreen});

  final ThemeData theme;
  final double widthScreen;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0.0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.apply(color: theme.colorScheme.onPrimary),
          ),

          Text(
            "Phat Ng",
            style: Theme.of(context).textTheme.headlineSmall!.apply(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Badge.count(
            count: 1,
            child: Icon(
              Symbols.add_shopping_cart_rounded,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          padding: EdgeInsets.zero,
          icon: Badge.count(
            count: 1,
            child: Icon(Symbols.chat, color: theme.colorScheme.onPrimary),
          ),
        ),
      ],
      actionsIconTheme: IconThemeData(color: theme.colorScheme.surface),
    );
  }
}
