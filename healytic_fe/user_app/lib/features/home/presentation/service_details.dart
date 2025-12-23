import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/utils/demensions.dart'; // Ensure correct import path for dimensions

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Custom colors from design that might not map directly to standard scheme
    // We try to use colorScheme where possible or fallbacks
    // HTML primary: #13ecda
    // We assume colorScheme.primary should match or be close, but for specific design fidelity we might need exact overrides if the theme isn't set up that way.
    // However, user asked to use Theme.of(context).colorScheme.

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Header Image Container
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCZw40mNsMWpXdBfnVg-YPfOhspx01qhSpLVYNk_vPLgYVk0ESiSA0RiLWgFw9XQqvXGd7uQyroqiilmHluloBJYpBweLsAso2xQu_gbQm2izd3nuqHBxTe1pixt17MYVzQTzhLmKGQCaKoEp2MsCsajRhq6B7c5U1JJb-mKqyjYfTRrUKwu8iG6U0ftLls0zmRWIQHVWLtrBWkZeDCY8iLdVo-5CmQd5Q3Ctxz0Yhuj_i7TbCQUtX6mwM0_TBtdIugnw9jrrRHKFHh',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(Icons.error, color: colorScheme.error),
                        ),
                      ),
                      // Gradient overlay
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 128,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Dot indicators at bottom
                      Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 24,
                              height: 6,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                            8.horizontalSpace,
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                            8.horizontalSpace,
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Main Content Block
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    padding: AppDimens.paddingAllLarge.copyWith(
                      bottom: 100,
                    ), // Bottom padding for fixed footer
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tag
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[100],
                            borderRadius: AppDimens.radiusSmall,
                          ),
                          child: Text(
                            'ĐIỀU TRỊ CÔNG NGHỆ CAO',
                            style: textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: isDarkMode
                                  ? Colors.grey[300]
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                        // Title
                        Text(
                          'Trị Liệu Da Chuyên Sâu Laser CO2',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        16.verticalSpace,
                        // Price and Rating
                        Container(
                          padding: 24.paddingBottom,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isDarkMode
                                    ? Colors.grey[800]!
                                    : Colors.grey[100]!,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '3.500.000 ₫',
                                style: textTheme.headlineSmall?.copyWith(
                                  color: colorScheme
                                      .primary, // Using primary color for price
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Symbols.star,
                                    fill: 1,
                                    color: Colors.yellow,
                                    size: 20,
                                  ),
                                  6.horizontalSpace,
                                  Text(
                                    '4.9',
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  4.horizontalSpace,
                                  Text(
                                    '(120 reviews)',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        32.verticalSpace,
                        // Key Features Horizontal Grid
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Row(
                            children: [
                              _buildFeatureBox(
                                context,
                                icon: Symbols.schedule,
                                label: '60 min',
                              ),
                              16.horizontalSpace,
                              _buildFeatureBox(
                                context,
                                icon: Symbols.person,
                                label: '1 Guest/Slot',
                              ),
                              16.horizontalSpace,
                              _buildFeatureBox(
                                context,
                                icon: Symbols.medical_services,
                                label: 'Laser CO2',
                              ),
                              16.horizontalSpace,
                              _buildFeatureBox(
                                context,
                                icon: Symbols.event_available,
                                label: 'Book 2h+',
                              ),
                            ],
                          ),
                        ),
                        32.verticalSpace,
                        // About Section
                        Text(
                          'About this service',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        12.verticalSpace,
                        Text(
                          'Experience our premium CO2 Fractional Laser treatment designed to rejuvenate skin, reduce scars, and improve texture. This non-invasive procedure stimulates collagen production for lasting results.',
                          style: textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[500],
                          ),
                        ),
                        8.verticalSpace,
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Read more',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                Symbols.expand_more,
                                color: colorScheme.primary,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        24.verticalSpace,
                        // Clinic Card
                        Container(
                          padding: AppDimens.paddingAllMedium,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? const Color(0xFF1A2C2A)
                                : Colors.white,
                            borderRadius: AppDimens.radiusMedium,
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.grey[800]!
                                  : const Color(0xFFF9FAFB),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 24,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? Colors.grey[800]
                                      : const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDarkMode
                                        ? Colors.grey[700]!
                                        : Colors.grey[100]!,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'FEDERM',
                                    style: textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                              16.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'FEDERM Clinic',
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    4.verticalSpace,
                                    Text(
                                      '1046 Au Co, Ward 14, Tan Binh District, HCMC',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: const Color(0xFF6B7280),
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              16.horizontalSpace,
                              Column(
                                children: [
                                  _buildSmallActionButton(
                                    context,
                                    'Visit',
                                    isPrimary: true,
                                    color: const Color(0xFF00C9A7),
                                  ),
                                  8.verticalSpace,
                                  _buildSmallActionButton(
                                    context,
                                    '',
                                    icon: Symbols.favorite,
                                    iconColor: const Color(0xFFEF4444),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        32.verticalSpace,
                        // Specialist Selection
                        Text(
                          'Choose your Specialist',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        16.verticalSpace,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Row(
                            children: [
                              _buildSpecialistCard(
                                context,
                                name: 'Dr. Hanh',
                                role: 'Dermatologist',
                                imageUrl:
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAA0GERfcjsWV8885IqiFU67STPSqVLkNarDjmjPoCcFffPw_zvJA2g0vrebVxYBFPwDLAIbXh_9G2pFqeQKTKt9uj-dExnJCkWt7uafOZlCh1tlnVzazUpg2I2ojDbJ3EOpCu0uG78s7dEmvumpSRn74daDYR32staXvjCU5jlyWnP2dqaCEHnQQ_okQcuS7fQJAHDqW7OLrok8YfJHiQ6xkAfIM3luDV3XGb6sLjK9V8dQwgZlweJS4jB9P4NLTlwGf0PYeDR7fe5',
                                isSelected: true,
                              ),
                              16.horizontalSpace,
                              _buildSpecialistCard(
                                context,
                                name: 'Nurse Lan',
                                role: 'Laser Tech',
                                imageUrl:
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBfHf5h1aVTxUN4hJBO0kqfWrEvpoDzQ3OBctUFOlCnilgHBv-5341K9JP2dgdmtirHJ2J0H4oa7BQho1zNW04oVaMQ8-sEua4f_GeKygDV98dHhjlY1Ji5KIwkr8bLWUOm7oiAyxBpsADotvq0icHK4atbaK5C35sY6ZmGreJ4zrfp6aDnRXuiQ7c4s4VeOQZh0AXYu4f-FfFtdPKcowE0KTAnmVBLa8DWnx0cFKpfL9dc8fpPoXJvU4N80PAtHDJK3I5obRSMqvZ-',
                                isSelected: false,
                              ),
                              16.horizontalSpace,
                              _buildSpecialistCard(
                                context,
                                name: 'Dr. Minh',
                                role: 'Senior Doctor',
                                imageUrl:
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCkNbvPxuzGdR8AWEzYQiNHzhAGTqT51c1rvdH_3kg6KLAyhW7aKrtIbBZe1Fh21Ikj7fsTTFfewVU6VvyhdSgSbVifrpWBPf3G0-K3WpVWYLqFVuaI7xUwqTt54J6nzEs5aFD00jlcJHjjYR7pKGXRr_JUA0DObP-MBReMM6KBndm-H-wr2ijiERU8_EQbqE3eW5AGH9SyWKJQfIme4YfyNcl3WdXT_FuV5Xt6oV4xHxIIIIHu7coQyn-sEPsI82_lWIzTkgvLbc2a',
                                isSelected: false,
                              ),
                            ],
                          ),
                        ),
                        32.verticalSpace,
                        // Technology & Facilities
                        Text(
                          'Technology & Facilities',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        16.verticalSpace,
                        Column(
                          children: [
                            _buildTechRow(
                              context,
                              icon: Symbols.biotech,
                              title: 'Máy Laser CO2 Fractional',
                              subtitle: 'Certified by FDA',
                            ),
                            12.verticalSpace,
                            _buildTechRow(
                              context,
                              icon: Symbols.clean_hands,
                              title: 'Phòng Điều Trị Vô Trùng',
                              subtitle: 'ISO 9001 Standard',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Header Actions
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildGlassButton(
                      icon: Symbols.arrow_back,
                      onTap: () => Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        _buildGlassButton(icon: Symbols.share, onTap: () {}),
                        12.horizontalSpace,
                        _buildGlassButton(icon: Symbols.favorite, onTap: () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
                  .add(
                    EdgeInsets.only(
                      bottom: MediaQuery.paddingOf(context).bottom,
                    ),
                  ),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: isDarkMode ? Colors.grey[800]! : Colors.grey[100]!,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Price',
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '3.500.000 ₫',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  24.horizontalSpace,
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            // A darker shade or variation if available, otherwise just use primary with a tweak
                            // Ideally mapped from theme, but for gradient we can check if we have primaryContainer
                            colorScheme.primary.withAlpha(200),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Book Appointment',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(
                                    0xFF0D1B1A,
                                  ), // Keep text dark for contrast on primary button
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Symbols.arrow_forward,
                                size: 20,
                                color: Color(0xFF0D1B1A),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBox(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 100,
      height: 100,
      padding: AppDimens.paddingAllSmall,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).disabledColor.withOpacity(0.05), // A way to get a light background
        borderRadius: AppDimens.radiusMedium,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          8.verticalSpace,
          Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialistCard(
    BuildContext context, {
    required String name,
    required String role,
    required String imageUrl,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 140,
      padding: 12.paddingAll,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : (isDarkMode ? Colors.grey[700]! : Colors.grey[200]!),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? const [BoxShadow(color: Colors.black12, blurRadius: 4)]
            : null,
      ),
      foregroundDecoration: isSelected
          ? null
          : BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: AppDimens.radiusMedium,
              backgroundBlendMode: BlendMode.saturation,
            ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(
              isSelected
                  ? Symbols.radio_button_checked
                  : Symbols.radio_button_unchecked,
              color: isSelected ? colorScheme.primary : Colors.grey[300],
              size: 20,
              fill: isSelected ? 1 : 0,
            ),
          ),
          Container(
            width: 64,
            height: 64,
            margin: 8.paddingBottom,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            name,
            style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(role, style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTechRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: 12.paddingAll,
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 2),
              ],
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallActionButton(
    BuildContext context,
    String label, {
    IconData? icon,
    Color? color,
    Color? iconColor,
    bool isPrimary = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 72,
      height: 28,
      decoration: BoxDecoration(
        color: isPrimary
            ? color!.withOpacity(0.1)
            : (isDarkMode ? Colors.transparent : Colors.white),
        borderRadius: BorderRadius.circular(100),
        border: isPrimary
            ? null
            : Border.all(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
      ),
      child: Center(
        child: isPrimary
            ? Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Icon(icon, color: iconColor, size: 18),
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Center(child: Icon(icon, color: Colors.white, size: 24)),
      ),
    );
  }
}
