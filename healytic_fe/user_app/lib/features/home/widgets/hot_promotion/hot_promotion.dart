import 'package:flutter/material.dart';
import 'package:user_app/features/home/widgets/hot_promotion/product_card.dart';

class HotPromoContainer extends StatelessWidget {
  HotPromoContainer({
    super.key,
    required this.theme,
    required this.wScreen,
    required this.hScreen,
  });

  final ThemeData theme;
  final double wScreen;
  final double hScreen;

  final List<Map<String, dynamic>> products = [
    {
      "name": "Massage & Spa",
      "price": "42,000",
      "sold": "1k+",
      "discount": "60.9%",
      "tag": "Trust",
      "address": "Hanoi, Vietnam",
    },
    {
      "name": "rejuvenate your skin",
      "price": "42,000",
      "sold": "1k+",
      "discount": "60.9%",
      "tag": null,
      "address": "Hanoi, Vietnam",
    },
    {
      "name": "Relaxing Body Massage",
      "price": "42,000",
      "sold": "1k+",
      "discount": "60.9%",
      "tag": null,
      "address": "Hanoi, Vietnam",
    },
    {
      "name": "Hair Spa Treatment adsdsadsd asdsdsads adsds",
      "price": "42,000",
      "sold": "1k+",
      "discount": "60.9%",
      "tag": null,
      "address": "Hanoi, Vietnam",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: hScreen * 0.4),
      child: Container(
        width: double.infinity,
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
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hot Promotion",
                    style: theme.textTheme.titleMedium!.apply(
                      color: Colors.orange[800],
                    ),
                  ),
                  GestureDetector(
                    child: Text("View All", style: theme.textTheme.bodySmall!),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: HotPromoCard(
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
      ),
    );
  }
}
