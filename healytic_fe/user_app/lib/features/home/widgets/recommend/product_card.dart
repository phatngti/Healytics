import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class RecommendCard extends StatelessWidget {
  const RecommendCard({
    super.key,
    required this.wScreen,
    required this.theme,
    this.product = const {},
  });

  final double wScreen;
  final ThemeData theme;
  final Map<String, dynamic> product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wScreen * 0.4,
      height: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              border: Border.all(
                color: Colors.grey.withValues(alpha: .5),
                width: 1,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(),
                    child: Image.asset(
                      "assets/icons/test.png",
                      height: constraints.maxHeight * 0.65,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      cacheWidth: 300,
                      cacheHeight: 300,
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight * 0.35,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.ltr,
                            text: TextSpan(
                              style: theme.textTheme.bodySmall,
                              children: [
                                if (product["tag"] != null &&
                                    product["tag"]!.isNotEmpty)
                                  WidgetSpan(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green[500],
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(
                                        "${product["tag"]}",
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  theme
                                                      .textTheme
                                                      .bodySmall!
                                                      .fontSize! *
                                                  0.9,
                                            ),
                                      ),
                                    ),
                                  ),
                                if (product["tag"] != null &&
                                    product["tag"]!.isNotEmpty)
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: SizedBox(width: 4),
                                  ),
                                TextSpan(
                                  text: "${product["name"]}",
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    fontSize:
                                        theme.textTheme.bodySmall!.fontSize! +
                                        0.1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${product["price"]}",
                              style: theme.textTheme.bodyMedium!.apply(
                                fontWeightDelta: 2,
                                fontSizeDelta: 0.5,
                              ),
                            ),
                            Text(
                              "${product["sold"]} sold",
                              style: theme.textTheme.bodySmall!.apply(
                                fontSizeFactor: 0.9,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: RichText(
                            textAlign: TextAlign.end,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: IconTheme(
                                    data: theme.iconTheme,
                                    child: Icon(Symbols.location_on, size: 14),
                                  ),
                                ),
                                TextSpan(
                                  text: product["address"] != null
                                      ? " ${product["address"]}"
                                      : "",
                                  style: theme.textTheme.bodySmall!.apply(
                                    fontSizeFactor: 0.9,
                                    fontWeightDelta: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: 20,
              width: 45,
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Center(
                child: Text(
                  "-${product["discount"]}",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
