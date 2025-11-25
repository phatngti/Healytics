import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeSearch extends StatelessWidget {
  const HomeSearch({super.key, required this.hScreen, required this.theme});

  final double hScreen;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.onPrimary, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconTheme(data: theme.iconTheme, child: Icon(Symbols.search)),
            SizedBox(width: 16),
            Text("Spa, Massage, etc", style: theme.textTheme.bodySmall!),
          ],
        ),
      ),
    );
  }
}
