import 'package:flutter/material.dart';
import 'package:user_app/features/home/widgets/recommend/product_card.dart';

class RecommendedContainer extends StatelessWidget {
  RecommendedContainer({
    super.key,
    required this.hScreen,
    required this.theme,
    required this.wScreen,
  });

  final double hScreen;
  final ThemeData theme;
  final double wScreen;
  final List<Map<String, dynamic>> products = [
    {
      "name": "Nourishing Shampoo Massage",
      "price": "42,000",
      "sold": "1k+",
      "discount": "60.9%",
      "tag": "Trust",
      "address": "Hanoi, Vietnam",
    },
    {
      "name": "Nourishing Shampoo Massage",
      "price": "42,000",
      "sold": "1k+",
      "discount": "60.9%",
      "tag": "Trust",
      "address": "Hanoi, Vietnam",
    },
    {
      "name": "Nourishing Shampoo Massage",
      "price": "42,000",
      "sold": "1k+",
      "discount": "60.9%",
      "tag": "Trust",
      "address": "Hanoi, Vietnam",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: hScreen * 0.4),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.withValues(alpha: 0.3),
              width: 1,
            ),
            bottom: BorderSide(
              color: Colors.grey.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          color: theme.colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recommended for you",
              style: theme.textTheme.titleMedium!.apply(
                color: Colors.orange[800],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: RecommendCard(
                    wScreen: wScreen,
                    theme: theme,
                    product: products[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
