import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Categories extends StatelessWidget {
  const Categories({
    super.key,
    required this.theme,
    required this.heigthScreen,
    required this.categories,
  });

  final ThemeData theme;
  final double heigthScreen;
  final List<Map<String, String>> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heigthScreen * 0.1,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset(
                      categories[index]["image"]!,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    categories[index]["label"]!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall!,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
