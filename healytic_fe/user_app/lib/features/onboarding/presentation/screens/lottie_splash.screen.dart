import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // 1. Import flutter_hooks
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/router/routes.dart';

class LottieSplashScreen extends HookConsumerWidget {
  const LottieSplashScreen({super.key});

  // 2. KHÔNG cần createState()

  @override
  // 3. Thêm WidgetRef ref vào hàm build
  Widget build(BuildContext context, WidgetRef ref) {
    // 4. Hook này thay thế cho:
    //    - SingleTickerProviderStateMixin
    //    - AnimationController _controller;
    //    - initState()
    //    - dispose()
    // Nó tự động tạo và hủy controller
    final controller = useAnimationController();

    // 5. (Sửa lỗi) Di chuyển logic điều hướng vào đây
    //    Dùng pushReplacementNamed để thay thế màn hình (không thể back lại)
    void navigateToHome() {
      // HomeRoute.name là "home", nên ta dùng pushReplacementNamed
      // context.pushReplacementNamed(OnboardingRoute.name);
      context.pushReplacementNamed(OnboardingRoute.name);

      // Hoặc, nếu HomeRoute.name là "/home" (location), bạn dùng:
      // context.pushReplacement(HomeRoute.name);
    }

    return Scaffold(
      body: Center(
        child: Platform.environment.containsKey('FLUTTER_TEST') ||
                const bool.fromEnvironment('patrol')
            ? Builder(
                builder: (context) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) navigateToHome();
                  });
                  return const SizedBox();
                },
              )
            : Lottie.asset(
                'assets/animations/splash_animate.json',
                controller: controller,
                onLoaded: (composition) {
                  controller
                    ..duration = composition.duration
                    ..forward().whenComplete(() {
                      navigateToHome();
                    });
                },
              ),
      ),
    );
  }
}
