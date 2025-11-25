import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/authenticate/presentation/provider/authenticate.provider.dart';
import 'package:user_app/features/common/button/button.dart';
import 'package:user_app/router/routes.dart';
import 'package:user_app/utils/demensions.dart';
import 'package:user_app/utils/device.dart';

class HomeUpdatePage extends HookConsumerWidget {
  const HomeUpdatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(authenticateProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: DeviceUtils.getMinBodyHeight(context),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: AppDimens.paddingAllMedium,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar widget
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          NameAvatar(
                            name:
                                asyncState
                                    .value
                                    ?.authenticate
                                    ?.basicInfo
                                    ?.name ??
                                '',
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Good Morning',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w300),
                              ),
                              5.verticalSpace,
                              Text(
                                asyncState
                                        .value
                                        ?.authenticate
                                        ?.basicInfo
                                        ?.name ??
                                    '',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Symbols.add_shopping_cart_rounded),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Symbols.settings),
                          ),
                        ],
                      ),
                    ],
                  ),
                  AppButton(
                    child: Text('Logout'),
                    onPressed: () {
                      context.pushReplacementNamed(SignInRoute.name);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NameAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final double? fontSize;

  const NameAvatar({
    super.key,
    required this.name,
    this.radius = 24.0,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: _getAvatarColor(name),
      child: Text(
        _getInitials(name),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize ?? (radius * 0.8), // Auto-scale font
          color: Colors.white,
        ),
      ),
    );
  }

  // Logic to extract initials
  String _getInitials(String name) {
    if (name.isEmpty) return "?";

    // Clean the string and split by space
    List<String> nameParts = name.trim().split(RegExp(r'\s+'));

    String firstLetter = nameParts.first[0].toUpperCase();

    // If there is a last name, add its initial
    if (nameParts.length > 1) {
      String lastLetter = nameParts.last[0].toUpperCase();
      return firstLetter + lastLetter;
    }

    return firstLetter;
  }

  // Logic to generate a consistent color based on the name string
  Color _getAvatarColor(String name) {
    // Use the hash of the name to pick a color from a predefined list
    // This ensures "John" always gets the same color.
    final int hash = name.hashCode;
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[hash % colors.length];
  }
}
