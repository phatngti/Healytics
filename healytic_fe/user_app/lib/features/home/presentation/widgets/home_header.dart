import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/utils/demensions.dart';

import 'name_avatar.dart';

class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withAlpha(204),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withAlpha(51),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAHFOX7h9F48tcGwMIcEIfkFIO_BCb-TwyhCGYTSYlivBYYPeitHy4W3oeX4l3dEEfJb_yZupssfa2sclSZPLyXfEG5q3pl2sx39c1coakQeOePB7aFA1dAPE3Ra0lpxaiQawpTpkWJktpcY7JCrjO_VPaGyAgzVQM37ZX_Y0pjSESxXa_IpilQ3wPqplOIkK3Rv_S_u-cz9aZh75qv45DoVVZ9RQ3Jl9ta2otLB3h_v3CdJg2ZGgoU5oVyRGojV_h0ciQfIgAJaK6I',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        NameAvatar(name: userName, radius: 22),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning,',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _HeaderButton(icon: Symbols.shopping_cart, onTap: () {}),
              const SizedBox(width: 12),
              _HeaderButton(icon: Symbols.settings, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).colorScheme.surface),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 24,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
