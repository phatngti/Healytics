// --- HELPER FUNCTION ---
// Hàm này giúp tái sử dụng logic slide transition cho tất cả các trang
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Page<void> buildSlideTransitionPage({
  required LocalKey pageKey,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
        child: child,
      );
    },
  );
}
