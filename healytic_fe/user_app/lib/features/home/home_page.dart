import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/common/adaptive_root_scraffold/staggered_grid_view/widget/silver_masonry_grid.dart';
import 'package:user_app/features/home/widgets/category/category.dart';
import 'package:user_app/features/home/widgets/custom_header/custom_header.dart';
import 'package:user_app/features/home/widgets/home_bar/home_bar.dart';
import 'package:user_app/features/home/widgets/home_search/home_search.dart';
import 'package:user_app/features/home/widgets/hot_promotion/hot_promotion.dart';
import 'package:user_app/features/home/widgets/recommend/recommend.dart';
import 'package:user_app/features/home/widgets/shortcut_container/shotcut_container.dart';
import 'package:user_app/utils/device.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final wScreen = DeviceUtils.getScreenWidth(context);
    final hScreen = DeviceUtils.getScreenHeight(context);
    final List<Map<String, String>> categories = [
      {"label": "Spa & Beauty", "image": "assets/icons/spa_beauty.svg"},
      {"label": "Massage", "image": "assets/icons/massage.svg"},
      {"label": "Fitness", "image": "assets/icons/fitness.svg"},
      {"label": "Nutrition", "image": "assets/icons/nutrition.svg"},
      {"label": "Wellness", "image": "assets/icons/wellness.svg"},
      {"label": "Yoga", "image": "assets/icons/yoga.svg"},
    ];

    final headerHeight = hScreen * 0.3;
    final floatingCardHeight = headerHeight * 0.35;
    final floatingCardTop = headerHeight - floatingCardHeight / 1.8;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // Each widget that was previously in the Column is now wrapped
          // in a SliverToBoxAdapter.
          SliverToBoxAdapter(
            child: SizedBox(
              height: headerHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: headerHeight,
                    child: CustomHeader(
                      theme: theme,
                      headerHeight: headerHeight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            HomeBar(theme: theme, widthScreen: wScreen),
                            const SizedBox(height: 16),
                            HomeSearch(hScreen: hScreen, theme: theme),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ShortcutContainer(
                    floatingCardTop: floatingCardTop,
                    floatingCardHeight: floatingCardHeight,
                    colors: colors,
                    theme: theme,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: floatingCardHeight / 2 + 10),
          ),
          SliverToBoxAdapter(
            child: Categories(
              theme: theme,
              heigthScreen: hScreen,
              categories: categories,
            ),
          ),
          // Hot Promotion
          SliverToBoxAdapter(
            child: HotPromoContainer(
              theme: theme,
              wScreen: wScreen,
              hScreen: hScreen,
            ),
          ),
          // Recommend
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(
            child: RecommendedContainer(
              hScreen: hScreen,
              theme: theme,
              wScreen: wScreen,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          // Use the SliverMasonryGrid.count widget
          HomeProducts(hScreen: hScreen, theme: theme),

          const SliverToBoxAdapter(child: SizedBox(height: 10)),
        ],
      ),
    );
  }
}

class HomeProducts extends StatelessWidget {
  HomeProducts({super.key, required this.hScreen, required this.theme});

  final double hScreen;
  final ThemeData theme;

  final List<Map<String, dynamic>> products = [
    {
      "image": {"url": "assets/icons/test.png", "height": 200.0},
      "name": "Massage & Spa",
      "price": "42,000",
      "sold": "1k+",
      "discount": "60.9%",
      "tag": "Trust",
      "address": "Hanoi, Vietnam",
    },
    {
      "image": {"url": "assets/icons/test.png", "height": 250.0},
      "name": "Facial Treatment",
      "price": "99,000",
      "sold": "800+",
      "discount": "50%",
      "tag": "Hot Deal",
      "address": "Ho Chi Minh City",
    },
    {
      "image": {"url": "assets/icons/test.png", "height": 180.0},
      "name": "Seafood Buffet",
      "price": "550,000",
      "sold": "2.5k+",
      "discount": "30%",
      "tag": "Recommended",
      "address": "Da Nang, Vietnam",
    },
    {
      "image": {"url": "assets/icons/test.png", "height": 220.0},
      "name": "Manicure & Pedicure",
      "price": "75,000",
      "sold": "500+",
      "discount": "45.5%",
      "tag": "New",
      "address": "Ho Chi Minh City",
    },
    {
      "image": {"url": "assets/icons/test.png", "height": 200.0},
      "name": "Luxury Hair Salon",
      "price": "120,000",
      "sold": "950+",
      "discount": "25%",
      "tag": "Trust",
      "address": "Hanoi, Vietnam",
    },
    {
      "image": {"url": "assets/icons/test.png", "height": 280.0},
      "name": "Boutique Hotel Stay",
      "price": "850,000",
      "sold": "1.2k+",
      "discount": "40%",
      "tag": "Hot Deal",
      "address": "Hoi An, Vietnam",
    },
    {
      "image": {"url": "assets/icons/test.png", "height": 190.0},
      "name": "Coffee Shop Voucher",
      "price": "29,000",
      "sold": "3k+",
      "discount": "50%",
      "tag": "Recommended",
      "address": "Ho Chi Minh City",
    },
    {
      "image": {"url": "assets/icons/test.png", "height": 210.0},
      "name": "Gym Membership (1 Month)",
      "price": "450,000",
      "sold": "400+",
      "discount": "35%",
      "tag": "New",
      "address": "Da Nang, Vietnam",
    },
    {
      "image": {"url": "assets/icons/test.png", "height": 260.0},
      "name": "Fine Dining Experience",
      "price": "1,200,000",
      "sold": "600+",
      "discount": "20%",
      "tag": "Trust",
      "address": "Ho Chi Minh City",
    },
    {
      "image": {"url": "assets/icons/test.png", "height": 200.0},
      "name": "Movie Tickets for Two",
      "price": "119,000",
      "sold": "5k+",
      "discount": "15%",
      "tag": "Hot Deal",
      "address": "Hanoi, Vietnam",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SliverMasonryGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      childCount: products.length, // Sliver grids require a child count
      itemBuilder: (context, index) {
        // A placeholder Tile widget is used here
        return ProductCard(
          index: index,
          hScreen: hScreen,
          theme: theme,
          product: products[index],
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.index,
    required this.hScreen,
    required this.theme,
    required this.product,
  });

  final int index;
  final double hScreen;
  final ThemeData theme;

  final Map<String, dynamic> product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3),
      ),
      padding: EdgeInsets.all(8),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                product["image"]["url"],
                height: product["image"]["height"],
                width: double.infinity,
                fit: BoxFit.cover,
                cacheWidth: 300,
                cacheHeight: 300,
              ),
              RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                text: TextSpan(
                  style: theme.textTheme.bodySmall,
                  children: [
                    if (product["tag"] != null && product["tag"]!.isNotEmpty)
                      WidgetSpan(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green[500],
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            "${product["tag"]}",
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  theme.textTheme.bodySmall!.fontSize! * 0.9,
                            ),
                          ),
                        ),
                      ),
                    if (product["tag"] != null && product["tag"]!.isNotEmpty)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: SizedBox(width: 4),
                      ),
                    TextSpan(
                      text: "${product["name"]}",
                      style: theme.textTheme.bodySmall!.copyWith(
                        fontSize: theme.textTheme.bodySmall!.fontSize! + 0.1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
              child: Center(
                child: Text(
                  "-69%",
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
